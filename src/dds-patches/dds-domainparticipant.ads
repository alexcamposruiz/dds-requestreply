--  (c) Copyright, Real-Time Innovations, $Date:: 2012-02-16 #$
--  All rights reserved.
--
--  No duplications, whole or partial, manual or electronic, may be made
--  without express written permission.  Any such copies, or
--  revisions thereof, must display this notice unaltered.
--  This code contains trade secrets of Real-Time Innovations, Inc.

with DDS.StatusCondition;
with DDS.DomainParticipantListener;
with DDS.TopicListener;
with DDS.SubscriberListener;
with DDS.PublisherListener;
with DDS.PublisherSeq;
with DDS.Publisher;
with DDS.Topic;
with DDS.Entity;
with DDS.TopicDescription;
with DDS.Subscriber;
with DDS.SubscriberSeq;
with DDS.ContentFilteredTopic;
with DDS.MultiTopic;
limited with DDS.DomainParticipantFactory;
--  limited with DDS.FlowController;
with DDS.DataWriter;
with DDS.DataWriterListener;
with DDS.DataReader;
with DDS.DataReaderListener;

--  <dref>DomainParticipant</dref>
package DDS.DomainParticipant is
   pragma Elaborate_Body;
   TOPIC_QOS_DEFAULT : aliased  constant TopicQos with
     Convention => Ada,
     Import,
     Link_Name => "DDS__DomainParticipant__TOPIC_QOS_DEFAULT";
   --  <dref>TOPIC_QOS_DEFAULT</dref>

   PUBLISHER_QOS_DEFAULT : aliased  constant PublisherQos with
     Convention => Ada,
     Import,
     Link_Name => "DDS__DomainParticipant__PUBLISHER_QOS_DEFAULT";
   --  <dref>PUBLISHER_QOS_DEFAULT</dref>

   SUBSCRIBER_QOS_DEFAULT : aliased  constant SubscriberQos with
     Convention => Ada,
     Import,
     Link_Name => "DDS__DomainParticipant__SUBSCRIBER_QOS_DEFAULT";
   --  <dref>SUBSCRIBER_QOS_DEFAULT</dref>

   FLOW_CONTROLLER_PROPERTY_DEFAULT : aliased  constant FlowControllerProperty_T with
     Convention => Ada,
     Import,
     Link_Name => "DDS__DomainParticipant__FLOW_CONTROLLER_PROPERTY_DEFAULT";
   --  <dref>FLOW_CONTROLLER_PROPERTY_DEFAULT</dref>

   type Ref is limited interface and DDS.Entity.Ref;
   type Ref_Access is access all Ref'Class;

   --  Re-Implement From DDS.DomainEntity

   procedure Enable (Self : not null access Ref) is abstract;

   function Get_StatusCondition (Self : not null access Ref) return
     DDS.StatusCondition.Ref_Access is abstract;

   function Get_Status_Changes (Self : not null access Ref) return
     DDS.StatusMask is abstract;

   function Get_Instance_Handle (Self : not null access Ref) return
     DDS.InstanceHandle_T is abstract;

   function Get_Entity_Kind (Self : not null access Ref) return
     DDS.EntityKind_T is abstract;

   --

   function Create_Publisher
     (Self       : not null access Ref;
      Qos        : in DDS.PublisherQos := PUBLISHER_QOS_DEFAULT;
      A_Listener : in DDS.PublisherListener.Ref_Access := null;
      Mask       : in DDS.StatusMask := STATUS_MASK_NONE)
     return DDS.Publisher.Ref_Access is abstract;
   --  <dref>DomainParticipant_create_publisher</dref>

   function Create_Publisher_With_Profile
     (Self         : not null access Ref;
      Library_Name : in DDS.String;
      profile_name : in DDS.String;
      A_Listener : in DDS.PublisherListener.Ref_Access := null;
      Mask       : in DDS.StatusMask := STATUS_MASK_NONE)
     return DDS.Publisher.Ref_Access is abstract;
   function Create_Publisher_With_Profile
     (Self         : not null access Ref;
      Library_Name : in Standard.String;
      profile_name : in Standard.String;
      A_Listener : in DDS.PublisherListener.Ref_Access := null;
      Mask       : in DDS.StatusMask := STATUS_MASK_NONE)
     return DDS.Publisher.Ref_Access is abstract;
   --  <dref>DomainParticipant_create_publisher_with_profile</dref>


   procedure Delete_Publisher
     (Self      : not null access Ref;
      Publisher : in out DDS.Publisher.Ref_Access) is abstract;
   --  <dref>DomainParticipant_delete_publisher</dref>


   function Create_Subscriber
     (Self       : not null access Ref;
      Qos        : in DDS.SubscriberQos := SUBSCRIBER_QOS_DEFAULT;
      A_Listener : in DDS.SubscriberListener.Ref_Access  := null;
      Mask       : in DDS.StatusMask := STATUS_MASK_NONE)
     return DDS.Subscriber.Ref_Access is abstract;
   --  <dref>DomainParticipant_create_subscriber</dref>

   function Create_Subscriber_With_Profile
     (Self         : not null access Ref;
      Library_Name : in DDS.String;
      profile_name : in DDS.String;
      A_Listener   : in DDS.SubscriberListener.Ref_Access  := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
     return DDS.Subscriber.Ref_Access is abstract;
   function Create_Subscriber_With_Profile
     (Self         : not null access Ref;
      Library_Name : in Standard.String;
      profile_name : in Standard.String;
      A_Listener   : in DDS.SubscriberListener.Ref_Access  := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
     return DDS.Subscriber.Ref_Access is abstract;
   --  <dref>DomainParticipant_create_subscriber_with_profile</dref>


   procedure Delete_Subscriber
     (Self :  not null access Ref;
      S    :  in out DDS.Subscriber.Ref_Access) is abstract;
   --  <dref>DomainParticipant_delete_subscriber</dref>


   function Create_DataWriter
     (Self       : not null access Ref;
      A_Topic    : in DDS.Topic.Ref_Access;
      Qos        : in DDS.DataWriterQos := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
      A_Listener : in DDS.DataWriterListener.Ref_Access := null;
      Mask       : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.DataWriter.Ref_Access is abstract;
   --  <dref>DomainParticipant_create_datawriter</dref>

   function Create_DataWriter_With_Profile
     (Self         : not null access Ref;
      A_Topic      : in DDS.Topic.Ref_Access;
      Library_Name : in DDS.String;
      profile_name : in DDS.String;
      A_Listener   : in DDS.DataWriterListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.DataWriter.Ref_Access is abstract;
   function Create_DataWriter_With_Profile
     (Self         : not null access Ref;
      A_Topic      : in DDS.Topic.Ref_Access;
      Library_Name : in Standard.String;
      profile_name : in Standard.String;
      A_Listener   : in DDS.DataWriterListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.DataWriter.Ref_Access is abstract;
   --  <dref>DomainParticipant_create_datawriter_with_profile</dref>


   procedure Delete_DataWriter
     (Self         : not null access Ref;
      A_DataWriter : in out DDS.DataWriter.Ref_Access) is abstract;
   --  <dref>DomainParticipant_delete_datawriter</dref>


   function Create_DataReader
     (Self       : not null access Ref;
      Topic      : not null access DDS.TopicDescription.Ref'Class;
      Qos        : in DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
      A_Listener : in DDS.DataReaderListener.Ref_Access := null;
      Mask       : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.DataReader.Ref_Access is abstract;
   --  <dref>DomainParticipant_create_datareader</dref>

   function Create_DataReader_With_Profile
     (Self         : not null access Ref;
      Topic        : not null access DDS.TopicDescription.Ref'Class;
      Library_Name : in DDS.String;
      profile_name : in DDS.String;
      A_Listener   : in DDS.DataReaderListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.DataReader.Ref_Access is abstract;
   --  <dref>DomainParticipant_create_datareader_with_profile</dref>


   procedure Delete_DataReader
     (Self         : not null access Ref;
      A_DataReader : in out DDS.DataReader.Ref_Access) is abstract;
   --  <dref>DomainParticipant_delete_datareader</dref>


   function Get_Builtin_Subscriber
     (Self :  not null access Ref)
      return DDS.Subscriber.Ref_Access is abstract;
   --  <dref>DomainParticipant_get_builtin_subscriber</dref>

   function Get_Implicit_Publisher
     (Self :  not null access Ref)
      return DDS.Publisher.Ref_Access is abstract;
   --  <dref>DomainParticipant_get_implicit_publisher</dref>

   function Get_Implicit_Subscriber
     (Self :  not null access Ref)
      return DDS.Subscriber.Ref_Access is abstract;
   --  <dref>DomainParticipant_get_implicit_subscriber</dref>
   --  <dref>Shared_implicit_subscriber_mt_safety</dref>


   function Create_Topic
     (Self       : not null access Ref;
      Topic_Name : in DDS.String;
      Type_Name  : in DDS.String;
      Qos        : in DDS.TopicQos := TOPIC_QOS_DEFAULT;
      A_Listener : in DDS.TopicListener.Ref_Access := null;
      Mask       : in DDS.StatusMask := STATUS_MASK_NONE)
     return DDS.Topic.Ref_Access is abstract;
   --  <dref>DomainParticipant_create_topic</dref>

   function Create_Topic_With_Profile
     (Self         : not null access Ref;
      Topic_Name   : in DDS.String;
      Type_Name    : in DDS.String;
      Library_Name : in DDS.String;
      profile_name : in DDS.String;
      A_Listener   : in DDS.TopicListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.Topic.Ref_Access is abstract;

   function Create_Topic_With_Profile
     (Self         : not null access Ref;
      Topic_Name   : in DDS.String;
      Type_Name    : in DDS.String;
      Library_Name : in Standard.String;
      profile_name : in Standard.String;
      A_Listener   : in DDS.TopicListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.Topic.Ref_Access is abstract;
   --  <dref>DomainParticipant_create_topic_with_profile</dref>

   function  Get_Or_Create_Topic
     (Self       : not null access Ref;
      Topic_Name : in DDS.String;
      Type_Name  : in DDS.String;
      Qos        : in DDS.TopicQos := DDS.DomainParticipant.TOPIC_QOS_DEFAULT;
      A_Listener : in DDS.TopicListener.Ref_Access := null;
      Mask       : in DDS.StatusMask := STATUS_MASK_NONE)return  DDS.Topic.Ref_Access is abstract;

   function  Get_Or_Create_Topic_With_Profile
     (Self         : not null access Ref;
      Topic_Name   : in DDS.String;
      Type_Name    : in DDS.String;
      Library_Name : in DDS.String;
      Profile_Name : in DDS.String;
      A_Listener   : in DDS.TopicListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE) return DDS.Topic.Ref_Access  is abstract;


--     function Create_FlowController
--       (Self         : not null access Ref;
--        name         : DDS.String;
--        prop         : access DDS.FlowControllerProperty_T)
--        return access DDS.FlowController.Ref'Class is abstract;

   procedure Delete_Topic
     (Self    : not null access Ref;
      A_Topic : in out DDS.Topic.Ref_Access) is abstract;
   --  <dref>DomainParticipant_delete_topic</dref>


   function Find_Topic
     (Self       : not null access Ref;
      Topic_Name : in DDS.String;
      Timeout    : in DDS.Duration_T)
     return DDS.Topic.Ref_Access is abstract;
   --  <dref>DomainParticipant_find_topic</dref>


   function Lookup_Topicdescription
     (Self : not null access Ref;
      Name : in DDS.String)
     return DDS.TopicDescription.Ref_Access is abstract;
   --  <dref>DomainParticipant_lookup_topicdescription</dref>


   function Create_Contentfilteredtopic
     (Self                  : not null access Ref;
      Name                  : in DDS.String;
      Related_Topic         : in DDS.Topic.Ref_Access;
      Filter_Expression     : in DDS.String;
      Expression_Parameters : access DDS.String_Seq.Sequence)
     return DDS.ContentFilteredTopic.Ref_Access is abstract;
   --  <dref>DomainParticipant_create_contentfilteredtopic</dref>

   procedure Delete_Contentfilteredtopic
     (Self                   : not null access Ref;
      A_Contentfilteredtopic : in out DDS.ContentFilteredTopic.Ref_Access) is abstract;
   --  <dref>DomainParticipant_delete_contentfilteredtopic</dref>

   function Create_MultiTopic
     (Self                    : not null access Ref;
      Name                    : in DDS.String;
      Type_Name               : in DDS.String;
      Subscription_Expression : in DDS.String;
      Expression_Parameters   : access DDS.String_Seq.Sequence)
      return DDS.MultiTopic.Ref_Access is abstract;
   --  <dref>DomainParticipant_create_multitopic</dref>

   procedure Delete_MultiTopic
     (Self     : not null access Ref;
      MTopic  : in out DDS.MultiTopic.Ref_Access) is abstract;
   --  <dref>DomainParticipant_delete_multitopic</dref>

   procedure Delete_Contained_Entities
     (Self :  not null access Ref) is abstract;
   --  <dref>DomainParticipant_delete_contained_entities</dref>


   procedure Set_Qos
     (Self : not null access Ref;
      Qos  : in DDS.DomainParticipantQos) is abstract;
   --  <dref>DomainParticipant_set_qos</dref>


   procedure Set_Qos_With_Profile
     (Self          : not null access Ref;
      library_name  : in String;
      profile_name  : in String) is abstract;
   procedure Set_Qos_With_Profile
     (Self          : not null access Ref;
      library_name  : in Standard.String;
      profile_name  : in Standard.String) is abstract;
   --  <dref>DomainParticipant_set_qos_with_profile</dref>

   procedure Get_Qos
     (Self : not null access Ref;
      Qos  : in out DDS.DomainParticipantQos) is abstract;
   --  <dref>DomainParticipant_get_qos</dref>

   procedure Set_Listener
     (Self       : not null access Ref;
      A_Listener : DDS.DomainParticipantListener.Ref_Access;
      Mask       : in DDS.StatusMask) is abstract;
   --  <dref>DomainParticipant_set_listener</dref>

   function Get_Listener
     (Self :  not null access Ref)
     return DDS.DomainParticipantListener.Ref_Access is abstract;
   --  <dref>DomainParticipant_get_listener</dref>

   procedure Ignore_Participant
     (Self   : not null access Ref;
      Handle : in DDS.InstanceHandle_T) is abstract;
   --  <dref>DomainParticipant_ignore_participant</dref>
   --  <dref>Shared_ignore_participant</dref>

   procedure Ignore_Topic
     (Self   : not null access Ref;
      Handle : in DDS.InstanceHandle_T) is abstract;
   --  <dref>DomainParticipant_ignore_topic</dref>

   procedure Ignore_Publication
     (Self   : not null access Ref;
      Handle : in DDS.InstanceHandle_T) is abstract;
   --  <dref>DomainParticipant_ignore_publication</dref>

   procedure Ignore_Subscription
     (Self   : not null access Ref;
      Handle : in DDS.InstanceHandle_T) is abstract;
   --  <dref>DomainParticipant_ignore_subscription</dref>

   function Get_Domain_Id
     (Self : not null access Ref)
     return DDS.DomainId_T is abstract;
   --  <dref>DomainParticipant_get_domain_id</dref>
   --  <dref>Shared_domain_id_description</dref>

   function Get_Factory
     (Self :  not null access Ref)
      return not null access DDS.DomainParticipantFactory.Ref is abstract;

   procedure Assert_Liveliness
     (Self : not null access Ref) is abstract;
   --  <dref>DomainParticipant_assert_liveliness</dref>
   --  <dref>Shared_liveliness</dref>

   procedure Set_Default_DataReader_Qos
     (Self : not null access Ref;
      Qos  : in DDS.DataReaderQoS) is abstract;
   --  <dref>DomainParticipant_set_default_datareader_qos</dref>
   --  <dref>Shared_set_default_datareader_qos</dref>

   procedure Set_Default_DataReader_Qos_With_Profile
     (Self     : not null access Ref;
      libName  : DDS.String;
      profName : DDS.String) is abstract;
   procedure Set_Default_DataReader_Qos_With_Profile
     (Self     : not null access Ref;
      libName  : Standard.String;
      profName : Standard.String) is abstract;
   --  <dref>DomainParticipant_set_default_datareader_qos_with_profile</dref>

   procedure Set_Default_DataWriter_Qos
     (Self : not null access Ref;
      Qos  : in DDS.DataWriterQoS) is abstract;
   --  <dref>DomainParticipant_set_default_datawriter_qos</dref>
   --  <dref>Shared_set_default_datawriter_qos</dref>

   procedure Set_Default_DataWriter_Qos_With_Profile
     (Self     : not null access Ref;
      libName  : DDS.String;
      profName : DDS.String) is abstract;
   procedure Set_Default_DataWriter_Qos_With_Profile
     (Self     : not null access Ref;
      libName  : Standard.String;
      profName : Standard.String) is abstract;
   --  <dref>DomainParticipant_set_default_datawriter_qos_with_profile</dref>

   procedure Set_Default_Publisher_Qos
     (Self : not null access Ref;
      Qos  : in DDS.PublisherQos) is abstract;
   --  <dref>DomainParticipant_set_default_publisher_qos</dref>
   --  <dref>Shared_set_default_publisher_qos</dref>

   procedure Set_Default_Publisher_Qos_With_Profile
     (Self     : not null access Ref;
      libName  : DDS.String;
      profName : DDS.String) is abstract;
   procedure Set_Default_Publisher_Qos_With_Profile
     (Self     : not null access Ref;
      libName  : Standard.String;
      profName : Standard.String) is abstract;
   --  <dref>DomainParticipant_set_default_publisher_qos_with_profile</dref>

   procedure Get_Default_Publisher_Qos
     (Self : not null access Ref;
      Qos  : in out DDS.PublisherQos) is abstract;
   --  <dref>DomainParticipant_get_default_publisher_qos</dref>
   --  <dref>Shared_get_default_publisher_qos_mtsafety</dref>

   procedure Set_Default_Subscriber_Qos
     (Self : not null access Ref;
      Qos  : in DDS.SubscriberQos) is abstract;
   --  <dref>DomainParticipant_set_default_subscriber_qos</dref>

   procedure Set_Default_Subscriber_Qos_With_Profile
     (Self : not null access Ref;
      libraryName : DDS.String;
      profileName : DDS.String) is abstract;
   procedure Set_Default_Subscriber_Qos_With_Profile
     (Self : not null access Ref;
      libraryName : Standard.String;
      profileName : Standard.String) is abstract;
   --  <dref>DomainParticipant_set_default_subscriber_qos_with_profile</dref>

   procedure Get_Default_Subscriber_Qos
     (Self : not null access Ref;
      Qos  : in out DDS.SubscriberQos) is abstract;
   --  <dref>DomainParticipant_get_default_subscriber_qos</dref>

   procedure Get_Default_DataReader_Qos
     (Self : not null access Ref;
      Qos  : in out DDS.DataReaderQoS) is abstract;
   --  <dref>DomainParticipant_get_default_datareader_qos</dref>
   --  <dref>Shared_get_default_datareader_qos_mtsafety</dref>

   procedure Get_Default_DataWriter_Qos
     (Self : not null access Ref;
      Qos  : in out DDS.DataWriterQos) is abstract;
   --  <dref>DomainParticipant_get_default_datawriter_qos</dref>
   --  <dref>Shared_get_default_datawriter_qos_mtsafety</dref>

   procedure Set_Default_Topic_Qos
     (Self : not null access Ref;
      Qos  : in DDS.TopicQos) is abstract;
   --  <dref>DomainParticipant_set_default_topic_qos</dref>
   --  <dref>Shared_set_default_topic_qos</dref>

   procedure Set_Default_Topic_Qos_With_Profile
     (Self        : not null access Ref;
      libraryName : DDS.String;
      profileName : DDS.String) is abstract;
   procedure Set_Default_Topic_Qos_With_Profile
     (Self        : not null access Ref;
      libraryName : Standard.String;
      profileName : Standard.String) is abstract;
   --  <dref>DomainParticipant_set_default_topic_qos_with_profile</dref>

   procedure Get_Default_Topic_Qos
     (Self : not null access Ref;
      Qos  : in out DDS.TopicQos) is abstract;
   --  <dref>DomainParticipant_get_default_topic_qos</dref>
   --  <dref>Shared_get_default_topic_qos_mtsafety</dref>

   procedure Set_Default_Profile
     (Self          : not null access Ref;
      library_name  : DDS.String;
      profile_name  : DDS.String) is abstract;
   --  <dref>DomainParticipant_set_default_profile</dref>

   procedure Set_Default_Library
     (Self          : not null access Ref;
      library_name   : DDS.String) is abstract;
   --  <dref>DomainParticipant_set_default_library</dref>

   function Get_Default_Library
     (Self : not null access Ref)
      return DDS.String is abstract;
   --  <dref>DomainParticipant_get_default_library</dref>

   function Get_Default_Profile
     (Self : not null access Ref)
      return DDS.String is abstract;
   --  <dref>DomainParticipant_get_default_profile</dref>

   function Get_Default_Profile_Library
     (Self : not null access Ref)
      return DDS.String is abstract;
   --  <dref>DomainParticipant_get_default_profile_library</dref>

   procedure Get_Default_Flowcontroller_Property
     (Self : not null access Ref;
      Property : in out DDS.FlowControllerProperty_T) is abstract;
   --  <dref>DomainParticipant_get_default_flowcontroller_property</dref>

   procedure Set_Default_Flowcontroller_Property
     (Self : not null access Ref;
      Property : in DDS.FlowControllerProperty_T) is abstract;
   --  <dref>DomainParticipant_set_default_flowcontroller_property</dref>

   function Get_Discovered_Participants
     (Self                :  access Ref)
     return DDS.InstanceHandle_Seq.Sequence is abstract;
   --  <dref>DomainParticipant_get_discovered_participants</dref>

   function Get_Discovered_Participant_Data
     (Self : not null access Ref;
      Participant_Handle : in DDS.InstanceHandle_T)
     return DDS.ParticipantBuiltinTopicData is abstract;
   --  <dref>DomainParticipant_get_discovered_participant_data</dref>

   function Get_Discovered_Topics
     (Self :  access Ref)
     return DDS.InstanceHandle_Seq.Sequence is abstract;
   --  <dref>DomainParticipant_get_discovered_topics</dref>

   function Get_Discovered_Topic_Data
     (Self : not null access Ref;
      Topic_Handle : in DDS.InstanceHandle_T)
      return DDS.TopicBuiltinTopicData is abstract;
   --  <dref>DomainParticipant_get_discovered_topic_data</dref>

   function Contains_Entity
     (Self : not null access Ref;
      A_Handle : in DDS.InstanceHandle_T)
     return Boolean is abstract;
   --  <dref>DomainParticipant_contains_entity</dref>

   function Get_Current_Time
     (Self : not null access Ref)
      return DDS.Time_T is abstract;
   --  <dref>DomainParticipant_get_current_time</dref>

   procedure Add_Peer
     (Self             : not null access Ref;
      peer_desc_string : DDS.String) is abstract;
   --  <dref>DomainParticipant_add_peer</dref>
   --  <dref>Shared_add_peer</dref>

   procedure Get_Publishers
     (Self : not null access Ref;
      publishers : access DDS.PublisherSeq.Sequence) is abstract;
   --  <dref>DomainParticipant_get_publishers</dref>

   procedure Get_Subscribers
     (Self        : not null access Ref;
      subscribers : access DDS.SubscriberSeq.Sequence) is abstract;
   --  <dref>DomainParticipant_get_publishers</dref>

end DDS.DomainParticipant;
