--  (c) Copyright, Real-Time Innovations, $Date:: 2012-12-04 #$
--  All rights reserved.
--
--  No duplications, whole or partial, manual or electronic, may be made
--  without express written permission.  Any such copies, or
--  revisions thereof, must display this notice unaltered.
--  This code contains trade secrets of Real-Time Innovations, Inc.

pragma Ada_05;

with System; use System;


with DDS.DomainParticipant_Impl;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_impl_h;
with GNAT.Threads;
with Ada.Unchecked_Conversion;

with DDS.Topic_Impl;
with DDS.ContentFilteredTopic_Impl;
with DDS.Publisher_Impl;
with DDS.Subscriber_Impl;
with DDS.DataReader_Impl;
with DDS.DataWriter_Impl;
with DDS.ReadCondition_Impl;
with system.Multiprocessors; pragma Unreferenced (system.Multiprocessors);
package body DDS.DomainParticipantFactory is
   use DDS.DomainParticipant_Impl;
   use RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h;
   use RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_impl_h;
   use DDS.DomainParticipant;

   type DDS_StringSeq_Access is access all RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_StringSeq;
   function convert is new Ada.Unchecked_Conversion (DDS.String_Seq.Sequence, RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_StringSeq);
   function convert is new Ada.Unchecked_Conversion (DDS_StringSeq_Access, DDS.String_Seq.Sequence_Access);

   TheParticipantFactory : Ref_Access;

   TheParticipantFactoryImpl : aliased Ref;
   Tasking_IF                : aliased DDS_DomainParticipantFactoryThreadListenerI;
   Finalize_Listener         : aliased DDS_DomainParticipantFactoryFinalizeListenerI;


   procedure On_Thread_Started_Callback (OnStartedParam : System.Address;
                                         Worker         : access RTIDDS.Low_Level.ndds_reda_reda_worker_impl_h.REDAWorker) is
      pragma Unreferenced (OnStartedParam, Worker);
      Dummy : System.Address;
      pragma Unreferenced (Dummy);
   begin
      Dummy := GNAT.Threads.Register_Thread;
   end On_Thread_Started_Callback;

   procedure On_Thread_Stopped_Callback (OnStartedParam : System.Address;
                                         Worker         : access RTIDDS.Low_Level.ndds_reda_reda_worker_impl_h.REDAWorker) is
      pragma Unreferenced (OnStartedParam, Worker);
   begin
      GNAT.Threads.Unregister_Thread;
   end On_Thread_Stopped_Callback;

   protected body Initializeer is
      procedure Initialize is
      begin
         if TheParticipantFactory = null then
            --  since this procedure just after loading libraries, check here the
            --  version of the Ada Binding and the DDS library used.
            --  DDS.Validate_Library;

            --  Set thread listener callbacks
            Tasking_IF.OnStarted := On_Thread_Started_Callback'Access;
            Tasking_IF.OnStopped := On_Thread_Stopped_Callback'Access;

            --  Get C Factory
            TheParticipantFactoryImpl.SetInterface
              (RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h.DDS_DomainParticipantFactory_Get_Instance);
            TheParticipantFactory := TheParticipantFactoryImpl'Access;
            Initialize (PARTICIPANT_QOS_DEFAULT);
            --  Set Default Participant QoS
            Ret_Code_To_Exception
              (DDS_DomainParticipantFactory_Get_Default_Participant_Qos
                 (TheParticipantFactoryImpl.GetInterface,
                  GetInterface (PARTICIPANT_QOS_DEFAULT)));

            --  Set thread listener
            DDS_DomainParticipantFactory_Set_Thread_ListenerI
              (RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h.DDS_DomainParticipantFactory_Get_Instance,
               Tasking_IF'Access);

            --  Set Finalize listener callbacks
            Finalize_Listener.OnBeforeTopicFinalizeFnc := DDS.Topic_Impl.Finalize_Callback'Access;
            Finalize_Listener.OnBeforeContentFilteredTopicFinalizeFnc := DDS.ContentFilteredTopic_Impl.Finalize_Callback'Access;
            Finalize_Listener.OnBeforeFlowControllerFinalizeFnc := null;
            Finalize_Listener.OnBeforePublisherFinalizeFnc := DDS.Publisher_Impl.Finalize_Callback'Access;
            Finalize_Listener.OnBeforeSubscriberFinalizeFnc := DDS.Subscriber_Impl.Finalize_Callback'Access;
            Finalize_Listener.OnBeforeDataReaderFinalizeFnc := DDS.DataReader_Impl.Finalize_Callback'Access;
            Finalize_Listener.OnBeforeDataWriterFinalizeFnc := DDS.DataWriter_Impl.Finalize_Callback'Access;
            Finalize_Listener.OnBeforeReadConditionFinalizeFnc := DDS.ReadCondition_Impl.Finalize_Callback'Access;
            DDS_DomainParticipantFactory_Set_Finalize_ListenerI (TheParticipantFactoryImpl.GetInterface, Finalize_Listener'Access);
         end if;
      end Initialize;
   end Initializeer;
   function Get_Instance return Ref_Access is
   begin
      if TheParticipantFactory = null then
         Initializeer.Initialize;
         return TheParticipantFactory;
      else
         return TheParticipantFactory;
      end if;
   end Get_Instance;

   ------------------------
   -- Create_Participant --
   ------------------------

   function Create_Participant
     (Self       : not null access Ref;
      Domain_Id  : in DDS.DomainId_T := Default_Domain;
      Qos        : in DDS.DomainParticipantQos := PARTICIPANT_QOS_DEFAULT;
      A_Listener : in DDS.DomainParticipantListener.Ref_Access := null;
      Mask       : in DDS.StatusMask := DDS.STATUS_MASK_NONE)
      return DDS.DomainParticipant.Ref_Access is
   begin
      return (DDS.DomainParticipant_Impl.CreateI (Self,
        Domain_Id,
        Qos,
        A_Listener,
        Mask));
   end Create_Participant;

   function Create_Participant_With_Profile
     (Self         : not null access Ref;
      Domain_Id    : in DDS.DomainId_T := Default_Domain;
      library_name : in DDS.String;
      profile_name : in DDS.String;
      A_Listener   : in DDS.DomainParticipantListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := DDS.STATUS_MASK_NONE)
      return DDS.DomainParticipant.Ref_Access is
   begin
      return (DDS.DomainParticipant_Impl.CreateI (Self,
        Domain_Id,
        library_name,
        profile_name,
        A_Listener,
        Mask));
   end Create_Participant_With_Profile;

   function Create_Participant_With_Profile
     (Self         : not null access Ref;
      Domain_Id    : in DDS.DomainId_T := Default_Domain;
      library_name : in Standard.String;
      profile_name : in Standard.String;
      A_Listener   : in DDS.DomainParticipantListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := DDS.STATUS_MASK_NONE)
      return DDS.DomainParticipant.Ref_Access is
      l   : DDS.String := To_DDS_String (library_name);
      p   : DDS.String := To_DDS_String (profile_Name);
      ret : DDS.DomainParticipant.Ref_Access;
   begin
      ret := DDS.DomainParticipant_Impl.CreateI (Self,
                                                 Domain_Id,
                                                 l,
                                                 p,
                                                 A_Listener,
                                                 Mask);
      Finalize (l);
      Finalize (p);
      return ret;
   end Create_Participant_With_Profile;


      function  Get_Or_Create_Participant
     (Self       : not null access Ref;
      Domain_Id  : in DDS.DomainId_T := Default_Domain;
      Qos        : in DDS.DomainParticipantQos := DDS.DomainParticipantFactory.PARTICIPANT_QOS_DEFAULT;
      A_Listener : in DDS.DomainParticipantListener.Ref_Access := null;
      Mask       : in DDS.StatusMask := STATUS_MASK_NONE)return  DDS.DomainParticipant.Ref_Access is
      Ret : DDS.DomainParticipant.Ref_Access;
   begin
      Ret := Self.Lookup_Participant (Domain_Id);
      if Ret = null then
         Ret := Self.Create_Participant (Domain_Id => Domain_Id , Qos => Qos , A_Listener => A_Listener , Mask => Mask);
      end if;
      return Ret;
   end;

   function  Get_Or_Create_Participant_With_Profile
     (Self         : not null access Ref;
      Domain_Id    : in DDS.DomainId_T := Default_Domain;
      Library_Name : in DDS.String;
      Profile_Name : in DDS.String;
      A_Listener   : in DDS.DomainParticipantListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE) return  DDS.DomainParticipant.Ref_Access is
      Ret : DDS.DomainParticipant.Ref_Access;
   begin
      Ret := Self.Lookup_Participant (Domain_Id);
      if Ret = null then
         ret := Self.Create_Participant_With_Profile
           (Domain_Id    => Domain_Id ,
            Library_Name => Library_Name,
            Profile_Name => Profile_Name ,
            A_Listener   => A_Listener,
            Mask         => Mask);
      end if;
      return Ret;
   end;

   ------------------------
   -- Delete_Participant --
   ------------------------

   procedure Delete_Participant
     (Self          : not null access Ref;
      A_Participant : in out DDS.DomainParticipant.Ref_Access)
   is
      P   : DDS.DomainParticipant_Impl.Ref_Access :=
              DDS.DomainParticipant_Impl.Ref_Access (A_Participant);
      C_P : System.Address;
   begin
      if P /= null then
         C_P := P.GetInterface;

         if C_P /= System.Null_Address then
            Ret_Code_To_Exception (DDS_DomainParticipant_disableI (C_P));
            P.Delete_Implicit_EntitiesI;
            Ret_Code_To_Exception (DDS_DomainParticipantFactory_delete_participant (Self.GetInterface, C_P),
                                   "Unable to delete participant");
            DomainParticipant_Impl.Free (P);
            P := null;
         end if;
      end if;
   end Delete_Participant;

   ------------------------
   -- Lookup_Participant --
   ------------------------

   function Lookup_Participant
     (Self      : not null access Ref;
      Domain_Id : in DDS.DomainId_T)
      return DDS.DomainParticipant.Ref_Access
   is

      C_Participant : constant System.Address := DDS_DomainParticipantFactory_lookup_participant
        (Self.GetInterface, DDS_DomainId_t (Domain_Id));
   begin
      if C_Participant /= System.Null_Address then
         return DDS.DomainParticipant.Ref_Access
           (DDS.DomainParticipant_Impl.Get_FacadeI (C_Participant));
      end if;
      return null;
   end Lookup_Participant;

   ---------------------------------
   -- Set_Default_Participant_Qos --
   ---------------------------------

   procedure Set_Default_Participant_Qos
     (Self : not null access Ref;
      Qos  : in DDS.DomainParticipantQos)
   is
      qos_Access : access DDS_DomainParticipantQos;
   begin
      if Qos'Address = PARTICIPANT_QOS_DEFAULT'Address then
         qos_Access := DDS_PARTICIPANT_QOS_DEFAULT'Unrestricted_Access;
      else
         qos_Access := GetInterface (Qos);
      end if;
      Ret_Code_To_Exception
        (DDS_DomainParticipantFactory_set_default_participant_qos
           (GetInterface (Self), qos_Access));
   end Set_Default_Participant_Qos;

   ----------------------------------------------
   -- Set_Default_Participant_Qos_with_profile --
   ----------------------------------------------

   procedure Set_Default_Participant_Qos_with_Profile
     (Self         : not null access Ref;
      libraryName  : in DDS.String;
      profile_name : in DDS.String)
   is
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipantFactory_set_default_participant_qos_with_profile
           (GetInterface (Self),
            GetInterface (libraryName).all,
            GetInterface (profile_name).all));
   end Set_Default_Participant_Qos_with_Profile;

   ---------------------------------
   -- Get_Default_Participant_Qos --
   ---------------------------------

   procedure Get_Default_Participant_Qos
     (Self    : not null access Ref;
      Qos     : in out DDS.DomainParticipantQos)
   is
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipantFactory_get_default_participant_qos
           (GetInterface (Self), GetInterface (Qos)));

   end Get_Default_Participant_Qos;

   -------------
   -- Set_Qos --
   -------------

   procedure Set_Qos
     (Self : not null access Ref;
      Qos  : in DDS.DomainParticipantFactoryQos) is
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipantFactory_set_qos
           (Self.GetInterface, GetInterface (Qos)));
   end Set_Qos;

   -------------------
   -- Load_Profiles --
   -------------------

   procedure Load_Profiles
     (Self          : not null access Ref)
   is
   begin
      Ret_Code_To_Exception (DDS_DomainParticipantFactory_load_profiles (self.GetInterface));
   end Load_Profiles;

   ---------------------
   -- Reload_Profiles --
   ---------------------

   procedure Reload_Profiles
     (Self          : not null access Ref)
   is
   begin
      Ret_Code_To_Exception (DDS_DomainParticipantFactory_reload_profiles (self.GetInterface));
   end Reload_Profiles;

   ---------------------
   -- Unload_Profiles --
   ---------------------

   procedure Unload_Profiles
     (Self          : not null access Ref)
   is
   begin
      Ret_Code_To_Exception (DDS_DomainParticipantFactory_unload_profiles (self.GetInterface));
   end Unload_Profiles;

   -------------------------
   -- Set_Default_Profile --
   -------------------------

   procedure Set_Default_Profile
     (Self          : not null access Ref;
      library_name  : DDS.String;
      profile_name  : DDS.String)
   is

   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipantFactory_set_default_profile (self.GetInterface, GetInterface (library_name), GetInterface (profile_name)));
   end Set_Default_Profile;

   -------------------------
   -- set_default_library --
   -------------------------

   procedure set_default_library
     (Self           : not null access Ref;
      library_name   : DDS.String)
   is
   begin
      Ret_Code_To_Exception (
        DDS_DomainParticipantFactory_set_default_library (
          Self.GetInterface, GetInterface (library_name)));
   end set_default_library;

   -------------------------
   -- get_default_library --
   -------------------------

   function get_default_library
     (Self          : not null access Ref)
      return DDS.String
   is
   begin
      return ret : dds.String do
         copy (ret, DDS_DomainParticipantFactory_get_default_library (self.GetInterface));
      end return;
   end get_default_library;

   -------------------------
   -- get_default_Profile --
   -------------------------

   function get_default_Profile
     (Self          : not null access Ref)
      return DDS.String
   is
   begin
      return ret : dds.String do
         Copy (ret, DDS_DomainParticipantFactory_get_default_profile (self.GetInterface));
      end return;
   end get_default_Profile;

   ---------------------------------
   -- get_default_profile_library --
   ---------------------------------

   function get_default_profile_library
     (Self          : not null access Ref)
      return DDS.String
   is
   begin
      return ret : dds.String do
         Copy (ret, DDS_DomainParticipantFactory_get_default_profile_library (self.GetInterface));
      end return;
   end get_default_profile_library;

   -------------------------------
   -- get_qos_profile_libraries --
   -------------------------------

   procedure get_qos_profile_libraries
     (Self   : not null access Ref;
      libSeq : not null access DDS.String_Seq.Sequence)
   is
      C_LibSeq : aliased RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_StringSeq;
   begin
      C_LibSeq := convert (libSeq.all);
      Ret_Code_To_Exception
        (DDS_DomainParticipantFactory_get_qos_profile_libraries
           (Self.GetInterface, C_LibSeq'Access));
      DDS.String_Seq.Copy (libSeq, convert (C_LibSeq'Unrestricted_Access));
   end get_qos_profile_libraries;

   function Get_Qos_Profile_Libraries
     (Self   : not null access Ref) return DDS.String_Seq.Sequence is
   begin
      return LibSeq : DDS.String_Seq.Sequence do
         Self.Get_Qos_Profile_Libraries (LibSeq'Unrestricted_Access);
      end return;
   end Get_Qos_Profile_Libraries;

   ----------------------
   -- get_qos_profiles --
   ----------------------

   procedure get_qos_profiles
     (Self    : not null access Ref;
      profSeq : not null access DDS.String_Seq.Sequence;
      libName : in DDS.String)
   is
      C_ProfSeq : aliased RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_StringSeq;
   begin
      C_ProfSeq := convert (profSeq.all);
      Ret_Code_To_Exception
        (DDS_DomainParticipantFactory_get_qos_profiles
           (Self.GetInterface, C_ProfSeq'Access, GetInterface (libName)));
      DDS.String_Seq.Copy (profSeq, convert (C_ProfSeq'Unrestricted_Access));
   end get_qos_profiles;

   function Get_Qos_Profiles
     (Self    : not null access Ref;
      LibName : in DDS.String) return DDS.String_Seq.Sequence is
   begin
      return LibSeq : DDS.String_Seq.Sequence do
         Self.Get_Qos_Profiles (LibSeq'Unrestricted_Access, libName);
      end return;
   end Get_Qos_Profiles;

   --------------------------
   -- get_qos_from_profile --
   --------------------------

   procedure get_participant_qos_from_profile
     (Self          : not null access Ref;
      QoS           : in out DDS.DomainParticipantQos;
      library_name  : DDS.String;
      profile_name  : DDS.String) is
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipantFactory_get_participant_qos_from_profile
           (self.GetInterface, GetInterface (QoS), GetInterface (library_name), GetInterface (profile_name)));
   end get_participant_qos_from_profile;

   --------------------------
   -- get_qos_from_profile --
   --------------------------

   procedure get_publisher_qos_from_profile
     (Self          : not null access Ref;
      QoS           : in out DDS.PublisherQos;
      library_name  : DDS.String;
      profile_name  : DDS.String) is
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipantFactory_get_publisher_qos_from_profile
           (self.GetInterface, GetInterface (QoS), GetInterface (library_name), GetInterface (profile_name)));
   end get_publisher_qos_from_profile;

   --------------------------
   -- get_qos_from_profile --
   --------------------------

   procedure get_subscriber_qos_from_profile
     (Self          : not null access Ref;
      QoS           : in out DDS.SubscriberQos;
      library_name  : DDS.String;
      profile_name  : DDS.String) is
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipantFactory_get_subscriber_qos_from_profile
           (self.GetInterface, GetInterface (QoS), GetInterface (library_name), GetInterface (profile_name)));
   end get_subscriber_qos_from_profile;

   --------------------------
   -- get_qos_from_profile --
   --------------------------

   procedure get_datareader_qos_from_profile
     (Self          : not null access Ref;
      QoS           : in out DDS.DataReaderQos;
      library_name  : DDS.String;
      profile_name  : DDS.String) is
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipantFactory_get_datareader_qos_from_profile
           (self.GetInterface, getInterface (QoS), GetInterface (library_name), GetInterface (profile_name)));
   end get_datareader_qos_from_profile;

   --------------------------
   -- get_qos_from_profile --
   --------------------------

   procedure get_datareader_qos_from_profile_w_topic_name
     (Self          : not null access Ref;
      QoS           : in out DDS.DataReaderQos;
      library_name  : DDS.String;
      profile_name  : DDS.String;
      topic_name    : DDS.String) is
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipantFactory_get_datareader_qos_from_profile_w_topic_name
           (self.GetInterface, GetInterface (QoS),
            GetInterface (library_name),
            GetInterface (profile_name),
            GetInterface (topic_name)));
   end get_datareader_qos_from_profile_w_topic_name;

   --------------------------
   -- get_qos_from_profile --
   --------------------------

   procedure get_datawriter_qos_from_profile
     (Self          : not null access Ref;
      QoS           : in out DDS.DataWriterQos;
      library_name  : DDS.String;
      profile_name  : DDS.String) is
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipantFactory_get_datawriter_qos_from_profile
           (self.GetInterface, GetInterface (QoS), GetInterface (library_name), GetInterface (profile_name)));
   end get_datawriter_qos_from_profile;

   --------------------------
   -- get_qos_from_profile --
   --------------------------

   procedure get_datawriter_qos_from_profile_w_topic_name
     (Self          : not null access Ref;
      QoS           : in out DDS.DataWriterQos;
      library_name  : DDS.String;
      profile_name  : DDS.String;
      topic_name    : DDS.String) is
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipantFactory_get_datawriter_qos_from_profile_w_topic_name
           (self.GetInterface, GetInterface (QoS),
            GetInterface (library_name),
            GetInterface (profile_name),
            GetInterface (topic_name)));
   end get_datawriter_qos_from_profile_w_topic_name;

   --------------------------
   -- get_qos_from_profile --
   --------------------------

   procedure get_topic_qos_from_profile
     (Self          : not null access Ref;
      QoS           : in out DDS.TopicQos;
      library_name  : DDS.String;
      profile_name  : DDS.String) is
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipantFactory_get_topic_qos_from_profile
           (self.GetInterface, GetInterface (QoS),
            GetInterface (library_name),
            GetInterface (profile_name)));
   end get_topic_qos_from_profile;

   --------------------------
   -- get_qos_from_profile --
   --------------------------

   procedure get_topic_qos_from_profile_w_topic_name
     (Self          : not null access Ref;
      QoS           : in out DDS.TopicQos;
      library_name  : DDS.String;
      profile_name  : DDS.String;
      topic_name    : DDS.String) is
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipantFactory_get_topic_qos_from_profile_w_topic_name
           (self.GetInterface, getInterface (QoS),
            GetInterface (library_name),
            GetInterface (profile_name),
            GetInterface (topic_name)));
   end get_topic_qos_from_profile_w_topic_name;

   -------------
   -- Get_Qos --
   -------------
   procedure Get_Qos
     (Self    : not null access Ref;
      Qos     : in out DDS.DomainParticipantFactoryQos) is

   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipantFactory_get_qos
           (Self.GetInterface, GetInterface (qos)));
   end Get_Qos;


   procedure Finalize_Instance (Self    : not null access Ref) is
   begin
      Ret_Code_To_Exception (DDS_DomainParticipantFactory_finalize_instance);
      Self.SetInterface (System.Null_Address);
      TheParticipantFactory := null;
   end Finalize_Instance;

   procedure Unregister_Thread (Self : not null access Ref) is
   begin
      DDS.Ret_Code_To_Exception
        (RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h.DDS_DomainParticipantFactory_unregister_thread
           (Self.GetInterface));
   end Unregister_Thread;

end DDS.DomainParticipantFactory;
