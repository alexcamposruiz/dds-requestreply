with DDS.Typed_DataWriter_Generic;
with DDS.Typed_DataReader_Generic;
with DDS.Entity_Impl;
with DDS.Topic;
with DDS.DomainParticipant;
with DDS.Subscriber;
with DDS.Publisher;
with DDS.Request_Reply.impl;
private with RTIDDS.Low_Level.ndds_connext_c_connext_c_requester_h;

generic
   with package Request_DataWriters is new DDS.Typed_DataWriter_Generic (<>);
   with package Reply_DataReaders is new DDS.Typed_DataReader_Generic (<>);
package DDS.Request_Reply.Request_Generic is

   type Ref (<>) is limited new  Dds.Request_Reply.impl.Ref and Dds.Request_Reply.Ref with private;
   type Ref_Access is access all Ref'Class;

   function Create (Participant         : DDS.DomainParticipant.Ref_Access;
                    Service_Name        : DDS.String) return Ref_Access;


   function Create (Participant        : DDS.DomainParticipant.Ref_Access;
                    Service_Name       : DDS.String;
                    Datawriter_Qos     : DDS.DataWriterQoS := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
                    Datareader_Qos     : DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
                    Publisher          : DDS.Publisher.Ref_Access;
                    Subscriber         : DDS.Subscriber.Ref_Access) return Ref_Access;

   function Create (Participant        : DDS.DomainParticipant.Ref_Access;
                    Service_Name       : DDS.String;
                    Qos_Library_Name   : DDS.String;
                    Qos_Profile_Name   : DDS.String) return Ref_Access;


   function Create (Participant        : DDS.DomainParticipant.Ref_Access;
                    Service_Name       : DDS.String;
                    Request_Topic_Name : DDS.String;
                    Reply_Topic_Name   : DDS.String;
                    Qos_Library_Name   : DDS.String;
                    Qos_Profile_Name   : DDS.String;
                    Publisher          : DDS.Publisher.Ref_Access := null;
                    Subscriber         : DDS.Subscriber.Ref_Access := null) return Ref_Access;



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
     (Self    : not null access Ref;
      Request : Request_DataWriters.Treats.Data_Type) return Reply_DataReaders.Treats.Data_Type;

   function Send_Request
     (Self            : not null access Ref;
      Request         : access Request_DataWriters.Treats.Data_Type;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.Long;
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
      Max_Reply_Count      : DDS.Long;
      Timeout              : DDS.Duration_T) return DDS.ReturnCode_T;

   function Receive_Replies
     (Self                 : not null access Ref;
      Min_Reply_Count      : DDS.Natural;
      Max_Reply_Count      : DDS.Long;
      Timeout              : DDS.Duration_T) return Reply_DataReaders.Container;

   function Receive_Replies
     (Self            : not null access Ref;
      Replies         : not null Reply_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info     : not null access DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.Long;
      Timeout         : Duration) return DDS.ReturnCode_T;

   function Receive_Replies
     (Self            : not null access Ref;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.Long;
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
      Max_Reply_Count : DDS.Long;
      Timeout         : DDS.Duration_T) return DDS.ReturnCode_T;



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
      Max_Reply_Count : DDS.Long;
      Timeout         : DDS.Duration_T) return DDS.ReturnCode_T;

   function Read_Replies
     (Self            : not null access Ref;
      Min_Reply_Count : DDS.Natural;
      Max_Reply_Count : DDS.Long;
      Timeout         : DDS.Duration_T) return Reply_DataReaders.Container'Class;



   function Read_Reply_For_Related_Request
     (Self                 : not null access Ref;
      Replies              : aliased Reply_DataReaders.Treats.Data_Type;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Related_Request_Info : not null access DDS.SampleIdentity_T) return DDS.ReturnCode_T;


   function Read_Replies_For_Related_Request
     (Self                 : not null access Ref;
      Replies              : not null Reply_DataReaders.Treats.Data_Sequences.Sequence_Access;
      Sample_Info          : not null access DDS.SampleInfo_Seq.Sequence;
      Related_Request_Info : not null access DDS.SampleIdentity_T) return DDS.ReturnCode_T;

   function Read_Replies_For_Related_Request
     (Self                 : not null access Ref;
      Related_Request_Info : not null access DDS.SampleIdentity_T) return Reply_DataReaders.Container'Class;


   procedure Return_Loan (Self         : not null access Ref;
                          Replies      : not null Reply_DataReaders.Treats.Data_Sequences.Sequence_Access;
                          Sample_Info  : DDS.SampleInfo_Seq.Sequence_Access);

   procedure Delete (This : in out Ref);

   procedure Wait_For_Replies
     (This      : in out Ref;
      Min_Count : Dds.Long;
      Max_Wait  : DDS.Duration_T);

   procedure Wait_For_Replies
     (This      : in out Ref;
      Min_Count : Dds.Long;
      Max_Wait  : Duration);

   procedure Wait_For_Replies
     (This      : in out Ref;
      Min_Count : Dds.Long;
      Max_Wait  : Ada.Real_Time.Time_Span);

   procedure Wait_For_Replies_For_Related_Reques
     (This               : in out Ref;
      Min_Count          : Dds.Long;
      Max_Wait           : DDS.Duration_T;
      Related_Request_Id : access DDS.SampleIdentity_T);

   procedure Wait_For_Replies_For_Related_Reques
     (This               : in out Ref;
      Min_Count          : Dds.Long;
      Max_Wait           : Duration;
      Related_Request_Id : access DDS.SampleIdentity_T);

   procedure Wait_For_Replies_For_Related_Reques
     (This               : in out Ref;
      Min_Count          : Dds.Long;
      Max_Wait           : Ada.Real_Time.Time_Span;
      Related_Request_Id : access DDS.SampleIdentity_T);

   function Get_Request_DataWriter (Self : not null access Ref) return Request_DataWriters.Ref_Access;
   function Get_Reply_DataReader (Self : not null access Ref) return Reply_DataReaders.Ref_Access;

private

   type Request_Params is new RTIDDS.Low_Level.Ndds_Connext_C_Connext_C_Requester_H.RTI_Connext_RequesterParams;
   function Create (Participant   : not null DDS.DomainParticipant.Ref_Access;
                    Params        : in Request_Params) return Ref_Access;

   type Ref is limited new Dds.Request_Reply.Impl.Ref and Dds.Request_Reply.Ref with record
      Request_Topic      : DDS.Topic.Ref_Access;
      Reply_Topic        : DDS.Topic.Ref_Access;
      Request_DataWriter : Request_DataWriters.Ref_Access;
      Reply_DataReader   : Reply_DataReaders.Ref_Access;
   end record;

end Dds.Request_Reply.Request_Generic;
