with DDS.Publisher;
with DDS.Subscriber;
with DDS.Request_Reply.Connext_C_Replier;
with DDS.Request_Reply.Connext_C_Entity_Params;

with DDS.Typed_DataWriter_Generic;
with DDS.Typed_DataReader_Generic;

generic
   with package Reply_DataWriter is new DDS.Typed_DataWriter_Generic (<>);
   with package Request_DataReader is new DDS.Typed_DataReader_Generic (<>);
   
package Dds.Request_Reply.Connext_C_Replier.Simple_Replier_Generic is
   use Connext_C_Entity_Params;
   
   type Ref (<>) is new Dds.Request_Reply.Connext_C_Replier.RTI_Connext_Replier with private;
   type Ref_Access is access all Ref'Class;
   
   function Create_With_Profile (Participant        : DDS.DomainParticipant.Ref_Access;
                                 Service_Name       : DDS.String;
                                 Qos_Library_Name   : DDS.String;
                                 Qos_Profile_Name   : DDS.String;
                                 Listner            : RTI_Connext_SimpleReplierListener_Access := null) return Ref_Access;
   
   function Create_With_Profile (Participant        : DDS.DomainParticipant.Ref_Access;
                                 Request_Topic_Name : DDS.String;
                                 Reply_Topic_Name   : DDS.String;
                                 Qos_Library_Name   : DDS.String;
                                 Qos_Profile_Name   : DDS.String;
                                 Listner            : RTI_Connext_SimpleReplierListener_Access := null) return Ref_Access;

   function Create_With_Profile (Publisher          : not null DDS.Publisher.Ref_Access;
                                 Subscriber         : not null DDS.Subscriber.Ref_Access;
                                 Service_Name       : DDS.String;
                                 Qos_Library_Name   : DDS.String;
                                 Qos_Profile_Name   : DDS.String;
                                 Listner            : RTI_Connext_SimpleReplierListener_Access := null) return Ref_Access;
   
   function Create_With_Profile (Publisher          : not null DDS.Publisher.Ref_Access;
                                 Subscriber         : not null DDS.Subscriber.Ref_Access;
                                 Request_Topic_Name : DDS.String;
                                 Reply_Topic_Name   : DDS.String;
                                 Qos_Library_Name   : DDS.String;
                                 Qos_Profile_Name   : DDS.String;
                                 Listner            : RTI_Connext_SimpleReplierListener_Access := null) return Ref_Access;
   
   ------
   function Create (Participant        : DDS.DomainParticipant.Ref_Access;
                    Service_Name       : DDS.String;
                    DataReader_QoS     : DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
                    DataWriter_QoS     : DDS.DataWriterQoS := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
                    Listner            : RTI_Connext_SimpleReplierListener_Access := null) return Ref_Access;
   
   function Create (Participant        : DDS.DomainParticipant.Ref_Access;
                    Request_Topic_Name : DDS.String;
                    Reply_Topic_Name   : DDS.String;
                    DataReader_QoS     : DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
                    DataWriter_QoS     : DDS.DataWriterQoS := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
                    Listner            : RTI_Connext_SimpleReplierListener_Access := null) return Ref_Access;

   function Create (Publisher          : not null DDS.Publisher.Ref_Access;
                    Subscriber         : not null DDS.Subscriber.Ref_Access;
                    Service_Name       : DDS.String;
                    DataReader_QoS     : DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
                    DataWriter_QoS     : DDS.DataWriterQoS := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
                    Listner            : RTI_Connext_SimpleReplierListener_Access := null) return Ref_Access;
   
   function Create (Publisher          : not null DDS.Publisher.Ref_Access;
                    Subscriber         : not null DDS.Subscriber.Ref_Access;
                    Request_Topic_Name : DDS.String;
                    Reply_Topic_Name   : DDS.String;
                    DataReader_QoS     : DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
                    DataWriter_QoS     : DDS.DataWriterQoS := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
                    Listner            : RTI_Connext_SimpleReplierListener_Access := null) return Ref_Access;

   
   type RTI_Connext_SimpleReplierParams is new RTI_Connext_EntityParams with record
      Simple_Listener    : RTI_Connext_SimpleReplierListener;
   end record;
   
   function Create (Params   : RTI_Connext_SimpleReplierParams) return Ref_Access;

   procedure Delete (Self : in out Ref_Access);
   
   function Get_Request_Datareader (Self : not null access Ref) return Request_DataReader.Ref_Access;
   function Get_Reply_Datawriter (Self : not null access Ref) return Reply_DataWriter.Ref_Access;

private
   type Ref (Simple_Listener    : RTI_Connext_SimpleReplierListener_Access) is new Dds.Request_Reply.Connext_C_Replier.RTI_Connext_Replier with  record
      null;
   end record;


end Dds.Request_Reply.Connext_C_Replier.Simple_Replier_Generic;
