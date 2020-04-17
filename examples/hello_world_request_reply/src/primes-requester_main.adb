
with Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with DDS.DomainParticipant;
with DDS.DomainParticipantFactory;
with Primes.PrimeNumberRequester;
with Primes_IDL_File.PrimeNumberRequest_TypeSupport;
with RTIDDS.Config;

procedure Primes.Requester_Main is
   use Primes_IDL_File;
   use DDS.DomainParticipant;
   use all type DDS.ReturnCode_T;

   Factory : constant DDS.DomainParticipantFactory.Ref_Access := DDS.DomainParticipantFactory.Get_Instance;

   procedure Requester_Shutdown (Participant : in out DDS.DomainParticipant.Ref_Access;
                                 Requester   : in out PrimeNumberRequester.Ref_Access;
                                 Request     : in out PrimeNumberRequest_Access) is
   begin


      PrimeNumberRequest_TypeSupport.Delete_Data (Request);
      PrimeNumberRequester.Delete (Requester);

      if Participant /= null then
         Participant.Delete_Contained_Entities;
      end if;

      Factory.Delete_Participant (Participant);
      Factory.Finalize_Instance;
   end;


   procedure Requester_Main (N                : DDS.long ;
                             Primes_Per_Reply : DDS.long ;
                             Domain_Id        : DDS.DomainId_T)
   is

      Retcode : DDS.ReturnCode_T;

      Replies          : aliased PrimeNumberReply_Seq.Sequence;
      Info_Seq         : aliased DDS.SampleInfo_Seq.Sequence;
      Participant      : DDS.DomainParticipant.Ref_Access;
      Requester        : PrimeNumberRequester.Ref_Access;
      Request          : PrimeNumberRequest_Access := PrimeNumberRequest_TypeSupport.Create_Data;
      MAX_WAIT         : constant DDS.Duration_T := DDS.To_Duration_T (20.0);
      In_Progress      : Boolean := False;

      use type PrimeNumberRequester.Ref_Access;
      use PrimeNumberReply_Seq;
      use DDS.SampleInfo_Seq;
   begin

      --  Create the participant
      Participant := Factory.Create_Participant (Domain_Id);
      if Participant = null then
         Put_Line (Standard_Error, "create_participant error");
         Ada.Command_Line.Set_Exit_Status (ADa.Command_Line.Failure);
         return;
      end if;


      --  Create the requester with that participant, and a QoS profile
      --  defined in USER_QOS_PROFILES.xml
      --
      Requester := PrimeNumberRequester.Create (Participant      => Participant,
                                                Service_Name     => Service_Name,
                                                Qos_Library_Name => Qos_Library_Name,
                                                Qos_Profile_Name => Qos_Profile_Name);
      if Requester = null then
         Put_Line (Standard_Error, "create requester error");
         Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
         Requester_Shutdown (Participant, Requester, Request);
         return;
      end if;


      Request := PrimeNumberRequest_TypeSupport.Create_Data;
      if Request = null then
         Put_Line (Standard_Error, "Create data error");
         ADa.Command_Line.Set_Exit_Status (ADa.Command_Line.Failure);
         Requester_Shutdown (Participant, Requester, Request);
         return;
      end if;


      Request.N := N;
      Request.Primes_Per_Reply := Primes_Per_Reply;
      Retcode := Requester.Send_Request (Request.all);

      if Retcode /= DDS.RETCODE_OK then
         Put_Line (Standard_Error, "send_request error:" & Retcode'Img );
         Ada.Command_Line.Set_Exit_Status (ADa.Command_Line.Failure);
         Requester_Shutdown (Participant, Requester, Request);
         return;
      end if;




      Retcode := Requester.Receive_Replies
        (Replies         => Replies'Unrestricted_Access,
         Sample_Info     => Info_Seq'Unrestricted_Access,
         Min_Reply_Count => 1,
         Max_Reply_Count => DDS.LENGTH_UNLIMITED,
         Timeout         => MAX_WAIT);


      In_Progress := True;
      while In_Progress and then (Retcode = DDS.RETCODE_OK)loop
         Put_Line ("(");
         for I in 1 .. Get_Length (Replies'Unrestricted_Access) loop
            declare
               Reply        : constant PrimeNumberReply_Access := Get_Reference (Replies'Unrestricted_Access, I);
               Info         : constant DDS.SampleInfo_Access := Get_Reference (Info_Seq'Unrestricted_Access, I);
            begin
               if (Info.Valid_Data) then
                  for Prime_Number of Reply.Primes loop
                     Put (Prime_Number.all'Img);
                  end loop;
               end if;
               if Reply.Status /= REPLY_IN_PROGRESS then
                  In_Progress := False;
                  if Reply.Status = REPLY_ERROR then
                     Put_Line (Standard_Error, "Error in Replier");
                  elsif Reply.Status = REPLY_COMPLETED then
                     Put_Line ("DONE");
                  end if;
               end if;
               Put_Line (")");
            end;
         end loop;

         --   Return the loan to the middleware
         Requester.Return_Loan (Replies, Info_Seq);

         if In_Progress then
            Retcode := Requester.Receive_Replies
              (Replies         => Replies'Unrestricted_Access,
               Sample_Info     => Info_Seq'Unrestricted_Access,
               Min_Reply_Count => 1,
               Max_Reply_Count => DDS.LENGTH_UNLIMITED,
               Timeout         => MAX_WAIT);
         end if;
      end loop;

      if Retcode /= DDS.RETCODE_OK then
         if (Retcode = DDS.RETCODE_TIMEOUT) then
            Put_Line (Standard_Error, "Timed out waiting for prime numbers");
         else
            Put_Line (Standard_Error, "Error receiving replies" &  Retcode'Img);
         end if;
      end if;
      Requester_Shutdown (Participant, Requester, Request);
   end;


   Domain_Id        : DDS.DomainId_T :=  0;
   N                : DDS.long;
   Primes_Per_Reply : DDS.long := 5;
begin

   if Ada.Command_Line.Argument_Count < 1 then
      Put_Line ("PrimeNumberRequester:");
      Put_Line ("Sends a request to calculate the prime numbers <= n");
      Put_Line ("Parameters: <n> [<primes_per_reply> = 5] [<domain_id> = 0]");
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
      return;
   end if;
   N := DDS.Integer'Value (Ada.Command_Line.Argument (1));
   if Ada.Command_Line.Argument_Count < 1 then
      Primes_Per_Reply := DDS.Integer'Value (Ada.Command_Line.Argument (2));
   end if;

   if Ada.Command_Line.Argument_Count < 2 then
      Domain_Id := DDS.DomainId_T'Value (Ada.Command_Line.Argument (3));
   end if;

   RTIDDS.Config.Logger.Get_Instance.Set_Verbosity (RTIDDS.Config.VERBOSITY_WARNING);
   -- Uncomment this to turn on additional logging
   -- RTIDDS.Config.Logger.Get_Instance.Set_Verbosity (RTIDDS.Config.VERBOSITY_ERROR);

   Put_Line ("PrimeNumberRequester: Sending a request to calculate the " &
               "prime numbers " & N'Img & " in sequences of " & Primes_Per_Reply'Img & " or less elements." &
               "(on domain " & Domain_Id'Img & ")" );


   Requester_Main (N, Primes_Per_Reply, Domain_Id);

end;
