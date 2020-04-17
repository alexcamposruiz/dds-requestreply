--  (c) Copyright, Real-Time Innovations, $Date:: 2012-02-16 #$
--  All rights reserved.
--
--  No duplications, whole or partial, manual or electronic, may be made
--  without express written permission.  Any such copies, or
--  revisions thereof, must display this notice unaltered.
--  This code contains trade secrets of Real-Time Innovations, Inc.

pragma Ada_05;

with DDS.DomainParticipantListener;
with DDS.TopicListener;
with DDS.SubscriberListener;
with DDS.PublisherListener;
with DDS.Publisher;
with DDS.PublisherSeq;
with DDS.Topic;
with DDS.TopicDescription;
with DDS.Subscriber;
with DDS.SubscriberSeq;
with DDS.ContentFilteredTopic;
with DDS.MultiTopic;
with DDS.DomainParticipant;
limited with dds.DomainParticipantFactory;
--  limited with DDS.FlowController;
with DDS.Entity_Impl;
with DDS.DataWriter;
with DDS.DataWriterListener;
with DDS.DataReader;
with DDS.DataReaderListener;

package DDS.DomainParticipant_Impl is

   type Ref is new DDS.Entity_Impl.Ref and DDS.DomainParticipant.Ref with record
      factory : access DDS.DomainParticipantFactory.Ref'Class;
   end record;

   type Ref_Access is access all Ref'Class;

   function Create_Publisher
     (Self       : not null access Ref;
      Qos        : in DDS.PublisherQos;
      A_Listener : in DDS.PublisherListener.Ref_Access;
      Mask       : in DDS.StatusMask)
      return DDS.Publisher.Ref_Access;

   function Create_Publisher_With_Profile
     (Self         : not null access Ref;
      Library_Name : in DDS.String;
      profile_name : in DDS.String;
      A_Listener   : in DDS.PublisherListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.Publisher.Ref_Access;
   function Create_Publisher_With_Profile
     (Self         : not null access Ref;
      Library_Name : in Standard.String;
      profile_name : in Standard.String;
      A_Listener   : in DDS.PublisherListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.Publisher.Ref_Access;

   procedure Delete_Publisher
     (Self      : not null access Ref;
      Publisher : in out DDS.Publisher.Ref_Access);


   function Create_Subscriber
     (Self       : not null access Ref;
      Qos        : in DDS.SubscriberQos;
      A_Listener : in DDS.SubscriberListener.Ref_Access;
      Mask       : in DDS.StatusMask)
      return DDS.Subscriber.Ref_Access;

   function Create_Subscriber_With_Profile
     (Self         : not null access Ref;
      Library_Name : in DDS.String;
      profile_name : in DDS.String;
      A_Listener   : in DDS.SubscriberListener.Ref_Access  := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.Subscriber.Ref_Access;

   function Create_Subscriber_With_Profile
     (Self         : not null access Ref;
      Library_Name : in Standard.String;
      profile_name : in Standard.String;
      A_Listener   : in DDS.SubscriberListener.Ref_Access  := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.Subscriber.Ref_Access;


   procedure Delete_Subscriber
     (Self       :  not null access Ref;
      Subscriber :  in out DDS.Subscriber.Ref_Access);


   function Create_DataWriter
     (Self       : not null access Ref;
      A_Topic    : in DDS.Topic.Ref_Access;
      Qos        : in DDS.DataWriterQos := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
      A_Listener : in DDS.DataWriterListener.Ref_Access := null;
      Mask       : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.DataWriter.Ref_Access;

   function Create_DataWriter_With_Profile
     (Self         : not null access Ref;
      A_Topic      : in DDS.Topic.Ref_Access;
      Library_Name : in DDS.String;
      profile_name : in DDS.String;
      A_Listener   : in DDS.DataWriterListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.DataWriter.Ref_Access;
   function Create_DataWriter_With_Profile
     (Self         : not null access Ref;
      A_Topic      : in DDS.Topic.Ref_Access;
      Library_Name : in Standard.String;
      profile_name : in Standard.String;
      A_Listener   : in DDS.DataWriterListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.DataWriter.Ref_Access;

   procedure Delete_DataWriter
     (Self         : not null access Ref;
      A_DataWriter : in out DDS.DataWriter.Ref_Access);


   function Create_DataReader
     (Self       : not null access Ref;
      Topic      : not null access DDS.TopicDescription.Ref'Class;
      Qos        : in DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
      A_Listener : in DDS.DataReaderListener.Ref_Access := null;
      Mask       : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.DataReader.Ref_Access;

   function Create_DataReader_With_Profile
     (Self         : not null access Ref;
      Topic        : not null access DDS.TopicDescription.Ref'Class;
      Library_Name : in DDS.String;
      profile_name : in DDS.String;
      A_Listener   : in DDS.DataReaderListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.DataReader.Ref_Access;
   function Create_DataReader_With_Profile
     (Self         : not null access Ref;
      Topic        : not null access DDS.TopicDescription.Ref'Class;
      Library_Name : in Standard.String;
      profile_name : in Standard.String;
      A_Listener   : in DDS.DataReaderListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.DataReader.Ref_Access;

   procedure Delete_DataReader
     (Self         : not null access Ref;
      A_DataReader : in out DDS.DataReader.Ref_Access);


   function Get_Builtin_Subscriber
     (Self :  not null access Ref)
      return DDS.Subscriber.Ref_Access;

   function Get_Implicit_Publisher
     (Self :  not null access Ref)
      return DDS.Publisher.Ref_Access;

   function Get_Implicit_Subscriber
     (Self :  not null access Ref)
      return DDS.Subscriber.Ref_Access;

   function Create_Topic
     (Self       : not null access Ref;
      Topic_Name : in DDS.String;
      Type_Name  : in DDS.String;
      Qos        : in DDS.TopicQos;
      A_Listener : in DDS.TopicListener.Ref_Access;
      Mask       : in DDS.StatusMask)
      return DDS.Topic.Ref_Access;

   function Create_Topic_With_Profile
     (Self         : not null access Ref;
      Topic_Name   : in DDS.String;
      Type_Name    : in DDS.String;
      Library_Name : in DDS.String;
      profile_name : in DDS.String;
      A_Listener   : in DDS.TopicListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.Topic.Ref_Access;

   function Create_Topic_With_Profile
     (Self         : not null access Ref;
      Topic_Name   : in DDS.String;
      Type_Name    : in DDS.String;
      Library_Name : in Standard.String;
      profile_name : in Standard.String;
      A_Listener   : in DDS.TopicListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.Topic.Ref_Access;

   function  Get_Or_Create_Topic
     (Self       : not null Access Ref;
      Topic_Name : in DDS.String;
      Type_Name  : in DDS.String;
      Qos        : in DDS.TopicQos := DDS.DomainParticipant.TOPIC_QOS_DEFAULT;
      A_Listener : in DDS.TopicListener.Ref_Access := null;
      Mask       : in DDS.StatusMask := STATUS_MASK_NONE)return  DDS.Topic.Ref_Access;

   function  Get_Or_Create_Topic_With_Profile
     (Self         : not null access Ref;
      Topic_Name   : in DDS.String;
      Type_Name    : in DDS.String;
      Library_Name : in DDS.String;
      Profile_Name : in DDS.String;
      A_Listener   : in DDS.TopicListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE) return  DDS.Topic.Ref_Access;

   procedure Delete_Topic
     (Self    : not null access Ref;
      A_Topic : in out DDS.Topic.Ref_Access);


   function Find_Topic
     (Self       : not null access Ref;
      Topic_Name : in DDS.String;
      Timeout    : in DDS.Duration_T)
      return DDS.Topic.Ref_Access;


   function Lookup_Topicdescription
     (Self : not null access Ref;
      Name : in DDS.String)
      return DDS.TopicDescription.Ref_Access;

   function Create_Contentfilteredtopic
     (Self                  : not null access Ref;
      Name                  : in DDS.String;
      Related_Topic         : in DDS.Topic.Ref_Access;
      Filter_Expression     : in DDS.String;
      Filter_Parameters     : access DDS.String_Seq.Sequence)
      return DDS.ContentFilteredTopic.Ref_Access;

   procedure Delete_Contentfilteredtopic
     (Self    : not null access Ref;
      CFTopic : in out DDS.ContentFilteredTopic.Ref_Access);

   function Create_MultiTopic
     (Self                    : not null access Ref;
      Name                    : in DDS.String;
      Type_Name               : in DDS.String;
      Subscription_Expression : in DDS.String;
      Expression_Parameters   : access DDS.String_Seq.Sequence)
      return DDS.MultiTopic.Ref_Access;

   procedure Delete_MultiTopic
     (Self     : not null access Ref;
      MTopic  : in out DDS.MultiTopic.Ref_Access);

--     function Create_FlowController
--       (Self         : not null access Ref;
--        name         : DDS.String;
--        prop         : access DDS.FlowControllerProperty_T)
--        return access DDS.FlowController.Ref'Class;

   procedure Delete_Contained_Entities
     (Self :  not null access Ref);


   procedure Set_Qos
     (Self : not null access Ref;
      Qos  : in DDS.DomainParticipantQos);

   procedure Set_Qos_With_Profile
     (Self          : not null access Ref;
      library_name  : in String;
      profile_name  : in String);
   procedure Set_Qos_With_Profile
     (Self          : not null access Ref;
      library_name  : in Standard.String;
      profile_name  : in Standard.String);

   procedure Get_Qos
     (Self : not null access Ref;
      Qos  : in out DDS.DomainParticipantQos);

   procedure Set_Listener
     (Self       : not null access Ref;
      A_Listener : DDS.DomainParticipantListener.Ref_Access;
      Mask       : in DDS.StatusMask);

   function Get_Listener
     (Self :  not null access Ref)
      return DDS.DomainParticipantListener.Ref_Access;


   procedure Ignore_Participant
     (Self   : not null access Ref;
      Handle : in DDS.InstanceHandle_T);


   procedure Ignore_Topic
     (Self   : not null access Ref;
      Handle : in DDS.InstanceHandle_T);

   procedure Ignore_Publication
     (Self   : not null access Ref;
      Handle : in DDS.InstanceHandle_T);

   procedure Ignore_Subscription
     (Self   : not null access Ref;
      Handle : in DDS.InstanceHandle_T);

   function Get_Domain_Id
     (Self :  not null access Ref)
      return DDS.DomainId_T;

   function Get_Factory
     (Self :  not null access Ref)
      return not null access DDS.DomainParticipantFactory.Ref;

   procedure Assert_Liveliness
     (Self :  not null access Ref);

   procedure Set_Default_DataReader_Qos
     (Self : not null access Ref;
      Qos  : in DDS.DataReaderQoS);

   procedure Set_Default_DataReader_Qos_With_Profile
     (Self     : not null access Ref;
      libName  : DDS.String;
      profName : DDS.String);
   procedure Set_Default_DataReader_Qos_With_Profile
     (Self     : not null access Ref;
      libName  : Standard.String;
      profName : Standard.String);

   procedure Set_Default_DataWriter_Qos
     (Self : not null access Ref;
      Qos  : in DDS.DataWriterQoS);

   procedure Set_Default_DataWriter_Qos_With_Profile
     (Self     : not null access Ref;
      libName  : DDS.String;
      profName : DDS.String);
   procedure Set_Default_DataWriter_Qos_With_Profile
     (Self     : not null access Ref;
      libName  : Standard.String;
      profName : Standard.String);

   procedure Set_Default_Publisher_Qos
     (Self : not null access Ref;
      Qos  : in DDS.PublisherQos);

   procedure Set_Default_Publisher_Qos_With_Profile
     (Self     : not null access Ref;
      libName  : DDS.String;
      profName : DDS.String);
   procedure Set_Default_Publisher_Qos_With_Profile
     (Self     : not null access Ref;
      libName  : Standard.String;
      profName : Standard.String);

   procedure Get_Default_Publisher_Qos
     (Self    : not null access Ref;
      Qos     : in out DDS.PublisherQos);

   procedure Set_Default_Subscriber_Qos
     (Self : not null access Ref;
      Qos  : in DDS.SubscriberQos);

   procedure Set_Default_Subscriber_Qos_With_Profile
     (Self : not null access Ref;
      libraryName : DDS.String;
      profileName : DDS.String);
   procedure Set_Default_Subscriber_Qos_With_Profile
     (Self : not null access Ref;
      libraryName : Standard.String;
      profileName : Standard.String);

   procedure Get_Default_Subscriber_Qos
     (Self    : not null access Ref;
      Qos     : in out DDS.SubscriberQos);

   procedure Get_Default_DataReader_Qos
     (Self : not null access Ref;
      Qos  : in out DDS.DataReaderQoS);

   procedure Get_Default_DataWriter_Qos
     (Self : not null access Ref;
      Qos  : in out DDS.DataWriterQos);

   procedure Set_Default_Topic_Qos
     (Self : not null access Ref;
      Qos  : in DDS.TopicQos);

   procedure Set_Default_Topic_Qos_With_Profile
     (Self        : not null access Ref;
      libraryName : DDS.String;
      profileName : DDS.String);
   procedure Set_Default_Topic_Qos_With_Profile
     (Self        : not null access Ref;
      libraryName : Standard.String;
      profileName : Standard.String);

   procedure Get_Default_Topic_Qos
     (Self    : not null access Ref;
      Qos     : in out DDS.TopicQos);

   procedure Set_Default_Profile
     (Self          : not null access Ref;
      library_name  : DDS.String;
      profile_name  : DDS.String);

   procedure Set_Default_Library
     (Self          : not null access Ref;
      library_name   : DDS.String);

   function Get_Default_Library
     (Self : not null access Ref)
      return DDS.String;

   function Get_Default_Profile
     (Self : not null access Ref)
      return DDS.String;

   function Get_Default_Profile_Library
     (Self : not null access Ref)
      return DDS.String;

   procedure Get_Default_Flowcontroller_Property
     (Self : not null access Ref;
      Property : in out DDS.FlowControllerProperty_T);

   procedure Set_Default_Flowcontroller_Property
     (Self : not null access Ref;
      Property : in DDS.FlowControllerProperty_T);

   function Get_Discovered_Participants
     (Self                :  access Ref)
      return DDS.InstanceHandle_Seq.Sequence;

   function Get_Discovered_Participant_Data
     (Self               : not null access Ref;
      Participant_Handle : in DDS.InstanceHandle_T)
      return DDS.ParticipantBuiltinTopicData;

   function Get_Discovered_Topics
     (Self :  access Ref)
      return DDS.InstanceHandle_Seq.Sequence;

   function Get_Discovered_Topic_Data
     (Self         : not null access Ref;
      Topic_Handle : in DDS.InstanceHandle_T)
      return DDS.TopicBuiltinTopicData;

   procedure Get_Discovered_Topic_Data
     (Self         : not null access Ref;
      Topic_Handle : in DDS.InstanceHandle_T;
      data         : access DDS.TopicBuiltinTopicData);

   function Contains_Entity
     (Self     : not null access Ref;
      A_Handle : in DDS.InstanceHandle_T)
      return Boolean;

   function Get_Current_Time
     (Self : not null access Ref)
      return DDS.Time_T;

   procedure Free (This : in out Ref_Access);

   function CreateI
     (Participant_Factory   : not null access dds.DomainParticipantFactory.ref;
      Domain_Id             : in DDS.DomainId_T;
      Qos                   : in DDS.DomainParticipantQos;
      A_Listener            : in DDS.DomainParticipantListener.Ref_Access;
      Mask                  : in DDS.StatusMask)
      return DDS.DomainParticipant.Ref_Access;

   function CreateI
     (Participant_Factory : not null access dds.DomainParticipantFactory.ref;
      Domain_Id             : in DDS.DomainId_T;
      library_name          : in DDS.String;
      profile_name          : in DDS.String;
      A_Listener            : in DDS.DomainParticipantListener.Ref_Access;
      Mask                  : in DDS.StatusMask)
      return DDS.DomainParticipant.Ref_Access;

   function Get_FacadeI (C_DomainParticpant : System.Address)
                         return Ref_Access;

   procedure Add_Peer
     (Self             : not null access Ref;
      peer_desc_string : DDS.String);

   procedure Register_Builtin_TypesI (Self : not null access Ref);

   procedure Register_User_TypesI (Self : not null access Ref);

   procedure Delete_Implicit_EntitiesI (Self : not null access Ref);

   procedure Get_Publishers
     (Self : not null access Ref;
      publishers : access DDS.PublisherSeq.Sequence);

   procedure Get_Subscribers
     (Self        : not null access Ref;
      subscribers : access DDS.SubscriberSeq.Sequence);

   type Register_Type_Procedure is not null access procedure
     (Participant :  not null access DDS.DomainParticipant.Ref'Class);

   procedure Register_Type_Registration (P : Register_Type_Procedure);
private

   procedure Free_Impl is new Ada.Unchecked_Deallocation (Ref'Class, Ref_Access);
   procedure Free_Mem (This : in out Ref_Access) renames Free_Impl;

end DDS.DomainParticipant_Impl;
