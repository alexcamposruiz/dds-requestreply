-------------------------------------------------------------------------------
--                                                                           --
--     D D S . R E Q U E S T _ R E P L Y . R E Q U E S T _ G E N E R I C     --
--                                                                           --
--                                  B o d y                                  --
--                                                                           --
-------------------------------------------------------------------------------

package body DDS.Request_Reply.Request_Generic is

   ------------
   -- Create --
   ------------

   function Create (Participant   : not null DDS.DomainParticipant.Ref_Access;
                    Params        : in Request_Params) return Ref_Access is
   begin
      return ret : Ref_Access := new ref do
         RTI_Connext_RequesterUntypedImpl_Create;
      end return;
   end;

   function Create
     (Participant         : DDS.DomainParticipant.Ref_Access;
      Service_Name        : DDS.String)
      return Ref_Access
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      raise Program_Error with "Unimplemented function Create";
      return Create (Participant => Participant, Service_Name => Service_Name);
   end Create;

   ------------
   -- Create --
   ------------

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Service_Name       : Standard.String)
      return Ref_Access
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      raise Program_Error with "Unimplemented function Create";
      return Create (Participant => Participant, Service_Name => Service_Name);
   end Create;

   ------------
   -- Create --
   ------------

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Service_Name       : DDS.String;
      Datawriter_Qos     : DDS.DataWriterQoS := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
      Datareader_Qos     : DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
      Publisher          : DDS.Publisher.Ref_Access;
      Subscriber         : DDS.Subscriber.Ref_Access)
      return Ref_Access
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      raise Program_Error with "Unimplemented function Create";
      return Create (Participant => Participant, Service_Name => Service_Name,
         Datawriter_Qos => Datawriter_Qos, Datareader_Qos => Datareader_Qos,
         Publisher => Publisher, Subscriber => Subscriber);
   end Create;

   ------------
   -- Create --
   ------------

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Service_Name       : DDS.String;
      Qos_Library_Name   : DDS.String;
      Qos_Profile_Name   : DDS.String)
      return Ref_Access
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      raise Program_Error with "Unimplemented function Create";
      return Create (Participant => Participant, Service_Name => Service_Name,
         Qos_Library_Name => Qos_Library_Name,
         Qos_Profile_Name => Qos_Profile_Name);
   end Create;

   ------------
   -- Create --
   ------------

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Service_Name       : DDS.String;
      Qos_Library_Name   : Standard.String;
      Qos_Profile_Name   : Standard.String)
      return Ref_Access
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      raise Program_Error with "Unimplemented function Create";
      return Create (Participant => Participant, Service_Name => Service_Name,
         Qos_Library_Name => Qos_Library_Name,
         Qos_Profile_Name => Qos_Profile_Name);
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
      Publisher          : DDS.Publisher.Ref_Access := null;
      Subscriber         : DDS.Subscriber.Ref_Access := null)
      return Ref_Access
   is
   begin
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      raise Program_Error with "Unimplemented function Create";
      return Create (Participant => Participant, Service_Name => Service_Name,
         Request_Topic_Name => Request_Topic_Name,
         Reply_Topic_Name => Reply_Topic_Name,
         Qos_Library_Name => Qos_Library_Name,
         Qos_Profile_Name => Qos_Profile_Name, Publisher => Publisher,
         Subscriber => Subscriber);
   end Create;

   ------------------
   -- Send_Request --
   ------------------

   procedure Send_Request
     (Self    : not null access Ref;
      Request : access Request_DataWriters.Treats.Data_Type)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Send_Request unimplemented");
      raise Program_Error with "Unimplemented procedure Send_Request";
   end Send_Request;

   ------------------
   -- Send_Request --
   ------------------

   function Send_Request
     (Self    : not null access Ref;
      Request : access Request_DataWriters.Treats.Data_Type)
      return Reply_DataReaders.Container
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Send_Request unimplemented");
      raise Program_Error with "Unimplemented function Send_Request";
      return Send_Request (Self => Self, Request => Request);
   end Send_Request;

   ------------------
   -- Send_Request --
   ------------------

   function Send_Request
     (Self    : not null access Ref;
      Request : Request_DataWriters.Treats.Data_Type)
      return Reply_DataReaders.Container
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Send_Request unimplemented");
      raise Program_Error with "Unimplemented function Send_Request";
      return Send_Request (Self => Self, Request => Request);
   end Send_Request;

   ------------------
   -- Send_Request --
   ------------------

   function Send_Request
     (Self    : not null access Ref;
      Request : Request_DataWriters.Treats.Data_Type)
      return Reply_DataReaders.Treats.Data_Type
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Send_Request unimplemented");
      raise Program_Error with "Unimplemented function Send_Request";
      return Send_Request (Self => Self, Request => Request);
   end Send_Request;

   ------------------
   -- Send_Request --
   ------------------

   function Send_Request
     (Self            : not null access Ref;
      Request         : access Request_DataWriters.Treats.Data_Type;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.Long;
      Timeout         : DDS.Duration_T := DURATION_INFINITE)
      return Reply_DataReaders.Container
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Send_Request unimplemented");
      raise Program_Error with "Unimplemented function Send_Request";
      return Send_Request (Self => Self, Request => Request,
         Min_Reply_Count => Min_Reply_Count,
         Max_Reply_Count => Max_Reply_Count, Timeout => Timeout);
   end Send_Request;

   ------------------
   -- Send_Request --
   ------------------

   procedure Send_Request
     (Self         : not null access Ref;
      Request      : access Request_DataWriters.Treats.Data_Type;
      Request_Info : DDS.WriteParams_T)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Send_Request unimplemented");
      raise Program_Error with "Unimplemented procedure Send_Request";
   end Send_Request;

   -------------------
   -- Receive_Reply --
   -------------------

   function Receive_Reply
     (Self     : not null access Ref;
      Replies  : aliased Reply_DataReaders.Treats.Data_Type;
      Info_Seq : not null access DDS.SampleInfo_Seq.Sequence;
      Timeout  : DDS.Duration_T)
      return DDS.ReturnCode_T
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Receive_Reply unimplemented");
      raise Program_Error with "Unimplemented function Receive_Reply";
      return Receive_Reply (Self => Self, Replies => Replies,
         Info_Seq => Info_Seq, Timeout => Timeout);
   end Receive_Reply;

   -------------------
   -- Receive_Reply --
   -------------------

   function Receive_Reply
     (Self     : not null access Ref;
      Timeout  : DDS.Duration_T)
      return Reply_DataReaders.Container
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Receive_Reply unimplemented");
      raise Program_Error with "Unimplemented function Receive_Reply";
      return Receive_Reply (Self => Self, Timeout => Timeout);
   end Receive_Reply;

   ---------------------
   -- Receive_Replies --
   ---------------------

   function Receive_Replies
     (Self                 : not null access Ref;
      Replies              : not null Reply_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count      : DDS.Natural;
      Max_Reply_Count      : DDS.Long;
      Timeout              : DDS.Duration_T)
      return DDS.ReturnCode_T
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Receive_Replies unimplemented");
      raise Program_Error with "Unimplemented function Receive_Replies";
      return Receive_Replies (Self => Self, Replies => Replies,
         Sample_Info => Sample_Info, Min_Reply_Count => Min_Reply_Count,
         Max_Reply_Count => Max_Reply_Count, Timeout => Timeout);
   end Receive_Replies;

   ---------------------
   -- Receive_Replies --
   ---------------------

   function Receive_Replies
     (Self                 : not null access Ref;
      Min_Reply_Count      : DDS.Natural;
      Max_Reply_Count      : DDS.Long;
      Timeout              : DDS.Duration_T)
      return Reply_DataReaders.Container
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Receive_Replies unimplemented");
      raise Program_Error with "Unimplemented function Receive_Replies";
      return Receive_Replies (Self => Self, Min_Reply_Count => Min_Reply_Count,
         Max_Reply_Count => Max_Reply_Count, Timeout => Timeout);
   end Receive_Replies;

   ---------------------
   -- Receive_Replies --
   ---------------------

   function Receive_Replies
     (Self            : not null access Ref;
      Replies         : not null Reply_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info     : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.Long;
      Timeout         : Duration)
      return DDS.ReturnCode_T
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Receive_Replies unimplemented");
      raise Program_Error with "Unimplemented function Receive_Replies";
      return Receive_Replies (Self => Self, Replies => Replies,
         Sample_Info => Sample_Info, Min_Reply_Count => Min_Reply_Count,
         Max_Reply_Count => Max_Reply_Count, Timeout => Timeout);
   end Receive_Replies;

   ---------------------
   -- Receive_Replies --
   ---------------------

   function Receive_Replies
     (Self            : not null access Ref;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.Long;
      Timeout         : Duration)
      return Reply_DataReaders.Container
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Receive_Replies unimplemented");
      raise Program_Error with "Unimplemented function Receive_Replies";
      return Receive_Replies (Self => Self, Min_Reply_Count => Min_Reply_Count,
         Max_Reply_Count => Max_Reply_Count, Timeout => Timeout);
   end Receive_Replies;

   ----------------
   -- Take_Reply --
   ----------------

   function Take_Reply
     (Self        : not null access Ref;
      Replies     : aliased Reply_DataReaders.Treats.Data_Type;
      Sample_Info : not null access DDS.SampleInfo_Seq.Sequence;
      Timeout     : DDS.Duration_T)
      return DDS.ReturnCode_T
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Take_Reply unimplemented");
      raise Program_Error with "Unimplemented function Take_Reply";
      return Take_Reply (Self => Self, Replies => Replies,
         Sample_Info => Sample_Info, Timeout => Timeout);
   end Take_Reply;

   ------------------
   -- Take_Replies --
   ------------------

   function Take_Replies
     (Self            : not null access Ref;
      Replies         : not null Reply_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info     : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.Long;
      Timeout         : DDS.Duration_T)
      return DDS.ReturnCode_T
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Take_Replies unimplemented");
      raise Program_Error with "Unimplemented function Take_Replies";
      return Take_Replies (Self => Self, Replies => Replies,
         Sample_Info => Sample_Info, Min_Reply_Count => Min_Reply_Count,
         Max_Reply_Count => Max_Reply_Count, Timeout => Timeout);
   end Take_Replies;

   ------------------------------------
   -- Take_Reply_For_Related_Request --
   ------------------------------------

   function Take_Reply_For_Related_Request
     (Self                 : not null access Ref;
      Replies              : aliased Reply_DataReaders.Treats.Data_Type;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Related_Request_Info : not null access DDS.SampleIdentity_T)
      return DDS.ReturnCode_T
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Take_Reply_For_Related_Request unimplemented");
      raise Program_Error with "Unimplemented function Take_Reply_For_Related_Request";
      return Take_Reply_For_Related_Request (Self => Self, Replies => Replies,
         Sample_Info => Sample_Info,
         Related_Request_Info => Related_Request_Info);
   end Take_Reply_For_Related_Request;

   --------------------------------------
   -- Take_Replies_For_Related_Request --
   --------------------------------------

   function Take_Replies_For_Related_Request
     (Self                 : not null access Ref;
      Replies              : not null Reply_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Related_Request_Info : not null access DDS.SampleIdentity_T)
      return DDS.ReturnCode_T
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Take_Replies_For_Related_Request unimplemented");
      raise Program_Error with "Unimplemented function Take_Replies_For_Related_Request";
      return Take_Replies_For_Related_Request (Self => Self,
         Replies => Replies, Sample_Info => Sample_Info,
         Related_Request_Info => Related_Request_Info);
   end Take_Replies_For_Related_Request;

   --------------------------------------
   -- Take_Replies_For_Related_Request --
   --------------------------------------

   function Take_Replies_For_Related_Request
     (Self                 : not null access Ref;
      Related_Request_Info : not null access DDS.SampleIdentity_T)
      return Reply_DataReaders.Container
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Take_Replies_For_Related_Request unimplemented");
      raise Program_Error with "Unimplemented function Take_Replies_For_Related_Request";
      return Take_Replies_For_Related_Request (Self => Self,
         Related_Request_Info => Related_Request_Info);
   end Take_Replies_For_Related_Request;

   ----------------
   -- Read_Reply --
   ----------------

   function Read_Reply
     (Self        : not null access Ref;
      Replies     : aliased Reply_DataReaders.Treats.Data_Type;
      Sample_Info : not null access DDS.SampleInfo_Seq.Sequence;
      Timeout     : DDS.Duration_T)
      return DDS.ReturnCode_T
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Read_Reply unimplemented");
      raise Program_Error with "Unimplemented function Read_Reply";
      return Read_Reply (Self => Self, Replies => Replies,
         Sample_Info => Sample_Info, Timeout => Timeout);
   end Read_Reply;

   ------------------
   -- Read_Replies --
   ------------------

   function Read_Replies
     (Self            : not null access Ref;
      Replies         : not null Reply_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info     : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.Long;
      Timeout         : DDS.Duration_T)
      return DDS.ReturnCode_T
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Read_Replies unimplemented");
      raise Program_Error with "Unimplemented function Read_Replies";
      return Read_Replies (Self => Self, Replies => Replies,
         Sample_Info => Sample_Info, Min_Reply_Count => Min_Reply_Count,
         Max_Reply_Count => Max_Reply_Count, Timeout => Timeout);
   end Read_Replies;

   ------------------
   -- Read_Replies --
   ------------------

   function Read_Replies
     (Self            : not null access Ref;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.Long;
      Timeout         : DDS.Duration_T)
      return Reply_DataReaders.Container'Class
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Read_Replies unimplemented");
      raise Program_Error with "Unimplemented function Read_Replies";
      return Read_Replies (Self => Self, Min_Reply_Count => Min_Reply_Count,
         Max_Reply_Count => Max_Reply_Count, Timeout => Timeout);
   end Read_Replies;

   ------------------------------------
   -- Read_Reply_For_Related_Request --
   ------------------------------------

   function Read_Reply_For_Related_Request
     (Self                 : not null access Ref;
      Replies              : aliased Reply_DataReaders.Treats.Data_Type;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Related_Request_Info : not null access DDS.SampleIdentity_T)
      return DDS.ReturnCode_T
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Read_Reply_For_Related_Request unimplemented");
      raise Program_Error with "Unimplemented function Read_Reply_For_Related_Request";
      return Read_Reply_For_Related_Request (Self => Self, Replies => Replies,
         Sample_Info => Sample_Info,
         Related_Request_Info => Related_Request_Info);
   end Read_Reply_For_Related_Request;

   --------------------------------------
   -- Read_Replies_For_Related_Request --
   --------------------------------------

   function Read_Replies_For_Related_Request
     (Self                 : not null access Ref;
      Replies              : not null Reply_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Related_Request_Info : not null access DDS.SampleIdentity_T)
      return DDS.ReturnCode_T
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Read_Replies_For_Related_Request unimplemented");
      raise Program_Error with "Unimplemented function Read_Replies_For_Related_Request";
      return Read_Replies_For_Related_Request (Self => Self,
         Replies => Replies, Sample_Info => Sample_Info,
         Related_Request_Info => Related_Request_Info);
   end Read_Replies_For_Related_Request;

   --------------------------------------
   -- Read_Replies_For_Related_Request --
   --------------------------------------

   function Read_Replies_For_Related_Request
     (Self                 : not null access Ref;
      Related_Request_Info : not null access DDS.SampleIdentity_T)
      return Reply_DataReaders.Container'Class
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Read_Replies_For_Related_Request unimplemented");
      raise Program_Error with "Unimplemented function Read_Replies_For_Related_Request";
      return Read_Replies_For_Related_Request (Self => Self,
         Related_Request_Info => Related_Request_Info);
   end Read_Replies_For_Related_Request;

   -----------------
   -- Return_Loan --
   -----------------

   procedure Return_Loan
     (Self         : not null access Ref;
      Replies      : not null Reply_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info  : DDS.SampleInfo_Seq.Sequence_Access)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Return_Loan unimplemented");
      raise Program_Error with "Unimplemented procedure Return_Loan";
   end Return_Loan;

   ------------
   -- Delete --
   ------------

   procedure Delete (This : in out Ref) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Delete unimplemented");
      raise Program_Error with "Unimplemented procedure Delete";
   end Delete;

   ----------------------
   -- Wait_For_Replies --
   ----------------------

   procedure Wait_For_Replies
     (This      : in out Ref;
      Min_Count : Dds.Long;
      Max_Wait  : DDS.Duration_T)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Wait_For_Replies unimplemented");
      raise Program_Error with "Unimplemented procedure Wait_For_Replies";
   end Wait_For_Replies;

   ----------------------
   -- Wait_For_Replies --
   ----------------------

   procedure Wait_For_Replies
     (This      : in out Ref;
      Min_Count : Dds.Long;
      Max_Wait  : Duration)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Wait_For_Replies unimplemented");
      raise Program_Error with "Unimplemented procedure Wait_For_Replies";
   end Wait_For_Replies;

   ----------------------
   -- Wait_For_Replies --
   ----------------------

   procedure Wait_For_Replies
     (This      : in out Ref;
      Min_Count : Dds.Long;
      Max_Wait  : Ada.Real_Time.Time_Span)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Wait_For_Replies unimplemented");
      raise Program_Error with "Unimplemented procedure Wait_For_Replies";
   end Wait_For_Replies;

   -----------------------------------------
   -- Wait_For_Replies_For_Related_Reques --
   -----------------------------------------

   procedure Wait_For_Replies_For_Related_Reques
     (This               : in out Ref;
      Min_Count          : Dds.Long;
      Max_Wait           : DDS.Duration_T;
      Related_Request_Id : access DDS.SampleIdentity_T)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Wait_For_Replies_For_Related_Reques unimplemented");
      raise Program_Error with "Unimplemented procedure Wait_For_Replies_For_Related_Reques";
   end Wait_For_Replies_For_Related_Reques;

   -----------------------------------------
   -- Wait_For_Replies_For_Related_Reques --
   -----------------------------------------

   procedure Wait_For_Replies_For_Related_Reques
     (This               : in out Ref;
      Min_Count          : Dds.Long;
      Max_Wait           : Duration;
      Related_Request_Id : access DDS.SampleIdentity_T)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Wait_For_Replies_For_Related_Reques unimplemented");
      raise Program_Error with "Unimplemented procedure Wait_For_Replies_For_Related_Reques";
   end Wait_For_Replies_For_Related_Reques;

   -----------------------------------------
   -- Wait_For_Replies_For_Related_Reques --
   -----------------------------------------

   procedure Wait_For_Replies_For_Related_Reques
     (This               : in out Ref;
      Min_Count          : Dds.Long;
      Max_Wait           : Ada.Real_Time.Time_Span;
      Related_Request_Id : access DDS.SampleIdentity_T)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Wait_For_Replies_For_Related_Reques unimplemented");
      raise Program_Error with "Unimplemented procedure Wait_For_Replies_For_Related_Reques";
   end Wait_For_Replies_For_Related_Reques;

   ----------------------------
   -- Get_Request_DataWriter --
   ----------------------------

   function Get_Request_DataWriter
     (Self : not null access Ref)
      return Request_DataWriters.Ref_Access
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Get_Request_DataWriter unimplemented");
      raise Program_Error with "Unimplemented function Get_Request_DataWriter";
      return Get_Request_DataWriter (Self => Self);
   end Get_Request_DataWriter;

   --------------------------
   -- Get_Reply_DataReader --
   --------------------------

   function Get_Reply_DataReader
     (Self : not null access Ref)
      return Reply_DataReaders.Ref_Access
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Get_Reply_DataReader unimplemented");
      raise Program_Error with "Unimplemented function Get_Reply_DataReader";
      return Get_Reply_DataReader (Self => Self);
   end Get_Reply_DataReader;

end Dds.Request_Reply.Request_Generic;
