pragma Ada_2012;

package body DDS.Request_Reply.Typed_Replier_Generic is
   use type DDS.Publisher.Ref_Access;
   use type DDS.Subscriber.Ref_Access;
   -----------------------------
   -- Get_Request_Data_Reader --
   -----------------------------

   function Get_Request_Data_Reader
     (Self : not null access Ref) return DDS.DataReader.Ref_Access
   is (DDS.DataReader.Ref_Access (Self.Reply_DataWriter));

   ---------------------------
   -- Get_Reply_Data_Writer --
   ---------------------------

   function Get_Reply_Data_Writer
     (Self : not null access Ref) return DDS.DataWriter.Ref_Access
   is (DDS.DataWriter.Ref_Access (Self.Reply_DataWriter));

   ------------
   -- Create --
   ------------

   function Create
     (Participant      : DDS.DomainParticipant.Ref_Access;
      Service_Name     : DDS.String;
      Qos_Library_Name : DDS.String;
      Qos_Profile_Name : DDS.String;
      Publisher        : DDS.Publisher.Ref_Access     := null;
      Subscriber       : DDS.Subscriber.Ref_Access    := null;
      A_Listner        : Replyer_Listeners.Ref_Access := null;
      Mask             : DDS.StatusMask := DDS.STATUS_MASK_NONE) return Ref_Access
   is
      Dummy              : aliased Ref;
      Request_Topic_Name : DDS.String := Dummy.Create_Request_Topic_Name_From_Service_Name (Service_Name);
      Reply_Topic_Name   : DDS.String := Dummy.Create_Reply_Topic_Name_From_Service_Name (Service_Name);
      Ret                : Ref_Access;
   begin
      Ret := Create (Participant,
                     Request_Topic_Name, Reply_Topic_Name,
                     Qos_Library_Name, Qos_Profile_Name,
                     Publisher, Subscriber,
                     A_Listner, Mask);
      Finalize (Request_Topic_Name);
      Finalize (Reply_Topic_Name);
      return Ret;

   end Create;

   ------------
   -- Create --
   ------------

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Request_Topic_Name : DDS.String;
      Reply_Topic_Name   : DDS.String;
      Qos_Library_Name   : DDS.String;
      Qos_Profile_Name   : DDS.String;
      Publisher          : DDS.Publisher.Ref_Access     := null;
      Subscriber         : DDS.Subscriber.Ref_Access    := null;
      A_Listner          : Replyer_Listeners.Ref_Access := null;
      Mask               : DDS.StatusMask := DDS.STATUS_MASK_NONE) return Ref_Access
   is
      Ret : Ref_Access := new Ref;
   begin
      Ret.Participant := Participant;
      Ret.Validate (Publisher, Subscriber);

      Ret.Reply_Topic := Ret.Create_Reply_Topic_With_Profile
        (Topic_Name       => Reply_Topic_Name,
         Type_Name        => Reply_DataWriters.Treats.Get_Type_Name,
         Qos_Library_Name => Qos_Library_Name,
         Qos_Profile_Name => Qos_Profile_Name);

      Ret.Request_Topic := Ret.Create_Request_Topic_With_Profile
        (Topic_Name       => Request_Topic_Name,
         Type_Name        => Request_DataReaders.Treats.Get_Type_Name,
         Qos_Library_Name => Qos_Library_Name,
         Qos_Profile_Name => Qos_Profile_Name);

      Ret.Reply_DataWriter := Reply_DataWriters.Ref_Access
        ((if Publisher = null
         then
            Participant.Create_DataWriter_With_Profile
           (A_Topic      => Ret.Reply_Topic,
            Library_Name => Qos_Library_Name,
            Profile_Name => Qos_Profile_Name,
            A_Listener   => Ret.Writer_Listner'Unrestricted_Access,
            Mask         => Mask)
         else
            Publisher.Create_DataWriter_With_Profile
           (A_Topic      => Ret.Request_Topic,
            Library_Name => Qos_Library_Name,
            Profile_Name => Qos_Profile_Name,
            A_Listener   => Ret.Writer_Listner'Unrestricted_Access,
            Mask         => Mask)));

      Ret.Request_DataReader := Request_DataReaders.Ref_Access
        ((if Subscriber = null
         then
            Participant.Create_DataReader_With_Profile
           (Topic      => Ret.Reply_Topic.As_TopicDescription,
            Library_Name => Qos_Library_Name,
            Profile_Name => Qos_Profile_Name,
            A_Listener   => Ret.Reader_Listner'Unrestricted_Access,
            Mask         => Mask)
         else
            Subscriber.Create_DataReader_With_Profile
           (Topic      => Ret.Request_Topic.As_TopicDescription,
            Library_Name => Qos_Library_Name,
            Profile_Name => Qos_Profile_Name,
            A_Listener   => Ret.Reader_Listner'Unrestricted_Access,
            Mask         => Mask)));

      return raise Program_Error with "Unimplemented function Create";
   end Create;

   ------------
   -- Create --
   ------------

   function Create
     (Participant    : DDS.DomainParticipant.Ref_Access;
      Service_Name   : DDS.String;
      Datawriter_Qos : DDS.DataWriterQos;
      Datareader_Qos : DDS.DataReaderQos;
      Publisher      : DDS.Publisher.Ref_Access     := null;
      Subscriber     : DDS.Subscriber.Ref_Access    := null;
      A_Listner      : Replyer_Listeners.Ref_Access := null;
      Mask           : DDS.StatusMask := DDS.STATUS_MASK_NONE) return Ref_Access
   is
      Dummy              : aliased Ref;
      Request_Topic_Name : DDS.String := Dummy.Create_Request_Topic_Name_From_Service_Name (Service_Name);
      Reply_Topic_Name   : DDS.String := Dummy.Create_Reply_Topic_Name_From_Service_Name (Service_Name);
      Ret                : Ref_Access;
   begin
      Ret :=  Create (Participant,
                      Request_Topic_Name, Reply_Topic_Name,
                      Datawriter_Qos, Datareader_Qos,
                      Publisher, Subscriber,
                      A_Listner, Mask);
      Finalize (Request_Topic_Name);
      Finalize (Reply_Topic_Name);
      return Ret;
   end Create;

   ------------
   -- Create --
   ------------

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Request_Topic_Name : DDS.String;
      Reply_Topic_Name   : DDS.String;
      Datawriter_Qos     : DDS.DataWriterQos;
      Datareader_Qos     : DDS.DataReaderQos;
      Publisher          : DDS.Publisher.Ref_Access     := null;
      Subscriber         : DDS.Subscriber.Ref_Access    := null;
      A_Listner          : Replyer_Listeners.Ref_Access := null;
      Mask               : DDS.StatusMask := DDS.STATUS_MASK_NONE) return Ref_Access
   is
      Ret : Ref_Access := new Ref;
   begin
      --        Ret.Create_Reply_Topic (Reply_Topic_Name, Reply_DataWriters.Treats.Get_Type_Name);
      --        Ret.Create_Request_Topic (Request_Topic_Name, Request_DataReaders.Treats.Get_Type_Name);
      --        pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      return raise Program_Error with "Unimplemented function Create";
   end Create;

   ------------
   -- Delete --
   ------------

   procedure Delete (Self : in out Ref_Access) is
   begin
      --        pragma Compile_Time_Warning (Standard.True, "Delete unimplemented");
      raise Program_Error with "Unimplemented procedure Delete";
   end Delete;

   ----------------
   -- Send_Reply --
   ----------------

   function Send_Reply
     (Self  : not null access Ref;
      Reply : access Reply_DataWriters.Treats.Data_Type;
      Id    : access DDS.SampleIdentity_T) return DDS.ReturnCode_T
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True, "Send_Reply unimplemented");
      return raise Program_Error with "Unimplemented function Send_Reply";
   end Send_Reply;

   ----------------
   -- Send_Reply --
   ----------------

   function Send_Reply
     (Self : not null access Ref; Reply : Reply_DataWriters.Treats.Data_Type;
      Id   : DDS.SampleIdentity_T) return DDS.ReturnCode_T
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True, "Send_Reply unimplemented");
      return raise Program_Error with "Unimplemented function Send_Reply";
   end Send_Reply;

   ----------------
   -- Send_Reply --
   ----------------

   procedure Send_Reply
     (Self  : not null access Ref;
      Reply : access Reply_DataWriters.Treats.Data_Type;
      Id    : access DDS.SampleIdentity_T)
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True, "Send_Reply unimplemented");
      raise Program_Error with "Unimplemented procedure Send_Reply";
   end Send_Reply;

   ----------------
   -- Send_Reply --
   ----------------

   procedure Send_Reply
     (Self : not null access Ref; Reply : Reply_DataWriters.Treats.Data_Type;
      Id   : DDS.SampleIdentity_T)
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True, "Send_Reply unimplemented");
      raise Program_Error with "Unimplemented procedure Send_Reply";
   end Send_Reply;

   ---------------------
   -- Receive_Request --
   ---------------------

   function Receive_Request
     (Self     :        not null access Ref;
      Request  : in out Request_DataReaders.Treats.Data_Type;
      Info_Seq : in out DDS.SampleInfo;
      Timeout  :        DDS.Duration_T := DDS.DURATION_INFINITE) return DDS
     .ReturnCode_T
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True,
      --           "Receive_Request unimplemented");
      return raise Program_Error with "Unimplemented function Receive_Request";
   end Receive_Request;

   ---------------------
   -- Receive_Request --
   ---------------------

   procedure Receive_Request
     (Self     :        not null access Ref;
      Request  : in out Request_DataReaders.Treats.Data_Type;
      Info_Seq : in out DDS.SampleInfo;
      Timeout  :        DDS.Duration_T := DDS.DURATION_INFINITE)
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True,
      --           "Receive_Request unimplemented");
      raise Program_Error with "Unimplemented procedure Receive_Request";
   end Receive_Request;

   ---------------------
   -- Receive_Request --
   ---------------------

   function Receive_Request
     (Self : not null access Ref; Timeout : DDS.Duration_T)
      return Request_DataReaders.Container
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True,
      --           "Receive_Request unimplemented");
      return raise Program_Error with "Unimplemented function Receive_Request";
   end Receive_Request;

   ----------------------
   -- Receive_Requests --
   ----------------------

   function Receive_Requests
     (Self               : not null access Ref;
      Requests           : not null Request_DataReaders.Treats.Data_Sequences
      .Sequence_Access;
      Sample_Info        : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Requests_Count : DDS.long       := 1;
      Max_Requests_Count : DDS.long       := DDS.INFINITE;
      Timeout            : DDS.Duration_T := DDS.DURATION_INFINITE) return DDS
     .ReturnCode_T
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True,
      --           "Receive_Requests unimplemented");
      return raise Program_Error
        with "Unimplemented function Receive_Requests";
   end Receive_Requests;

   ----------------------
   -- Receive_Requests --
   ----------------------

   procedure Receive_Requests
     (Self            : not null access Ref;
      Requests        : not null Request_DataReaders.Treats.Data_Sequences
      .Sequence_Access;
      Sample_Info     : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count : DDS.long       := 1;
      Max_Reply_Count : DDS.long       := DDS.INFINITE;
      Timeout         : DDS.Duration_T := DDS.DURATION_INFINITE)
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True,
      --           "Receive_Requests unimplemented");
      raise Program_Error with "Unimplemented procedure Receive_Requests";
   end Receive_Requests;

   ----------------------
   -- Receive_Requests --
   ----------------------

   procedure Receive_Requests
     (Self            :        not null access Ref;
      Requests        : in out Request_DataReaders.Treats.Data_Sequences.Sequence;
      Sample_Info     : in out DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count :        DDS.long       := 1;
      Max_Reply_Count :        DDS.long       := DDS.INFINITE;
      Timeout         :        DDS.Duration_T := DDS.DURATION_INFINITE)
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True,
      --           "Receive_Requests unimplemented");
      raise Program_Error with "Unimplemented procedure Receive_Requests";
   end Receive_Requests;

   ---------------------
   -- Receive_Request --
   ---------------------

   function Receive_Request
     (Self            : not null access Ref;
      Min_Reply_Count : DDS.long := 1;
      Max_Reply_Count : DDS.long       := DDS.INFINITE;
      Timeout         : DDS.Duration_T := DDS.DURATION_INFINITE)
      return Request_DataReaders.Container
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True,
      --                                     "Receive_Request unimplemented");
      return raise Program_Error with "Unimplemented function Receive_Request";
   end Receive_Request;

   ---------------------
   -- Receive_Request --
   ---------------------

   function Receive_Request
     (Self            : not null access Ref;
      Requests        : not null Request_DataReaders.Treats.Data_Sequences
      .Sequence_Access;
      Sample_Info     : not null DDS.SampleInfo_Seq.Sequence_Access;
      Min_Reply_Count : DDS.Natural; Max_Reply_Count : DDS.long;
      Timeout         : Duration) return DDS.ReturnCode_T
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True,
      --                                     "Receive_Request unimplemented");
      return raise Program_Error with "Unimplemented function Receive_Request";
   end Receive_Request;

   ---------------------
   -- Receive_Request --
   ---------------------

   function Receive_Request
     (Self            : not null access Ref; Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.long; Timeout : Duration)
      return Request_DataReaders.Container
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True,
      --                                     "Receive_Request unimplemented");
      return raise Program_Error with "Unimplemented function Receive_Request";
   end Receive_Request;

   ------------------
   -- Take_Request --
   ------------------

   function Take_Request
     (Self        :         not null access Ref;
      Requests    : aliased Request_DataReaders.Treats.Data_Type;
      Sample_Info :         not null access DDS.SampleInfo_Seq.Sequence;
      Timeout     :         DDS.Duration_T) return DDS.ReturnCode_T
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True,
      --                                     "Take_Request unimplemented");
      return raise Program_Error with "Unimplemented function Take_Request";
   end Take_Request;

   ------------------
   -- Take_Request --
   ------------------

   function Take_Request
     (Self            : not null access Ref;
      Requests        : not null Request_DataReaders.Treats.Data_Sequences
      .Sequence_Access;
      Sample_Info     : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count : DDS.Natural := 1;
      Max_Reply_Count : DDS.long    := DDS.INFINITE; Timeout : DDS.Duration_T)
      return DDS.ReturnCode_T
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True,
      --                                     "Take_Request unimplemented");
      return raise Program_Error with "Unimplemented function Take_Request";
   end Take_Request;

   ------------------
   -- Take_Request --
   ------------------

   function Take_Request
     (Self            : not null access Ref; Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.long; Timeout : DDS.Duration_T)
      return Request_DataReaders.Container
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True,
      --                                     "Take_Request unimplemented");
      return raise Program_Error with "Unimplemented function Take_Request";
   end Take_Request;

   ------------------
   -- Read_Request --
   ------------------

   function Read_Request
     (Self        :         not null access Ref;
      Request     : aliased Request_DataReaders.Treats.Data_Type;
      Sample_Info :         not null access DDS.SampleInfo_Seq.Sequence;
      Timeout     :         DDS.Duration_T) return DDS.ReturnCode_T
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True,
      --                                     "Read_Request unimplemented");
      return raise Program_Error with "Unimplemented function Read_Request";
   end Read_Request;

   ------------------
   -- Read_Request --
   ------------------

   function Read_Request
     (Self            : not null access Ref;
      Requests        : not null Request_DataReaders.Treats.Data_Sequences
      .Sequence_Access;
      Sample_Info     : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count : DDS.Natural; Max_Reply_Count : DDS.long;
      Timeout         : DDS.Duration_T) return DDS.ReturnCode_T
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True,
      --                                     "Read_Request unimplemented");
      return raise Program_Error with "Unimplemented function Read_Request";
   end Read_Request;

   ------------------
   -- Read_Request --
   ------------------

   function Read_Request
     (Self            : not null access Ref; Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.long; Timeout : DDS.Duration_T)
      return Request_DataReaders.Container'Class
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True,
      --                                     "Read_Request unimplemented");
      return raise Program_Error with "Unimplemented function Read_Request";
   end Read_Request;

   -----------------
   -- Return_Loan --
   -----------------

   procedure Return_Loan
     (Self        : not null access Ref;
      Replies     : not null Request_DataReaders.Treats.Data_Sequences
      .Sequence_Access;
      Sample_Info : DDS.SampleInfo_Seq.Sequence_Access)
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True, "Return_Loan unimplemented");
      raise Program_Error with "Unimplemented procedure Return_Loan";
   end Return_Loan;

   -----------------
   -- Return_Loan --
   -----------------

   procedure Return_Loan
     (Self        : not null access Ref;
      Replies     : Request_DataReaders.Treats.Data_Sequences.Sequence;
      Sample_Info : DDS.SampleInfo_Seq.Sequence)
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True, "Return_Loan unimplemented");
      raise Program_Error with "Unimplemented procedure Return_Loan";
   end Return_Loan;

   ------------
   -- Delete --
   ------------

   procedure Delete (This : in out Ref) is
   begin
      --        pragma Compile_Time_Warning (Standard.True, "Delete unimplemented");
      raise Program_Error with "Unimplemented procedure Delete";
   end Delete;

   ----------------------------
   -- Get_Request_DataReader --
   ----------------------------

   function Get_Request_DataReader
     (Self : not null access Ref) return Request_DataReaders.Ref_Access
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True,
      --                                     "Get_Request_DataReader unimplemented");
      return raise Program_Error
        with "Unimplemented function Get_Request_DataReader";
   end Get_Request_DataReader;

   --------------------------
   -- Get_Reply_Datawriter --
   --------------------------

   function Get_Reply_Datawriter
     (Self : not null access Ref) return Reply_DataWriters.Ref_Access
   is
   begin
      --        pragma Compile_Time_Warning (Standard.True,
      --                                     "Get_Reply_Datawriter unimplemented");
      return raise Program_Error
        with "Unimplemented function Get_Reply_Datawriter";
   end Get_Reply_Datawriter;


   --===========================================================================
   --===========================================================================

   use type Replyer_Listeners.Ref_Access;
   --------------------------------
   -- On_Offered_Deadline_Missed --
   --------------------------------

   procedure On_Offered_Deadline_Missed
     (Self   :    not null access DataReader_Listner;
      Writer :    access DDS.DataWriter.Ref'Class;
      Status : in DDS.OfferedDeadlineMissedStatus)
   is
   begin
      if Self.Parent.Listner /= null then
         Self.Parent.Listner.On_Offered_Deadline_Missed (Self.Parent.all'Access, Status);
      end if;
   end On_Offered_Deadline_Missed;

   -----------------------
   -- On_Data_Available --
   -----------------------

   procedure On_Data_Available
     (Self       :    not null access DataReader_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access)
   is
   begin
      if Self.Parent.Listner /= null then
         Self.Parent.Listner.On_Request_Avalible (Self.Parent.all'Access);
      end if;
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
      if Self.Parent.Listner /= null then
         Self.Parent.Listner.On_Offered_Incompatible_Qos (Self.Parent.all'Access, Status);
      end if;
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
      if Self.Parent.Listner /= null then
         Self.Parent.Listner.On_Liveliness_Lost (Self.Parent.all'Access, Status);
      end if;
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
      if Self.Parent.Listner /= null then
         Self.Parent.Listner.On_Publication_Matched (Self.Parent.all'Access, Status);
      end if;
   end On_Publication_Matched;

   --------------------------------------
   -- On_Reliable_Writer_Cache_Changed --
   --------------------------------------

   procedure On_Reliable_Writer_Cache_Changed
     (Self   : not null access DataReader_Listner;
      Writer : access DDS.DataWriter.Ref'Class;
      Status : in DDS.ReliableWriterCacheChangedStatus)
   is
   begin
      if Self.Parent.Listner /= null then
         Self.Parent.Listner.On_Reliable_Writer_Cache_Changed (Self.Parent.all'Access, Status);
      end if;
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
      if Self.Parent.Listner /= null then
         Self.Parent.Listner.On_Reliable_Reader_Activity_Changed (Self.Parent.all'Access, Status);
      end if;
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
      if Self.Parent.Listner /= null then
         Self.Parent.Listner.On_Destination_Unreachable (Self.Parent.all'Access, Instance, Locator);
      end if;
   end On_Destination_Unreachable;

   ---------------------
   -- On_Data_Request --
   ---------------------

   procedure On_Data_Request
     (Self    :        not null access DataReader_Listner;
      Writer  :    access DDS.DataWriter.Ref'Class;
      Cookie  : in DDS.Cookie_T;
      Request : in out System.Address)
   is
   begin
      if Self.Parent.Listner /= null then
         Self.Parent.Listner.On_Data_Request (Self.Parent.all'Access, Cookie, Request);
      end if;
   end On_Data_Request;

   --------------------
   -- On_Data_Return --
   --------------------

   procedure On_Data_Return
     (Self   :    not null access DataReader_Listner;
      Writer :    access DDS.DataWriter.Ref'Class;
      Arg    : System.Address;
      Cookie : in DDS.Cookie_T)
   is
   begin
      if Self.Parent.Listner /= null then
         Self.Parent.Listner.On_Data_Return (Self.Parent.all'Access, Arg, Cookie);
      end if;
   end On_Data_Return;

   -----------------------
   -- On_Sample_Removed --
   -----------------------

   procedure On_Sample_Removed
     (Self   : not null access DataReader_Listner;
      Writer : access DDS.DataWriter.Ref'Class;
      Cookie : in DDS.Cookie_T)
   is
   begin
      if Self.Parent.Listner /= null then
         Self.Parent.Listner.On_Sample_Removed (Self.Parent.all'Access, Cookie);
      end if;
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
      if Self.Parent.Listner /= null then
         Self.Parent.Listner.On_Instance_Replaced (Self.Parent.all'Access, Instance);
      end if;
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
      if Self.Parent.Listner /= null then
         Self.Parent.Listner.On_Application_Acknowledgment (Self.Parent.all'Access, Info);
      end if;
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
      if Self.Parent.Listner /= null then
         Self.Parent.Listner.On_Service_Request_Accepted (Self.Parent.all'Access, Info);
      end if;
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
      if Self.Parent.Listner /= null then
         Self.Parent.Listner.On_Requested_Deadline_Missed (Self.Parent.all'Access, Status);
      end if;
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
      if Self.Parent.Listner /= null then
         Self.Parent.Listner.On_Requested_Incompatible_Qos (Self.Parent.all'Access, Status);
      end if;
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
      if Self.Parent.Listner /= null then
         Self.Parent.Listner.On_Sample_Rejected (Self.Parent.all'Access, Status);
      end if;
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
      if Self.Parent.Listner /= null then
         Self.Parent.Listner.On_Liveliness_Changed (Self.Parent.all'Access, Status);
      end if;
   end On_Liveliness_Changed;

   -----------------------
   -- On_Data_Available --
   -----------------------

   --     procedure On_Data_Available
   --       (Self       :    not null access DataWriter_Listner;
   --        The_Reader : in DDS.DataReaderListener.DataReader_Access)
   --     is
   --     begin
   --        if Self.Parent.Listner /= null then
   --           Self.Parent.Listner.On_Request_Avalible (Self.all'Access);
   --        end if;
   --     end On_Data_Available;

   -----------------------------
   -- On_Subscription_Matched --
   -----------------------------

   procedure On_Subscription_Matched
     (Self       :    not null access DataWriter_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.SubscriptionMatchedStatus)
   is
   begin
      if Self.Parent.Listner /= null then
         Self.Parent.Listner.On_Subscription_Matched (Self.Parent.all'Access, Status);
      end if;
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
      if Self.Parent.Listner /= null then
         Self.Parent.Listner.On_Sample_Lost (Self.Parent.all'Access, Status);
      end if;
   end On_Sample_Lost;

end DDS.Request_Reply.Typed_Replier_Generic;
