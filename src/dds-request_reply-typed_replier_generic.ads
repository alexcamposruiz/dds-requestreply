with DDS.DataReader;
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
   with package Reply_DataWriters is new DDS.Typed_DataWriter_Generic (<>);
   with package Request_DataReaders is new DDS.Typed_DataReader_Generic (<>);
package DDS.Request_Reply.Typed_Replier_Generic is

   type Ref is new DDS.Request_Reply.Requester.Impl.Ref with private;
   type Ref_Access is access all Ref'Class;

   package Replyer_Listeners is
      type Ref is limited interface;
      type Ref_Access is access all Ref'Class;

      procedure On_Request_Avalible (Self      : not null access Ref;
                                     Requester : not null access Typed_Replier_Generic.Ref'Class) is abstract;

      procedure On_Offered_Deadline_Missed
        (Self   : not null access Ref;
         Writer : access Typed_Replier_Generic.Ref'Class;
         Status : in DDS.OfferedDeadlineMissedStatus) is null;
      --  <dref>DataWriterListener_on_offered_deadline_missed</dref>

      procedure On_Offered_Incompatible_Qos
        (Self   : not null access Ref;
         Writer : access Typed_Replier_Generic.Ref'Class;
         Status : in DDS.OfferedIncompatibleQosStatus) is null;
      --  <dref>DataWriterListener_on_offered_incompatible_qos</dref>

      procedure On_Liveliness_Lost
        (Self   : not null access Ref;
         Writer : access Typed_Replier_Generic.Ref'Class;
         Status : in DDS.LivelinessLostStatus) is null;
      --  <dref>DataWriterListener_on_liveliness_lost</dref>

      procedure On_Publication_Matched
        (Self   : not null access Ref;
         Writer : access Typed_Replier_Generic.Ref'Class;
         Status : in DDS.PublicationMatchedStatus) is null;
      --  <dref>DataWriterListener_on_publication_matched</dref>

      procedure On_Reliable_Writer_Cache_Changed
        (Self   : not null access Ref;
         Writer : access Typed_Replier_Generic.Ref'Class;
         Status : in DDS.ReliableWriterCacheChangedStatus) is null;
      --  <dref>DataWriterListener_on_reliable_writer_cache_changed</dref>

      procedure On_Reliable_Reader_Activity_Changed
        (Self   : not null access Ref;
         Writer : access Typed_Replier_Generic.Ref'Class;
         Status : in DDS.ReliableReaderActivityChangedStatus) is null;
      --  <dref>DataWriterListener_on_reliable_reader_activity_changed</dref>

      procedure On_Destination_Unreachable
        (Self     : not null access Ref;
         Writer   : access Typed_Replier_Generic.Ref'Class;
         Instance : in DDS.InstanceHandle_T;
         Locator  : in DDS.Locator_T) is null;
      --  <dref internal="true">DataWriterListener_on_destination_unreachable</dref>

      procedure On_Data_Request
        (Self     : not null access Ref;
         Writer   : access Typed_Replier_Generic.Ref'Class;
         Cookie   : in DDS.Cookie_T;
         Request  : in out System.Address) is null;
      --  <dref internal="true">DataWriterListener_on_data_request</dref>

      procedure On_Data_Return
        (Self     : not null access Ref;
         Writer   : access Typed_Replier_Generic.Ref'Class;
         Arg      : System.Address;
         Cookie   : in DDS.Cookie_T) is null;
      --  <dref internal="true">DataWriterListener_on_data_return</dref>

      procedure On_Sample_Removed
        (Self   : not null access Ref;
         Writer : access Typed_Replier_Generic.Ref'Class;
         Cookie : in DDS.Cookie_T) is null;
      --  <dref internal="true">DataWriterListener_on_sample_removed</dref>

      procedure On_Instance_Replaced
        (Self     : not null access Ref;
         Writer   : access Typed_Replier_Generic.Ref'Class;
         Instance : in DDS.InstanceHandle_T) is null;
      --  <dref>DataWriterListener_on_instance_replaced</dref>

      procedure On_Application_Acknowledgment
        (Self   : not null access Ref;
         Writer : access Typed_Replier_Generic.Ref'Class;
         Info   : in DDS.AcknowledgmentInfo) is null;
      --  <dref>DataWriterListener_on_application_acknowledgment</dref>

      procedure On_Service_Request_Accepted
        (Self   : not null access Ref;
         Writer : access Typed_Replier_Generic.Ref'Class;
         Info   : in DDS.ServiceRequestAcceptedStatus) is null;
      --  <dref>DataWriterListener_on_service_request_accepted</dref>

      procedure On_Requested_Deadline_Missed
        (Self       : not null access Ref;
         The_Reader : in Typed_Replier_Generic.Ref_Access;
         Status     : in DDS.RequestedDeadlineMissedStatus)
      is null;
      --  <dref>DataReaderListener_on_requested_deadline_missed</dref>
      --  <internal>
      --  Handles the StatusKind.REQUESTED_DEADLINE_MISSED_STATUS
      --  communication status.
      --  </internal>

      procedure On_Requested_Incompatible_Qos
        (Self       : not null access Ref;
         The_Reader : in Typed_Replier_Generic.Ref_Access;
         Status     : in DDS.RequestedIncompatibleQosStatus)
      is null;
      --  <dref>DataReaderListener_on_requested_incompatible_qos</dref>
      --  <internal>
      --  Handles the StatusKind.REQUESTED_INCOMPATIBLE_QOS_STATUS
      --  communication status.
      --  </internal>

      procedure On_Sample_Rejected
        (Self       : not null access Ref;
         The_Reader : in Typed_Replier_Generic.Ref_Access;
         Status     : in DDS.SampleRejectedStatus)
      is null;
      --  <dref>DataReaderListener_on_sample_rejected</dref>
      --  <internal>
      --  Handles the StatusKind.SAMPLE_REJECTED_STATUS
      --  communication status.
      --  </internal>

      procedure On_Liveliness_Changed
        (Self       : not null access Ref;
         The_Reader : in Typed_Replier_Generic.Ref_Access;
         Status     : in DDS.LivelinessChangedStatus)
      is null;
      --  <dref>DataReaderListener_on_liveliness_changed</dref>
      --  <internal>
      --  Handles the StatusKind.LIVELINESS_CHANGED_STATUS
      --  communication status.
      --  </internal>



      procedure On_Subscription_Matched
        (Self       : not null access Ref;
         The_Reader : in Typed_Replier_Generic.Ref_Access;
         Status     : in DDS.SubscriptionMatchedStatus)
      is null;
      --  <dref>DataReaderListener_on_subscription_matched</dref>
      --  <internal>
      --  Handles the StatusKind.SUBSCRIPTION_MATCHED_STATUS communication status.
      --  </internal>

      procedure On_Sample_Lost
        (Self       : not null access Ref;
         The_Reader : in Typed_Replier_Generic.Ref_Access;
         Status     : in DDS.SampleLostStatus)
      is null;
   end Replyer_Listeners;

   function Get_Request_Data_Reader
     (Self : not null access Ref)
      return DDS.DataReader.Ref_Access;

   function Get_Reply_Data_Writer
     (Self : not null access Ref)
      return DDS.DataWriter.Ref_Access;

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Service_Name       : DDS.String;
      Qos_Library_Name   : DDS.String;
      Qos_Profile_Name   : DDS.String;
      Publisher          : DDS.Publisher.Ref_Access := null;
      Subscriber         : DDS.Subscriber.Ref_Access := null;
      A_Listner          : Replyer_Listeners.Ref_Access := null;
      Mask               : DDS.StatusMask := DDS.STATUS_MASK_NONE)return Ref_Access;

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Request_Topic_Name : DDS.String;
      Reply_Topic_Name   : DDS.String;
      Qos_Library_Name   : DDS.String;
      Qos_Profile_Name   : DDS.String;
      Publisher          : DDS.Publisher.Ref_Access := null;
      Subscriber         : DDS.Subscriber.Ref_Access := null;
      A_Listner          : Replyer_Listeners.Ref_Access := null;
      Mask               : DDS.StatusMask := DDS.STATUS_MASK_NONE)return Ref_Access;

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Service_Name       : DDS.String;
      Datawriter_Qos     : DDS.DataWriterQos;
      Datareader_Qos     : DDS.DataReaderQos;
      Publisher          : DDS.Publisher.Ref_Access := null;
      Subscriber         : DDS.Subscriber.Ref_Access := null;
      A_Listner          : Replyer_Listeners.Ref_Access := null;
      Mask               : DDS.StatusMask := DDS.STATUS_MASK_NONE)return Ref_Access;

   function Create
     (Participant        : DDS.DomainParticipant.Ref_Access;
      Request_Topic_Name : DDS.String;
      Reply_Topic_Name   : DDS.String;
      Datawriter_Qos     : DDS.DataWriterQos;
      Datareader_Qos     : DDS.DataReaderQos;
      Publisher          : DDS.Publisher.Ref_Access := null;
      Subscriber         : DDS.Subscriber.Ref_Access := null;
      A_Listner          : Replyer_Listeners.Ref_Access := null;
      Mask               : DDS.StatusMask := DDS.STATUS_MASK_NONE)return Ref_Access;


   procedure Delete (Self : in out Ref_Access);


   function Send_Reply
     (Self    : not null access Ref;
      Reply   : access Reply_DataWriters.Treats.Data_Type;
      Id      : access DDS.SampleIdentity_T)return DDS.ReturnCode_T;

   function Send_Reply
     (Self    : not null access Ref;
      Reply   : Reply_DataWriters.Treats.Data_Type;
      Id      : DDS.SampleIdentity_T)return DDS.ReturnCode_T;

   procedure Send_Reply
     (Self    : not null access Ref;
      Reply   : access Reply_DataWriters.Treats.Data_Type;
      Id      : access DDS.SampleIdentity_T);

   procedure Send_Reply
     (Self    : not null access Ref;
      Reply   : Reply_DataWriters.Treats.Data_Type;
      Id      : DDS.SampleIdentity_T);


   function Receive_Request
     (Self     : not null access Ref;
      Request  : in out Request_DataReaders.Treats.Data_Type;
      Info_Seq : in out DDS.SampleInfo;
      Timeout  : DDS.Duration_T := DDS.DURATION_INFINITE) return DDS.ReturnCode_T;

   procedure Receive_Request
     (Self     : not null access Ref;
      Request  : in out Request_DataReaders.Treats.Data_Type;
      Info_Seq : in out DDS.SampleInfo;
      Timeout  : DDS.Duration_T := DDS.DURATION_INFINITE);

   function Receive_Request
     (Self     : not null access Ref;
      Timeout  : DDS.Duration_T) return Request_DataReaders.Container;

   function Receive_Requests
     (Self                 : not null access Ref;
      Requests             : not null Request_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Requests_Count   : DDS.long := 1;
      Max_Requests_Count   : DDS.long := DDS.INFINITE;
      Timeout              : DDS.Duration_T := DDS.DURATION_INFINITE) return DDS.ReturnCode_T;

   procedure Receive_Requests
     (Self                 : not null access Ref;
      Requests             : not null Request_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count      : DDS.long := 1;
      Max_Reply_Count      : DDS.long := DDS.INFINITE;
      Timeout              : DDS.Duration_T := DDS.DURATION_INFINITE);

   procedure Receive_Requests
     (Self                 : not null access Ref;
      Requests             : in out Request_DataReaders.Treats.Data_Sequences.Sequence;
      Sample_Info          : in out DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count      : DDS.long := 1;
      Max_Reply_Count      : DDS.long := DDS.INFINITE;
      Timeout              : DDS.Duration_T := DDS.DURATION_INFINITE);


   function Receive_Request
     (Self                 : not null access Ref;
      Min_Reply_Count      : DDS.long := 1;
      Max_Reply_Count      : DDS.long := DDS.INFINITE;
      Timeout              : DDS.Duration_T := DDS.DURATION_INFINITE) return Request_DataReaders.Container;


   function Receive_Request
     (Self            : not null access Ref;
      Requests        : not null Request_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info     : not null DDS.SampleInfo_Seq.Sequence_Access;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.long;
      Timeout         : Duration) return DDS.ReturnCode_T;


   function Receive_Request
     (Self            : not null access Ref;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.long;
      Timeout         : Duration) return Request_DataReaders.Container;


   function Take_Request
     (Self        : not null access Ref;
      Requests    : aliased Request_DataReaders.Treats.Data_Type;
      Sample_Info : not null access DDS.SampleInfo_Seq.Sequence;
      Timeout     : DDS.Duration_T) return DDS.ReturnCode_T;

   function Take_Request
     (Self            : not null access Ref;
      Requests        : not null Request_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info     : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count : DDS.Natural := 1;
      Max_Reply_Count : DDS.long := DDS.INFINITE;
      Timeout         : DDS.Duration_T) return DDS.ReturnCode_T;

   function Take_Request
     (Self            : not null access Ref;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.long;
      Timeout         : DDS.Duration_T) return  Request_DataReaders.Container;



   function Read_Request
     (Self        : not null access Ref;
      Request     : aliased Request_DataReaders.Treats.Data_Type;
      Sample_Info : not null access DDS.SampleInfo_Seq.Sequence;
      Timeout     : DDS.Duration_T) return DDS.ReturnCode_T;

   function Read_Request
     (Self            : not null access Ref;
      Requests        : not null Request_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info     : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.long;
      Timeout         : DDS.Duration_T) return DDS.ReturnCode_T;

   function Read_Request
     (Self            : not null access Ref;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.long;
      Timeout         : DDS.Duration_T) return Request_DataReaders.Container'Class;




   procedure Return_Loan (Self         : not null access Ref;
                          Replies      : not null Request_DataReaders.Treats.Data_Sequences.Sequence_Access;
                          Sample_Info  : DDS.SampleInfo_Seq.Sequence_Access);

   procedure Return_Loan (Self         : not null access Ref;
                          Replies      : Request_DataReaders.Treats.Data_Sequences.Sequence;
                          Sample_Info  : DDS.SampleInfo_Seq.Sequence);
   procedure Delete (This : in out Ref);

   function Get_Request_DataReader (Self : not null access Ref) return Request_DataReaders.Ref_Access;
   function Get_Reply_Datawriter (Self : not null access Ref) return Reply_DataWriters.Ref_Access;

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
     (Self   : not null access DataReader_Listner;
      Writer : access DDS.DataWriter.Ref'Class;
      Instance : in DDS.InstanceHandle_T;
      Locator  : in DDS.Locator_T);

   procedure On_Data_Request
     (Self   : not null access DataReader_Listner;
      Writer : access DDS.DataWriter.Ref'Class;
      Cookie   : in DDS.Cookie_T;
      Request  : in out System.Address);

   procedure On_Data_Return
     (Self   : not null access DataReader_Listner;
      Writer : access DDS.DataWriter.Ref'Class;
      arg      : System.Address;
      Cookie   : in DDS.Cookie_T);
   procedure On_Sample_Removed
     (Self   : not null access DataReader_Listner;
      Writer : access DDS.DataWriter.Ref'Class;
      Cookie : in DDS.Cookie_T);

   procedure On_Instance_Replaced
     (Self   : not null access DataReader_Listner;
      Writer : access DDS.DataWriter.Ref'Class;
      Instance : in DDS.InstanceHandle_T);
   --  <dref>DataWriterListener_on_instance_replaced</dref>

   procedure On_Application_Acknowledgment
     (Self   : not null access DataReader_Listner;
      Writer : access DDS.DataWriter.Ref'Class;
      Info : in DDS.AcknowledgmentInfo);
   --  <dref>DataWriterListener_on_application_acknowledgment</dref>

   procedure On_Service_Request_Accepted
     (Self   : not null access DataReader_Listner;
      Writer : access DDS.DataWriter.Ref'Class;
      Info : in DDS.ServiceRequestAcceptedStatus);


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

--     procedure On_Data_Available
--       (Self       : not null access DataWriter_Listner;
--        The_Reader : in DDS.DataReaderListener.DataReader_Access);

   procedure On_Subscription_Matched
     (Self       : not null access DataWriter_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.SubscriptionMatchedStatus);

   procedure On_Sample_Lost
     (Self       : not null access DataWriter_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access;
      Status     : in DDS.SampleLostStatus);

   type Ref is new DDS.Request_Reply.Requester.Impl.Ref with record
      Participant        : DDS.DomainParticipant.Ref_Access;
      Request_Topic      : DDS.Topic.Ref_Access;
      Reply_Topic        : DDS.Topic.Ref_Access;
      Reply_DataWriter   : Reply_DataWriters.Ref_Access;
      Request_DataReader : Request_DataReaders.Ref_Access;
      Listner            : Replyer_Listeners.Ref_Access;
      Writer_Listner     : DataWriter_Listner (Ref'Access);
      Reader_Listner     : DataReader_Listner (Ref'Access);

   end record;

end DDS.Request_Reply.Typed_Replier_Generic;
