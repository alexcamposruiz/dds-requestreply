-------------------------------------------------------------------------------
--                                                                           --
--       D D S . R E Q U E S T _ R E P L Y . R E P L Y _ G E N E R I C       --
--                                                                           --
--                                  B o d y                                  --
--                                                                           --
-------------------------------------------------------------------------------

package body Dds.Request_Reply.Reply_Generic is

   ------------
   -- Create --
   ------------

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Service_Name       : DDS.String;
      Datawriter_Qos     : DDS.DataWriterQoS := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
      Datareader_Qos     : DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
      Listener           : ReplierListener_Access := null)
      return Ref_Access
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      raise Program_Error with "Unimplemented function Create";
      return Create (Participant => Participant, Service_Name => Service_Name,
         Datawriter_Qos => Datawriter_Qos, Datareader_Qos => Datareader_Qos,
         Listener => Listener);
   end Create;

   ------------
   -- Create --
   ------------

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Service_Name       : Standard.String;
      Datawriter_Qos     : DDS.DataWriterQoS := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
      Datareader_Qos     : DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
      Listener           : ReplierListener_Access := null)
      return Ref_Access
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      raise Program_Error with "Unimplemented function Create";
      return Create (Participant => Participant, Service_Name => Service_Name,
         Datawriter_Qos => Datawriter_Qos, Datareader_Qos => Datareader_Qos,
         Listener => Listener);
   end Create;

   ------------
   -- Create --
   ------------

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Service_Name       : DDS.String;
      Datawriter_Qos     : DDS.String;
      Datareader_Qos     : DDS.String;
      Listener           : ReplierListener_Access := null)
      return Ref_Access
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      raise Program_Error with "Unimplemented function Create";
      return Create (Participant => Participant, Service_Name => Service_Name,
         Datawriter_Qos => Datawriter_Qos, Datareader_Qos => Datareader_Qos,
         Listener => Listener);
   end Create;

   ------------
   -- Create --
   ------------

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Service_Name       : DDS.String;
      Datawriter_Qos     : Standard.String;
      Datareader_Qos     : Standard.String;
      Listener           : ReplierListener_Access := null)
      return Ref_Access
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      raise Program_Error with "Unimplemented function Create";
      return Create (Participant => Participant, Service_Name => Service_Name,
         Datawriter_Qos => Datawriter_Qos, Datareader_Qos => Datareader_Qos,
         Listener => Listener);
   end Create;

   ------------
   -- Create --
   ------------

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Service_Name       : DDS.String;
      Request_Topic_Name : DDS.String;
      Reply_Topic_Name   : DDS.String;
      Publisher          : DDS.Publisher.Ref_Access;
      Subscriber         : DDS.Subscriber.Ref_Access;
      Listener           : ReplierListener_Access := null)
      return Ref_Access
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      raise Program_Error with "Unimplemented function Create";
      return Create (Participant => Participant, Service_Name => Service_Name,
         Request_Topic_Name => Request_Topic_Name,
         Reply_Topic_Name => Reply_Topic_Name, Publisher => Publisher,
         Subscriber => Subscriber, Listener => Listener);
   end Create;

   ------------
   -- Create --
   ------------

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Service_Name       : DDS.String;
      Request_Topic_Name : DDS.String;
      Reply_Topic_Name   : DDS.String;
      Qos_Library_Name   : DDS.String;
      Qos_Profile_Name   : DDS.String;
      Publisher          : DDS.Publisher.Ref_Access;
      Subscriber         : DDS.Subscriber.Ref_Access;
      Listener           : ReplierListener_access := null)
      return Ref_Access
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      raise Program_Error with "Unimplemented function Create";
      return Create (Participant => Participant, Service_Name => Service_Name,
         Request_Topic_Name => Request_Topic_Name,
         Reply_Topic_Name => Reply_Topic_Name,
         Qos_Library_Name => Qos_Library_Name,
         Qos_Profile_Name => Qos_Profile_Name, Publisher => Publisher,
         Subscriber => Subscriber, Listener => Listener);
   end Create;

   ------------
   -- Create --
   ------------

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Service_Name       : DDS.String;
      Request_Topic_Name : DDS.String;
      Reply_Topic_Name   : DDS.String;
      Qos_Library_Name   : Standard.String;
      Qos_Profile_Name   : Standard.String;
      Publisher          : DDS.Publisher.Ref_Access;
      Subscriber         : DDS.Subscriber.Ref_Access;
      Listener           : ReplierListener_access := null)
      return Ref_Access
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      raise Program_Error with "Unimplemented function Create";
      return Create (Participant => Participant, Service_Name => Service_Name,
         Request_Topic_Name => Request_Topic_Name,
         Reply_Topic_Name => Reply_Topic_Name,
         Qos_Library_Name => Qos_Library_Name,
         Qos_Profile_Name => Qos_Profile_Name, Publisher => Publisher,
         Subscriber => Subscriber, Listener => Listener);
   end Create;

   ------------
   -- Create --
   ------------

   function Create return Ref_Access is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      raise Program_Error with "Unimplemented function Create";
      return Create;
   end Create;

   ------------------
   -- Take_Request --
   ------------------

   function Take_Request
     (Self         : not null access Ref;
      Requests     : aliased Request_DataReaders.Treats.Data_Type;
      Sample_Info  : not null access DDS.SampleInfo_Seq.Sequence)
      return DDS.ReturnCode_T
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Take_Request unimplemented");
      raise Program_Error with "Unimplemented function Take_Request";
      return Take_Request (Self => Self, Requests => Requests,
         Sample_Info => Sample_Info);
   end Take_Request;

   ------------------
   -- Take_Request --
   ------------------

   function Take_Request
     (Self         : not null access Ref)
      return Request_DataReaders.Container'Class
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Take_Request unimplemented");
      raise Program_Error with "Unimplemented function Take_Request";
      return Take_Request (Self => Self);
   end Take_Request;

   -------------------
   -- Take_Requests --
   -------------------

   function Take_Requests
     (Self               : not null access Ref;
      Max_Request_Count  : DDS.Long)
      return Request_DataReaders.Container'Class
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Take_Requests unimplemented");
      raise Program_Error with "Unimplemented function Take_Requests";
      return Take_Requests (Self => Self,
         Max_Request_Count => Max_Request_Count);
   end Take_Requests;

   ------------------
   -- Read_Request --
   ------------------

   function Read_Request
     (Self         : not null access Ref;
      Requests     : aliased Request_DataReaders.Treats.Data_Type;
      Sample_Info  : not null access DDS.SampleInfo_Seq.Sequence)
      return DDS.ReturnCode_T
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Read_Request unimplemented");
      raise Program_Error with "Unimplemented function Read_Request";
      return Read_Request (Self => Self, Requests => Requests,
         Sample_Info => Sample_Info);
   end Read_Request;

   -------------------
   -- Read_Requests --
   -------------------

   function Read_Requests
     (Self               : not null access Ref;
      Requests           : not null Request_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info        : not null access DDS.SampleInfo_Seq.Sequence;
      Max_Request_Count  : DDS.Long)
      return DDS.ReturnCode_T
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Read_Requests unimplemented");
      raise Program_Error with "Unimplemented function Read_Requests";
      return Read_Requests (Self => Self, Requests => Requests,
         Sample_Info => Sample_Info, Max_Request_Count => Max_Request_Count);
   end Read_Requests;

   -------------------
   -- Read_Requests --
   -------------------

   function Read_Requests
     (Self               : not null access Ref;
      Max_Request_Count  : DDS.Long := DDS.Long'Last)
      return Request_DataReaders.Container'Class
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Read_Requests unimplemented");
      raise Program_Error with "Unimplemented function Read_Requests";
      return Read_Requests (Self => Self,
         Max_Request_Count => Max_Request_Count);
   end Read_Requests;

   ---------------------
   -- Receive_Request --
   ---------------------

   function Receive_Request
     (Self     : not null access Ref;
      Request  : access Request_DataReaders.Treats.Data_Type;
      Info_Seq : not null access DDS.SampleInfo_Seq.Sequence;
      Timeout  : DDS.Duration_T)
      return DDS.ReturnCode_T
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Receive_Request unimplemented");
      raise Program_Error with "Unimplemented function Receive_Request";
      return Receive_Request (Self => Self, Request => Request,
         Info_Seq => Info_Seq, Timeout => Timeout);
   end Receive_Request;

   ----------------------
   -- Receive_Requests --
   ----------------------

   function Receive_Requests
     (Self                 : not null access Ref;
      Requests             : not null Request_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Request_Count    : Request_DataReaders.Treats.Index_Type;
      Max_Request_Count    : Request_DataReaders.Treats.Index_Type;
      Timeout              : DDS.Duration_T)
      return DDS.ReturnCode_T
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Receive_Requests unimplemented");
      raise Program_Error with "Unimplemented function Receive_Requests";
      return Receive_Requests (Self => Self, Requests => Requests,
         Sample_Info => Sample_Info, Min_Request_Count => Min_Request_Count,
         Max_Request_Count => Max_Request_Count, Timeout => Timeout);
   end Receive_Requests;

   ----------------------
   -- Receive_Requests --
   ----------------------

   function Receive_Requests
     (Self                 : not null access Ref;
      Min_Request_Count    : Request_DataReaders.Treats.Index_Type;
      Max_Request_Count    : Request_DataReaders.Treats.Index_Type;
      Timeout              : DDS.Duration_T)
      return Request_DataReaders.Container'Class
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Receive_Requests unimplemented");
      raise Program_Error with "Unimplemented function Receive_Requests";
      return Receive_Requests (Self => Self,
         Min_Request_Count => Min_Request_Count,
         Max_Request_Count => Max_Request_Count, Timeout => Timeout);
   end Receive_Requests;

   ----------------
   -- Send_Reply --
   ----------------

   procedure Send_Reply
     (Self                 : not null access Ref;
      Reply                : access Reply_DataWriters.Treats.Data_Type;
      Related_Request_Info : DDS.SampleIdentity_T)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Send_Reply unimplemented");
      raise Program_Error with "Unimplemented procedure Send_Reply";
   end Send_Reply;

   ----------------
   -- Send_Reply --
   ----------------

   procedure Send_Reply
     (Self                 : not null access Ref;
      Reply                : access Reply_DataWriters.Treats.Data_Type;
      Related_Request_Info : DDS.SampleInfo)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Send_Reply unimplemented");
      raise Program_Error with "Unimplemented procedure Send_Reply";
   end Send_Reply;

   ----------------
   -- Send_Reply --
   ----------------

   procedure Send_Reply
     (Self                 : not null access Ref;
      Reply                : Reply_DataWriters.Treats.Data_Type;
      Related_Request_Info : DDS.SampleIdentity_T)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Send_Reply unimplemented");
      raise Program_Error with "Unimplemented procedure Send_Reply";
   end Send_Reply;

   ----------------
   -- Send_Reply --
   ----------------

   procedure Send_Reply
     (Self                 : not null access Ref;
      Reply                : Reply_DataWriters.Treats.Data_Type;
      Related_Request_Info : DDS.SampleInfo)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Send_Reply unimplemented");
      raise Program_Error with "Unimplemented procedure Send_Reply";
   end Send_Reply;

   ----------------
   -- Send_Reply --
   ----------------

   procedure Send_Reply
     (Self                 : not null access Ref;
      Reply                : Reply_DataWriters.Treats.Data_Array;
      Related_Request_Info : DDS.SampleIdentity_T)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Send_Reply unimplemented");
      raise Program_Error with "Unimplemented procedure Send_Reply";
   end Send_Reply;

   ----------------
   -- Send_Reply --
   ----------------

   procedure Send_Reply
     (Self                 : not null access Ref;
      Reply                : Reply_DataWriters.Treats.Data_Array;
      Related_Request_Info : DDS.SampleInfo)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Send_Reply unimplemented");
      raise Program_Error with "Unimplemented procedure Send_Reply";
   end Send_Reply;

   -----------------
   -- Return_Loan --
   -----------------

   procedure Return_Loan
     (Self         : not null access Ref;
      Requests     : not null Reply_DataWriters.Treats.Data_Sequences.Sequence_Access;
      Sample_Info  : DDS.SampleInfo_Seq.Sequence_Access)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Return_Loan unimplemented");
      raise Program_Error with "Unimplemented procedure Return_Loan";
   end Return_Loan;

   ----------------------------
   -- Get_Request_DataReader --
   ----------------------------

   function Get_Request_DataReader
     (Self : not null access Ref)
      return Request_DataReaders.Ref_Access
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Get_Request_DataReader unimplemented");
      raise Program_Error with "Unimplemented function Get_Request_DataReader";
      return Get_Request_DataReader (Self => Self);
   end Get_Request_DataReader;

   --------------------------
   -- Get_Reply_DataWriter --
   --------------------------

   function Get_Reply_DataWriter
     (Self : not null access Ref)
      return Reply_DataWriters.Ref_Access
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Get_Reply_DataWriter unimplemented");
      raise Program_Error with "Unimplemented function Get_Reply_DataWriter";
      return Get_Reply_DataWriter (Self => Self);
   end Get_Reply_DataWriter;

end Dds.Request_Reply.Reply_Generic;
