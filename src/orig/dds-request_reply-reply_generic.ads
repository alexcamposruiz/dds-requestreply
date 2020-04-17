with DDS.Typed_DataWriter_Generic;
with DDS.Typed_DataReader_Generic;
with DDS.Entity_Impl;
with DDS.Topic;
with DDS.DomainParticipant;
with DDS.Publisher;
with DDS.Subscriber;

generic
   with package Request_DataReaders is new DDS.Typed_DataReader_Generic (<>);
   with package Reply_DataWriters is new DDS.Typed_DataWriter_Generic (<>);
package Dds.Request_Reply.Reply_Generic is

   type ReplierListener is interface;
   type ReplierListener_Access is access all ReplierListener'Class;

   function On_Request (Self : in out ReplierListener;
                        Request_Data : Request_DataReaders.Treats.Data_Type)
                        return Reply_DataWriters.Treats.Data_Type is abstract;

   type Ref is limited new Dds.Entity_Impl.Ref and Dds.Request_Reply.Ref with private;
   type Ref_Access is access all Ref'Class;

   generic
      Service_Name : Standard.String := "";
      Request_Topic_Name : Standard.String := "";
      Reply_Topic_Name   : Standard.String := "";
   package TopicReplier is
      type TopicReplierListener is interface and ReplierListener;
      function On_Request (Self         : in out TopicReplierListener;
                           Request_Data : Request_DataReaders.Treats.Data_Type)
                           return Reply_DataWriters.Treats.Data_Type is abstract;
   end TopicReplier;

   function Create (Participant        : DDS.DomainParticipant.Ref_Access;
                    Service_Name       : DDS.String;
                    Datawriter_Qos     : DDS.DataWriterQoS := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
                    Datareader_Qos     : DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
                    Listener           : ReplierListener_Access := null) return Ref_Access;


   function Create (Participant        : DDS.DomainParticipant.Ref_Access;
                    Service_Name       : DDS.String;
                    Datawriter_Qos     : DDS.String;
                    Datareader_Qos     : DDS.String;
                    Listener           : ReplierListener_Access := null) return Ref_Access;


   function Create (Participant        : DDS.DomainParticipant.Ref_Access;
                    Service_Name       : DDS.String;
                    Request_Topic_Name : DDS.String;
                    Reply_Topic_Name   : DDS.String;
                    Publisher          : DDS.Publisher.Ref_Access;
                    Subscriber         : DDS.Subscriber.Ref_Access;
                    Listener           : ReplierListener_Access := null) return Ref_Access;

   function Create (Participant        : DDS.DomainParticipant.Ref_Access;
                    Service_Name       : DDS.String;
                    Request_Topic_Name : DDS.String;
                    Reply_Topic_Name   : DDS.String;
                    Qos_Library_Name   : DDS.String;
                    Qos_Profile_Name   : DDS.String;
                    Publisher          : DDS.Publisher.Ref_Access;
                    Subscriber         : DDS.Subscriber.Ref_Access;
                    Listener           : ReplierListener_access := null) return Ref_Access;



   function Take_Request
     (Self         : not null access Ref;
      Requests     : aliased Request_DataReaders.Treats.Data_Type;
      Sample_Info  : not null access DDS.SampleInfo_Seq.Sequence) return DDS.ReturnCode_T;

   function Take_Request
     (Self         : not null access Ref) return Request_DataReaders.Container'Class;

   function Take_Requests
     (Self               : not null access Ref;
      Max_Request_Count  : DDS.Long) return Request_DataReaders.Container'Class;



   function Read_Request
     (Self         : not null access Ref;
      Requests     : aliased Request_DataReaders.Treats.Data_Type;
      Sample_Info  : not null access DDS.SampleInfo_Seq.Sequence) return DDS.ReturnCode_T;

   function Read_Requests
     (Self               : not null access Ref;
      Requests           : not null Request_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info        : not null access DDS.SampleInfo_Seq.Sequence;
      Max_Request_Count  : DDS.Long) return DDS.ReturnCode_T;

   function Read_Requests
     (Self               : not null access Ref;
      Max_Request_Count  : DDS.Long := DDS.Long'Last) return  Request_DataReaders.Container'Class;




   function Receive_Request
     (Self     : not null access Ref;
      Request  : access Request_DataReaders.Treats.Data_Type;
      Info_Seq : not null access DDS.SampleInfo_Seq.Sequence;
      Timeout  : DDS.Duration_T) return DDS.ReturnCode_T;

   function Receive_Requests
     (Self                 : not null access Ref;
      Requests             : not null Request_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Request_Count    : Request_DataReaders.Treats.Index_Type;
      Max_Request_Count    : Request_DataReaders.Treats.Index_Type;
      Timeout              : DDS.Duration_T) return DDS.ReturnCode_T;


   function Receive_Requests
     (Self                 : not null access Ref;
      Min_Request_Count    : Request_DataReaders.Treats.Index_Type;
      Max_Request_Count    : Request_DataReaders.Treats.Index_Type;
      Timeout              : DDS.Duration_T) return Request_DataReaders.Container'Class;



   procedure Send_Reply
     (Self                 : not null access Ref;
      Reply                : access Reply_DataWriters.Treats.Data_Type;
      Related_Request_Info : DDS.SampleIdentity_T);

   procedure Send_Reply
     (Self                 : not null access Ref;
      Reply                : access Reply_DataWriters.Treats.Data_Type;
      Related_Request_Info : DDS.SampleInfo);

   procedure Send_Reply
     (Self                 : not null access Ref;
      Reply                : Reply_DataWriters.Treats.Data_Type;
      Related_Request_Info : DDS.SampleIdentity_T);

   procedure Send_Reply
     (Self                 : not null access Ref;
      Reply                : Reply_DataWriters.Treats.Data_Type;
      Related_Request_Info : DDS.SampleInfo);

   procedure Send_Reply
     (Self                 : not null access Ref;
      Reply                : Reply_DataWriters.Treats.Data_Array;
      Related_Request_Info : DDS.SampleIdentity_T);

   procedure Send_Reply
     (Self                 : not null access Ref;
      Reply                : Reply_DataWriters.Treats.Data_Array;
      Related_Request_Info : DDS.SampleInfo);

   procedure Return_Loan (Self         : not null access Ref;
                          Requests     : not null Reply_DataWriters.Treats.Data_Sequences.Sequence_Access;
                          Sample_Info  : DDS.SampleInfo_Seq.Sequence_Access);

   function Get_Request_DataReader (Self : not null access Ref) return Request_DataReaders.Ref_Access;
   function Get_Reply_DataWriter (Self : not null access Ref) return Reply_DataWriters.Ref_Access;

private
   type Ref is limited new Dds.Entity_Impl.Ref and Dds.Request_Reply.Ref with record
      Request_Topic      : DDS.Topic.Ref_Access;
      Reply_Topic        : DDS.Topic.Ref_Access;
      Request_DataReader : Request_DataReaders.Ref_Access;
      Reply_DatWriter    : Reply_DataWriters.Ref_Access;
   end record;

end Dds.Request_Reply.Reply_Generic;
