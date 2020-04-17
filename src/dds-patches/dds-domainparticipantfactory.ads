--  (c) Copyright, Real-Time Innovations, $Date:: 2012-02-16 #$
--  All rights reserved.
--
--  No duplications, whole or partial, manual or electronic, may be made
--  without express written permission.  Any such copies, or
--  revisions thereof, must display this notice unaltered.
--  This code contains trade secrets of Real-Time Innovations, Inc.

pragma Ada_05;

with RTIDDS.Obj_Impl;
with DDS.DomainParticipant;
with DDS.DomainParticipantListener;
private with RTIDDS.Low_Level.ndds_reda_reda_worker_impl_h;

--  <module name="DDSDomainModule" actualName="Domain Module">domain</module>
--  <dref>DomainParticipantFactory</dref>
package DDS.DomainParticipantFactory is

   type Ref is new RTIDDS.Obj_Impl.Ref with private;
   type Ref_Access is access all Ref'Class;

   PARTICIPANT_QOS_DEFAULT : aliased DDS.DomainParticipantQos;
   --  <dref>PARTICIPANT_QOS_DEFAULT</dref>

   function Get_Instance return Ref_Access;
   --  <dref>DomainParticipantFactory_get_instance</dref>

   function Create_Participant
     (Self       : not null access Ref;
      Domain_Id  : in DDS.DomainId_T := Default_Domain;
      Qos        : in DDS.DomainParticipantQos := PARTICIPANT_QOS_DEFAULT;
      A_Listener : in DDS.DomainParticipantListener.Ref_Access := null;
      Mask       : in DDS.StatusMask := DDS.STATUS_MASK_NONE)
      return DDS.DomainParticipant.Ref_Access;
   --  <dref>DomainParticipantFactory_create_participant</dref>

   function Create_Participant_With_Profile
     (Self         : not null access Ref;
      Domain_Id    : in DDS.DomainId_T := Default_Domain;
      library_name : in DDS.String;
      profile_name : in DDS.String;
      A_Listener   : in DDS.DomainParticipantListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := DDS.STATUS_MASK_NONE)
      return DDS.DomainParticipant.Ref_Access;
   function Create_Participant_With_Profile
     (Self         : not null access Ref;
      Domain_Id    : in DDS.DomainId_T := Default_Domain;
      library_name : in Standard.String;
      profile_name : in Standard.String;
      A_Listener   : in DDS.DomainParticipantListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := DDS.STATUS_MASK_NONE)
      return DDS.DomainParticipant.Ref_Access;
   --  <dref>DomainParticipantFactory_create_participant_with_profile</dref>

   function  Get_Or_Create_Participant
     (Self       : not null access Ref;
      Domain_Id  : in DDS.DomainId_T := Default_Domain;
      Qos        : in DDS.DomainParticipantQos := DDS.DomainParticipantFactory.PARTICIPANT_QOS_DEFAULT;
      A_Listener : in DDS.DomainParticipantListener.Ref_Access := null;
      Mask       : in DDS.StatusMask := STATUS_MASK_NONE)return  DDS.DomainParticipant.Ref_Access;

   function  Get_Or_Create_Participant_With_Profile
     (Self         : not null access Ref;
      Domain_Id    : in DDS.DomainId_T := Default_Domain;
      Library_Name : in DDS.String;
      Profile_Name : in DDS.String;
      A_Listener   : in DDS.DomainParticipantListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE) return  DDS.DomainParticipant.Ref_Access;


   procedure Delete_Participant
     (Self          : not null access Ref;
      A_Participant : in out DDS.DomainParticipant.Ref_Access);
   --  <dref>DomainParticipantFactory_delete_participant</dref>


   function Lookup_Participant
     (Self      : not null access Ref;
      Domain_Id : in DDS.DomainId_T)
      return DDS.DomainParticipant.Ref_Access;
   --  <dref>DomainParticipantFactory_lookup_participant</dref>


   procedure Set_Default_Participant_Qos
     (Self : not null access Ref;
      Qos  : in DDS.DomainParticipantQos);
   --  <dref>DomainParticipantFactory_set_default_participant_qos</dref>

   procedure Set_Default_Participant_Qos_with_Profile
     (Self         : not null access Ref;
      libraryName  : in DDS.String;
      profile_name : in DDS.String);
   --  <dref>DomainParticipantFactory_set_default_participant_qos_with_profile</dref>

   procedure Get_Default_Participant_Qos
     (Self    : not null access Ref;
      Qos     : in out DDS.DomainParticipantQos);
   --  <dref>DomainParticipantFactory_get_default_participant_qos</dref>


   procedure Set_Qos
     (Self : not null access Ref;
      Qos  : in DDS.DomainParticipantFactoryQos);
   --  <dref>DomainParticipantFactory_set_qos</dref>
   --  <internal>
   --  Sets the value for a participant factory QoS.
   --  The DDS_DomainParticipantFactoryQos::entity_factory can be changed. The other policies are immutable.
   --  Note that despite having QoS, the DDS_DomainParticipantFactory is not an DDS_Entity.
   --  Parameters:
   --     self <<in>> Cannot be NULL.
   --     qos  <<in>> Set of policies to be applied to DDS_DomainParticipantFactory. Policies must be consistent.
   --                 Immutable Policies Can Only Be Changed Before Calling Any Other
   --                 Data Distribution Service Functions Except for DDS_DomainParticipantFactory_Get_Qos.
   --  Raises:
   --     One of the Standard Return Codes, DDS_RETCODE_IMMUTABLE_POLICY if immutable policy is changed,
   --     or DDS_RETCODE_INCONSISTENT_POLICY if Policies Are Inconsistent
   --  See also:
   --     DDS_DomainParticipantFactoryQos for rules on consistency among QoS
   --  </internal>

   procedure Load_Profiles
     (Self          : not null access Ref);
   --  <dref>DomainParticipantFactory_load_profiles</dref>

   procedure Reload_Profiles
     (Self          : not null access Ref);
   --  <dref>DomainParticipantFactory_reload_profiles</dref>

   procedure Unload_Profiles
     (Self          : not null access Ref);
   --  <dref>DomainParticipantFactory_unload_profiles</dref>

   procedure Set_Default_Profile
     (Self          : not null access Ref;
      library_name  : DDS.String;
      profile_name  : DDS.String);
   --  <dref>DomainParticipantFactory_set_default_profile</dref>

   procedure set_default_library
     (Self          : not null access Ref;
     library_name   : DDS.String);
   --  <dref>DomainParticipantFactory_set_default_library</dref>

   function get_default_library
     (Self          : not null access Ref) return DDS.String;
   --  <dref>DomainParticipantFactory_get_default_library</dref>

   function get_default_Profile
     (Self          : not null access Ref) return DDS.String;
   --  <dref>DomainParticipantFactory_get_default_profile</dref>

   function get_default_profile_library
     (Self          : not null access Ref) return DDS.String;
   --  <dref>DomainParticipantFactory_get_default_profile_library</dref>

   procedure get_qos_profile_libraries
     (Self   : not null access Ref;
      libSeq : not null access DDS.String_Seq.Sequence);
   function get_qos_profile_libraries
     (Self   : not null access Ref) return DDS.String_Seq.Sequence;
   --  <dref>DomainParticipantFactory_get_qos_profile_libraries</dref>

   procedure get_qos_profiles
     (Self    : not null access Ref;
      profSeq : not null access DDS.String_Seq.Sequence;
      libName : in DDS.String);
   function get_qos_profiles
     (Self    : not null access Ref;
      libName : in DDS.String) return DDS.String_Seq.Sequence;
   --  <dref>DomainParticipantFactory_get_qos_profiles</dref>

   -----------------------------------------------------------

   procedure get_participant_qos_from_profile
     (Self          : not null access Ref;
      QoS           : in out DDS.DomainParticipantQos;
      library_name  : DDS.String;
      profile_name  : DDS.String);
   --  <dref>DomainParticipantFactory_get_participant_qos_from_profile</dref>

   ------------------------------------------------------

   procedure get_publisher_qos_from_profile
     (Self          : not null access Ref;
      QoS           : in out DDS.PublisherQos;
      library_name  : DDS.String;
      profile_name  : DDS.String);
   --  <dref>DomainParticipantFactory_get_publisher_qos_from_profile</dref>

   ------------------------------------------------------

   procedure get_subscriber_qos_from_profile
     (Self          : not null access Ref;
      QoS           : in out DDS.SubscriberQos;
      library_name  : DDS.String;
      profile_name  : DDS.String);
   --  <dref>DomainParticipantFactory_get_subscriber_qos_from_profile</dref>


   ------------------------------------------------------

   procedure get_datareader_qos_from_profile
     (Self          : not null access Ref;
      QoS           : in out DDS.DataReaderQos;
      library_name  : DDS.String;
      profile_name  : DDS.String);
   --  <dref>DomainParticipantFactory_get_datareader_qos_from_profile</dref>


   ------------------------------------------------------

   procedure get_datareader_qos_from_profile_w_topic_name
     (Self          : not null access Ref;
      QoS           : in out DDS.DataReaderQos;
      library_name  : DDS.String;
      profile_name  : DDS.String;
      topic_name    : DDS.String);
   --  <dref>DomainParticipantFactory_get_datareader_qos_from_profile_w_topic_name</dref>


   ------------------------------------------------------

   procedure get_datawriter_qos_from_profile
     (Self          : not null access Ref;
      QoS           : in out DDS.DataWriterQos;
      library_name  : DDS.String;
      profile_name  : DDS.String);
   --  <dref>DomainParticipantFactory_get_datawriter_qos_from_profile</dref>

   ------------------------------------------------------

   procedure get_datawriter_qos_from_profile_w_topic_name
     (Self          : not null access Ref;
      QoS           : in out DDS.DataWriterQos;
      library_name  : DDS.String;
      profile_name  : DDS.String;
      topic_name    : DDS.String);
   --  <dref>DomainParticipantFactory_get_datawriter_qos_from_profile_w_topic_name</dref>


   ------------------------------------------------------

   procedure get_topic_qos_from_profile
     (Self          : not null access Ref;
      QoS           : in out DDS.TopicQos;
      library_name  : DDS.String;
      profile_name  : DDS.String);
   --  <dref>DomainParticipantFactory_get_topic_qos_from_profile</dref>

   ------------------------------------------------------

   procedure get_topic_qos_from_profile_w_topic_name
     (Self          : not null access Ref;
      QoS           : in out DDS.TopicQos;
      library_name  : DDS.String;
      profile_name  : DDS.String;
      topic_name    : DDS.String);
   --  <dref>DomainParticipantFactory_get_topic_qos_from_profile_w_topic_name</dref>

   procedure Get_Qos
     (Self    : not null access Ref;
      Qos     : in out DDS.DomainParticipantFactoryQos);
   --  <dref>DomainParticipantFactory_get_qos</dref>

   procedure Finalize_Instance (Self : not null access Ref);
   --  <dref>DomainParticipantFactory_finalize_instance</dref>

   procedure Unregister_Thread (Self : not null access Ref);
   --  <dref>DomainParticipantFactory_unregister_thread</dref>

private

   type Ref is new RTIDDS.Obj_Impl.Ref with null record;

   protected Initializeer is
      procedure Initialize;
   end Initializeer;

   procedure On_Thread_Started_Callback
     (OnStartedParam : System.Address;
      Worker         : access RTIDDS.Low_Level.ndds_reda_reda_worker_impl_h.REDAWorker);
   pragma Convention (C, On_Thread_Started_Callback);
   procedure On_Thread_Stopped_Callback
     (OnStartedParam : System.Address;
      Worker         : access RTIDDS.Low_Level.ndds_reda_reda_worker_impl_h.REDAWorker);
   pragma Convention (C, On_Thread_Stopped_Callback);

end DDS.DomainParticipantFactory;
