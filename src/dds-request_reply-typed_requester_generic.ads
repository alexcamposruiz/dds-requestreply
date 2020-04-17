with DDS.DataReader;
with DDS.DataReaderListener;
with DDS.DataReaderListener;
with DDS.DataWriter;
with DDS.DataWriterListener;
with DDS.DomainParticipant;
with DDS.Publisher;
with DDS.Request_Reply.Requester;
with DDS.Subscriber;
with DDS.Topic;
with DDS.Request_Reply.Requester.Impl;
with DDS.Typed_DataWriter_Generic;
with DDS.Typed_DataReader_Generic;
with DDS.Request_Reply.Connext_C_Requester;

generic
   with package Request_DataWriters is new DDS.Typed_DataWriter_Generic (<>);
   with package Reply_DataReaders is new DDS.Typed_DataReader_Generic (<>);
package DDS.Request_Reply.Typed_Requester_Generic is

   type Ref is limited new DDS.Request_Reply.Requester.Impl.Ref with private;
   type Ref_Access is access all Ref'Class;

   package Request_Listeners is
      type Ref is limited interface;
      type Ref_Access is access all Ref'Class;

      procedure On_Reply_Avalible
        (Self      : not null access Ref;
         Requester : not null access Typed_Requester_Generic.Ref_Access) is null;

      procedure On_Offered_Deadline_Missed
        (Self   : not null access Ref;
         Writer : access Typed_Requester_Generic.Ref'Class;
         Status : in DDS.OfferedDeadlineMissedStatus) is null;
      --  <dref>DataWriterListener_on_offered_deadline_missed</dref>

      procedure On_Offered_Incompatible_Qos
        (Self   : not null access Ref;
         Writer : access Typed_Requester_Generic.Ref'Class;
         Status : in DDS.OfferedIncompatibleQosStatus) is null;
      --  <dref>DataWriterListener_on_offered_incompatible_qos</dref>

      procedure On_Liveliness_Lost
        (Self   : not null access Ref;
         Writer : access Typed_Requester_Generic.Ref'Class;
         Status : in DDS.LivelinessLostStatus) is null;
      --  <dref>DataWriterListener_on_liveliness_lost</dref>

      procedure On_Publication_Matched
        (Self   : not null access Ref;
         Writer : access Typed_Requester_Generic.Ref'Class;
         Status : in DDS.PublicationMatchedStatus) is null;
      --  <dref>DataWriterListener_on_publication_matched</dref>

      procedure On_Reliable_Writer_Cache_Changed
        (Self   : not null access Ref;
         Writer : access Typed_Requester_Generic.Ref'Class;
         Status : in DDS.ReliableWriterCacheChangedStatus) is null;
      --  <dref>DataWriterListener_on_reliable_writer_cache_changed</dref>

      procedure On_Reliable_Reader_Activity_Changed
        (Self   : not null access Ref;
         Writer : access Typed_Requester_Generic.Ref'Class;
         Status : in DDS.ReliableReaderActivityChangedStatus) is null;
      --  <dref>DataWriterListener_on_reliable_reader_activity_changed</dref>

      procedure On_Destination_Unreachable
        (Self     : not null access Ref;
         Writer   : access Typed_Requester_Generic.Ref'Class;
         Instance : in DDS.InstanceHandle_T;
         Locator  : in DDS.Locator_T) is null;
      --  <dref internal="true">DataWriterListener_on_destination_unreachable</dref>

      procedure On_Data_Request
        (Self     : not null access Ref;
         Writer   : access Typed_Requester_Generic.Ref'Class;
         Cookie   : in DDS.Cookie_T;
         Request  : in out System.Address) is null;
      --  <dref internal="true">DataWriterListener_on_data_request</dref>

      procedure On_Data_Return
        (Self     : not null access Ref;
         Writer   : access Typed_Requester_Generic.Ref'Class;
         Arg      : System.Address;
         Cookie   : in DDS.Cookie_T) is null;
      --  <dref internal="true">DataWriterListener_on_data_return</dref>

      procedure On_Sample_Removed
        (Self   : not null access Ref;
         Writer : access Typed_Requester_Generic.Ref'Class;
         Cookie : in DDS.Cookie_T) is null;
      --  <dref internal="true">DataWriterListener_on_sample_removed</dref>

      procedure On_Instance_Replaced
        (Self     : not null access Ref;
         Writer   : access Typed_Requester_Generic.Ref'Class;
         Instance : in DDS.InstanceHandle_T) is null;
      --  <dref>DataWriterListener_on_instance_replaced</dref>

      procedure On_Application_Acknowledgment
        (Self   : not null access Ref;
         Writer : access Typed_Requester_Generic.Ref'Class;
         Info   : in DDS.AcknowledgmentInfo) is null;
      --  <dref>DataWriterListener_on_application_acknowledgment</dref>

      procedure On_Service_Request_Accepted
        (Self   : not null access Ref;
         Writer : access Typed_Requester_Generic.Ref'Class;
         Info   : in DDS.ServiceRequestAcceptedStatus) is null;
      --  <dref>DataWriterListener_on_service_request_accepted</dref>

      procedure On_Requested_Deadline_Missed
        (Self       : not null access Ref;
         The_Reader : in Typed_Requester_Generic.Ref_Access;
         Status     : in DDS.RequestedDeadlineMissedStatus)
      is null;
      --  <dref>DataReaderListener_on_requested_deadline_missed</dref>
      --  <internal>
      --  Handles the StatusKind.REQUESTED_DEADLINE_MISSED_STATUS
      --  communication status.
      --  </internal>

      procedure On_Requested_Incompatible_Qos
        (Self       : not null access Ref;
         The_Reader : in Typed_Requester_Generic.Ref_Access;
         Status     : in DDS.RequestedIncompatibleQosStatus)
      is null;
      --  <dref>DataReaderListener_on_requested_incompatible_qos</dref>
      --  <internal>
      --  Handles the StatusKind.REQUESTED_INCOMPATIBLE_QOS_STATUS
      --  communication status.
      --  </internal>

      procedure On_Sample_Rejected
        (Self       : not null access Ref;
         The_Reader : in Typed_Requester_Generic.Ref_Access;
         Status     : in DDS.SampleRejectedStatus)
      is null;
      --  <dref>DataReaderListener_on_sample_rejected</dref>
      --  <internal>
      --  Handles the StatusKind.SAMPLE_REJECTED_STATUS
      --  communication status.
      --  </internal>

      procedure On_Liveliness_Changed
        (Self       : not null access Ref;
         The_Reader : in Typed_Requester_Generic.Ref_Access;
         Status     : in DDS.LivelinessChangedStatus)
      is null;
      --  <dref>DataReaderListener_on_liveliness_changed</dref>
      --  <internal>
      --  Handles the StatusKind.LIVELINESS_CHANGED_STATUS
      --  communication status.
      --  </internal>
   end Request_Listeners;

   function Get_Request_Data_Writer
     (Self : not null access Ref)
      return DDS.DataWriter.Ref_Access;

   function Get_Reply_Data_Reader
     (Self : not null access Ref)
      return DDS.DataReader.Ref_Access;

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Service_Name       : DDS.String;
      Qos_Library_Name   : DDS.String;
      Qos_Profile_Name   : DDS.String;
      Publisher          : DDS.Publisher.Ref_Access := null;
      Subscriber         : DDS.Subscriber.Ref_Access := null;
      A_Listner          : Request_Listeners.Ref_Access := null;
      Mask               : DDS.StatusMask := DDS.STATUS_MASK_NONE)return Ref_Access;

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Request_Topic_Name : DDS.String;
      Reply_Topic_Name   : DDS.String;
      Qos_Library_Name   : DDS.String;
      Qos_Profile_Name   : DDS.String;
      Publisher          : DDS.Publisher.Ref_Access := null;
      Subscriber         : DDS.Subscriber.Ref_Access := null;
      A_Listner          : Request_Listeners.Ref_Access := null;
      Mask               : DDS.StatusMask := DDS.STATUS_MASK_NONE)return Ref_Access;

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Service_Name       : DDS.String;
      Datawriter_Qos     : DDS.DataWriterQos;
      Datareader_Qos     : DDS.DataReaderQos;
      Publisher          : DDS.Publisher.Ref_Access := null;
      Subscriber         : DDS.Subscriber.Ref_Access := null;
      A_Listner          : Request_Listeners.Ref_Access := null;
      Mask               : DDS.StatusMask := DDS.STATUS_MASK_NONE)return Ref_Access;

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Request_Topic_Name : DDS.String;
      Reply_Topic_Name   : DDS.String;
      Datawriter_Qos     : DDS.DataWriterQos;
      Datareader_Qos     : DDS.DataReaderQos;
      Publisher          : DDS.Publisher.Ref_Access := null;
      Subscriber         : DDS.Subscriber.Ref_Access := null;
      A_Listner          : Request_Listeners.Ref_Access := null;
      Mask               : DDS.StatusMask := DDS.STATUS_MASK_NONE)return Ref_Access;

   procedure Delete (Self : in out Ref_Access);

   function Send_Request (Self : not null access Ref;
                          Data : Request_DataWriters.Treats.Data_Type) return DDS.ReturnCode_T;

   procedure Send_Request (Self : not null access Ref;
                           Data : Request_DataWriters.Treats.Data_Type);

   function Send_Request (Self : not null access Ref;
                          Data : Request_DataWriters.Treats.Data_Type) return Reply_DataReaders.Treats.Data_Type;



   procedure Send_Request
     (Self    : not null access Ref;
      Request : access Request_DataWriters.Treats.Data_Type);

   function Send_Request
     (Self    : not null access Ref;
      Request : access Request_DataWriters.Treats.Data_Type) return Reply_DataReaders.Container;

   function Send_Request
     (Self    : not null access Ref;
      Request : Request_DataWriters.Treats.Data_Type) return Reply_DataReaders.Container;


   function Send_Request
     (Self            : not null access Ref;
      Request         : access Request_DataWriters.Treats.Data_Type;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.long;
      Timeout         : DDS.Duration_T := DURATION_INFINITE) return Reply_DataReaders.Container;

   procedure Send_Request
     (Self         : not null access Ref;
      Request      : access Request_DataWriters.Treats.Data_Type;
      Request_Info : DDS.WriteParams_T);

   function Receive_Reply
     (Self     : not null access Ref;
      Replies  : aliased Reply_DataReaders.Treats.Data_Type;
      Info_Seq : not null access DDS.SampleInfo_Seq.Sequence;
      Timeout  : DDS.Duration_T) return DDS.ReturnCode_T;

   function Receive_Reply
     (Self     : not null access Ref;
      Timeout  : DDS.Duration_T) return Reply_DataReaders.Container;

   function Receive_Replies
     (Self                 : not null access Ref;
      Replies              : not null Reply_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count      : DDS.Natural;
      Max_Reply_Count      : DDS.long;
      Timeout              : DDS.Duration_T) return DDS.ReturnCode_T;


   procedure Receive_Replies
     (Self                 : not null access Ref;
      Replies              : not null Reply_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count      : DDS.Natural;
      Max_Reply_Count      : DDS.long;
      Timeout              : DDS.Duration_T);

   function Receive_Replies
     (Self                 : not null access Ref;
      Min_Reply_Count      : DDS.Natural;
      Max_Reply_Count      : DDS.long;
      Timeout              : DDS.Duration_T) return Reply_DataReaders.Container;

   function Receive_Replies
     (Self            : not null access Ref;
      Replies         : not null Reply_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info     : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.long;
      Timeout         : Duration) return DDS.ReturnCode_T;

   function Receive_Replies
     (Self            : not null access Ref;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.long;
      Timeout         : Duration) return Reply_DataReaders.Container;


   function Take_Reply
     (Self        : not null access Ref;
      Replies     : aliased Reply_DataReaders.Treats.Data_Type;
      Sample_Info : not null access DDS.SampleInfo_Seq.Sequence;
      Timeout     : DDS.Duration_T) return DDS.ReturnCode_T;

   function Take_Replies
     (Self            : not null access Ref;
      Replies         : not null Reply_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info     : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.long;
      Timeout         : DDS.Duration_T) return DDS.ReturnCode_T;

   function Take_Replies
     (Self            : not null access Ref;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.long;
      Timeout         : DDS.Duration_T) return  Reply_DataReaders.Container;



   function Take_Reply_For_Related_Request
     (Self                 : not null access Ref;
      Replies              : aliased Reply_DataReaders.Treats.Data_Type;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Related_Request_Info : not null access DDS.SampleIdentity_T) return DDS.ReturnCode_T;

   function Take_Replies_For_Related_Request
     (Self                 : not null access Ref;
      Replies              : not null Reply_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Related_Request_Info : not null access DDS.SampleIdentity_T) return DDS.ReturnCode_T;

   function Take_Replies_For_Related_Request
     (Self                 : not null access Ref;
      Related_Request_Info : not null access DDS.SampleIdentity_T) return Reply_DataReaders.Container;


   function Read_Reply
     (Self        : not null access Ref;
      Replies     : aliased Reply_DataReaders.Treats.Data_Type;
      Sample_Info : not null access DDS.SampleInfo_Seq.Sequence;
      Timeout     : DDS.Duration_T) return DDS.ReturnCode_T;

   function Read_Replies
     (Self            : not null access Ref;
      Replies         : not null Reply_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info     : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.long;
      Timeout         : DDS.Duration_T) return DDS.ReturnCode_T;

   function Read_Replies
     (Self            : not null access Ref;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.long;
      Timeout         : DDS.Duration_T) return Reply_DataReaders.Container'Class;



   function Read_Reply_For_Related_Request
     (Self                 : not null access Ref;
      Replies              : aliased Reply_DataReaders.Treats.Data_Type;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Related_Request_Info : DDS.SampleIdentity_T) return DDS.ReturnCode_T;


   function Read_Replies_For_Related_Request
     (Self                 : not null access Ref;
      Replies              : not null Reply_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Related_Request_Info : DDS.SampleIdentity_T) return DDS.ReturnCode_T;

   function Read_Replies_For_Related_Request
     (Self                 : not null access Ref;
      Related_Request_Info : DDS.SampleIdentity_T) return Reply_DataReaders.Container'Class;


   procedure Return_Loan (Self         : not null access Ref;
                          Replies      : not null Reply_DataReaders.Treats.Data_Sequences.Sequence_Access;
                          Sample_Info  : DDS.SampleInfo_Seq.Sequence_Access);

   procedure Return_Loan (Self         : not null access Ref;
                          Replies      : Reply_DataReaders.Treats.Data_Sequences.Sequence;
                          Sample_Info  : DDS.SampleInfo_Seq.Sequence);
   procedure Delete (This : in out Ref);

   procedure Wait_For_Replies
     (This      : in out Ref;
      Min_Count : Dds.long;
      Max_Wait  : DDS.Duration_T);


   procedure Wait_For_Replies_For_Related_Reques
     (This               : in out Ref;
      Min_Count          : Dds.long;
      Max_Wait           : DDS.Duration_T;
      Related_Request_Id : DDS.SampleIdentity_T);

   function Get_Request_DataWriter (Self : not null access Ref) return Request_DataWriters.Ref_Access;
   function Get_Reply_DataReader (Self : not null access Ref) return Reply_DataReaders.Ref_Access;

private

   type DataReader_Listner (Parent : not null access Ref )is new DDS.DataReaderListener.Ref with null record;
   procedure On_Offered_Deadline_Missed
     (Self   : not null access DataReader_Listner;
      Writer : access DDS.DataWriter.Ref'Class;
      Status : in DDS.OfferedDeadlineMissedStatus);

   procedure On_Data_Available
     (Self       : not null access DataReader_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access);

   procedure On_Offered_Incompatible_Qos
     (Self   : not null access DataReader_Listner;
      Writer : access DDS.DataWriter.Ref'Class;
      Status : in DDS.OfferedIncompatibleQosStatus);
   --  <dref>DataWriterListener_on_offered_incompatible_qos</dref>

   procedure On_Liveliness_Lost
     (Self   : not null access DataReader_Listner;
      Writer : access DDS.DataWriter.Ref'Class;
      Status : in DDS.LivelinessLostStatus);
   --  <dref>DataWriterListener_on_liveliness_lost</dref>

   procedure On_Publication_Matched
     (Self   : not null access DataReader_Listner;
      Writer : access DDS.DataWriter.Ref'Class;
      Status : in DDS.PublicationMatchedStatus);
   --  <dref>DataWriterListener_on_publication_matched</dref>

   procedure On_Reliable_Writer_Cache_Changed
     (Self   : not null access DataReader_Listner;
      Writer : access DDS.DataWriter.Ref'Class;
      Status : in DDS.ReliableWriterCacheChangedStatus);
   --  <dref>DataWriterListener_on_reliable_writer_cache_changed</dref>

   procedure On_Reliable_Reader_Activity_Changed
     (Self   : not null access DataReader_Listner;
      Writer : access DDS.DataWriter.Ref'Class;
      Status : in DDS.ReliableReaderActivityChangedStatus);


   procedure On_Destination_Unreachable
     (Self     : not null access DataReader_Listner;
      Writer   : access DDS.DataWriter.Ref'Class;
      Instance : in DDS.InstanceHandle_T;
      Locator  : in DDS.Locator_T);

   procedure On_Data_Request
     (Self     : not null access DataReader_Listner;
      Writer   : access DDS.DataWriter.Ref'Class;
      Cookie   : in DDS.Cookie_T;
      Request  : in out System.Address);

   procedure On_Data_Return
     (Self     : not null access DataReader_Listner;
      Writer   : access DDS.DataWriter.Ref'Class;
      Arg      : System.Address;
      Cookie   : in DDS.Cookie_T);
   procedure On_Sample_Removed
     (Self   : not null access DataReader_Listner;
      Writer : access DDS.DataWriter.Ref'Class;
      Cookie : in DDS.Cookie_T);

   procedure On_Instance_Replaced
     (Self     : not null access DataReader_Listner;
      Writer   : access DDS.DataWriter.Ref'Class;
      Instance : in DDS.InstanceHandle_T);
   --  <dref>DataWriterListener_on_instance_replaced</dref>

   procedure On_Application_Acknowledgment
     (Self   : not null access DataReader_Listner;
      Writer : access DDS.DataWriter.Ref'Class;
      Info   : in DDS.AcknowledgmentInfo);
   --  <dref>DataWriterListener_on_application_acknowledgment</dref>

   procedure On_Service_Request_Accepted
     (Self   : not null access DataReader_Listner;
      Writer : access DDS.DataWriter.Ref'Class;
      Info   : in DDS.ServiceRequestAcceptedStatus);


   type DataWriter_Listner (Parent : not null access Ref )is new DDS.DataWriterListener.Ref with null record;
   procedure On_Requested_Deadline_Missed
     (Self       : not null access DataWriter_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.RequestedDeadlineMissedStatus);

   procedure On_Requested_Incompatible_Qos
     (Self       : not null access DataWriter_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.RequestedIncompatibleQosStatus);

   procedure On_Sample_Rejected
     (Self       : not null access DataWriter_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.SampleRejectedStatus);

   procedure On_Liveliness_Changed
     (Self       : not null access DataWriter_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.LivelinessChangedStatus);

   procedure On_Data_Available
     (Self       : not null access DataWriter_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access);

   procedure On_Subscription_Matched
     (Self       : not null access DataWriter_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.SubscriptionMatchedStatus);

   procedure On_Sample_Lost
     (Self       : not null access DataWriter_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.SampleLostStatus);

   type Ref is limited new DDS.Request_Reply.Requester.Impl.Ref with record
      Request_DataWriter : Request_DataWriters.Ref_Access;
      Reply_DataReader   : Reply_DataReaders.Ref_Access;
      Listner            : Request_Listeners.Ref_Access;
      Request_Topic      : DDS.Topic.Ref_Access;
      Reply_Topic        : DDS.Topic.Ref_Access;
      Writer_Listner     : DataWriter_Listner (Ref'Access);
      Reader_Listner     : DataReader_Listner (Ref'Access);
   end record;

end DDS.Request_Reply.Typed_Requester_Generic;
