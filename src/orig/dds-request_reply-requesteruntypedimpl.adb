with DDS.Topic;
with DDS.TopicDescription;
with RTIDDS.Low_Level.Ndds_Mig_Mig_Rtps_H;
with DDS.ContentFilteredTopic;
with DDS.DomainParticipant;
with DDS.Request_Reply.Untypedcommon;
with DDS.Request_Reply.Connext_C_Entity_Params;
package body DDS.Request_Reply.Requesteruntypedimpl is
   use DDS.ContentFilteredTopic;
   use DDS.String_Seq;
   use Untypedcommon;
   use Connext_C_Entity_Params;

   --  
   RTI_Connext_CorrelationCFTBuilder_GUID_FIELD_NAME       : constant DDS.String := To_DDS_String ("@related_sample_identity.writer_guid.value");
   RTI_Connext_CorrelationCFTBuilder_GUID_SIZE             : constant DDS.Natural := 16;
   RTI_Connext_CorrelationCFTBuilder_MAX_TOPIC_NAME_LENGTH : constant DDS.Natural := RTIDDS.Low_Level.Ndds_Mig_Mig_Rtps_H.MIG_RTPS_PATHNAME_LEN_MAX - (16 * 4 + 1);
   

   
   function  RTI_Connext_CorrelationCFTBuilder_Create_Correlation_Cft 
     (Participant      : not null DDS.DomainParticipant.Ref_Access;
      Topic            : not null DDS.Topic.Ref_Access;
      Correlation_Guid : DDS.GUID_T) return DDS.ContentFilteredTopic.Ref_Access is
      
      Cft_Parameters : aliased DDS.String_Seq.Sequence;
      Topic_Name     : DDS.String;
      Guid_Str       : DDS.String;
      Filter_Str     : DDS.String;
      Cft            : DDS.ContentFilteredTopic.Ref_Access;
   begin
      DDS.String_Seq.Ensure_Length (Cft_Parameters'Access, 0, 0);
      Copy (Topic_Name, Topic.As_TopicDescription.Get_Name);
      if Length (Topic_Name) > RTI_Connext_CorrelationCFTBuilder_MAX_TOPIC_NAME_LENGTH then         
         DDSLog_Exception ("topic name " & To_Standard_String (Topic_Name) &  "is too long");
         Finalize (Topic_Name);
         return null;
      end if;
      Copy (Guid_Str, Topic_Name);
      Append (Guid_Str, "_" & Standard.String'(Image (Correlation_Guid)));
      
      Copy (Filter_Str, RTI_Connext_CorrelationCFTBuilder_GUID_FIELD_NAME);
      Append (Filter_Str, Standard.String'("= &hex(" & Standard.String'(Image (Correlation_Guid)) & ")"));
      
      Cft := Participant.Create_Contentfilteredtopic
        (Name                  => Guid_Str, 
         Related_Topic         => Topic, 
         Filter_Expression     => Filter_Str, 
         Expression_Parameters => Cft_Parameters'Access);
      
      if   Cft = null then
         DDSLog_Exception ("create content-filtered topic");
      end if;
      Finalize (Guid_Str);
      Finalize (Filter_Str);
      Finalize (Topic_Name);      
      return Cft;
   end;
   
   function RTI_Connext_RequesterUntypedImpl_Create_Reader_Topic  
     (Self            : not null access RTI_Connext_EntityUntypedImpl;
      Params          : not null access RTI_Connext_EntityParams;
      Reply_Type_Name : DDS.String) return DDS.TopicDescription.Ref_Access is
      Topic            : DDS.Topic.Ref_Access;
      Reply_Topic_Name : DDS.String ;
      CurrentWriterQos : DDS.DataWriterQos;
      TempR            : DDS.ContentFilteredTopic.Ref_Access;
      TopicDesc        : DDS.TopicDescription.Ref_Access;
   begin
      if Length (Params.Reply_Topic_Name) = DDS.Natural'(0) then 
         DDS.Copy (Reply_Topic_Name, Params.Reply_Topic_Name);
      else
         DDS.Copy (Reply_Topic_Name, RTI_Connext_Create_Reply_Topic_Name_From_Service_Name (Params.Service_Name));
      end if;
      Topic := DDS.Topic.Narrow (RTI_Connext_Get_Or_Create_Topic (Self.Participant, Reply_Topic_Name, Reply_Type_Name, False));
      TopicDesc := Topic.As_TopicDescription;
      Self.Writer.Get_Qos (CurrentWriterQos);
      TempR := RTI_Connext_CorrelationCFTBuilder_Create_Correlation_Cft
        (Participant      => Self.Participant,
         Topic            => Topic, 
         Correlation_Guid => CurrentWriterQos.Protocol.Virtual_Guid);
      Finalize(Reply_Topic_Name);
      TopicDesc := DDS.TopicDescription.Ref_Access (TempR);
      return TopicDesc;
   end;
   
   
   -- ==========================================================================
   -- ==========================================================================
   --  DDS_Topic *  RTI_Connext_RequesterUntypedImpl_create_writer_topic(
   --      struct RTI_Connext_EntityUntypedImpl * self,
   --      const RTI_Connext_EntityParams* params,
   --      const char * request_type_name)
   --  {
   --      char* request_topic_name = NULL;
   --      DDS_Topic * topic = NULL;
   --  
   --      request_topic_name =
   --          params->request_topic_name != NULL ?
   --              (char*) params->request_topic_name :
   --              RTI_Connext_create_request_topic_name_from_service_name(params->service_name);
   --  
   --      if(request_topic_name == NULL) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "Failure to create writer topic for requester");
   --          goto finish;
   --      }
   --  
   --      topic = DDS_Topic_narrow(
   --          RTI_Connext_get_or_create_topic(
   --              self->participant,
   --              request_topic_name,
   --              request_type_name, RTI_FALSE));
   --      if(topic == NULL)
   --      {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "Failure to create writer topic for requester");
   --          goto finish;
   --      }
   --  
   --      finish:
   --      /* Only free if we created it */
   --      if(request_topic_name != NULL && params->request_topic_name == NULL)
   --      {
   --          DDS_String_free(request_topic_name);
   --      }
   --      return topic;
   --  
   --  }

   
   function RTI_Connext_RequesterUntypedImpl_Create_Writer_Topic
     (Self : not null access RTI_Connext_EntityUntypedImpl;
      Params : RTI_Connext_EntityParams;
      Request_Type_Name : DDS.String) return DDS.Topic.Ref_Access is 
   
       request_topic_name : DDS.String;
       topic : DDS.Topic.Ref_Access;
   begin
      Copy (Request_Topic_Name,
            (if Params.Request_Topic_Name = NULL_STRING 
             then 
                To_Standard_String (Params.Request_Topic_Name)
             else
                RTI_Connext_Create_Request_Topic_Name_From_Service_Name (To_Standard_String (Params.Service_Name))));
   
       if request_topic_name = DDS.NULL_STRING then
              DDSLog_Exception ("Failure to create writer topic for requester");
           goto finish;
      end if;
   
      Topic := DDS.Topic.Narrow
        (RTI_Connext_Get_Or_Create_Topic
           (Participant => Self.Participant,
            Name        => Request_Topic_Name,
            Type_Name   => Request_Type_Name, 
            Allow_Cft   => FALSE));
      if Topic = null then
         DDSLog_Exception ("Failure to create writer topic for requester");
         goto Finish;
      end if;
   
      <<Finish>>
      Finalize (Request_Topic_Name);
      return Topic;
   
   end;

   
   
   -- ==========================================================================
   -- ==========================================================================
   --  DDS_ReturnCode_t RTI_Connext_RequesterParams_to_RTI_Connext_EntityParams(const RTI_Connext_RequesterParams* self, RTI_Connext_EntityParams* toParams)
   --  {
   --  
   --      DDSLog_testPrecondition(self == NULL, return DDS_RETCODE_PRECONDITION_NOT_MET);
   --      DDSLog_testPrecondition(toParams == NULL, return DDS_RETCODE_PRECONDITION_NOT_MET);
   --      toParams->participant = self->participant;
   --      toParams->datareader_qos = self->datareader_qos;
   --      toParams->datawriter_qos = self->datawriter_qos;
   --      toParams->publisher = self->publisher;
   --      toParams->qos_library_name = self->qos_library_name;
   --      toParams->qos_profile_name = self->qos_profile_name;
   --      toParams->reply_topic_name = self->reply_topic_name;
   --      toParams->request_topic_name = self->request_topic_name;
   --      toParams->service_name = self->service_name;
   --      toParams->subscriber = self->subscriber;
   --  
   --      return DDS_RETCODE_OK;
   --  }
   --  
   --  RTIBool RTI_Connext_RequesterUntypedImpl_initializeWaitSet(
   --      void * buffer, void * params)
   --  {
   --      DDS_WaitSet * waitset = (DDS_WaitSet *) buffer;
   --      DDS_WaitSet_initialize(waitset);
   --  
   --      return RTI_TRUE;
   --  }
   --  
   --  void RTI_Connext_RequesterUntypedImpl_finalizeWaitSet(
   --      void * buffer, void * params)
   --  {
   --      DDS_WaitSet * waitset = (DDS_WaitSet *) buffer;
   --      DDS_WaitSet_finalize(waitset);
   --  }
   --  
   --  RTI_Connext_RequesterUntypedImpl* RTI_Connext_RequesterUntypedImpl_create(
   --      const RTI_Connext_RequesterParams* params,
   --      RegisterTypeFunc register_request_type_fnc,
   --      const char * request_type_name,
   --      RegisterTypeFunc register_reply_type_fnc,
   --      const char * reply_type_name,
   --      int reply_size)
   --  {
   --      struct REDAFastBufferPoolProperty poolProperty =
   --          REDA_FAST_BUFFER_POOL_PROPERTY_DEFAULT;
   --      DDS_DataReader * reader;
   --      RTIBool ok = RTI_FALSE;
   --      RTI_Connext_RequesterUntypedImpl* requester = NULL;
   --      DDS_ReturnCode_t retCode = DDS_RETCODE_OK;
   --      RTI_Connext_EntityParams entity_params;
   --      struct RTI_Connext_TopicBuilder topic_builder = RTI_Connext_TopicBuilder_INITIALIZER;
   --  
   --      requester = RTI_Connext_EntityUntypedImpl_create();
   --      if(requester == NULL) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "error creating entity untyped");
   --          goto done;
   --      }
   --  
   --      topic_builder.create_reader_topic =
   --          RTI_Connext_RequesterUntypedImpl_create_reader_topic;
   --      topic_builder.create_writer_topic =
   --          RTI_Connext_RequesterUntypedImpl_create_writer_topic;
   --      retCode = RTI_Connext_RequesterParams_to_RTI_Connext_EntityParams(
   --          params, &entity_params);
   --  
   --      retCode = RTI_Connext_EntityUntypedImpl_initialize(
   --          requester,
   --          &entity_params,
   --          register_request_type_fnc,
   --          request_type_name,
   --          register_reply_type_fnc,
   --          reply_type_name,
   --          reply_size,
   --          &topic_builder,
   --          NULL,
   --          "Requester");
   --  
   --      if(retCode != DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "error initializing the entity untyped");
   --          goto done;
   --      }
   --  
   --      reader = (DDS_DataReader *)
   --          RTI_Connext_EntityUntypedImpl_get_datareader(requester);
   --      DDSLog_testPrecondition(reader == NULL, goto done;)
   --  
   --      retCode = DDS_DataReader_create_correlation_index(
   --          reader, "RequestReplyIndex");
   --      if(retCode != DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_CREATION_FAILURE_s,
   --                           "correlation index");
   --          goto done;
   --      }
   --  
   --      poolProperty.multiThreadedAccess = 1;
   --      requester->_waitset_pool = REDAFastBufferPool_newWithNotification(
   --          DDS_WaitSet_sizeof(), 8,
   --          RTI_Connext_RequesterUntypedImpl_initializeWaitSet, NULL,
   --          RTI_Connext_RequesterUntypedImpl_finalizeWaitSet, NULL,
   --          &poolProperty);
   --      if (requester->_waitset_pool == NULL) {
   --          DDSLog_exception(&RTI_LOG_CREATION_FAILURE_s,
   --                           "waitset pool");
   --          goto done;
   --      }
   --  
   --  
   --      ok = RTI_TRUE;
   --    done:
   --      if (!ok && requester != NULL) {
   --          RTI_Connext_EntityUntypedImpl_delete(requester);
   --          requester = NULL;
   --      }
   --  
   --      return requester;
   --  }
   --  
   --  const char * RTI_Connext_RequesterUntypedImpl_CORRELATION_SN_FIELD_NAME =
   --          "@related_sample_identity.sequence_number";
   --  
   --  char* RTI_Connext_RequesterUntypedImpl_create_query_expression_for_correlation_sequence_number(
   --          const struct DDS_SequenceNumber_t* sequence_number)
   --  {
   --      char* expr = DDS_String_alloc(strlen(RTI_Connext_RequesterUntypedImpl_CORRELATION_SN_FIELD_NAME) +
   --          strlen(".low =") + 20 +  strlen(" and ") + strlen(RTI_Connext_RequesterUntypedImpl_CORRELATION_SN_FIELD_NAME) +
   --          strlen(".high =") + 20);
   --      if(expr == NULL)
   --      {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "failure to create string");
   --          return NULL;
   --      }
   --  
   --      sprintf(expr, "%s.low =%lu and %s.high =%ld", RTI_Connext_RequesterUntypedImpl_CORRELATION_SN_FIELD_NAME, (long unsigned int)sequence_number->low,
   --          RTI_Connext_RequesterUntypedImpl_CORRELATION_SN_FIELD_NAME, (long int)sequence_number->high);
   --  
   --      return expr;
   --  }
   --  
   
   -- ==========================================================================
   -- ==========================================================================
   --  DDS_ReadCondition * RTI_Connext_RequesterUntypedImpl_create_correlation_condition(
   --      RTI_Connext_RequesterUntypedImpl* self,
   --      DDS_SampleStateMask state_kind,
   --      const struct DDS_SequenceNumber_t* sequence_number)
   --  {
   --      struct DDS_SampleInfo sample_info;
   --      DDS_ReadCondition * condition = NULL;
   --      if (DDS_SequenceNumber_compare(sequence_number, &DDS_AUTO_SEQUENCE_NUMBER) == 0 ||
   --          DDS_SequenceNumber_compare(sequence_number, &DDS_SEQUENCE_NUMBER_MAX) == 0 ||
   --          DDS_SequenceNumber_compare(sequence_number, &DDS_SEQUENCE_NUMBER_ZERO) == 0 ||
   --          DDS_SequenceNumber_compare(sequence_number, &DDS_SEQUENCE_NUMBER_UNKNOWN) == 0) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "Invalid correlation sequence number");
   --          return NULL;
   --      }
   --  
   --      sample_info.related_original_publication_virtual_sequence_number =
   --          *sequence_number;
   --  
   --      condition = DDS_IndexCondition_as_readcondition(
   --          DDS_DataReader_create_indexcondition(self->_reader,
   --          state_kind, DDS_ANY_SAMPLE_STATE, DDS_ALIVE_INSTANCE_STATE,
   --          "RequestReplyIndex", &sample_info));
   --  
   --      if (condition == NULL) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "Error creating correlation condition");
   --          return NULL;
   --      }
   --  
   --      return condition;
   --  }
   --  
   
   -- ==========================================================================
   -- ==========================================================================
   --  DDS_ReturnCode_t RTI_Connext_RequesterUntypedImpl_wait_for_replies(
   --      RTI_Connext_RequesterUntypedImpl* self,
   --      const struct DDS_Duration_t* max_wait,
   --      int min_sample_count,
   --      const struct DDS_SampleIdentity_t* related_request_info)
   --  {
   --  
   --      DDS_ReadCondition * correlation_condition = NULL;
   --      DDS_ReadCondition * initial_condition = NULL;
   --      DDS_WaitSet* waitset = NULL;
   --      DDS_ReturnCode_t retcode = DDS_RETCODE_ERROR;
   --  
   --      DDSLog_testPrecondition(self == NULL,
   --          return DDS_RETCODE_PRECONDITION_NOT_MET);
   --      DDSLog_testPrecondition(max_wait == NULL,
   --          return DDS_RETCODE_PRECONDITION_NOT_MET);
   --      DDSLog_testPrecondition(related_request_info == NULL,
   --          return DDS_RETCODE_PRECONDITION_NOT_MET);
   --  
   --      DDSLog_testPrecondition(self->_waitset_pool == NULL,
   --          return DDS_RETCODE_PRECONDITION_NOT_MET);
   --  
   --      correlation_condition = RTI_Connext_RequesterUntypedImpl_create_correlation_condition(
   --          self, DDS_NOT_READ_SAMPLE_STATE,
   --          &related_request_info->sequence_number);
   --      if(correlation_condition == NULL) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "Error creating correlation condition");
   --          goto finish;
   --      }
   --  
   --      initial_condition = RTI_Connext_RequesterUntypedImpl_create_correlation_condition(
   --          self, DDS_ANY_SAMPLE_STATE,
   --          &related_request_info->sequence_number);
   --      if(initial_condition == NULL) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "Error creating initial correlation condition");
   --          goto finish;
   --      }
   --  
   --      waitset = (DDS_WaitSet *)
   --          REDAFastBufferPool_getBuffer(self->_waitset_pool);
   --      if(waitset == NULL) {
   --          DDSLog_exception(&RTI_LOG_CREATION_FAILURE_s,
   --                           "waitset");
   --          goto finish;
   --      }
   --  
   --      retcode = DDS_WaitSet_attach_condition(
   --          waitset, DDS_ReadCondition_as_condition(correlation_condition));
   --      if (retcode != DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "attach correlation condition to waitset");
   --          goto finish;
   --      }
   --  
   --      retcode = RTI_Connext_EntityUntypedImpl_wait_for_samples(
   --          self,
   --          max_wait, min_sample_count,
   --          waitset, initial_condition, correlation_condition);
   --  
   --    finish:
   --  
   --      if(correlation_condition != NULL) {
   --          DDS_DataReader_delete_readcondition(self->_reader, correlation_condition);
   --      }
   --  
   --      if(initial_condition != NULL) {
   --          DDS_DataReader_delete_readcondition(self->_reader, initial_condition);
   --      }
   --  
   --      if(waitset != NULL) {
   --          REDAFastBufferPool_returnBuffer(self->_waitset_pool, waitset);
   --      }
   --  
   --      return retcode;
   --  }
   --  
   
   -- ==========================================================================
   -- ==========================================================================
   --  DDS_ReturnCode_t RTI_Connext_RequesterUntypedImpl_get_reply_loaned(
   --      RTI_Connext_RequesterUntypedImpl* self,
   --      void *** received_data,
   --      int * data_count,
   --      DDS_Boolean* is_loan,
   --      void* dataSeqContiguousBuffer,
   --      struct DDS_SampleInfoSeq* info_seq,
   --      DDS_Long data_seq_len,
   --      DDS_Long data_seq_max_len,
   --      DDS_Boolean ownership,
   --      DDS_Long max_samples,
   --      const struct DDS_SampleIdentity_t * related_request_id,
   --      RTIBool take)
   --  {
   --      DDS_ReturnCode_t retCode = DDS_RETCODE_ERROR;
   --      DDS_ReadCondition * correlation_condition = NULL;
   --  
   --      DDSLog_testPrecondition(self == NULL,
   --          return DDS_RETCODE_PRECONDITION_NOT_MET);
   --      DDSLog_testPrecondition(received_data == NULL,
   --          return DDS_RETCODE_PRECONDITION_NOT_MET);
   --      DDSLog_testPrecondition(data_count == NULL,
   --          return DDS_RETCODE_PRECONDITION_NOT_MET);
   --      DDSLog_testPrecondition(is_loan == NULL,
   --          return DDS_RETCODE_PRECONDITION_NOT_MET);
   --      DDSLog_testPrecondition(info_seq == NULL,
   --          return DDS_RETCODE_PRECONDITION_NOT_MET);
   --  
   --  
   --      if (related_request_id != NULL) {
   --          correlation_condition =
   --              RTI_Connext_RequesterUntypedImpl_create_correlation_condition(
   --                  self, DDS_ANY_SAMPLE_STATE,
   --                  &related_request_id->sequence_number);
   --  
   --          if(correlation_condition == NULL) {
   --              DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                  "Error creating correlation condition");
   --              goto finish;
   --          }
   --      }
   --  
   --      retCode = RTI_Connext_EntityUntypedImpl_get_sample_loaned(
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
   --          correlation_condition,
   --          take);
   --  
   --      if(retCode != DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "Error getting sample loaned");
   --      }
   --  
   --   finish:
   --      if(correlation_condition != NULL) {
   --          DDS_DataReader_delete_readcondition(
   --              self->_reader, correlation_condition);
   --      }
   --  
   --      return retCode;
   --  }

end DDS.Request_Reply.Requesteruntypedimpl;
