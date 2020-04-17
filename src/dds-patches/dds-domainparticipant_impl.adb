--  (c) Copyright, Real-Time Innovations, $Date:: 2012-02-16 #$
--  All rights reserved.
--
--  No duplications, whole or partial, manual or electronic, may be made
--  without express written permission.  Any such copies, or
--  revisions thereof, must display this notice unaltered.
--  This code contains trade secrets of Real-Time Innovations, Inc.

with Ada.Unchecked_Conversion;

with DDS.Builtin_KeyedOctets_TypeSupport;
with DDS.Builtin_KeyedString_TypeSupport;
with DDS.Builtin_Octets_TypeSupport;
with DDS.Builtin_String_TypeSupport;

with DDS.PublicationBuiltinTopicData_TypeSupport;

with DDS.ContentFilteredTopic_Impl;
with DDS.DomainParticipantListener.Low_Level;
with DDS.DomainparticipantFactory;
with DDS.ParticipantBuiltinTopicData_TypeSupport;
with DDS.Publisher_Impl;
with DDS.Subscriber_Impl;
with DDS.SubscriptionBuiltinTopicData_TypeSupport;
with DDS.TopicBuiltinTopicData_TypeSupport;
with DDS.Topic_Impl;

with RTIDDS.Low_Level.ndds_dds_c_dds_c_flowcontroller_h;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_builtin_h;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_common_h;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_impl_h;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_impl_h;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_publication_h;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_subscription_h;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_topic_h;
with RTIDDS.Low_Level.ndds_pres_pres_participant_h;
with RTIDDS.Low_Level.ndds_pres_pres_common_h;

with System;

with Interfaces.C;
with Ada.Containers.Ordered_Sets;

package body DDS.DomainParticipant_Impl is

   use Interfaces.C;

   use RTIDDS.Low_Level.ndds_dds_c_dds_c_flowcontroller_h;
   use RTIDDS.Low_Level.ndds_dds_c_dds_c_common_h;
   use RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h;
   use RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_impl_h;
   use RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h;
   use RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_impl_h;
   use RTIDDS.Low_Level.ndds_dds_c_dds_c_publication_h;
   use RTIDDS.Low_Level.ndds_dds_c_dds_c_subscription_h;
   use RTIDDS.Low_Level.ndds_dds_c_dds_c_topic_h;
   use RTIDDS.Low_Level.ndds_pres_pres_participant_h;

   use DDS.Topic;
   use DDS.Subscriber;
   use DDS.Publisher;
   use System;
   use DDS.InstanceHandle_Seq;


   type Ref_Access_Access is access all Ref_Access;
   type DDS_InstanceHandleSeq_Access is access all DDS_InstanceHandleSeq;
   function Convert is new Ada.Unchecked_Conversion (System.Address, DDS.DomainParticipantListener.Ref_Access);
   function Convert is new Ada.Unchecked_Conversion (System.Address, Ref_Access_Access);
   function Convert is new Ada.Unchecked_Conversion
     (Sequence_Access, DDS_InstanceHandleSeq_Access);

   function As_Long is new Ada.Unchecked_Conversion (Source => Register_Type_Procedure, Target => Unsigned_Long_Long);
   function "<" (L, R :  Register_Type_Procedure) return Boolean is
     (As_Long (L) < As_Long (R));

   package Register_Sets is new Ada.Containers.Ordered_Sets (Element_Type => Register_Type_Procedure, "<" => "<", "=" => "=");

   --  Allow storage for access type
   Default_Impl_Size      : constant DDS.Long := ((System.Address'Size + 7) / 8);
   --  Always align on 64-bit boundaries
   Default_Impl_Alignment : constant DDS.Long := 8;

   Default_UserObjectSettings : constant UserObjectSettings_T :=
                                  (Size      => Default_Impl_Size,
                                   Alignment => Default_Impl_Alignment);

   Registered_Types : Register_Sets.Set;
   --
   function Create_Publisher
     (Self       : not null access Ref;
      Qos        : in DDS.PublisherQos;
      A_Listener : in DDS.PublisherListener.Ref_Access;
      Mask       : in DDS.StatusMask)
      return DDS.Publisher.Ref_Access is
   begin

      return DDS.Publisher_Impl.CreateI
        (Self.GetInterface,
         Qos,
         A_Listener,
         Mask);

   end Create_Publisher;

   function Create_Publisher_With_Profile
     (Self         : not null access Ref;
      Library_Name : in DDS.String;
      Profile_Name : in DDS.String;
      A_Listener   : in DDS.PublisherListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.Publisher.Ref_Access is
      Qos : DDS.PublisherQos;
      Ret : DDS.Publisher.Ref_Access;
   begin
      Self.Get_Default_Publisher_Qos (Qos);
      DomainParticipantFactory.Get_Instance.Get_Publisher_Qos_From_Profile
        (Qos,
         Library_Name,
         Profile_Name);
      Ret := Self.Create_Publisher (Qos, A_Listener, Mask);
      return Ret;
   end Create_Publisher_With_Profile;
   function Create_Publisher_With_Profile
     (Self         : not null access Ref;
      Library_Name : in Standard.String;
      Profile_Name : in Standard.String;
      A_Listener   : in DDS.PublisherListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.Publisher.Ref_Access is
      Qos : DDS.PublisherQos;
      Ret : DDS.Publisher.Ref_Access;
      L   : DDS.String := To_DDS_String (Library_Name);
      P   : DDS.String := To_DDS_String (Profile_Name);

   begin
      Self.Get_Default_Publisher_Qos (Qos);
      DomainParticipantFactory.Get_Instance.Get_Publisher_Qos_From_Profile
        (Qos,
         L,
         P);
      Ret := Self.Create_Publisher (Qos, A_Listener, Mask);
      Finalize (L);
      Finalize (P);
      return Ret;
   end Create_Publisher_With_Profile;


   ----------------------
   -- Delete_Publisher --
   ----------------------

   procedure Delete_Publisher
     (Self      : not null access Ref;
      Publisher : in out DDS.Publisher.Ref_Access)
   is
      P   : constant DDS.Publisher_Impl.Ref_Access :=
              DDS.Publisher_Impl.Ref_Access (Publisher);
      C_P : System.Address;
      use type DDS.Publisher_Impl.Ref_Access;
   begin
      if P /= null then
         C_P := P.GetInterface;

         if C_P /= System.Null_Address then
            Ret_Code_To_Exception (DDS_DomainParticipant_Delete_Publisher (Self.GetInterface, C_P));
         end if;
      end if;
      Publisher := null;
   end Delete_Publisher;


   -----------------------
   -- Create_Subscriber --
   -----------------------

   function Create_Subscriber
     (Self       : not null access Ref;
      Qos        : in DDS.SubscriberQos;
      A_Listener : in DDS.SubscriberListener.Ref_Access;
      Mask       : in DDS.StatusMask)
      return DDS.Subscriber.Ref_Access
   is
   begin

      return (DDS.Subscriber_Impl.CreateI
              (DomainParticipant.Ref_Access (Self),
                 Qos,
                 A_Listener,
                 Mask));

   end Create_Subscriber;

   function Create_Subscriber_With_Profile
     (Self         : not null access Ref;
      Library_Name : in DDS.String;
      Profile_Name : in DDS.String;
      A_Listener   : in DDS.SubscriberListener.Ref_Access  := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.Subscriber.Ref_Access is
      Qos : DDS.SubscriberQos;
   begin
      Self.Get_Default_Subscriber_Qos (Qos);
      Self.Get_Factory.Get_Subscriber_Qos_From_Profile
        (Qos,
         Library_Name,
         Profile_Name);
      return Self.Create_Subscriber (Qos, A_Listener, Mask);
   end Create_Subscriber_With_Profile;

   function Create_Subscriber_With_Profile
     (Self         : not null access Ref;
      Library_Name : in Standard.String;
      Profile_Name : in Standard.String;
      A_Listener   : in DDS.SubscriberListener.Ref_Access  := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.Subscriber.Ref_Access is
      Qos : DDS.SubscriberQos;
      L   : DDS.String := To_DDS_String (Library_Name);
      P   : DDS.String := To_DDS_String (Profile_Name);
   begin
      Self.Get_Default_Subscriber_Qos (Qos);
      Self.Get_Factory.Get_Subscriber_Qos_From_Profile
        (Qos,
         L,
         P);
      Finalize (L);
      Finalize (P);
      return Self.Create_Subscriber (Qos, A_Listener, Mask);
   end Create_Subscriber_With_Profile;


   -----------------------
   -- Delete_Subscriber --
   -----------------------

   procedure Delete_Subscriber
     (Self       :  not null access Ref;
      Subscriber :  in out DDS.Subscriber.Ref_Access)
   is
      S   : constant DDS.Subscriber_Impl.Ref_Access :=
              DDS.Subscriber_Impl.Ref_Access (Subscriber);
      C_S : System.Address;
      use type DDS.Subscriber_Impl.Ref_Access;
   begin
      if S /= null then
         C_S := S.GetInterface;

         if C_S /= System.Null_Address then
            Ret_Code_To_Exception
              (DDS_DomainParticipant_Delete_Subscriber
                 (Self.GetInterface,
                  C_S));
         end if;
      end if;
      Subscriber := null;
   end Delete_Subscriber;

   -----------------------
   -- Create_DataWriter --
   -----------------------
   function Create_DataWriter
     (Self       : not null access Ref;
      A_Topic    : in DDS.Topic.Ref_Access;
      Qos        : in DDS.DataWriterQos := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
      A_Listener : in DDS.DataWriterListener.Ref_Access := null;
      Mask       : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.DataWriter.Ref_Access is
   begin
      return Self.Get_Implicit_Publisher.Create_DataWriter
        (A_Topic, Qos, A_Listener, Mask);
   end Create_DataWriter;

   -----------------------
   -- Create_DataWriter --
   -----------------------
   function Create_DataWriter_With_Profile
     (Self         : not null access Ref;
      A_Topic      : in DDS.Topic.Ref_Access;
      Library_Name : in DDS.String;
      Profile_Name : in DDS.String;
      A_Listener   : in DDS.DataWriterListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.DataWriter.Ref_Access is
   begin
      return Self.Get_Implicit_Publisher.Create_DataWriter_With_Profile
        (A_Topic, Library_Name, Profile_Name, A_Listener, Mask);
   end Create_DataWriter_With_Profile;

   function Create_DataWriter_With_Profile
     (Self         : not null access Ref;
      A_Topic      : in DDS.Topic.Ref_Access;
      Library_Name : in Standard.String;
      Profile_Name : in Standard.String;
      A_Listener   : in DDS.DataWriterListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.DataWriter.Ref_Access is
   begin
      return Self.Get_Implicit_Publisher.Create_DataWriter_With_Profile
        (A_Topic, Library_Name, Profile_Name, A_Listener, Mask);
   end Create_DataWriter_With_Profile;

   -----------------------
   -- Delete_DataWriter --
   -----------------------
   procedure Delete_DataWriter
     (Self         : not null access Ref;
      A_DataWriter : in out DDS.DataWriter.Ref_Access) is
   begin
      Self.Get_Implicit_Publisher.Delete_DataWriter (A_DataWriter);
   end Delete_DataWriter;


   -----------------------
   -- Create_DataReader --
   -----------------------
   function Create_DataReader
     (Self       : not null access Ref;
      Topic      : not null access DDS.TopicDescription.Ref'Class;
      Qos        : in DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
      A_Listener : in DDS.DataReaderListener.Ref_Access := null;
      Mask       : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.DataReader.Ref_Access is
   begin
      return Self.Get_Implicit_Subscriber.Create_DataReader
        (Topic, Qos, A_Listener, Mask);
   end Create_DataReader;

   -----------------------
   -- Create_DataReader --
   -----------------------
   function Create_DataReader_With_Profile
     (Self         : not null access Ref;
      Topic        : not null access DDS.TopicDescription.Ref'Class;
      Library_Name : in DDS.String;
      Profile_Name : in DDS.String;
      A_Listener   : in DDS.DataReaderListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.DataReader.Ref_Access is
   begin
      return Self.Get_Implicit_Subscriber.Create_DataReader_With_Profile
        (Topic, Library_Name, Profile_Name, A_Listener, Mask);
   end Create_DataReader_With_Profile;
   function Create_DataReader_With_Profile
     (Self         : not null access Ref;
      Topic        : not null access DDS.TopicDescription.Ref'Class;
      Library_Name : in Standard.String;
      Profile_Name : in Standard.String;
      A_Listener   : in DDS.DataReaderListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.DataReader.Ref_Access is
   begin
      return Self.Get_Implicit_Subscriber.Create_DataReader_With_Profile
        (Topic, Library_Name, Profile_Name, A_Listener, Mask);
   end Create_DataReader_With_Profile;

   -----------------------
   -- Delete_DataReader --
   -----------------------
   procedure Delete_DataReader
     (Self         : not null access Ref;
      A_DataReader : in out DDS.DataReader.Ref_Access) is
   begin
      Self.Get_Implicit_Subscriber.Delete_DataReader (A_DataReader);
   end Delete_DataReader;

   ----------------------------
   -- Get_Builtin_Subscriber --
   ----------------------------
   function Get_Builtin_Subscriber
     (Self : not null access Ref)
      return DDS.Subscriber.Ref_Access
   is
      C_Subscriber     : System.Address := System.Null_Address;
      Subscriber       : DDS.Subscriber_Impl.Ref_Access;
      Is_Newly_Created : aliased DDS_Boolean := 0;
      Need_To_Enable   : aliased DDS_Boolean := 0;
      use type DDS.Subscriber_Impl.Ref_Access;
   begin
      --  Get builtin subscriber
      C_Subscriber := DDS_DomainParticipant_Get_Builtin_SubscriberI
        (Self.GetInterface,
         Is_Newly_Created'Access,
         Need_To_Enable'Access,
         1,
         RTIDDS.Low_Level.ndds_pres_pres_common_h.PRES_GROUP_SUFFIX_NORMAL_USER_VIRTUAL_READER_GROUP);

      if C_Subscriber = System.Null_Address then
         return null;
      end if;

      --  If it had just been created in C, then create in Ada
      if Is_Newly_Created = 1 then
         Subscriber := DDS.Subscriber_Impl.Create_WrapperI (C_Subscriber);

         if Subscriber = null then
            return null;
         end if;

         if Need_To_Enable = 1 then
            Subscriber.Enable;
         end if;

         return DDS.Subscriber.Ref_Access (Subscriber);
      else
         --  It already exists in Ada
         return DDS.Subscriber.Ref_Access (DDS.Subscriber_Impl.Get_FacadeI
                                           (C_Subscriber));
      end if;
   end Get_Builtin_Subscriber;

   ----------------------------
   -- Get_Implicit_Publisher --
   ----------------------------
   function Get_Implicit_Publisher
     (Self :  not null access Ref)
      return DDS.Publisher.Ref_Access is
      C_Publisher      : System.Address := System.Null_Address;
      Publisher        : DDS.Publisher_Impl.Ref_Access;
      Is_Newly_Created : aliased DDS_Boolean := 0;
      Need_To_Enable   : aliased DDS_Boolean := 0;
      use type DDS.Publisher_Impl.Ref_Access;
   begin
      --  Get implicit publisher
      C_Publisher := DDS_DomainParticipant_Get_Implicit_PublisherI
        (Self.GetInterface, Is_Newly_Created'Access, Need_To_Enable'Access,
         1);

      if C_Publisher = System.Null_Address then
         return null;
      end if;

      --  If it had just been created in C, then create in Ada
      if Is_Newly_Created = 1 then
         Publisher := DDS.Publisher_Impl.Create_WrapperI (C_Publisher);

         if Publisher = null then
            begin
               DDS.Ret_Code_To_Exception
                 (DDS_DomainParticipant_Delete_Publisher
                    (Self.GetInterface,
                     C_Publisher));
            exception
               when others =>
                  null;
            end;

            return null;
         end if;

         if Need_To_Enable = 1 then
            Publisher.Enable;
         end if;

         return DDS.Publisher.Ref_Access (Publisher);
      else
         --  It already exists in Ada
         return DDS.Publisher.Ref_Access (DDS.Publisher_Impl.Get_FacadeI
                                          (C_Publisher));
      end if;
   end Get_Implicit_Publisher;

   -----------------------------
   -- Get_Implicit_Subscriber --
   -----------------------------
   function Get_Implicit_Subscriber
     (Self :  not null access Ref)
      return DDS.Subscriber.Ref_Access is
      C_Subscriber     : System.Address := System.Null_Address;
      Subscriber       : DDS.Subscriber_Impl.Ref_Access;
      Is_Newly_Created : aliased DDS_Boolean := 0;
      Need_To_Enable   : aliased DDS_Boolean := 0;
      use type DDS.Subscriber_Impl.Ref_Access;
   begin
      --  Get implicit subscriber
      C_Subscriber := DDS_DomainParticipant_Get_Implicit_SubscriberI
        (Self.GetInterface, Is_Newly_Created'Access, Need_To_Enable'Access,
         1);

      if C_Subscriber = System.Null_Address then
         return null;
      end if;

      --  If it had just been created in C, then create in Ada
      if Is_Newly_Created = 1 then
         Subscriber := DDS.Subscriber_Impl.Create_WrapperI (C_Subscriber);

         if Subscriber = null then
            begin
               DDS.Ret_Code_To_Exception
                 (DDS_DomainParticipant_Delete_Subscriber
                    (Self.GetInterface,
                     C_Subscriber));
            exception
               when others =>
                  null;
            end;

            return null;
         end if;

         if Need_To_Enable = 1 then
            Subscriber.Enable;
         end if;

         return DDS.Subscriber.Ref_Access (Subscriber);
      else
         --  It already exists in Ada
         return DDS.Subscriber.Ref_Access (DDS.Subscriber_Impl.Get_FacadeI
                                           (C_Subscriber));
      end if;
   end Get_Implicit_Subscriber;

   ------------------
   -- Create_Topic --
   ------------------

   function Create_Topic
     (Self       : not null access Ref;
      Topic_Name : in DDS.String;
      Type_Name  : in DDS.String;
      Qos        : in DDS.TopicQos;
      A_Listener : in DDS.TopicListener.Ref_Access;
      Mask       : in DDS.StatusMask)
      return DDS.Topic.Ref_Access is
   begin
      return (Topic_Impl.CreateI (DomainParticipant.Ref_Access (Self),
              Topic_Name,
              Type_Name,
              Qos,
              A_Listener,
              Mask));
   end Create_Topic;

   function Create_Topic_With_Profile
     (Self         : not null access Ref;
      Topic_Name   : in DDS.String;
      Type_Name    : in DDS.String;
      Library_Name : in DDS.String;
      Profile_Name : in DDS.String;
      A_Listener   : in DDS.TopicListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.Topic.Ref_Access is
      Qos : DDS.TopicQos;
      Ret : DDS.Topic.Ref_Access;
   begin
      Self.Get_Default_Topic_Qos (Qos);
      DomainParticipantFactory.
        Get_Instance.Get_Topic_Qos_From_Profile_W_Topic_Name
          (Qos,
           Library_Name,
           Profile_Name,
           Topic_Name);
      Ret := Self.Create_Topic (Topic_Name, Type_Name, Qos, A_Listener, Mask);
      return Ret;
   end Create_Topic_With_Profile;
   function Create_Topic_With_Profile
     (Self         : not null access Ref;
      Topic_Name   : in DDS.String;
      Type_Name    : in DDS.String;
      Library_Name : in Standard.String;
      Profile_Name : in Standard.String;
      A_Listener   : in DDS.TopicListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)
      return DDS.Topic.Ref_Access is
      Qos : DDS.TopicQos;
      Ret : DDS.Topic.Ref_Access;
      L   : DDS.String := To_DDS_String (Library_Name);
      P   : DDS.String := To_DDS_String (Profile_Name);

   begin
      Self.Get_Default_Topic_Qos (Qos);
      DomainParticipantFactory.
        Get_Instance.Get_Topic_Qos_From_Profile_W_Topic_Name
          (Qos,
           L,
           P,
           Topic_Name);
      Finalize (L);
      Finalize (P);

      Ret := Self.Create_Topic (Topic_Name, Type_Name, Qos, A_Listener, Mask);
      return Ret;
   end Create_Topic_With_Profile;





   function  Get_Or_Create_Topic
     (Self       : not null access Ref;
      Topic_Name : in DDS.String;
      Type_Name  : in DDS.String;
      Qos        : in DDS.TopicQos := DDS.DomainParticipant.TOPIC_QOS_DEFAULT;
      A_Listener : in DDS.TopicListener.Ref_Access := null;
      Mask       : in DDS.StatusMask := STATUS_MASK_NONE)return  DDS.Topic.Ref_Access is
      use type DDS.TopicDescription.Ref_Access;
      use type DDS.Topic.Ref_Access;
      Temp : DDS.TopicDescription.Ref_Access;

   begin
      return Ret : DDS.Topic.Ref_Access do
         Temp := self.Lookup_Topicdescription (Topic_Name);
         if Temp = null then
            Ret := Self.Create_Topic (Topic_Name, Topic_Name, Qos, A_Listener, Mask);
         else
            Ret := Topic.Narrow (Temp);
         end if;
      end return;
   end;

   function  Get_Or_Create_Topic_With_Profile
     (Self         : not null access Ref;
      Topic_Name   : in DDS.String;
      Type_Name    : in DDS.String;
      Library_Name : in DDS.String;
      Profile_Name : in DDS.String;
      A_Listener   : in DDS.TopicListener.Ref_Access := null;
      Mask         : in DDS.StatusMask := STATUS_MASK_NONE)return  DDS.Topic.Ref_Access is
      use type DDS.TopicDescription.Ref_Access;
      use type DDS.Topic.Ref_Access;
      Temp : DDS.TopicDescription.Ref_Access;

   begin
      return Ret : DDS.Topic.Ref_Access do
         Temp := self.Lookup_Topicdescription (Topic_Name);
         if Temp = null then
            Ret := Self.Create_Topic_With_Profile (Topic_Name, Topic_Name, Library_Name, Profile_Name, A_Listener, Mask);
         else
            Ret := Topic.Narrow (Temp);
         end if;
      end return;
   end;
   ------------------
   -- Delete_Topic --
   ------------------

   procedure Delete_Topic
     (Self    : not null access Ref;
      A_Topic : in out DDS.Topic.Ref_Access)
   is
      T_Impl   : constant DDS.Topic_Impl.Ref_Access := DDS.Topic_Impl.Ref_Access (A_Topic);
      use type DDS.Topic_Impl.Ref_Access;
   begin
      if T_Impl /= null then

         if T_Impl.As_TopicWrapper_I /= null then
            Ret_Code_To_Exception (DDS_DomainParticipant_Delete_Topic (Self.GetInterface, T_Impl.As_TopicWrapper_I));
         end if;
      end if;
      A_Topic := null;
   end Delete_Topic;

   ----------------
   -- Find_Topic --
   ----------------

   function Find_Topic
     (Self       : not null access Ref;
      Topic_Name : in DDS.String;
      Timeout    : in DDS.Duration_T)
      return DDS.Topic.Ref_Access
   is
      C_TopicW  : access RTIDDS.Low_Level.ndds_dds_c_dds_c_topic_h.DDS_Topic;
      Topic     : DDS.Topic_Impl.Ref_Access;
      Timeoutl  : aliased Dds_Duration_T := (Int (Timeout.Sec), Unsigned (Timeout.Nanosec));
      use type DDS.Topic_Impl.Ref_Access;
   begin
      C_TopicW := DDS_DomainParticipant_Find_Topic (Self.GetInterface, GetInterface (Topic_Name).all, Timeoutl'Access);

      if C_TopicW /= null then
         Topic := DDS.Topic_Impl.Create_ReferenceI (C_TopicW);

         if Topic = null then
            return null;
         end if;

         return DDS.Topic.Ref_Access (Topic);
      end if;
      return null;
   end Find_Topic;

   -----------------------------
   -- Lookup_Topicdescription --
   -----------------------------

   function Lookup_Topicdescription
     (Self : not null access Ref;
      Name : in DDS.String)
      return DDS.TopicDescription.Ref_Access
   is
      C_TopicD         : System.Address;
      C_TopicW         : access DDS_Topic;
      CF_TopicW        : access DDS_ContentFilteredTopic;
      Topic            : DDS.Topic_Impl.Ref_Access;
      CFTopic          : DDS.ContentFilteredTopic_Impl.Ref_Access;
      Is_Newly_Created : aliased DDS_Boolean := 0;
      Need_To_Enable   : aliased DDS_Boolean := 0;
      use type DDS.Topic_Impl.Ref_Access;
      use type DDS.ContentFilteredTopic_Impl.Ref_Access;
   begin
      --  Lookup Topic Description, regardless of being user-created or built-in
      C_TopicD := DDS_DomainParticipant_Lookup_TopicdescriptionI
        (Self.GetInterface, Is_Newly_Created'Access, Need_To_Enable'Access,
         1, GetInterface (Name).all);

      if C_TopicD = System.Null_Address then
         return null;
      end if;

      C_TopicW := DDS_Topic_Narrow (C_TopicD);

      --  If it's not a Topic, check for a ContentFilteredTopic
      if C_TopicW = null then
         CF_TopicW := DDS_ContentFilteredTopic_Narrow (C_TopicD);

         CFTopic := DDS.ContentFilteredTopic_Impl.Get_FacadeI (CF_TopicW);

         if CFTopic = null then
            return null;
         end if;

         return DDS.TopicDescription.Ref_Access (CFTopic);
      end if;

      --  If it's a builtin topic and had just been created in C, then create in Ada
      if Is_Newly_Created = 1 then
         Topic := DDS.Topic_Impl.Create_WrapperI (C_TopicW);

         if Topic = null then
            return null;
         end if;

         --  Needs to be enabled?
         if Need_To_Enable = 1 then
            Topic.Enable;
         end if;

         return Topic.As_TopicDescription_I;
      else
         --  It already exists in Ada
         Topic := DDS.Topic_Impl.Get_FacadeI (C_TopicW);

         if Topic = null then
            return null;
         end if;

         return Topic.As_TopicDescription_I;
      end if;
   end Lookup_Topicdescription;

   ---------------------------------
   -- Create_Contentfilteredtopic --
   ---------------------------------

   function Create_Contentfilteredtopic
     (Self              : not null access Ref;
      Name              : in DDS.String;
      Related_Topic     : in DDS.Topic.Ref_Access;
      Filter_Expression : in DDS.String;
      Filter_Parameters : access DDS.String_Seq.Sequence)
      return DDS.ContentFilteredTopic.Ref_Access
   is
   begin
      return DDS.ContentFilteredTopic_Impl.CreateI (Self.GetInterface, Name, Related_Topic,
                                                    Filter_Expression, Filter_Parameters);
   end Create_Contentfilteredtopic;

   ---------------------------------
   -- Delete_Contentfilteredtopic --
   ---------------------------------

   procedure Delete_Contentfilteredtopic
     (Self     : not null access Ref;
      CFTopic  : in out DDS.ContentFilteredTopic.Ref_Access)
   is
      CFT   : ContentFilteredTopic_Impl.Ref_Access := ContentFilteredTopic_Impl.Ref_Access (CFTopic);
      CFT_W : access RTIDDS.Low_Level.ndds_dds_c_dds_c_topic_h.DDS_ContentFilteredTopic;
      use type ContentFilteredTopic_Impl.Ref_Access;
   begin
      if CFT /= null then
         CFT_W := CFT.Get_Native_Wrapper;
         if CFT_W /= null then
            Ret_Code_To_Exception
              (DDS_DomainParticipant_Delete_Contentfilteredtopic
                 (Self.GetInterface, CFT_W));
         end if;
         ContentFilteredTopic_Impl.Free (CFT);
         CFTopic := null;
      end if;
   end Delete_Contentfilteredtopic;

   ---------------------------------
   -- Create_MultiTopic           --
   ---------------------------------
   function Create_MultiTopic
     (Self                    : not null access Ref;
      Name                    : in DDS.String;
      Type_Name               : in DDS.String;
      Subscription_Expression : in DDS.String;
      Expression_Parameters   : access DDS.String_Seq.Sequence)
      return DDS.MultiTopic.Ref_Access
   is
   begin
      raise DDS.UNSUPPORTED;
      return null;
   end Create_MultiTopic;

   ---------------------------------
   -- Delete_MultiTopic           --
   ---------------------------------
   procedure Delete_MultiTopic
     (Self     : not null access Ref;
      MTopic   : in out DDS.MultiTopic.Ref_Access)
   is
   begin
      raise DDS.UNSUPPORTED;
   end Delete_MultiTopic;

   ---------------------------------
   -- Create_FlowController           --
   ---------------------------------
   --     function Create_FlowController
   --       (Self         : not null access Ref;
   --        name         : DDS.String;
   --        prop         : access DDS.FlowControllerProperty_T)
   --        return access DDS.FlowController.Ref'Class
   --     is
   --     begin
   --        return DDS.FlowController_Impl.CreateI (Self, name, FALSE, prop);
   --     end Create_FlowController;

   -------------------------------
   -- Delete_Contained_Entities --
   -------------------------------

   procedure Delete_Contained_Entities
     (Self : not null access Ref)
   is
   begin
      Ret_Code_To_Exception (DDS_DomainParticipant_Delete_Contained_Entities (Self.GetInterface), "Unable to delete entities");
   end Delete_Contained_Entities;

   -------------
   -- Set_Qos --
   -------------

   procedure Set_Qos
     (Self : not null access Ref;
      Qos  : in DDS.DomainParticipantQos)
   is

   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipant_Set_Qos
           (GetInterface (Self), GetInterface (Qos)));
   end Set_Qos;


   procedure Set_Qos_With_Profile
     (Self          : not null access Ref;
      Library_Name  : in String;
      Profile_Name  : in String)
   is
   begin
      Ret_Code_To_Exception (DDS_DomainParticipant_Set_Qos_With_Profile (Self.GetInterface, GetInterface (Library_Name).all, GetInterface (Profile_Name).all));
   end Set_Qos_With_Profile;

   procedure Set_Qos_With_Profile
     (Self          : not null access Ref;
      Library_Name  : in Standard.String;
      Profile_Name  : in Standard.String)
   is
      L   : Interfaces.C.Strings.Chars_Ptr := New_String (Library_Name);
      P   : Interfaces.C.Strings.Chars_Ptr := New_String (Profile_Name);
      Ret : DDS_ReturnCode_T;

   begin
      Ret := DDS_DomainParticipant_Set_Qos_With_Profile (Self.GetInterface, L, P);
      Free (L);
      Free (P);
      Ret_Code_To_Exception  (Ret);
   end Set_Qos_With_Profile;

   -------------
   -- Get_Qos --
   -------------

   procedure Get_Qos
     (Self : not null access Ref;
      Qos  : in out DDS.DomainParticipantQos)
   is

   begin
      Ret_Code_To_Exception (DDS_DomainParticipant_Get_Qos (GetInterface (Self), GetInterface (Qos)));
   end Get_Qos;

   ------------------
   -- Set_Listener --
   ------------------
   procedure Set_Listener
     (Self       : not null access Ref;
      A_Listener : in DDS.DomainParticipantListener.Ref_Access;
      Mask       : in DDS.StatusMask) is
   --  All callbacks initialized in declaration
      C_Listener : aliased RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h.DDS_DomainParticipantListener :=
                     DDS.DomainParticipantListener.Low_Level.DomainParticipantListener_DEFAULT;
      use type DDS.DomainParticipantListener.Ref_Access;
      function Convert is new Ada.Unchecked_Conversion (DDS.DomainParticipantListener.Ref_Access, System.Address);

   begin
      if A_Listener /= null then
         C_Listener.As_Topiclistener.As_Listener.Listener_Data := Convert (A_Listener);
         C_Listener.As_Publisherlistener.As_Datawriterlistener.As_Listener.Listener_Data := Convert (A_Listener);
         C_Listener.As_Subscriberlistener.As_Datareaderlistener.As_Listener.Listener_Data := Convert (A_Listener);

         if Self.GetInterface /= System.Null_Address then
            Ret_Code_To_Exception
              (DDS_DomainParticipant_Set_Listener (Self.GetInterface,
               C_Listener'Unrestricted_Access, DDS_StatusMask (Mask)),
               "Set Listener FAILED");
         end if;
      else
         if Self.GetInterface /= System.Null_Address then
            Ret_Code_To_Exception
              (DDS_DomainParticipant_Set_Listener (Self.GetInterface,
               null, DDS_StatusMask (Mask)),
               "Set Listener FAILED");
         end if;
      end if;
   end Set_Listener;

   ------------------
   -- Get_Listener --
   ------------------

   function Get_Listener
     (Self : not null access Ref)
      return DDS.DomainParticipantListener.Ref_Access is
      C_Listener : DDS_DomainParticipantListener;

   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipant_Get_ListenerX
           (Self.GetInterface,
            C_Listener'Unrestricted_Access));
      return Convert (C_Listener.As_Topiclistener.As_Listener.Listener_Data);
   end Get_Listener;

   ------------------------
   -- Ignore_Participant --
   ------------------------

   procedure Ignore_Participant
     (Self   : not null access Ref;
      Handle : in DDS.InstanceHandle_T)
   is

      Local_Handle : aliased constant DDS_InstanceHandle_T := DDS_InstanceHandle_T (Handle);
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipant_Ignore_Participant
           (Self.GetInterface,
            Local_Handle'Access));
   end Ignore_Participant;

   ------------------
   -- Ignore_Topic --
   ------------------

   procedure Ignore_Topic
     (Self   : not null access Ref;
      Handle : in DDS.InstanceHandle_T)
   is

      Local_Handle : aliased constant DDS_InstanceHandle_T := DDS_InstanceHandle_T (Handle);
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipant_Ignore_Topic
           (Self.GetInterface,
            Local_Handle'Access));
   end Ignore_Topic;

   ------------------------
   -- Ignore_Publication --
   ------------------------

   procedure Ignore_Publication
     (Self   : not null access Ref;
      Handle : in DDS.InstanceHandle_T)
   is

      Local_Handle : aliased constant DDS_InstanceHandle_T := DDS_InstanceHandle_T (Handle);
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipant_Ignore_Publication
           (Self.GetInterface,
            Local_Handle'Access));
   end Ignore_Publication;

   -------------------------
   -- Ignore_Subscription --
   -------------------------

   procedure Ignore_Subscription
     (Self   : not null access Ref;
      Handle : in DDS.InstanceHandle_T)
   is

      Local_Handle : aliased constant DDS_InstanceHandle_T := DDS_InstanceHandle_T (Handle);
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipant_Ignore_Subscription
           (Self.GetInterface,
            Local_Handle'Access));
   end Ignore_Subscription;

   -------------------
   -- Get_Domain_Id --
   -------------------

   function Get_Domain_Id
     (Self : not null access Ref)
      return DDS.DomainId_T
   is
   begin
      return DomainId_T (DDS_DomainParticipant_Get_Domain_Id (Self.GetInterface));
   end Get_Domain_Id;

   function Get_Factory
     (Self :  not null access Ref)
      return not null access DDS.DomainParticipantFactory.Ref is
   begin
      return Self.Factory;
   end Get_Factory;

   -----------------------
   -- Assert_Liveliness --
   -----------------------

   procedure Assert_Liveliness
     (Self : not null access Ref)
   is

   begin
      Ret_Code_To_Exception (DDS_DomainParticipant_Assert_Liveliness (Self.GetInterface));
   end Assert_Liveliness;

   --------------------------------
   -- Set_Default_DataReader_Qos --
   --------------------------------

   procedure Set_Default_DataReader_Qos
     (Self : not null access Ref;
      Qos  : in DDS.DataReaderQoS)
   is
   begin
      Ret_Code_To_Exception (DDS_DomainParticipant_Set_Default_Datareader_Qos (Self.GetInterface, Qos.GetInterface));
   end Set_Default_DataReader_Qos;

   ---------------------------------------------
   -- Set_Default_DataReader_Qos_With_Profile --
   ---------------------------------------------
   procedure Set_Default_DataReader_Qos_With_Profile
     (Self     : not null access Ref;
      LibName  : DDS.String;
      ProfName : DDS.String)
   is
   begin
      Ret_Code_To_Exception (DDS_DomainParticipant_Set_Default_Datareader_Qos_With_Profile (Self.GetInterface, GetInterface (LibName).all, GetInterface (ProfName).all));
   end Set_Default_DataReader_Qos_With_Profile;
   procedure Set_Default_DataReader_Qos_With_Profile
     (Self     : not null access Ref;
      LibName  : Standard.String;
      ProfName : Standard.String)
   is
      L   : Interfaces.C.Strings.Chars_Ptr := New_String (LibName);
      P   : Interfaces.C.Strings.Chars_Ptr := New_String (ProfName);
      Ret : DDS_ReturnCode_T;

   begin
      Ret :=  DDS_DomainParticipant_Set_Default_Datareader_Qos_With_Profile (Self.GetInterface, L, P);
      Free (L);
      Free (P);
      Ret_Code_To_Exception  (Ret);
   end Set_Default_DataReader_Qos_With_Profile;

   --------------------------------
   -- Set_Default_DataWriter_Qos --
   --------------------------------

   procedure Set_Default_DataWriter_Qos
     (Self : not null access Ref;
      Qos  : in DDS.DataWriterQoS)
   is
   begin
      Ret_Code_To_Exception (DDS_DomainParticipant_Set_Default_Datawriter_Qos (Self.GetInterface, Qos.GetInterface));
   end Set_Default_DataWriter_Qos;

   ---------------------------------------------
   -- Set_Default_DataWriter_Qos_With_Profile --
   ---------------------------------------------
   procedure Set_Default_DataWriter_Qos_With_Profile
     (Self     : not null access Ref;
      LibName  : DDS.String;
      ProfName : DDS.String)
   is
   begin
      Ret_Code_To_Exception (DDS_DomainParticipant_Set_Default_Datawriter_Qos_With_Profile
                             (Self.GetInterface,
                                GetInterface (LibName).all,
                                GetInterface (ProfName).all));
   end Set_Default_DataWriter_Qos_With_Profile;

   procedure Set_Default_DataWriter_Qos_With_Profile
     (Self     : not null access Ref;
      LibName  : Standard.String;
      ProfName : Standard.String)
   is
      L   : Interfaces.C.Strings.Chars_Ptr := New_String (LibName);
      P   : Interfaces.C.Strings.Chars_Ptr := New_String (ProfName);
      Ret : DDS_ReturnCode_T;
   begin
      Ret := DDS_DomainParticipant_Set_Default_Datawriter_Qos_With_Profile (Self.GetInterface, L, P);
      Free (L);
      Free (P);
      Ret_Code_To_Exception  (Ret);
   end Set_Default_DataWriter_Qos_With_Profile;

   -------------------------------
   -- Set_Default_Publisher_Qos --
   -------------------------------

   procedure Set_Default_Publisher_Qos
     (Self : not null access Ref;
      Qos  : in DDS.PublisherQos)
   is
      Qos_Address : access DDS_PublisherQos;
   begin
      if Qos'Address = DDS.DomainParticipant.PUBLISHER_QOS_DEFAULT'Address then
         Qos_Address := DDS_PUBLISHER_QOS_DEFAULT'Unrestricted_Access;
      else
         Qos_Address := GetInterface (Qos);
      end if;
      Ret_Code_To_Exception
        (DDS_DomainParticipant_Set_Default_Publisher_Qos
           (Self.GetInterface, Qos_Address));
   end Set_Default_Publisher_Qos;

   --------------------------------------------
   -- Set_Default_Publisher_Qos_With_Profile --
   --------------------------------------------
   procedure Set_Default_Publisher_Qos_With_Profile
     (Self     : not null access Ref;
      LibName  : DDS.String;
      ProfName : DDS.String)
   is
   begin
      Ret_Code_To_Exception (DDS_DomainParticipant_Set_Default_Publisher_Qos_With_Profile
                             (Self.GetInterface,
                                GetInterface (LibName),
                                GetInterface (ProfName)));
   end Set_Default_Publisher_Qos_With_Profile;

   procedure Set_Default_Publisher_Qos_With_Profile
     (Self     : not null access Ref;
      LibName  : Standard.String;
      ProfName : Standard.String)
   is
      L   : Interfaces.C.Strings.Chars_Ptr := New_String (LibName);
      P   : Interfaces.C.Strings.Chars_Ptr := New_String (ProfName);
      Ret : DDS_ReturnCode_T;
   begin
      Ret :=  DDS_DomainParticipant_Set_Default_Publisher_Qos_With_Profile (Self.GetInterface, L, P);
      Free (L);
      Free (P);
      Ret_Code_To_Exception  (Ret);
   end Set_Default_Publisher_Qos_With_Profile;

   -------------------------------
   -- Get_Default_Publisher_Qos --
   -------------------------------

   procedure Get_Default_Publisher_Qos
     (Self    : not null access Ref;
      Qos     : in out DDS.PublisherQos)
   is
   begin
      Ret_Code_To_Exception (DDS_DomainParticipant_Get_Default_Publisher_Qos (Self.GetInterface, GetInterface (Qos)));
   end Get_Default_Publisher_Qos;

   --------------------------------
   -- Set_Default_Subscriber_Qos --
   --------------------------------

   procedure Set_Default_Subscriber_Qos
     (Self : not null access Ref;
      Qos  : in DDS.SubscriberQos)
   is
      Qos_Access : access DDS_SubscriberQos;
   begin
      if Qos'Address = DDS.DomainParticipant.SUBSCRIBER_QOS_DEFAULT'Address then
         Qos_Access := DDS_SUBSCRIBER_QOS_DEFAULT'Unrestricted_Access;
      else
         Qos_Access := GetInterface (Qos);
      end if;
      Ret_Code_To_Exception
        (DDS_DomainParticipant_Set_Default_Subscriber_Qos
           (Self.GetInterface, Qos_Access));
   end Set_Default_Subscriber_Qos;

   ---------------------------------------------
   -- Set_Default_Subscriber_Qos_With_Profile --
   ---------------------------------------------
   procedure Set_Default_Subscriber_Qos_With_Profile
     (Self        : not null access Ref;
      LibraryName : DDS.String;
      ProfileName : DDS.String)
   is
   begin
      Ret_Code_To_Exception (DDS_DomainParticipant_Set_Default_Subscriber_Qos_With_Profile
                             (Self.GetInterface,
                                GetInterface (LibraryName),
                                GetInterface (ProfileName)));
   end Set_Default_Subscriber_Qos_With_Profile;
   procedure Set_Default_Subscriber_Qos_With_Profile
     (Self        : not null access Ref;
      LibraryName : Standard.String;
      ProfileName : Standard.String)
   is
      L   : Interfaces.C.Strings.Chars_Ptr := New_String (LibraryName);
      P   : Interfaces.C.Strings.Chars_Ptr := New_String (ProfileName);
      Ret : DDS_ReturnCode_T;
   begin
      Ret :=  DDS_DomainParticipant_Set_Default_Subscriber_Qos_With_Profile (Self.GetInterface, L, P);
      Free (L);
      Free (P);
      Ret_Code_To_Exception  (Ret);
   end Set_Default_Subscriber_Qos_With_Profile;

   --------------------------------
   -- Get_Default_Subscriber_Qos --
   --------------------------------

   procedure Get_Default_Subscriber_Qos
     (Self    : not null access Ref;
      Qos     : in out DDS.SubscriberQos)
   is
   begin
      Ret_Code_To_Exception (DDS_DomainParticipant_Get_Default_Subscriber_Qos (Self.GetInterface, GetInterface (Qos)));
   end Get_Default_Subscriber_Qos;

   --------------------------------
   -- Get_Default_DataReader_Qos --
   --------------------------------

   procedure Get_Default_DataReader_Qos
     (Self : not null access Ref;
      Qos  : in out DDS.DataReaderQoS)
   is
   begin
      Ret_Code_To_Exception (DDS_DomainParticipant_Get_Default_Datareader_Qos (Self.GetInterface, GetInterface (Qos)));
   end Get_Default_DataReader_Qos;

   --------------------------------
   -- Get_Default_DataReader_Qos --
   --------------------------------

   procedure Get_Default_DataWriter_Qos
     (Self : not null access Ref;
      Qos  : in out DDS.DataWriterQos)
   is
   begin
      Ret_Code_To_Exception (DDS_DomainParticipant_Get_Default_Datawriter_Qos (Self.GetInterface, GetInterface (Qos)));
   end Get_Default_DataWriter_Qos;

   ---------------------------
   -- Set_Default_Topic_Qos --
   ---------------------------

   procedure Set_Default_Topic_Qos
     (Self : not null access Ref;
      Qos  : in DDS.TopicQos)
   is
      Qos_Access : access DDS_TopicQos;
   begin
      if Qos'Address = DDS.DomainParticipant.TOPIC_QOS_DEFAULT'Address then
         Qos_Access := DDS_TOPIC_QOS_DEFAULT'Unrestricted_Access;
      else
         Qos_Access := GetInterface (Qos);
      end if;
      Ret_Code_To_Exception
        (DDS_DomainParticipant_Set_Default_Topic_Qos
           (Self.GetInterface, Qos_Access));
   end Set_Default_Topic_Qos;

   ----------------------------------------
   -- Set_Default_Topic_Qos_With_Profile --
   ----------------------------------------
   procedure Set_Default_Topic_Qos_With_Profile
     (Self        : not null access Ref;
      LibraryName : DDS.String;
      ProfileName : DDS.String)
   is
   begin
      Ret_Code_To_Exception (DDS_DomainParticipant_Set_Default_Topic_Qos_With_Profile
                             (Self.GetInterface,
                                GetInterface (LibraryName),
                                GetInterface (ProfileName)));
   end Set_Default_Topic_Qos_With_Profile;
   procedure Set_Default_Topic_Qos_With_Profile
     (Self        : not null access Ref;
      LibraryName : Standard.String;
      ProfileName : Standard.String)
   is
      L   : Interfaces.C.Strings.Chars_Ptr := New_String (LibraryName);
      P   : Interfaces.C.Strings.Chars_Ptr := New_String (ProfileName);
      Ret : DDS_ReturnCode_T;
   begin
      Ret :=  DDS_DomainParticipant_Set_Default_Topic_Qos_With_Profile (Self.GetInterface, L, P);
      Free (L);
      Free (P);
      Ret_Code_To_Exception  (Ret);
   end Set_Default_Topic_Qos_With_Profile;

   ---------------------------
   -- Get_Default_Topic_Qos --
   ---------------------------
   procedure Get_Default_Topic_Qos
     (Self    : not null access Ref;
      Qos     : in out DDS.TopicQos)
   is
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipant_Get_Default_Topic_Qos
           (Self.GetInterface, GetInterface (Qos)));
   end Get_Default_Topic_Qos;

   -------------------------
   -- Set_Default_Profile --
   -------------------------
   procedure Set_Default_Profile
     (Self          : not null access Ref;
      Library_Name  : DDS.String;
      Profile_Name  : DDS.String)
   is
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipant_Set_Default_Profile
           (Self.GetInterface, GetInterface (Library_Name), GetInterface (Profile_Name)));
   end Set_Default_Profile;

   -------------------------
   -- Set_Default_Library --
   -------------------------
   procedure Set_Default_Library
     (Self           : not null access Ref;
      Library_Name   : DDS.String)
   is
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipant_Set_Default_Library
           (Self.GetInterface, GetInterface (Library_Name)));
   end Set_Default_Library;

   -------------------------
   -- Get_Default_Library --
   -------------------------
   function Get_Default_Library
     (Self : not null access Ref)
      return DDS.String
   is
   begin
      return Ret : Dds.String do
         Copy (Ret, DDS_DomainParticipant_Get_Default_Library
              (Self.GetInterface));
      end return;
   end Get_Default_Library;

   -------------------------
   -- Get_Default_Profile --
   -------------------------
   function Get_Default_Profile
     (Self : not null access Ref)
      return DDS.String
   is
   begin
      return Ret : Dds.String do
         Copy (Ret, DDS_DomainParticipant_Get_Default_Profile
           (Self.GetInterface));
      end return;
   end Get_Default_Profile;

   ---------------------------------
   -- Get_Default_Profile_Library --
   ---------------------------------
   function Get_Default_Profile_Library
     (Self : not null access Ref)
      return DDS.String
   is
   begin
      return Ret : Dds.String do
         Copy (Ret, DDS_DomainParticipant_Get_Default_Profile_Library
           (Self.GetInterface));
      end return;
   end Get_Default_Profile_Library;

   -----------------------------------------
   -- Get_Default_Flowcontroller_Property --
   -----------------------------------------
   procedure Get_Default_Flowcontroller_Property
     (Self     : not null access Ref;
      Property : in out DDS.FlowControllerProperty_T)
   is
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipant_Get_Default_Flowcontroller_Property
           (Self.GetInterface, GetInterface (Property)));
   end Get_Default_Flowcontroller_Property;

   -----------------------------------------
   -- Set_Default_Flowcontroller_Property --
   -----------------------------------------
   procedure Set_Default_Flowcontroller_Property
     (Self     : not null access Ref;
      Property : in DDS.FlowControllerProperty_T)
   is
      Fcp_Access : access DDS_FlowControllerProperty_T;
   begin
      if Property'Address = DDS.DomainParticipant.FLOW_CONTROLLER_PROPERTY_DEFAULT'Address then
         Fcp_Access := DDS_FLOW_CONTROLLER_PROPERTY_DEFAULT'Unrestricted_Access;
      else
         Fcp_Access := GetInterface (Property);
      end if;
      Ret_Code_To_Exception
        (DDS_DomainParticipant_Set_Default_Flowcontroller_Property
           (Self.GetInterface, Fcp_Access));
   end Set_Default_Flowcontroller_Property;

   ---------------------------------
   -- Get_Discovered_Participants --
   ---------------------------------
   function Get_Discovered_Participants
     (Self                :  access Ref)
      return DDS.InstanceHandle_Seq.Sequence
   is

      Arg : DDS_InstanceHandleSeq_Access;
   begin
      return Ret : DDS.InstanceHandle_Seq.Sequence do
         DDS.InstanceHandle_Seq.Initialize (Ret'Unrestricted_Access);
         Arg := Convert (Ret'Unrestricted_Access);
         Ret_Code_To_Exception
           (DDS_DomainParticipant_Get_Discovered_Participants
              (Self.GetInterface, Arg));
      end return;
   end Get_Discovered_Participants;

   -------------------------------------
   -- Get_Discovered_Participant_Data --
   -------------------------------------

   function Get_Discovered_Participant_Data
     (Self               : not null access Ref;
      Participant_Handle : in DDS.InstanceHandle_T)
      return DDS.ParticipantBuiltinTopicData
   is
      type DDS_ParticipantBuiltinTopicData_Access is access all RTIDDS.Low_Level.ndds_dds_c_dds_c_builtin_h.DDS_ParticipantBuiltinTopicData;
      function Convert is new Ada.Unchecked_Conversion (DDS.ParticipantBuiltinTopicData_Access, DDS_ParticipantBuiltinTopicData_Access);
   begin
      return Ret : DDS.ParticipantBuiltinTopicData do
         initialize (Ret);
         Ret_Code_To_Exception
           (DDS_DomainParticipant_Get_Discovered_Participant_Data
              (Self.GetInterface,
               Convert (Ret'Unrestricted_Access),
               PRESInstanceHandle (Participant_Handle)'Unrestricted_Access));
      end return;
   end Get_Discovered_Participant_Data;

   ---------------------------
   -- Get_Discovered_Topics --
   ---------------------------

   function Get_Discovered_Topics
     (Self :  access Ref)
      return DDS.InstanceHandle_Seq.Sequence
   is

      Arg : DDS_InstanceHandleSeq_Access;
   begin
      return Ret : DDS.InstanceHandle_Seq.Sequence do
         Arg := Convert (Ret'Unrestricted_Access);
         Ret_Code_To_Exception
           (DDS_DomainParticipant_Get_Discovered_Topics
              (Self.GetInterface,
               Arg));
      end return;
   end Get_Discovered_Topics;

   -------------------------------
   -- Get_Discovered_Topic_Data --
   -------------------------------

   function Get_Discovered_Topic_Data
     (Self         : not null access Ref;
      Topic_Handle : in DDS.InstanceHandle_T)
      return DDS.TopicBuiltinTopicData
   is
   begin
      return Ret : DDS.TopicBuiltinTopicData do
         Self.Get_Discovered_Topic_Data (Topic_Handle, Ret'Unrestricted_Access);
      end return;
   end Get_Discovered_Topic_Data;

   procedure Get_Discovered_Topic_Data
     (Self         : not null access Ref;
      Topic_Handle : in DDS.InstanceHandle_T;
      Data         : access DDS.TopicBuiltinTopicData) is
      type TopicBuiltinTopicData_Access is access all DDS.TopicBuiltinTopicData;
      type DDS_TopicBuiltinTopicData_Access is access all RTIDDS.Low_Level.ndds_dds_c_dds_c_builtin_h.DDS_TopicBuiltinTopicData;
      function Convert is new Ada.Unchecked_Conversion (TopicBuiltinTopicData_Access, DDS_TopicBuiltinTopicData_Access);
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipant_Get_Discovered_Topic_Data
           (Self.GetInterface,
            Convert (TopicBuiltinTopicData_Access (Data)),
            DDS_InstanceHandle_T (Topic_Handle)'Unrestricted_Access));
   end Get_Discovered_Topic_Data;

   ---------------------
   -- Contains_Entity --
   ---------------------

   function Contains_Entity
     (Self     : not null access Ref;
      A_Handle : in DDS.InstanceHandle_T)
      return Boolean
   is

   begin
      return DDS_DomainParticipant_Contains_Entity
        (Self.GetInterface,
         DDS_InstanceHandle_T (A_Handle)'Unrestricted_Access) /= 0;
   end Contains_Entity;

   --------------------
   -- Get_Publishers --
   --------------------

   procedure Get_Publishers
     (Self       : not null access Ref;
      Publishers : access DDS.PublisherSeq.Sequence)
   is
      CPubs         : aliased DDS_PublisherSeq;
      Max_Length    : DDS_Long;
      New_Max       : DDS_Long;
      PublishersMax : Natural;
      Index         : Natural;
      CPublisher    : DDS_Publisher_Ptr;
      AdaPublisher  : DDS.Publisher.Ref_Access;
   begin
      if DDS_PublisherSeq_Initialize (CPubs'Address) = 0 then
         raise DDS.ERROR with "initialize";
      end if;
      Max_Length := DDS_PublisherSeq_Get_Maximum (CPubs'Address);

      DDS.Ret_Code_To_Exception
        (DDS_DomainParticipant_Lock_All_GroupsI
           (Self.GetInterface, DDS_GROUP_PUBLISHER_I), "Lock");

      if DDS_PublisherSeq_Has_Ownership (CPubs'Address) = 1 then
         New_Max := DDS_DomainParticipant_Get_User_Group_CountI
           (Self.GetInterface, DDS_GROUP_PUBLISHER_I);
         if New_Max > Max_Length then
            if DDS_PublisherSeq_Set_Maximum (CPubs'Address, New_Max) = 0 then
               raise DDS.ERROR with "maximum";
            end if;
            Max_Length := New_Max;
         end if;
      end if;

      DDS.Ret_Code_To_Exception
        (DDS_DomainParticipant_Get_Publishers
           (Self.GetInterface, CPubs'Access));

      PublishersMax := Natural (New_Max);
      if DDS.PublisherSeq.Has_Ownership (Publishers) then
         if PublishersMax > DDS.PublisherSeq.Get_Maximum (Publishers) then
            DDS.PublisherSeq.Set_Maximum (Publishers, PublishersMax);
         end if;
      end if;

      DDS.PublisherSeq.Set_Length (Publishers, PublishersMax);
      if DDS_PublisherSeq_Get_Length (CPubs'Address) > 0 then
         for I in 0 .. DDS_PublisherSeq_Get_Length (CPubs'Address) - 1 loop
            CPublisher := DDS_PublisherSeq_Get (CPubs'Address, I);
            AdaPublisher := DDS.Publisher.Ref_Access
              (DDS.Publisher_Impl.Get_FacadeI (System.Address (CPublisher)));
            Index := Natural (I + 1);
            DDS.PublisherSeq.Set_Element (Publishers, Index, AdaPublisher);
         end loop;
      end if;

      DDS.Ret_Code_To_Exception
        (DDS_DomainParticipant_Unlock_All_GroupsI
           (Self.GetInterface, DDS_GROUP_PUBLISHER_I));
   end Get_Publishers;

   ---------------------
   -- Get_Subscribers --
   ---------------------

   procedure Get_Subscribers
     (Self        : not null access Ref;
      Subscribers : access DDS.SubscriberSeq.Sequence)
   is
      CPubs           : aliased DDS_SubscriberSeq;
      Max_Length      : DDS_Long;
      New_Max         : DDS_Long;
      SubscribersMax  : Natural;
      Index           : Natural;
      CSubscriber     : DDS_Subscriber_Ptr;
      AdaSubscriber   : DDS.Subscriber.Ref_Access;
   begin
      if DDS_SubscriberSeq_Initialize (CPubs'Address) = 0 then
         raise DDS.ERROR with "initialize";
      end if;
      Max_Length := DDS_SubscriberSeq_Get_Maximum (CPubs'Address);

      DDS.Ret_Code_To_Exception
        (DDS_DomainParticipant_Lock_All_GroupsI
           (Self.GetInterface, DDS_GROUP_SUBSCRIBER_I), "Lock");

      if DDS_SubscriberSeq_Has_Ownership (CPubs'Address) = 1 then
         New_Max := DDS_DomainParticipant_Get_User_Group_CountI
           (Self.GetInterface, DDS_GROUP_SUBSCRIBER_I);
         if New_Max > Max_Length then
            if DDS_SubscriberSeq_Set_Maximum (CPubs'Address, New_Max) = 0 then
               raise DDS.ERROR with "maximum";
            end if;
            Max_Length := New_Max;
         end if;
      end if;

      DDS.Ret_Code_To_Exception
        (DDS_DomainParticipant_Get_Subscribers
           (Self.GetInterface, CPubs'Access));

      SubscribersMax := Natural (New_Max);
      if DDS.SubscriberSeq.Has_Ownership (Subscribers) then
         if SubscribersMax > DDS.SubscriberSeq.Get_Maximum (Subscribers) then
            DDS.SubscriberSeq.Set_Maximum (Subscribers, SubscribersMax);
         end if;
      end if;

      DDS.SubscriberSeq.Set_Length (Subscribers, SubscribersMax);
      if DDS_SubscriberSeq_Get_Length (CPubs'Address) > 0 then
         for I in 0 .. DDS_SubscriberSeq_Get_Length (CPubs'Address) - 1 loop
            CSubscriber := DDS_SubscriberSeq_Get (CPubs'Address, I);
            AdaSubscriber := DDS.Subscriber.Ref_Access
              (DDS.Subscriber_Impl.Get_FacadeI (System.Address (CSubscriber)));
            Index := Natural (I + 1);
            DDS.SubscriberSeq.Set_Element (Subscribers, Index, AdaSubscriber);
         end loop;
      end if;

      DDS.Ret_Code_To_Exception
        (DDS_DomainParticipant_Unlock_All_GroupsI
           (Self.GetInterface, DDS_GROUP_SUBSCRIBER_I));
   end Get_Subscribers;

   ----------------------
   -- Get_Current_Time --
   ----------------------

   function Get_Current_Time
     (Self : not null access Ref)
      return DDS.Time_T
   is
      type Conv (Part : Boolean := False) is record
         case Part is
            when True =>
               Ret : aliased DDS.Time_T;
            when False =>
               Arg : aliased DDS_Time_T;
         end case;
      end record;
      pragma Unchecked_Union (Conv);
      Data : Conv;
   begin
      Ret_Code_To_Exception (DDS_DomainParticipant_Get_Current_Time (Self.GetInterface, Data.Arg'Unrestricted_Access));
      return Data.Ret;
   end Get_Current_Time;

   function CreateI
     (Participant_Factory   : not null access Dds.DomainParticipantFactory.Ref;
      Domain_Id             : in DDS.DomainId_T;
      Library_Name          : in DDS.String;
      Profile_Name          : in DDS.String;
      A_Listener            : in DDS.DomainParticipantListener.Ref_Access;
      Mask                  : in DDS.StatusMask)
      return DDS.DomainParticipant.Ref_Access is
      Qos       : aliased DDS.DomainParticipantQos;
   begin
      Participant_Factory.Get_Default_Participant_Qos (Qos);
      Participant_Factory.Get_Participant_Qos_From_Profile (Qos, Library_Name, Profile_Name);
      return CreateI (Participant_Factory, Domain_Id, Qos, A_Listener, Mask);
   end CreateI;

   function CreateI
     (Participant_Factory   : not null access Dds.DomainParticipantFactory.Ref;
      Domain_Id             : in DDS.DomainId_T;
      Qos                   : in DDS.DomainParticipantQos;
      A_Listener            : in DDS.DomainParticipantListener.Ref_Access;
      Mask                  : in DDS.StatusMask)
      return DDS.DomainParticipant.Ref_Access
   is
      Need_To_Enable     : aliased RTIDDS.Low_Level.ndds_dds_c_dds_c_common_h.DDS_Boolean := 0;
      P_Impl             : Ref_Access;
      P_Impl_Access      : Ref_Access_Access;
      Local_Qos          : aliased DDS.DomainParticipantQos;
      Modified_Qos       : aliased DDS.DomainParticipantQos;

      use type DDS.DomainParticipantListener.Ref_Access;
   begin
      --  Check if default QoS must be used
      if Qos'Address = DDS.DomainParticipantFactory.PARTICIPANT_QOS_DEFAULT'Address then
         Participant_Factory.Get_Default_Participant_Qos (Local_Qos);
      else
         Copy (Local_Qos, Qos);
      end if;

      P_Impl := new DomainParticipant_Impl.Ref;
      Copy (Modified_Qos, Local_Qos);
      P_Impl.Factory := Participant_Factory;

      Modified_Qos.User_Object.Participant_User_Object            := Default_UserObjectSettings;
      Modified_Qos.User_Object.Topic_User_Object                  := Default_UserObjectSettings;
      Modified_Qos.User_Object.Content_Filtered_Topic_User_Object := Default_UserObjectSettings;
      Modified_Qos.User_Object.Publisher_User_Object              := Default_UserObjectSettings;
      Modified_Qos.User_Object.Data_Writer_User_Object            := Default_UserObjectSettings;
      Modified_Qos.User_Object.Subscriber_User_Object             := Default_UserObjectSettings;
      Modified_Qos.User_Object.Data_Reader_User_Object            := Default_UserObjectSettings;
      Modified_Qos.User_Object.Read_Condition_User_Object         := Default_UserObjectSettings;
      Modified_Qos.User_Object.Query_Condition_User_Object        := Default_UserObjectSettings;
      Modified_Qos.User_Object.Flow_Controller_User_Object        := Default_UserObjectSettings;

      P_Impl.SetInterface (DDS_DomainParticipantFactory_Create_Participant_DisabledI
        (Participant_Factory.GetInterface,
         Need_To_Enable'Unchecked_Access,
         DDS_DomainId_T (Domain_Id),
         GetInterface (Modified_Qos),
         null, -- will reset before enable
         DDS_StatusMask (Mask),
         System.Null_Address,
         System.Null_Address,
         System.Null_Address,
         System.Null_Address,
         0,
         1));

      if P_Impl.GetInterface /= System.Null_Address then
         P_Impl.Entity_Initialize_I (P_Impl.GetInterface);
         P_Impl_Access := Convert (DDS_Entity_Get_User_DataI (P_Impl.GetInterface));
         if P_Impl_Access /= null then
            P_Impl_Access.all := P_Impl;

            --  Pre-register all builtin types and user types.
            Register_Builtin_TypesI (P_Impl);
            Register_User_TypesI (P_Impl);

            --  Set Listener
            if A_Listener /= null then
               P_Impl.Set_Listener (A_Listener, Mask);
            end if;
            if Need_To_Enable  /= 0 then
               P_Impl.Enable;
            end if;
            return DomainParticipant.Ref_Access (P_Impl);
         else
            raise ERROR;
         end if;
      else
         Free (P_Impl);
         return null;
      end if;

   exception
      when others =>
         if P_Impl /= null and then
           P_Impl.GetInterface /= System.Null_Address
         then
            begin
               DDS.Ret_Code_To_Exception
                 (DDS_DomainParticipantFactory_Delete_Participant
                    (Participant_Factory.GetInterface,
                     P_Impl.GetInterface));
            exception
               when others =>
                  null;
            end;
         end if;
         if P_Impl /= null then
            Free (P_Impl);
         end if;
         return null;
   end CreateI;


   function Get_FacadeI (C_DomainParticpant : System.Address)
                         return Ref_Access is

      P_Impl        : Ref_Access := null;
      P_Impl_Access : Ref_Access_Access;

   begin

      if C_DomainParticpant /= System.Null_Address then
         P_Impl_Access := Convert (DDS_Entity_Get_User_DataI (C_DomainParticpant));

         if P_Impl_Access /= null then
            P_Impl := P_Impl_Access.all;
         end if;
      end if;

      return P_Impl;

   end Get_FacadeI;


   procedure Add_Peer
     (Self             : not null access Ref;
      Peer_Desc_String : DDS.String)
   is
   begin
      Ret_Code_To_Exception (DDS_DomainParticipant_Add_Peer (Self.GetInterface, GetInterface (Peer_Desc_String)));
   end Add_Peer;

   procedure Register_User_TypesI (Self : not null access Ref)
   is
   begin
      --  Call the registrator functions from the set.
      for Registrator of Registered_Types loop
         Registrator (Self);
      end loop;
   end Register_User_TypesI;

   procedure Register_Builtin_TypesI (Self : not null access Ref)
   is
   begin
      --  Builtin Types
      Builtin_String_TypeSupport.Register_Type
        (Self,
         Builtin_String_TypeSupport.Get_Type_Name);

      Builtin_Octets_TypeSupport.Register_Type
        (Self,
         Builtin_Octets_TypeSupport.Get_Type_Name);

      Builtin_KeyedString_TypeSupport.Register_Type
        (Self,
         Builtin_KeyedString_TypeSupport.Get_Type_Name);

      Builtin_KeyedOctets_TypeSupport.Register_Type
        (Self,
         Builtin_KeyedOctets_TypeSupport.Get_Type_Name);

      --  Builtin Topics
      ParticipantBuiltinTopicData_TypeSupport.Register_Type
        (Self,
         ParticipantBuiltinTopicData_TypeSupport.Get_Type_Name);

      TopicBuiltinTopicData_TypeSupport.Register_Type
        (Self,
         TopicBuiltinTopicData_TypeSupport.Get_Type_Name);

      PublicationBuiltinTopicData_TypeSupport.Register_Type
        (Self,
         PublicationBuiltinTopicData_TypeSupport.Get_Type_Name);

      SubscriptionBuiltinTopicData_TypeSupport.Register_Type
        (Self,
         SubscriptionBuiltinTopicData_TypeSupport.Get_Type_Name);
   end Register_Builtin_TypesI;

   procedure Delete_Implicit_EntitiesI (Self : not null access Ref)
   is
      C_Publisher  : System.Address;
      C_Subscriber : System.Address;
      Publisher    : DDS.Publisher_Impl.Ref_Access;
      Subscriber   : DDS.Subscriber_Impl.Ref_Access;
   begin
      --  check if there is an implicit publisher
      C_Publisher := DDS_DomainParticipant_Get_Implicit_PublisherI
        (Self.GetInterface, null, null, 0);

      if C_Publisher /= System.Null_Address then
         --  delete implicit publisher
         Publisher := DDS.Publisher_Impl.Get_FacadeI (C_Publisher);
         Self.Delete_Publisher (DDS.Publisher.Ref_Access (Publisher));
      end if;

      --  check if there is an implicit subscriber
      C_Subscriber := DDS_DomainParticipant_Get_Implicit_SubscriberI
        (Self.GetInterface, null, null, 0);

      if C_Subscriber /= System.Null_Address then
         --  delete implicit subscriber
         Subscriber := DDS.Subscriber_Impl.Get_FacadeI (C_Subscriber);
         Self.Delete_Subscriber (DDS.Subscriber.Ref_Access (Subscriber));
      end if;
   end Delete_Implicit_EntitiesI;

   procedure Free (This : in out Ref_Access)
   is
   begin
      Free_Mem (This);
      This := null;
   end Free;


   procedure Register_Type_Registration (P : Register_Type_Procedure) is
   begin
      if not Registered_Types.Contains (P) then
         Registered_Types.Include (P);
      end if;
   end Register_Type_Registration;

end DDS.DomainParticipant_Impl;
