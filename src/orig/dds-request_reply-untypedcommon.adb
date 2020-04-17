with DDS.DomainParticipantFactory;
with DDS.TopicListener;
with GNAT.Source_Info;
package body DDS.Request_Reply.Untypedcommon is


   
   
   --  void DebugDataWriterListener_on_publication_matched(DDS_DataWriter* writer,
   --      const struct DDS_PublicationMatchedStatus* status) {
   --      printf("on_publication_matched\n");
   --  }
   
    
  
   --  struct DDS_DataWriterQos* RTI_Connext_get_default_request_reply_writer_qos(DDS_DomainParticipant * participant)
   --  {
   --      static struct DDS_DataWriterQos qos = DDS_DataWriterQos_INITIALIZER;
   --      DDS_DomainParticipant_get_default_datawriter_qos(participant, &qos);
   --      return &qos;
   --  }
   procedure RTI_Connext_Get_Default_Request_Reply_Writer_Qos
     (Participant : DDS.DomainParticipant.Ref_Access; 
      Ret         : in out DDS.DataWriterQos) is
   begin
      Participant.Get_Default_DataWriter_Qos (Ret);
   end;
   
   

  
   procedure RTI_Connext_Get_Default_Request_Reply_Reader_Qos 
     (Participant : DDS.DomainParticipant.Ref_Access; 
      Ret         : in out DDS.DataReaderQos) is
   begin
      Participant.Get_Default_DataReader_Qos (Ret);
   end;
   
    

   
   
   function RTI_Connext_EntityUntypedImpl_Get_Datawriter_Qos 
     (Self      : not null access RTI_Connext_EntityUntypedImpl;
      Qos       : in out DDS.DataWriterQos;
      Params    : RTI_Connext_EntityParams;
      Role_Name : DDS.String := DDS.NULL_STRING) return DDS.ReturnCode_T is
      
      RetCode : DDS.ReturnCode_T := DDS.RETCODE_OK;
   begin
      if Params.Datawriter_Qos = null and Params.Qos_Library_Name /= NULL_STRING then
         DDS.DomainParticipantFactory.Get_Instance.Get_Datawriter_Qos_From_Profile_W_Topic_Name
           (QoS          => QoS,
            Library_Name => Params.Qos_Library_Name,
            Profile_Name => Params.Qos_Profile_Name,
            Topic_Name   => Self.Writer_Topic.As_TopicDescription.Get_Name);      
      elsif Params.Datawriter_Qos /= null then
         Copy (Qos, Params.Datawriter_Qos.all);
      else
         Self.Participant.Get_Default_Datawriter_Qos (QoS);
         Qos.Reliability.Kind :=  DDS.RELIABLE_RELIABILITY_QOS;
         Qos.History.Kind := DDS.KEEP_ALL_HISTORY_QOS;

         Qos.Resource_Limits.Max_Samples := DDS.LENGTH_UNLIMITED;
         Qos.Reliability.Max_Blocking_Time:= To_Duration_T(10.0);
   
         --   Heartbeats
         Qos.Protocol.Rtps_Reliable_Writer.Max_Heartbeat_Retries := DDS.LENGTH_UNLIMITED;
         Qos.Protocol.Rtps_Reliable_Writer.Heartbeat_Period:= To_Duration_T(0.100);
         
         Qos.Protocol.Rtps_Reliable_Writer.Fast_Heartbeat_Period := To_Duration_T (0.010);
         Qos.Protocol.Rtps_Reliable_Writer.Late_Joiner_Heartbeat_Period := To_Duration_T (0.010);
         Qos.Protocol.Rtps_Reliable_Writer.Heartbeats_Per_Max_Samples := 2;
   
         --  Nack response delay
         Qos.Protocol.Rtps_Reliable_Writer.Max_Nack_Response_Delay := To_Duration_T(0.0);
         Qos.Protocol.Rtps_Reliable_Writer.Min_Nack_Response_Delay := To_Duration_T (0.0);
   
         --   Send window
         Qos.Protocol.Rtps_Reliable_Writer.Max_Send_Window_Size := 32;
         Qos.Protocol.Rtps_Reliable_Writer.Min_Send_Window_Size := 32;
   
         --  max_remote_reader_filters unlimited
         --  This allows a Replier to do writer-side filtering
         --  for any number of Requester
         Qos.Writer_Resource_Limits.Max_Remote_Reader_Filters := DDS.LENGTH_UNLIMITED;
      end if;
      if Qos.Publication_Name.Role_Name = NULL_STRING then
         Copy (Qos.Publication_Name.Role_Name, Role_Name);
      end if;
      return RetCode;
   end;


   function RTI_Connext_EntityUntypedImpl_Get_Datareader_Qos 
     (Self      : not null access RTI_Connext_EntityUntypedImpl;
      Qos       : in out DDS.DataReaderQoS;
      Params    : RTI_Connext_EntityParams;
      Role_Name : DDS.String := DDS.NULL_STRING) return DDS.ReturnCode_T is
      
      RetCode : DDS.ReturnCode_T := DDS.RETCODE_OK;
   begin
      if Params.Datareader_Qos = null and Params.Qos_Library_Name /= NULL_STRING then
         DDS.DomainParticipantFactory.Get_Instance.get_datareader_qos_from_profile_w_topic_name
           (QoS          => QoS,
            Library_Name => Params.Qos_Library_Name,
            Profile_Name => Params.Qos_Profile_Name,
            Topic_Name   => Self.Writer_Topic.As_TopicDescription.Get_Name);      
      elsif Params.Datareader_Qos /= null then
         Copy (Qos, Params.Datareader_Qos.all);
      else
         Self.Participant.Get_Default_Datareader_Qos (QoS);
         Qos.Reliability.Kind :=  DDS.RELIABLE_RELIABILITY_QOS;
         Qos.History.Kind := DDS.KEEP_ALL_HISTORY_QOS;

         Qos.Resource_Limits.Max_Samples := DDS.LENGTH_UNLIMITED;
         Qos.Reliability.Max_Blocking_Time:= To_Duration_T(10.0);
   
         Qos.Protocol.Rtps_Reliable_Reader.Max_Heartbeat_Response_Delay := To_Duration_T (0.0);
         Qos.Protocol.Rtps_Reliable_Reader.Min_Heartbeat_Response_Delay := To_Duration_T (0.0);
      end if;
      if Qos.Subscription_Name.Role_Name = DDS.NULL_STRING then
         Copy (Qos.Subscription_Name.Role_Name, Role_Name);
      end if;
      return RetCode;
   end;

   
   
  
   --  DDS_ReturnCode_t RTI_Connext_EntityUntypedImpl_delete(
   --      struct RTI_Connext_EntityUntypedImpl * self)
   --  {
   --      DDS_ReturnCode_t retCode = DDS_RETCODE_OK;
   --      DDS_ReturnCode_t realReturn = DDS_RETCODE_OK;
   --  
   --      if (self == NULL) {
   --          return DDS_RETCODE_OK;
   --      }
   --  
   --      if (self->participant != NULL) {
   --          /* We do not delete topics even if we create them as they
   --           * may be used else where in the participant.
   --           * Therefore the end user is responsible for cleaning these
   --           * topics up prior to deleting the participant.
   --           */
   --          if (self->_reader != NULL) {
   --  
   --              if (self->_not_read_sample_cond != NULL) {
   --                  retCode = DDS_DataReader_delete_readcondition(
   --                      self->_reader, self->_not_read_sample_cond);
   --                  if(retCode != DDS_RETCODE_OK) {
   --                      DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                          "Error deleting reader read condition");
   --                      realReturn = DDS_RETCODE_ERROR;
   --                  }
   --              }
   --  
   --              if (self->_any_sample_cond != NULL) {
   --                  retCode = DDS_DataReader_delete_readcondition(
   --                      self->_reader, self->_any_sample_cond);
   --                  if(retCode != DDS_RETCODE_OK) {
   --                      DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                          "Error deleting reader read condition");
   --                      realReturn = DDS_RETCODE_ERROR;
   --                  }
   --                  self->_any_sample_cond = NULL;
   --              }
   --  
   --              retCode = DDS_Subscriber_delete_datareader(
   --                  self->_subscriber, self->_reader);
   --              if(retCode != DDS_RETCODE_OK) {
   --                  DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                      "Error deleting datareader");
   --                  realReturn = DDS_RETCODE_ERROR;
   --              }
   --  
   --              self->_reader = NULL;
   --          }
   --  
   --          if (self->_writer != NULL) {
   --              retCode = DDS_Publisher_delete_datawriter(
   --                  self->_publisher, self->_writer);
   --              if(retCode != DDS_RETCODE_OK) {
   --                  DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                      "Error deleting datawriter");
   --                  realReturn = DDS_RETCODE_ERROR;
   --              }
   --              self->_writer = NULL;
   --          }
   --  
   --          self->participant = NULL;
   --      }
   --  
   --      if(self->_waitset != NULL) {
   --          DDS_WaitSet_delete(self->_waitset);
   --          self->_waitset = NULL;
   --      }
   --  
   --      if (self->_waitset_pool != NULL) {
   --          REDAFastBufferPool_delete(self->_waitset_pool);
   --          self->_waitset_pool = NULL;
   --      }
   --  
   --      RTIOsapiHeap_freeStructure(self);
   --      return realReturn;
   --  }
   

   
   --  =========================================================================
   --  =========================================================================
   --  Package
   --  DDS_ReturnCode_t RTI_Connext_EntityUntypedImpl_initialize(
   --      struct RTI_Connext_EntityUntypedImpl * self,
   --      const RTI_Connext_EntityParams* params,
   --      RegisterTypeFunc register_writer_type_fnc,
   --      const char * writer_type_name,
   --      RegisterTypeFunc register_reader_type_fnc,
   --      const char * reader_type_name,
   --      int sample_size,
   --      struct RTI_Connext_TopicBuilder * topic_builder,
   --      struct DDS_DataReaderListener * reader_listener,
   --      const char * role_name)
   --  {
   --      DDS_ReturnCode_t retcode = DDS_RETCODE_ERROR;
   --      struct DDS_DataWriterQos writerQos = DDS_DataWriterQos_INITIALIZER;
   --      struct DDS_DataReaderQos readerQos = DDS_DataReaderQos_INITIALIZER;
   --  
   --      if(!RTI_Connext_EntityParams_validate(params)) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "invalid params");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --  
   --      self->_waitset_pool = NULL; /* Initialized by RequesterUntypedImpl only */
   --      self->_sample_size = sample_size;
   --  
   --      self->participant = params->participant;
   --      self->_publisher = params->publisher;
   --      self->_subscriber = params->subscriber;
   --      if(self->_publisher == NULL) {
   --          self->_publisher = DDS_DomainParticipant_get_implicit_publisher(
   --              self->participant);
   --          if(self->_publisher == NULL) {
   --              DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                  "unable to get implicit publisher");
   --              goto done;
   --          }
   --      }
   --  
   --      if(self->_subscriber == NULL) {
   --          self->_subscriber = DDS_DomainParticipant_get_implicit_subscriber(
   --              self->participant);
   --          if(self->_subscriber == NULL) {
   --              DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                  "unable to get implicit subscriber");
   --              goto done;
   --          }
   --      }
   --  
   --      self->_waitset = DDS_WaitSet_new();
   --      if(self->_waitset == NULL)
   --      {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "unable to create waitset.");
   --          goto done;
   --      }
   --  
   --      if (register_writer_type_fnc(self->participant, writer_type_name) !=
   --              DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "Error registering DataWriter type");
   --          goto done;
   --      }
   --  
   --      self->_writer_topic =
   --          topic_builder->create_writer_topic(self, params, writer_type_name);
   --  
   --      if (self->_writer_topic == NULL) {
   --          DDSLog_exception(&RTI_LOG_CREATION_FAILURE_s,
   --                           "writer topic");
   --          goto done;
   --      }
   --  
   --      retcode = RTI_Connext_EntityUntypedImpl_get_datawriter_qos(
   --          self, &writerQos, params, role_name);
   --      if(retcode != DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "Failure to get datawriter qos");
   --          goto done;
   --      }
   --  
   --      self->_writer = DDS_Publisher_create_datawriter(
   --          self->_publisher,
   --          self->_writer_topic,
   --          &writerQos,
   --          NULL, DDS_STATUS_MASK_NONE);
   --  
   --      if (self->_writer == NULL) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "EntityUntypedImpl: Error creating DDS DataWriter");
   --          goto done;
   --      } 
   --  
   --      if (register_reader_type_fnc(self->participant, reader_type_name) !=
   --              DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "Error registering DataReader type");
   --          goto done;
   --      }
   --  
   --      self->_reader_topic =
   --          topic_builder->create_reader_topic(self, params, reader_type_name);
   --  
   --      if (self->_reader_topic == NULL) {
   --          DDSLog_exception(&RTI_LOG_CREATION_FAILURE_s,
   --                           "reader topic");
   --          goto done;
   --      }
   --  
   --      retcode = RTI_Connext_EntityUntypedImpl_get_datareader_qos(
   --          self, &readerQos, params, role_name);
   --      if(retcode != DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "Error getting datareader qos");
   --          goto done;
   --      }
   --  
   --      /* Remember this value to check for inconsistent calls later */
   --      self->_max_samples_per_read =
   --          readerQos.reader_resource_limits.max_samples_per_read;
   --  
   --      self->_reader = DDS_Subscriber_create_datareader(
   --          self->_subscriber,
   --          self->_reader_topic,
   --          &readerQos,
   --          reader_listener,
   --          reader_listener != NULL ?
   --              DDS_DATA_AVAILABLE_STATUS :
   --              DDS_STATUS_MASK_NONE);
   --  
   --      if (self->_reader == NULL) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "EntityUntypedImpl: Error creating DDS DataReader");
   --          goto done;
   --      }
   --  
   --  
   --      self->_any_sample_cond = DDS_DataReader_create_readcondition(
   --          self->_reader,
   --          DDS_ANY_SAMPLE_STATE,
   --          DDS_ANY_VIEW_STATE,
   --          DDS_ANY_INSTANCE_STATE);
   --  
   --      if (self->_any_sample_cond == NULL) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "EntityUntypedImpl: Error creating DDS ReadCondition");
   --          goto done;
   --      }
   --  
   --      self->_not_read_sample_cond = DDS_DataReader_create_readcondition(
   --          self->_reader,
   --          DDS_NOT_READ_SAMPLE_STATE,
   --          DDS_ANY_VIEW_STATE,
   --          DDS_ANY_INSTANCE_STATE);
   --  
   --      if (self->_not_read_sample_cond == NULL) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "EntityUntypedImpl: Error creating DDS ReadCondition");
   --          goto done;
   --      }
   --  
   --      retcode = DDS_WaitSet_attach_condition(
   --          self->_waitset,
   --          DDS_ReadCondition_as_condition(self->_not_read_sample_cond));
   --      if(retcode !=  DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "Error attaching waitset");
   --          goto done;
   --      }
   --  
   --     retcode = DDS_RETCODE_OK;
   --  done:
   --      DDS_DataWriterQos_finalize(&writerQos);
   --      DDS_DataReaderQos_finalize(&readerQos);
   --  
   --      return retcode;
   --  }
   
   function RTI_Connext_EntityUntypedImpl_Initialize (Self             : in out RTI_Connext_EntityUntypedImpl;
                                                      Params           : RTI_Connext_EntityParams;                                                      
                                                      Writer_Type_Name : DDS.String;
                                                      Reader_Type_Name : DDS.String;
                                                      Sample_Size      : DDS.long;
                                                      --                                                       Topic_Builder    : RTI_Connext_TopicBuilder;
                                                      Reader_Listener  : DDS.DataReaderListener.Ref_Access;
                                                      Role_Name        : DDS.String) return DDS.ReturnCode_T is
   begin
      return raise Program_Error with "unimplemented RTI_Connext_EntityUntypedImpl_Touch_Samples";
   end;

   
   
   --  int RTI_Connext_EntityUntypedImpl_touch_samples(
   --      struct RTI_Connext_EntityUntypedImpl * self,
   --      int max_count,
   --      DDS_ReadCondition * read_condition)
   --  {
   --      void ** received_data = NULL;
   --      struct DDS_SampleInfoSeq info_seq = DDS_SEQUENCE_INITIALIZER;
   --      int data_count = -1;
   --      DDS_ReturnCode_t retCode = DDS_RETCODE_OK;
   --      DDS_Boolean isLoan = DDS_BOOLEAN_TRUE;
   --  
   --      retCode = RTI_Connext_EntityUntypedImpl_get_sample_loaned_w_len(
   --          self,
   --          &received_data,
   --          &data_count,
   --          &isLoan,
   --          NULL, /* dont need buffer */
   --          &info_seq,
   --          (DDS_Long)0, /* data_seq_len */
   --          (DDS_Long)0, /* data_seq_max_len */
   --          DDS_BOOLEAN_TRUE, /* ownership */
   --          (DDS_Long)max_count, /* We don't care if we have more */
   --          read_condition,
   --          RTI_FALSE /* read instead of taking */);
   --  
   --      if (retCode == DDS_RETCODE_OK) {
   --          retCode = RTI_Connext_EntityUntypedImpl_return_loan(self, received_data, &info_seq);
   --          if(retCode != DDS_RETCODE_OK)
   --          {
   --              DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                                           "error with returning loan");
   --              return -1;
   --          }
   --      } else if (retCode != DDS_RETCODE_NO_DATA) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "error with getting sample loan");
   --          return -1;
   --      }
   --  
   --      return data_count;
   --  }
   
   function RTI_Connext_EntityUntypedImpl_Touch_Samples
     (Self           : not null access RTI_Connext_EntityUntypedImpl;
      Max_Count      : DDS.Integer;
      Read_Condition : Dds.ReadCondition.Ref_Access) return DDS.Integer is
      RetCode : DDS.ReturnCode_T := DDS.RETCODE_OK;
      
   begin
      return raise Program_Error with "unimplemented RTI_Connext_EntityUntypedImpl_Touch_Samples";
   end;
   --  =========================================================================
   --  =========================================================================
  
   
 
   
   --  DDS_ReturnCode_t RTI_Connext_EntityUntypedImpl_wait_for_samples(
   --      struct RTI_Connext_EntityUntypedImpl * self,
   --      const struct DDS_Duration_t* max_wait,
   --      int min_sample_count,
   --      DDS_WaitSet* waitset,
   --      DDS_ReadCondition * initial_condition,
   --      DDS_ReadCondition * condition)
   --  {
   --      struct DDS_Duration_t remainingWait;
   --      struct DDS_ConditionSeq activeConditions = DDS_SEQUENCE_INITIALIZER;
   --      DDS_ReturnCode_t retCode = DDS_RETCODE_ERROR;
   --      int sample_count = 0;
   --      struct DDS_Duration_t durationBefore, durationAfter;
   --      struct DDS_Time_t timeBefore, timeAfter;
   --      RTINtpTime timeBeforeNtp, timeAfterNtp, remainingWaitNtp;
   --  
   --  
   --      DDSLog_testPrecondition(
   --          initial_condition == NULL, return DDS_RETCODE_PRECONDITION_NOT_MET);
   --      DDSLog_testPrecondition(
   --          condition == NULL, return DDS_RETCODE_PRECONDITION_NOT_MET);
   --  
   --      remainingWait = *max_wait;
   --      DDS_Duration_to_ntp_time(max_wait, &remainingWaitNtp);
   --  
   --      /* The conditions can be QueryConditions or ReadConditions but we
   --       need the following SampleStateKinds always
   --       */
   --      DDSLog_testPrecondition(
   --          DDS_ReadCondition_get_sample_state_mask(condition)
   --              != DDS_NOT_READ_SAMPLE_STATE,
   --          return DDS_RETCODE_PRECONDITION_NOT_MET);
   --      DDSLog_testPrecondition(
   --          DDS_ReadCondition_get_sample_state_mask(initial_condition)
   --              != DDS_ANY_SAMPLE_STATE,
   --          return DDS_RETCODE_PRECONDITION_NOT_MET);
   --  
   --  
   --      if (min_sample_count == DDS_LENGTH_UNLIMITED) {
   --          min_sample_count = INT_MAX;
   --      }
   --  
   --      sample_count = RTI_Connext_EntityUntypedImpl_touch_samples(
   --          self, min_sample_count, initial_condition);
   --      if(sample_count == -1){
   --          DDSLog_exception(&RTI_LOG_GET_FAILURE_s,
   --                           "initial sample count");
   --          goto finish;
   --      }
   --  
   --      min_sample_count -= sample_count;
   --  
   --      while (min_sample_count > 0) {
   --          if (min_sample_count == 1) {
   --              retCode = DDS_WaitSet_wait(
   --                  waitset, &activeConditions, &remainingWait);
   --          } else {
   --              DDS_DomainParticipant_get_current_time(
   --                  self->participant, &timeBefore);
   --  
   --              retCode = DDS_WaitSet_wait(
   --                  waitset, &activeConditions, &remainingWait);
   --  
   --              DDS_DomainParticipant_get_current_time(
   --                  self->participant, &timeAfter);
   --  
   --              /* Calculate remainingWait -= timeAfter - timeBefore */
   --              durationAfter.sec = timeAfter.sec;
   --              durationAfter.nanosec = timeAfter.nanosec;
   --              durationBefore.sec = timeBefore.sec;
   --              durationBefore.nanosec = durationAfter.nanosec;
   --              DDS_Duration_to_ntp_time(&durationBefore, &timeBeforeNtp);
   --              DDS_Duration_to_ntp_time(&durationAfter, &timeAfterNtp);
   --              RTINtpTime_decrement(timeAfterNtp, timeBeforeNtp);
   --              RTINtpTime_decrement(remainingWaitNtp, timeAfterNtp);
   --              DDS_Duration_from_ntp_time(&remainingWait, &remainingWaitNtp);
   --          }
   --  
   --          if (retCode == DDS_RETCODE_TIMEOUT) {
   --              DDSLog_local(&RTI_LOG_ANY_s,
   --                           "timed out waiting for data");
   --              goto finish;
   --          } else if (retCode != DDS_RETCODE_OK) {
   --              DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                               "wait");
   --              goto finish;
   --          }
   --  
   --          DDSLog_testPrecondition(
   --              DDS_ConditionSeq_get_length(&activeConditions) != 1,
   --              goto finish);
   --  
   --          DDSLog_testPrecondition(
   --              DDS_ConditionSeq_get(&activeConditions, 0) !=
   --                  DDS_ReadCondition_as_condition(condition),
   --              goto finish);
   --  
   --          if (min_sample_count > 1) {
   --              sample_count = RTI_Connext_EntityUntypedImpl_touch_samples(self, min_sample_count, condition);
   --              if(sample_count == -1) {
   --                  DDSLog_exception(&RTI_LOG_GET_FAILURE_s,
   --                                   "sample count");
   --                  retCode = DDS_RETCODE_ERROR;
   --                  goto finish;
   --              }
   --              min_sample_count -= sample_count;
   --          } else {
   --              /* If we woke up from the waitset, we have at least
   --               * one sample to read; we can skip the read operation
   --               */
   --              min_sample_count--;
   --          }
   --      }
   --  
   --      retCode = DDS_RETCODE_OK;
   --   finish:
   --      DDS_ConditionSeq_finalize(&activeConditions);
   --      return retCode;
   --  }
   function RTI_Connext_EntityUntypedImpl_Wait_For_Samples
     (Self              : not null access RTI_Connext_EntityUntypedImpl;
      Max_Wait          : DDS.Duration_T;
      Min_Sample_Count  : DDS.Integer;
      Waitset           : DDS.WaitSet.Ref_Access;
      Initial_Condition : DDS.ReadCondition.Ref_Access;
      Condition         : DDS.ReadCondition.Ref_Access ) return DDS.ReturnCode_T is
   begin

      
      return raise Program_Error with "unimplemented RTI_Connext_EntityUntypedImpl_Wait_For_Samples";
   end;
   --  =========================================================================
   --  =========================================================================
  
   
                                                           
   
   
   --  DDS_ReturnCode_t RTI_Connext_EntityUntypedImpl_wait_for_any_sample(
   --      struct RTI_Connext_EntityUntypedImpl * self,
   --      const struct DDS_Duration_t* max_wait,
   --      int min_sample_count)
   --  {
   --      DDS_ReturnCode_t retCode = DDS_RETCODE_OK;
   --  
   --      retCode = RTI_Connext_EntityUntypedImpl_wait_for_samples(
   --          self, max_wait, min_sample_count,
   --          self->_waitset, self->_any_sample_cond, self->_not_read_sample_cond);
   --  
   --      if(retCode != DDS_RETCODE_OK && retCode != DDS_RETCODE_TIMEOUT)
   --      {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                           "wait error");
   --      }
   --      return retCode;
   --  }
   function RTI_Connext_EntityUntypedImpl_Wait_For_Any_Sample 
     (Self             : not null access RTI_Connext_EntityUntypedImpl;
      Max_Wait         : DDS.Duration_T;
      Min_Sample_Count : DDS.Integer) return DDS.ReturnCode_T is
      RetCode : DDS.ReturnCode_T := DDS.RETCODE_OK;
   begin
      RetCode := RTI_Connext_EntityUntypedImpl_Wait_For_Samples 
        (Self, Max_Wait    => Max_Wait, 
         Min_Sample_Count  => Min_Sample_Count , 
         Waitset           =>  Self.Waitset,
         Initial_Condition =>  Self.Any_Sample_Cond, 
         Condition         => Self.Not_Read_Sample_Cond);
      --        if RetCode not in (DDS.RETCODE_OK , DDS.RETCODE_TIMEOUT) then 
      --           null; -- log error
      --        end if;
      return RetCode;
   end;
   --  =========================================================================
   --  =========================================================================
  
   
   
                                                               
   --  DDS_ReturnCode_t RTI_Connext_EntityUntypedImpl_get_sample_loaned_w_len(
   --      struct RTI_Connext_EntityUntypedImpl * self,
   --      void *** received_data,
   --      int * data_count,
   --      DDS_Boolean* is_loan,
   --      void* dataSeqContiguousBuffer,
   --      struct DDS_SampleInfoSeq* info_seq,
   --      DDS_Long data_seq_len,
   --      DDS_Long data_seq_max_len,
   --      DDS_Boolean data_seq_has_ownership,
   --      DDS_Long max_samples,
   --      DDS_ReadCondition * read_condition,
   --      RTIBool take)
   --  {
   --  
   --      DDS_ReturnCode_t retCode = DDS_RETCODE_OK;
   --  
   --      DDSLog_testPrecondition(received_data == NULL, return DDS_RETCODE_PRECONDITION_NOT_MET);
   --      DDSLog_testPrecondition(data_count == NULL, return DDS_RETCODE_PRECONDITION_NOT_MET);
   --      DDSLog_testPrecondition(read_condition == NULL, return DDS_RETCODE_PRECONDITION_NOT_MET);
   --  
   --      retCode = DDS_DataReader_read_or_take_w_condition_untypedI(
   --          self->_reader,
   --          is_loan,
   --          received_data,
   --          data_count,
   --          info_seq,
   --          data_seq_len,
   --          data_seq_max_len,
   --          data_seq_has_ownership,
   --          dataSeqContiguousBuffer,
   --          self->_sample_size,
   --          max_samples,
   --          (DDS_ReadCondition *) read_condition,
   --          take);
   --  
   --      DDSLog_testPrecondition(!is_loan, return DDS_RETCODE_ERROR);
   --  
   --      if(retCode != DDS_RETCODE_OK && retCode != DDS_RETCODE_NO_DATA)
   --      {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                           "read or take error");
   --      }
   --      return retCode;
   --  }
   --  
   function RTI_Connext_EntityUntypedImpl_Get_Sample_Loaned_W_Len
     (Self                    : not null access RTI_Connext_EntityUntypedImpl;
      Received_Data           : System.Address;      
      Data_Count              : in out DDS.Natural;
      Is_Loan                 : in out Boolean;
      DataSeqContiguousBuffer : System.Address;
      Info_Seq                : not null access DDS.SampleInfo_Seq.Sequence;
      Data_Seq_Len            : DDS.long;
      Data_Seq_Max_Len        : DDS.long;
      Data_Seq_Has_Ownership  : DDS.Boolean;
      Max_Samples             : DDS.long;
      Read_Condition          : DDS.ReadCondition.Ref_Access;
      Take                    : Boolean) return Dds.ReturnCode_T is
      pragma Unreferenced (Data_Count, Is_Loan);
   begin
      return DDS.ReturnCode_T'Val (Self.Reader.Read_W_Condition
                                   (Received_Data => Received_Data,
                                    Info_Seq      => Info_Seq,
                                    Max_Samples   => Max_Samples,
                                    Condition     => Read_Condition));
   end;
   
   --  =========================================================================
   --  =========================================================================
   --  RTIBool RTI_Connext_EntityUntypedImpl_validate(struct RTI_Connext_EntityUntypedImpl * self,
   --                                   int min_count,
   --                                   int max_count, 
   --                                   const struct DDS_Duration_t* max_wait)
   --  {
   --  
   --      if(max_count == 0) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                           "max_request_count must be greater than zero.");
   --          return RTI_FALSE;
   --      }
   --      if((min_count < 0) && (min_count != DDS_LENGTH_UNLIMITED)) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                           "Negative min_request_count not allowed except DDS_LENGTH_UNLIMITED.");
   --          return RTI_FALSE;
   --      }
   --      if((max_count < 0) && (max_count != DDS_LENGTH_UNLIMITED)) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                           "Negative max_request_count not allowed except DDS_LENGTH_UNLIMITED.");
   --          return RTI_FALSE;
   --      }
   --      if((min_count == DDS_LENGTH_UNLIMITED) && (max_count != DDS_LENGTH_UNLIMITED)) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                           "max_request_count must be at least min_request_count.");
   --          return RTI_FALSE;
   --      }
   --      if((max_count < min_count) && (max_count != DDS_LENGTH_UNLIMITED)) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                           "max_request_count must be at least min_request_count.");
   --          return RTI_FALSE;
   --      }
   --  
   --      if(DDS_Time_is_zero(max_wait)) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                           "max_wait must be greater than zero.");
   --          return RTI_FALSE;
   --      }
   --   
   --      if((max_count == DDS_LENGTH_UNLIMITED)  &&
   --         (DDS_Duration_is_infinite(max_wait))) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                           "The call will block foreever.");
   --          return RTI_FALSE;
   --      }
   --  
   --      return RTI_TRUE;
   --  }
   --  
   --  =========================================================================
   --  =========================================================================
   
   --  DDS_ReturnCode_t RTI_Connext_EntityUntypedImpl_get_sample_loaned(
   --      struct RTI_Connext_EntityUntypedImpl * self,
   --      void *** received_data,
   --      int * data_count,
   --      DDS_Boolean* is_loan,
   --      void* dataSeqContiguousBuffer,
   --      struct DDS_SampleInfoSeq* info_seq,
   --      DDS_Long data_seq_len,
   --      DDS_Long data_seq_max_len,
   --      DDS_Boolean ownership,
   --      DDS_Long max_samples,
   --      DDS_ReadCondition * read_condition,
   --      RTIBool take)
   --  {
   --      DDS_ReturnCode_t retCode = DDS_RETCODE_OK;
   --  
   --      DDSLog_testPrecondition(received_data == NULL, return DDS_RETCODE_PRECONDITION_NOT_MET);
   --      DDSLog_testPrecondition(data_count == NULL, return DDS_RETCODE_PRECONDITION_NOT_MET);
   --      DDSLog_testPrecondition(max_samples < 0 &&
   --                            max_samples != DDS_LENGTH_UNLIMITED, return DDS_RETCODE_PRECONDITION_NOT_MET);
   --  
   --      if (read_condition == NULL) {
   --          read_condition = self->_any_sample_cond;
   --      }
   --  
   --      retCode = RTI_Connext_EntityUntypedImpl_get_sample_loaned_w_len(
   --          self,
   --          received_data,
   --          data_count,
   --          is_loan,
   --          dataSeqContiguousBuffer,
   --          info_seq,
   --          data_seq_len,
   --          data_seq_max_len,
   --          ownership,
   --          max_samples,
   --          read_condition,
   --          take);
   --  
   --      if (retCode == DDS_RETCODE_NO_DATA) {
   --          *data_count = 0;
   --          return retCode;
   --      }
   --      if(retCode != DDS_RETCODE_OK)
   --      {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                           "get sample loan error");
   --      }
   --      return retCode;
   --  }
   function RTI_Connext_EntityUntypedImpl_Get_Sample_Loaned
     (Self                    : not null access RTI_Connext_EntityUntypedImpl;
      Received_Data           : System.Address;      
      Data_Count              : in out DDS.Natural;
      Is_Loan                 : in out Boolean;
      DataSeqContiguousBuffer : System.Address;
      Info_Seq                : not null access DDS.SampleInfo_Seq.Sequence;
      Data_Seq_Len            : DDS.long;
      Data_Seq_Max_Len        : DDS.long;
      Ownership               : DDS.Boolean;
      Max_Samples             : DDS.long;
      Read_Condition          : DDS.ReadCondition.Ref_Access;
      Take                    : Boolean) return Dds.ReturnCode_T is
      Retcode : DDS.ReturnCode_T;
      use type DDS.ReadCondition.Ref_Access;
   begin

      Retcode := RTI_Connext_EntityUntypedImpl_Get_Sample_Loaned_W_Len
        (Self, 
         Received_Data, 
         Data_Count, 
         Is_Loan, 
         DataSeqContiguousBuffer, 
         Info_Seq, 
         Data_Seq_Len, 
         Data_Seq_Max_Len, 
         Ownership,
         Max_Samples,
         (if Read_Condition = null
          then Self.Any_Sample_Cond
          else Read_Condition),
         Take);
      if Retcode = DDS.RETCODE_NO_DATA then
         Data_Count := 0;
         return RetCode;
      elsif RetCode /= DDS.RETCODE_OK then
         null;
         -- DDSLog_Exception (RTI_LOG_ANY_FAILURE_S, "get sample loan error");
      end if;
      return RetCode;
   end;
      
      
   
   --  =========================================================================
   --  =========================================================================
   --  
   --  DDS_ReturnCode_t RTI_Connext_EntityUntypedImpl_return_loan(
   --      struct RTI_Connext_EntityUntypedImpl * self, void ** dataArray, struct DDS_SampleInfoSeq* info_seq)
   --  {
   --      DDS_ReturnCode_t retCode = DDS_RETCODE_OK;
   --  
   --      DDSLog_testPrecondition(dataArray == NULL, return DDS_RETCODE_PRECONDITION_NOT_MET);
   --  
   --       retCode = DDS_DataReader_return_loan_untypedI(
   --              self->_reader,
   --              dataArray, 
   --              DDS_SampleInfoSeq_get_length(info_seq),
   --              info_seq);
   --  
   --      if (retCode != DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                           "return DataReader loan");
   --      }
   --      return retCode;
   --  }
   --  
   --  DDS_ReturnCode_t RTI_Connext_EntityUntypedImpl_send_sample(
   --      struct RTI_Connext_EntityUntypedImpl * self,
   --      const void * data,
   --      struct DDS_WriteParams_t* info)
   --  {
   --      DDS_ReturnCode_t retCode = DDS_RETCODE_OK;
   --  
   --      DDSLog_testPrecondition(self == NULL, return DDS_RETCODE_PRECONDITION_NOT_MET);
   --      DDSLog_testPrecondition(data == NULL, return DDS_RETCODE_PRECONDITION_NOT_MET);
   --      DDSLog_testPrecondition(info == NULL, return DDS_RETCODE_PRECONDITION_NOT_MET);
   --      DDSLog_testPrecondition(self->_writer == NULL,
   --                              return DDS_RETCODE_PRECONDITION_NOT_MET);
   --  
   --      DDS_SampleIdentity_t_copy(&info->identity, &DDS_AUTO_SAMPLE_IDENTITY);
   --  
   --      retCode = DDS_DataWriter_write_w_params_untypedI(
   --          self->_writer, data, info);
   --  
   --      if(retCode != DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "send sample write error");
   --      }
   --  
   --      return retCode;
   --  }
   --  =========================================================================
   --  =========================================================================
  
   function RTI_Connext_EntityUntypedImpl_Send_Sample
     (Self : not null access  RTI_Connext_EntityUntypedImpl;
      Data : System.Address;
      Info : in out WriteParams_T ) return ReturnCode_T is
      RetCode : ReturnCode_T := RETCODE_OK;
   begin
      Info.Identity := DDS.AUTO_SAMPLE_IDENTITY;
      RetCode := Self.Writer.Write_W_Params (Data, Info);
      if RetCode /= RETCODE_OK then
         DDSLog_Exception ("send sample write error");
      end if;   
      return RetCode;
   end;
   
   
   function RTI_Connext_EntityUntypedImpl_Validate_Receive_Params
     (Self : not null access RTI_Connext_EntityUntypedImpl;
      FUNCTION_NAME : Standard.String := GNAT.Source_Info.Enclosing_Entity;
      Min_Count     : DDS.long;
      Max_Count     : DDS.long;
      Max_Wait      : DDS.Duration_T) return Boolean is
      L_Min_Count     : DDS.long := (if Min_Count = LENGTH_UNLIMITED
                                     then Self.Max_Samples_Per_Read
                                     else Max_Count);      
           
      L_Max_Count     : DDS.long := (if Max_Count = LENGTH_UNLIMITED
                                     then Self.Max_Samples_Per_Read
                                     else Max_Count);
      
      Ok              : Boolean := True;
   begin
      if L_Max_Count < 1 and L_Max_Count /= LENGTH_UNLIMITED 
      then
         DDSLog_Exception ("max_count must be greater than zero");
         OK := False;
      end if;
      
      if ((L_Max_Count < L_Min_Count) and (L_Max_Count /= LENGTH_UNLIMITED)) or
        ((L_Min_Count  = LENGTH_UNLIMITED) and (L_Min_Count  /= LENGTH_UNLIMITED))        
      then
         DDSLog_Exception ("max_count must be greater or equal than min_count");
         OK := False;
      end if;
      if (L_Max_Count = LENGTH_UNLIMITED) and then Duration_Is_Infinite (Max_Wait) then
         DDSLog_Exception ("max_count and max_wait cannot be both unbounded");
         OK := False;
      end if;         
      return OK;
   end;
                                                                  
  

   function RTI_Connext_SimpleReplierParams_To_Entityparams
     (Self : RTI_Connext_EntityParams'Class;
      ToParams : out RTI_Connext_EntityParams) return ReturnCode_T is
   begin
      
      ToParams.Participant := Self.Participant;
      ToParams.Datareader_Qos := Self.Datareader_Qos;
      ToParams.Datawriter_Qos := Self.Datawriter_Qos;
      ToParams.Publisher := Self.Publisher;
      Copy (ToParams.Qos_Library_Name, Self.Qos_Library_Name);
      Copy (ToParams.Qos_Profile_Name, Self.Qos_Profile_Name);
      Copy (ToParams.Reply_Topic_Name, Self.Reply_Topic_Name);
      Copy (ToParams.Request_Topic_Name, Self.Request_Topic_Name);
      Copy (ToParams.Service_Name, Self.Service_Name);
      ToParams.Subscriber := Self.Subscriber;
            
      return DDS.RETCODE_OK;
   end;
   

   
end DDS.Request_Reply.Untypedcommon;
