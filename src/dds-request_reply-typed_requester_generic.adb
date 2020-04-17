pragma Ada_2012;
package body DDS.Request_Reply.Typed_Requester_Generic is

   -----------------------------
   -- Get_Request_Data_Writer --
   -----------------------------

   function Get_Request_Data_Writer
     (Self : not null access Ref) return DDS.DataWriter.Ref_Access
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Get_Request_Data_Writer unimplemented");
      return raise Program_Error
          with "Unimplemented function Get_Request_Data_Writer";
   end Get_Request_Data_Writer;

   ---------------------------
   -- Get_Reply_Data_Reader --
   ---------------------------

   function Get_Reply_Data_Reader
     (Self : not null access Ref) return DDS.DataReader.Ref_Access
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Get_Reply_Data_Reader unimplemented");
      return raise Program_Error
          with "Unimplemented function Get_Reply_Data_Reader";
   end Get_Reply_Data_Reader;

   ------------
   -- Create --
   ------------

   function Create
     (Participant      : DDS.DomainParticipant.Ref_Access;
      Service_Name     : DDS.String; Qos_Library_Name : DDS.String;
      Qos_Profile_Name : DDS.String;
      Publisher        : DDS.Publisher.Ref_Access     := null;
      Subscriber       : DDS.Subscriber.Ref_Access    := null;
      A_Listner        : Request_Listeners.Ref_Access := null;
      Mask : DDS.StatusMask := DDS.STATUS_MASK_NONE) return Ref_Access
   is
   begin
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      return raise Program_Error with "Unimplemented function Create";
   end Create;

   ------------
   -- Create --
   ------------

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Request_Topic_Name : DDS.String; Reply_Topic_Name : DDS.String;
      Qos_Library_Name   : DDS.String; Qos_Profile_Name : DDS.String;
      Publisher          : DDS.Publisher.Ref_Access     := null;
      Subscriber         : DDS.Subscriber.Ref_Access    := null;
      A_Listner          : Request_Listeners.Ref_Access := null;
      Mask : DDS.StatusMask := DDS.STATUS_MASK_NONE) return Ref_Access
   is
   begin
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      return raise Program_Error with "Unimplemented function Create";
   end Create;

   ------------
   -- Create --
   ------------

   function Create
     (Participant    : DDS.DomainParticipant.Ref_Access;
      Service_Name   : DDS.String; Datawriter_Qos : DDS.DataWriterQos;
      Datareader_Qos : DDS.DataReaderQos;
      Publisher      : DDS.Publisher.Ref_Access     := null;
      Subscriber     : DDS.Subscriber.Ref_Access    := null;
      A_Listner      : Request_Listeners.Ref_Access := null;
      Mask : DDS.StatusMask := DDS.STATUS_MASK_NONE) return Ref_Access
   is
   begin
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      return raise Program_Error with "Unimplemented function Create";
   end Create;

   ------------
   -- Create --
   ------------

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Request_Topic_Name : DDS.String; Reply_Topic_Name : DDS.String;
      Datawriter_Qos : DDS.DataWriterQos; Datareader_Qos : DDS.DataReaderQos;
      Publisher          : DDS.Publisher.Ref_Access     := null;
      Subscriber         : DDS.Subscriber.Ref_Access    := null;
      A_Listner          : Request_Listeners.Ref_Access := null;
      Mask : DDS.StatusMask := DDS.STATUS_MASK_NONE) return Ref_Access
   is
   begin
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      return raise Program_Error with "Unimplemented function Create";
   end Create;

   ------------
   -- Delete --
   ------------

   procedure Delete (Self : in out Ref_Access) is
   begin
      pragma Compile_Time_Warning (Standard.True, "Delete unimplemented");
      raise Program_Error with "Unimplemented procedure Delete";
   end Delete;

   ------------------
   -- Send_Request --
   ------------------

   function Send_Request
     (Self : not null access Ref; Data : Request_DataWriters.Treats.Data_Type)
      return DDS.ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Send_Request unimplemented");
      return raise Program_Error with "Unimplemented function Send_Request";
   end Send_Request;

   ------------------
   -- Send_Request --
   ------------------

   procedure Send_Request
     (Self : not null access Ref; Data : Request_DataWriters.Treats.Data_Type)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Send_Request unimplemented");
      raise Program_Error with "Unimplemented procedure Send_Request";
   end Send_Request;

   ------------------
   -- Send_Request --
   ------------------

   function Send_Request
     (Self : not null access Ref; Data : Request_DataWriters.Treats.Data_Type)
      return Reply_DataReaders.Treats.Data_Type
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Send_Request unimplemented");
      return raise Program_Error with "Unimplemented function Send_Request";
   end Send_Request;

   ------------------
   -- Send_Request --
   ------------------

   procedure Send_Request
     (Self    : not null access Ref;
      Request : access Request_DataWriters.Treats.Data_Type)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Send_Request unimplemented");
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
      pragma Compile_Time_Warning (Standard.True,
         "Send_Request unimplemented");
      return raise Program_Error with "Unimplemented function Send_Request";
   end Send_Request;

   ------------------
   -- Send_Request --
   ------------------

   function Send_Request
     (Self    : not null access Ref;
      Request : Request_DataWriters.Treats.Data_Type) return Reply_DataReaders
     .Container
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Send_Request unimplemented");
      return raise Program_Error with "Unimplemented function Send_Request";
   end Send_Request;

   ------------------
   -- Send_Request --
   ------------------

   function Send_Request
     (Self            : not null access Ref;
      Request         : access Request_DataWriters.Treats.Data_Type;
      Min_Reply_Count : DDS.Natural; Max_Reply_Count : DDS.long;
      Timeout : DDS.Duration_T := DURATION_INFINITE) return Reply_DataReaders
     .Container
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Send_Request unimplemented");
      return raise Program_Error with "Unimplemented function Send_Request";
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
      pragma Compile_Time_Warning (Standard.True,
         "Send_Request unimplemented");
      raise Program_Error with "Unimplemented procedure Send_Request";
   end Send_Request;

   -------------------
   -- Receive_Reply --
   -------------------

   function Receive_Reply
     (Self     :         not null access Ref;
      Replies  : aliased Reply_DataReaders.Treats.Data_Type;
      Info_Seq :         not null access DDS.SampleInfo_Seq.Sequence;
      Timeout  :         DDS.Duration_T) return DDS.ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Receive_Reply unimplemented");
      return raise Program_Error with "Unimplemented function Receive_Reply";
   end Receive_Reply;

   -------------------
   -- Receive_Reply --
   -------------------

   function Receive_Reply
     (Self : not null access Ref; Timeout : DDS.Duration_T)
      return Reply_DataReaders.Container
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Receive_Reply unimplemented");
      return raise Program_Error with "Unimplemented function Receive_Reply";
   end Receive_Reply;

   ---------------------
   -- Receive_Replies --
   ---------------------

   function Receive_Replies
     (Self    : not null access Ref;
      Replies : not null Reply_DataReaders.Treats.Data_Sequences
        .Sequence_Access;
      Sample_Info     : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count : DDS.Natural; Max_Reply_Count : DDS.long;
      Timeout         : DDS.Duration_T) return DDS.ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Receive_Replies unimplemented");
      return raise Program_Error with "Unimplemented function Receive_Replies";
   end Receive_Replies;

   ---------------------
   -- Receive_Replies --
   ---------------------

   procedure Receive_Replies
     (Self    : not null access Ref;
      Replies : not null Reply_DataReaders.Treats.Data_Sequences
        .Sequence_Access;
      Sample_Info     : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count : DDS.Natural; Max_Reply_Count : DDS.long;
      Timeout         : DDS.Duration_T)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Receive_Replies unimplemented");
      raise Program_Error with "Unimplemented procedure Receive_Replies";
   end Receive_Replies;

   ---------------------
   -- Receive_Replies --
   ---------------------

   function Receive_Replies
     (Self            : not null access Ref; Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.long; Timeout : DDS.Duration_T)
      return Reply_DataReaders.Container
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Receive_Replies unimplemented");
      return raise Program_Error with "Unimplemented function Receive_Replies";
   end Receive_Replies;

   ---------------------
   -- Receive_Replies --
   ---------------------

   function Receive_Replies
     (Self    : not null access Ref;
      Replies : not null Reply_DataReaders.Treats.Data_Sequences
        .Sequence_Access;
      Sample_Info     : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count : DDS.Natural; Max_Reply_Count : DDS.long;
      Timeout         : Duration) return DDS.ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Receive_Replies unimplemented");
      return raise Program_Error with "Unimplemented function Receive_Replies";
   end Receive_Replies;

   ---------------------
   -- Receive_Replies --
   ---------------------

   function Receive_Replies
     (Self            : not null access Ref; Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.long; Timeout : Duration) return Reply_DataReaders
     .Container
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Receive_Replies unimplemented");
      return raise Program_Error with "Unimplemented function Receive_Replies";
   end Receive_Replies;

   ----------------
   -- Take_Reply --
   ----------------

   function Take_Reply
     (Self        :         not null access Ref;
      Replies     : aliased Reply_DataReaders.Treats.Data_Type;
      Sample_Info :         not null access DDS.SampleInfo_Seq.Sequence;
      Timeout     :         DDS.Duration_T) return DDS.ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True, "Take_Reply unimplemented");
      return raise Program_Error with "Unimplemented function Take_Reply";
   end Take_Reply;

   ------------------
   -- Take_Replies --
   ------------------

   function Take_Replies
     (Self    : not null access Ref;
      Replies : not null Reply_DataReaders.Treats.Data_Sequences
        .Sequence_Access;
      Sample_Info     : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count : DDS.Natural; Max_Reply_Count : DDS.long;
      Timeout         : DDS.Duration_T) return DDS.ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Take_Replies unimplemented");
      return raise Program_Error with "Unimplemented function Take_Replies";
   end Take_Replies;

   ------------------
   -- Take_Replies --
   ------------------

   function Take_Replies
     (Self            : not null access Ref; Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.long; Timeout : DDS.Duration_T)
      return Reply_DataReaders.Container
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Take_Replies unimplemented");
      return raise Program_Error with "Unimplemented function Take_Replies";
   end Take_Replies;

   ------------------------------------
   -- Take_Reply_For_Related_Request --
   ------------------------------------

   function Take_Reply_For_Related_Request
     (Self                 :         not null access Ref;
      Replies              : aliased Reply_DataReaders.Treats.Data_Type;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Related_Request_Info : not null access DDS.SampleIdentity_T) return DDS
     .ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Take_Reply_For_Related_Request unimplemented");
      return raise Program_Error
          with "Unimplemented function Take_Reply_For_Related_Request";
   end Take_Reply_For_Related_Request;

   --------------------------------------
   -- Take_Replies_For_Related_Request --
   --------------------------------------

   function Take_Replies_For_Related_Request
     (Self    : not null access Ref;
      Replies : not null Reply_DataReaders.Treats.Data_Sequences
        .Sequence_Access;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Related_Request_Info : not null access DDS.SampleIdentity_T) return DDS
     .ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Take_Replies_For_Related_Request unimplemented");
      return raise Program_Error
          with "Unimplemented function Take_Replies_For_Related_Request";
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
      pragma Compile_Time_Warning (Standard.True,
         "Take_Replies_For_Related_Request unimplemented");
      return raise Program_Error
          with "Unimplemented function Take_Replies_For_Related_Request";
   end Take_Replies_For_Related_Request;

   ----------------
   -- Read_Reply --
   ----------------

   function Read_Reply
     (Self        :         not null access Ref;
      Replies     : aliased Reply_DataReaders.Treats.Data_Type;
      Sample_Info :         not null access DDS.SampleInfo_Seq.Sequence;
      Timeout     :         DDS.Duration_T) return DDS.ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True, "Read_Reply unimplemented");
      return raise Program_Error with "Unimplemented function Read_Reply";
   end Read_Reply;

   ------------------
   -- Read_Replies --
   ------------------

   function Read_Replies
     (Self    : not null access Ref;
      Replies : not null Reply_DataReaders.Treats.Data_Sequences
        .Sequence_Access;
      Sample_Info     : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count : DDS.Natural; Max_Reply_Count : DDS.long;
      Timeout         : DDS.Duration_T) return DDS.ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Read_Replies unimplemented");
      return raise Program_Error with "Unimplemented function Read_Replies";
   end Read_Replies;

   ------------------
   -- Read_Replies --
   ------------------

   function Read_Replies
     (Self            : not null access Ref; Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.long; Timeout : DDS.Duration_T)
      return Reply_DataReaders.Container'Class
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Read_Replies unimplemented");
      return raise Program_Error with "Unimplemented function Read_Replies";
   end Read_Replies;

   ------------------------------------
   -- Read_Reply_For_Related_Request --
   ------------------------------------

   function Read_Reply_For_Related_Request
     (Self                 :         not null access Ref;
      Replies              : aliased Reply_DataReaders.Treats.Data_Type;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Related_Request_Info : DDS.SampleIdentity_T) return DDS.ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Read_Reply_For_Related_Request unimplemented");
      return raise Program_Error
          with "Unimplemented function Read_Reply_For_Related_Request";
   end Read_Reply_For_Related_Request;

   --------------------------------------
   -- Read_Replies_For_Related_Request --
   --------------------------------------

   function Read_Replies_For_Related_Request
     (Self    : not null access Ref;
      Replies : not null Reply_DataReaders.Treats.Data_Sequences
        .Sequence_Access;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Related_Request_Info : DDS.SampleIdentity_T) return DDS.ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Read_Replies_For_Related_Request unimplemented");
      return raise Program_Error
          with "Unimplemented function Read_Replies_For_Related_Request";
   end Read_Replies_For_Related_Request;

   --------------------------------------
   -- Read_Replies_For_Related_Request --
   --------------------------------------

   function Read_Replies_For_Related_Request
     (Self : not null access Ref; Related_Request_Info : DDS.SampleIdentity_T)
      return Reply_DataReaders.Container'Class
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Read_Replies_For_Related_Request unimplemented");
      return raise Program_Error
          with "Unimplemented function Read_Replies_For_Related_Request";
   end Read_Replies_For_Related_Request;

   -----------------
   -- Return_Loan --
   -----------------

   procedure Return_Loan
     (Self    : not null access Ref;
      Replies : not null Reply_DataReaders.Treats.Data_Sequences
        .Sequence_Access;
      Sample_Info : DDS.SampleInfo_Seq.Sequence_Access)
   is
   begin
      pragma Compile_Time_Warning (Standard.True, "Return_Loan unimplemented");
      raise Program_Error with "Unimplemented procedure Return_Loan";
   end Return_Loan;

   -----------------
   -- Return_Loan --
   -----------------

   procedure Return_Loan
     (Self        : not null access Ref;
      Replies     : Reply_DataReaders.Treats.Data_Sequences.Sequence;
      Sample_Info : DDS.SampleInfo_Seq.Sequence)
   is
   begin
      pragma Compile_Time_Warning (Standard.True, "Return_Loan unimplemented");
      raise Program_Error with "Unimplemented procedure Return_Loan";
   end Return_Loan;

   ------------
   -- Delete --
   ------------

   procedure Delete (This : in out Ref) is
   begin
      pragma Compile_Time_Warning (Standard.True, "Delete unimplemented");
      raise Program_Error with "Unimplemented procedure Delete";
   end Delete;

   ----------------------
   -- Wait_For_Replies --
   ----------------------

   procedure Wait_For_Replies
     (This : in out Ref; Min_Count : Dds.long; Max_Wait : DDS.Duration_T)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Wait_For_Replies unimplemented");
      raise Program_Error with "Unimplemented procedure Wait_For_Replies";
   end Wait_For_Replies;

   -----------------------------------------
   -- Wait_For_Replies_For_Related_Reques --
   -----------------------------------------

   procedure Wait_For_Replies_For_Related_Reques
     (This : in out Ref; Min_Count : Dds.long; Max_Wait : DDS.Duration_T;
      Related_Request_Id :        DDS.SampleIdentity_T)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Wait_For_Replies_For_Related_Reques unimplemented");
      raise Program_Error
        with "Unimplemented procedure Wait_For_Replies_For_Related_Reques";
   end Wait_For_Replies_For_Related_Reques;

   ----------------------------
   -- Get_Request_DataWriter --
   ----------------------------

   function Get_Request_DataWriter
     (Self : not null access Ref) return Request_DataWriters.Ref_Access
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Get_Request_DataWriter unimplemented");
      return raise Program_Error
          with "Unimplemented function Get_Request_DataWriter";
   end Get_Request_DataWriter;

   --------------------------
   -- Get_Reply_DataReader --
   --------------------------

   function Get_Reply_DataReader
     (Self : not null access Ref) return Reply_DataReaders.Ref_Access
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Get_Reply_DataReader unimplemented");
      return raise Program_Error
          with "Unimplemented function Get_Reply_DataReader";
   end Get_Reply_DataReader;

   --------------------------------
   -- On_Offered_Deadline_Missed --
   --------------------------------

   procedure On_Offered_Deadline_Missed
     (Self   :    not null access DataReader_Listner;
      Writer :    access DDS.DataWriter.Ref'Class;
      Status : in DDS.OfferedDeadlineMissedStatus)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Offered_Deadline_Missed unimplemented");
      raise Program_Error
        with "Unimplemented procedure On_Offered_Deadline_Missed";
   end On_Offered_Deadline_Missed;

   -----------------------
   -- On_Data_Available --
   -----------------------

   procedure On_Data_Available
     (Self       :    not null access DataReader_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Data_Available unimplemented");
      raise Program_Error with "Unimplemented procedure On_Data_Available";
   end On_Data_Available;

   ---------------------------------
   -- On_Offered_Incompatible_Qos --
   ---------------------------------

   procedure On_Offered_Incompatible_Qos
     (Self   :    not null access DataReader_Listner;
      Writer :    access DDS.DataWriter.Ref'Class;
      Status : in DDS.OfferedIncompatibleQosStatus)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Offered_Incompatible_Qos unimplemented");
      raise Program_Error
        with "Unimplemented procedure On_Offered_Incompatible_Qos";
   end On_Offered_Incompatible_Qos;

   ------------------------
   -- On_Liveliness_Lost --
   ------------------------

   procedure On_Liveliness_Lost
     (Self   :    not null access DataReader_Listner;
      Writer :    access DDS.DataWriter.Ref'Class;
      Status : in DDS.LivelinessLostStatus)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Liveliness_Lost unimplemented");
      raise Program_Error with "Unimplemented procedure On_Liveliness_Lost";
   end On_Liveliness_Lost;

   ----------------------------
   -- On_Publication_Matched --
   ----------------------------

   procedure On_Publication_Matched
     (Self   :    not null access DataReader_Listner;
      Writer :    access DDS.DataWriter.Ref'Class;
      Status : in DDS.PublicationMatchedStatus)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Publication_Matched unimplemented");
      raise Program_Error
        with "Unimplemented procedure On_Publication_Matched";
   end On_Publication_Matched;

   --------------------------------------
   -- On_Reliable_Writer_Cache_Changed --
   --------------------------------------

   procedure On_Reliable_Writer_Cache_Changed
     (Self   :    not null access DataReader_Listner;
      Writer :    access DDS.DataWriter.Ref'Class;
      Status : in DDS.ReliableWriterCacheChangedStatus)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Reliable_Writer_Cache_Changed unimplemented");
      raise Program_Error
        with "Unimplemented procedure On_Reliable_Writer_Cache_Changed";
   end On_Reliable_Writer_Cache_Changed;

   -----------------------------------------
   -- On_Reliable_Reader_Activity_Changed --
   -----------------------------------------

   procedure On_Reliable_Reader_Activity_Changed
     (Self   :    not null access DataReader_Listner;
      Writer :    access DDS.DataWriter.Ref'Class;
      Status : in DDS.ReliableReaderActivityChangedStatus)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Reliable_Reader_Activity_Changed unimplemented");
      raise Program_Error
        with "Unimplemented procedure On_Reliable_Reader_Activity_Changed";
   end On_Reliable_Reader_Activity_Changed;

   --------------------------------
   -- On_Destination_Unreachable --
   --------------------------------

   procedure On_Destination_Unreachable
     (Self     :    not null access DataReader_Listner;
      Writer   :    access DDS.DataWriter.Ref'Class;
      Instance : in DDS.InstanceHandle_T; Locator : in DDS.Locator_T)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Destination_Unreachable unimplemented");
      raise Program_Error
        with "Unimplemented procedure On_Destination_Unreachable";
   end On_Destination_Unreachable;

   ---------------------
   -- On_Data_Request --
   ---------------------

   procedure On_Data_Request
     (Self    :        not null access DataReader_Listner;
      Writer  :    access DDS.DataWriter.Ref'Class; Cookie : in DDS.Cookie_T;
      Request : in out System.Address)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Data_Request unimplemented");
      raise Program_Error with "Unimplemented procedure On_Data_Request";
   end On_Data_Request;

   --------------------
   -- On_Data_Return --
   --------------------

   procedure On_Data_Return
     (Self   :    not null access DataReader_Listner;
      Writer :    access DDS.DataWriter.Ref'Class; Arg : System.Address;
      Cookie : in DDS.Cookie_T)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Data_Return unimplemented");
      raise Program_Error with "Unimplemented procedure On_Data_Return";
   end On_Data_Return;

   -----------------------
   -- On_Sample_Removed --
   -----------------------

   procedure On_Sample_Removed
     (Self   : not null access DataReader_Listner;
      Writer : access DDS.DataWriter.Ref'Class; Cookie : in DDS.Cookie_T)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Sample_Removed unimplemented");
      raise Program_Error with "Unimplemented procedure On_Sample_Removed";
   end On_Sample_Removed;

   --------------------------
   -- On_Instance_Replaced --
   --------------------------

   procedure On_Instance_Replaced
     (Self     :    not null access DataReader_Listner;
      Writer   :    access DDS.DataWriter.Ref'Class;
      Instance : in DDS.InstanceHandle_T)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Instance_Replaced unimplemented");
      raise Program_Error with "Unimplemented procedure On_Instance_Replaced";
   end On_Instance_Replaced;

   -----------------------------------
   -- On_Application_Acknowledgment --
   -----------------------------------

   procedure On_Application_Acknowledgment
     (Self   :    not null access DataReader_Listner;
      Writer :    access DDS.DataWriter.Ref'Class;
      Info   : in DDS.AcknowledgmentInfo)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Application_Acknowledgment unimplemented");
      raise Program_Error
        with "Unimplemented procedure On_Application_Acknowledgment";
   end On_Application_Acknowledgment;

   ---------------------------------
   -- On_Service_Request_Accepted --
   ---------------------------------

   procedure On_Service_Request_Accepted
     (Self   :    not null access DataReader_Listner;
      Writer :    access DDS.DataWriter.Ref'Class;
      Info   : in DDS.ServiceRequestAcceptedStatus)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Service_Request_Accepted unimplemented");
      raise Program_Error
        with "Unimplemented procedure On_Service_Request_Accepted";
   end On_Service_Request_Accepted;

   ----------------------------------
   -- On_Requested_Deadline_Missed --
   ----------------------------------

   procedure On_Requested_Deadline_Missed
     (Self       :    not null access DataWriter_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.RequestedDeadlineMissedStatus)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Requested_Deadline_Missed unimplemented");
      raise Program_Error
        with "Unimplemented procedure On_Requested_Deadline_Missed";
   end On_Requested_Deadline_Missed;

   -----------------------------------
   -- On_Requested_Incompatible_Qos --
   -----------------------------------

   procedure On_Requested_Incompatible_Qos
     (Self       :    not null access DataWriter_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.RequestedIncompatibleQosStatus)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Requested_Incompatible_Qos unimplemented");
      raise Program_Error
        with "Unimplemented procedure On_Requested_Incompatible_Qos";
   end On_Requested_Incompatible_Qos;

   ------------------------
   -- On_Sample_Rejected --
   ------------------------

   procedure On_Sample_Rejected
     (Self       :    not null access DataWriter_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.SampleRejectedStatus)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Sample_Rejected unimplemented");
      raise Program_Error with "Unimplemented procedure On_Sample_Rejected";
   end On_Sample_Rejected;

   ---------------------------
   -- On_Liveliness_Changed --
   ---------------------------

   procedure On_Liveliness_Changed
     (Self       :    not null access DataWriter_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.LivelinessChangedStatus)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Liveliness_Changed unimplemented");
      raise Program_Error with "Unimplemented procedure On_Liveliness_Changed";
   end On_Liveliness_Changed;

   -----------------------
   -- On_Data_Available --
   -----------------------

   procedure On_Data_Available
     (Self       :    not null access DataWriter_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Data_Available unimplemented");
      raise Program_Error with "Unimplemented procedure On_Data_Available";
   end On_Data_Available;

   -----------------------------
   -- On_Subscription_Matched --
   -----------------------------

   procedure On_Subscription_Matched
     (Self       :    not null access DataWriter_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.SubscriptionMatchedStatus)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Subscription_Matched unimplemented");
      raise Program_Error
        with "Unimplemented procedure On_Subscription_Matched";
   end On_Subscription_Matched;

   --------------------
   -- On_Sample_Lost --
   --------------------

   procedure On_Sample_Lost
     (Self       :    not null access DataWriter_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.SampleLostStatus)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "On_Sample_Lost unimplemented");
      raise Program_Error with "Unimplemented procedure On_Sample_Lost";
   end On_Sample_Lost;

end DDS.Request_Reply.Typed_Requester_Generic;
