with Ada.Command_Line;
with Ada.Numerics.Long_Elementary_Functions;
with Ada.Text_IO; 
with DDS.DomainParticipant;
with DDS.DomainParticipantFactory;
with Primes.PrimeNumberReplier;
with Primes_IDL_File.PrimeNumberRequest_TypeSupport;
with RTIDDS.Config;

procedure Primes.Replier_Main is

   use Ada.Numerics.Long_Elementary_Functions;
   use Ada.Text_IO;

   use Primes_IDL_File;
   
   use type DDS.DomainParticipant.Ref_Access;
   use type DDS.ReturnCode_T;
   use type DDS.long;
   
   Factory          : constant DDS.DomainParticipantFactory.Ref_Access := DDS.DomainParticipantFactory.Get_Instance;
   MAX_WAIT         : constant DDS.Duration_T := DDS.To_Duration_T (20.0);

   procedure Replier_Shutdown
     (Participant : in out DDS.DomainParticipant.Ref_Access;
      Replier     : in PrimeNumberReplier.Ref_Access;
      Request     : in out PrimeNumberRequest_Access) is
      pragma Unreferenced (Request);
   begin
      -- Delete_Data (Request);
      Replier.Delete;
      Participant.Delete_Contained_Entities;
      Factory.Delete_Participant (Participant);
      Factory.Finalize_Instance;
   end;
   
   procedure Send_Error_Reply (Replier    : PrimeNumberReplier.Ref_Access;
                               Request    : PrimeNumberRequest;
                               Request_Id : DDS.SampleIdentity_T) is
      pragma Unreferenced (Request);
      Reply      : aliased PrimeNumberReply;
   begin
      Initialize (Reply);
      Reply.Status := REPLY_ERROR;
      Replier.Send_Reply (Reply, Request_Id);
      Finalize (Reply);
   end;
   
   
   procedure Calculate_And_Send_Primes (Replier    : PrimeNumberReplier.Ref_Access;
                                        Request    : PrimeNumberRequest;
                                        Request_Id : DDS.SampleIdentity_T) is

      M, Length        : DDS.long;
      N                : constant DDS.long := Request.N;
      Primes_Per_Reply : constant DDS.Natural :=  Request.Primes_Per_Reply;
      Reply            : aliased PrimeNumberReply;      
      type Prime_Type is array (0 .. N) of Integer; 

      Prime            : Prime_Type := (0 => 0, 1 => 0, others => 1);
      use DDS.Long_Seq;
   begin
      Length := 0;
      Initialize (Reply);
      Set_Maximum (Reply.Primes'Access, Primes_Per_Reply);      
      Reply.Status := REPLY_IN_PROGRESS;
      M := DDS.long (Sqrt (Long_Float (N)));
      
      for I in 2 .. M loop
         if Prime (I) /= 0 then
            for K in I * I .. N loop
               Prime (K) := 0;
            end loop;
            Append (Reply.Primes'Access, I);
            if Length + 1 = Primes_Per_Reply then
               Replier.Send_Reply (Reply, Request_Id);               
               Set_Length (Reply.Primes'Access, 0);           
            end if;
         end if;
      end loop;

      -- Calculation is done. Send remaining prime numbers
      for I  in  M + 1 .. N loop
         if Prime (I) /= 0 then
            Length := Get_Length (Reply.Primes'Access);
            Append (Reply.Primes'Access, I);

            if Length + 1 = Primes_Per_Reply then
               Replier.Send_Reply (Reply, Request_Id);               
               Set_Length (Reply.Primes'Access, 0);           
            end if;
         end if;
      end loop;
      
      --  Send the last reply. Indicate that the calculation is complete and
      --  send any prime number left in the sequence
      Reply.Status := REPLY_COMPLETED;
      Replier.Send_Reply (Reply, Request_Id);               
      
   end;
   
   
   procedure Replier_Main (Domain_Id : DDS.DomainId_T) is
      Participant      : DDS.DomainParticipant.Ref_Access;
      Replier          : PrimeNumberReplier.Ref_Access;
      Request_Id       : Dds.SampleIdentity_T;
      Request_Info     : aliased DDS.SampleInfo;
      Request          : PrimeNumberRequest_Access := PrimeNumberRequest_TypeSupport.Create_Data;      
      RetCode          : DDS.ReturnCode_T := DDS.RETCODE_OK;
     
      

   begin
      --      /* Create the participant */
      Participant := Factory.Create_Participant (Domain_Id);
      if Participant = null then
         Put_Line (Standard_Error, "create_participant error");
         return;
      end if;

      --   Create the replier with that participant, and a QoS profile
      --       * defined in USER_QOS_PROFILES.xml
      Replier := PrimeNumberReplier.Create (Participant, Service_Name , Qos_Library_Name, Qos_Profile_Name);
      Request := PrimeNumberRequest_TypeSupport.Create_Data;
      
      --      /*
      --       * Receive requests and process them
      --       */
      Retcode := Replier.Receive_Request (Request.all, Request_Info, Timeout => MAX_WAIT);
      
      while Retcode = DDS.RETCODE_OK  loop
         if Request_Info.Valid_Data then
            DDS.Get_Sample_Identity (Request_Info, Request_Id);
            
            --  This constant is defined in Primes.idl */
            if Request.N <= 0 or
              Request.Primes_Per_Reply <= 0 or
              Request.Primes_Per_Reply > PRIME_SEQUENCE_MAX_LENGTH then         
               Put_Line (Standard_Error, "Cannot process request");
               Send_Error_Reply (Replier, Request.all, Request_Id);
            else
         
               Put_Line ("Calculating prime numbers below " & Request.N'Img & "... ");    
               --   This operation could be executed in a separate thread,
               --   to process requests in parallel
               Calculate_And_Send_Primes (Replier => Replier, 
                                          Request    => Request.all, 
                                          Request_Id => Request_Id);
               
               Put_Line ("DONE");
            end if;
         end if;
         Retcode := Replier.Receive_Request (Request  => Request.all, 
                                             Info_Seq => Request_Info, 
                                             Timeout  => MAX_WAIT);
      end loop;

      if Retcode = DDS.RETCODE_TIMEOUT then
         Put_Line ("No request received for " & MAX_WAIT.Sec'Img & 
                     " seconds. Shutting down replier");
      else 
         Put_Line (Standard_Error, "Error in replier " &  Retcode'Img);
      end if;
      
      Replier_Shutdown (Participant, Replier, Request);

   end;
   
   Domain_Id        : DDS.DomainId_T :=  0;
begin
   
   if Ada.Command_Line.Argument_Count > 0 then
      Domain_Id := DDS.DomainId_T'Value (Ada.Command_Line.Argument (1));
   end if;

   RTIDDS.Config.Logger.Get_Instance.Set_Verbosity (RTIDDS.Config.VERBOSITY_WARNING);
   -- Uncomment this to turn on additional logging
   -- RTIDDS.Config.Logger.Get_Instance.Set_Verbosity (RTIDDS.Config.VERBOSITY_ERROR);

   Put_Line ("PrimeNumberRequester: Sending a request to calculate the " &
               "(on domain " & Domain_Id'Img & ")");

   Replier_Main (Domain_Id);

end Primes.Replier_Main;
