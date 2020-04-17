with DDS.Topic;
with DDS.TopicDescription;
with DDS.Request_Reply.Untypedcommon; 
with DDS.Request_Reply.Connext_C_Entity_Params;
with System;
with DDS.Request_Reply.Connext_C_Replier;

package body DDS.Request_Reply.Replieruntypedimpl is
   use System;
   use Untypedcommon;
   use Connext_C_Entity_Params;
   use Connext_C_Replier;
   
   function RTI_Connext_ReplierUntypedImpl_Create_Writer_Topic
     (Self            : not null access RTI_Connext_EntityUntypedImpl;
      Params          : RTI_Connext_EntityParams;
      Reply_Type_Name : DDS.String) return DDS.Topic.Ref_Access is
      Reply_Topic_Name     : DDS.String;
      RetTopicDescription  : DDS.TopicDescription.Ref_Access;
   begin
      DDS.Copy (Reply_Topic_Name , (if DDS.Length (Reply_Topic_Name)  /= DDS.long'(0) 
                then
                   DDS.To_Standard_String (Params.Reply_Topic_Name)
                else 
                   DDS.To_Standard_String (RTI_Connext_Create_Reply_Topic_Name_From_Service_Name ((Params.Service_Name)))));
      
      RetTopicDescription :=  RTI_Connext_Get_Or_Create_Topic (Self.Participant, Reply_Topic_Name, Reply_Type_Name, False);
      
      DDS.Finalize (Reply_Topic_Name);    
      return DDS.Topic.Narrow (RetTopicDescription);
   end;
      
   
   function RTI_Connext_ReplierUntypedImpl_Create_Reader_Topic
     (Self              : not null access RTI_Connext_EntityUntypedImpl;
      Params            : RTI_Connext_EntityParams;
      Request_Type_Name : DDS.String) return DDS.Topic.Ref_Access is
      Request_Topic_Name     : DDS.String;
      RetTopicDescription    : DDS.TopicDescription.Ref_Access;
   begin
      DDS.Copy (Request_Topic_Name , (if DDS.Length (Request_Topic_Name)  /= DDS.long'(0) 
                then
                   DDS.To_Standard_String (Params.Request_Topic_Name)
                else 
                   DDS.To_Standard_String (RTI_Connext_Create_Request_Topic_Name_From_Service_Name ((Params.Service_Name)))));
      
      RetTopicDescription :=  RTI_Connext_Get_Or_Create_Topic (Self.Participant, Request_Topic_Name, Request_Type_Name, False);
      
      DDS.Finalize (Request_Topic_Name);    
      return DDS.Topic.Narrow (RetTopicDescription);
   end;
   

   
   --  DDS_ReturnCode_t RTI_Connext_ReplierUntypedImpl_initialize(
   --      RTI_Connext_ReplierUntypedImpl * self,
   --      const struct RTI_Connext_EntityParams* params,
   --      RegisterTypeFunc _request_type_fnc,
   --      const char * request_type_name,
   --      RegisterTypeFunc _reply_type_fnc,
   --      const char * reply_type_name,
   --      int request_size,
   --      struct DDS_DataReaderListener * listener)
   --  {
   --      DDS_ReturnCode_t retCode = DDS_RETCODE_OK;
   --      struct RTI_Connext_TopicBuilder topic_builder;
   --      topic_builder.create_reader_topic = &RTI_Connext_ReplierUntypedImpl_create_reader_topic;
   --      topic_builder.create_writer_topic = &RTI_Connext_ReplierUntypedImpl_create_writer_topic;
   --  
   --  
   --      retCode = RTI_Connext_EntityUntypedImpl_initialize(
   --          self,
   --          params,
   --          _reply_type_fnc,
   --          reply_type_name,
   --          _request_type_fnc,
   --          request_type_name,
   --          request_size,
   --          &topic_builder,
   --          listener,
   --          "Replier");
   --  
   --      if(retCode !=  DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "error initializing the entity untyped");
   --      }
   --      return retCode;
  
   
   
   
   --  
   --  DDS_ReturnCode_t RTI_Connext_ReplierUntypedImpl_configure_params_for_reply(
   --      RTI_Connext_ReplierUntypedImpl * self, struct DDS_WriteParams_t* params,
   --      const struct DDS_SampleIdentity_t* related_request_info)
   --  {
   --      if(DDS_SampleIdentity_equals(related_request_info, &DDS_AUTO_SAMPLE_IDENTITY))
   --      {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "bad related_request_info");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --  
   --      DDS_GUID_copy(&params->related_sample_identity.writer_guid,
   --                    &related_request_info->writer_guid);
   --  
   --      params->related_sample_identity.sequence_number =
   --          related_request_info->sequence_number;
   --      return DDS_RETCODE_OK;
   --  
   --  }
   function RTI_Connext_ReplierUntypedImpl_Configure_Params_For_Reply 
     (Self : not null access RTI_Connext_ReplierUntypedImpl;
      Params : in out WriteParams_T;
      Related_Request_Info : DDS.SampleIdentity_T) return DDS.ReturnCode_T is
   begin
      if Related_Request_Info =  AUTO_SAMPLE_IDENTITY then
         return DDS.RETCODE_BAD_PARAMETER;
      end if;
      Params.Related_Sample_Identity := Related_Request_Info;
      return DDS.RETCODE_OK;
   end;
      
                                                                       
   
                                                       
   --  DDS_ReturnCode_t RTI_Connext_ReplierUntypedImpl_send_sample(
   --      RTI_Connext_ReplierUntypedImpl * self,
   --      const void * data,
   --      const struct DDS_SampleIdentity_t * related_request_info,
   --      struct DDS_WriteParams_t * writeParams)
   --  {
   --      DDS_ReturnCode_t retcode = DDS_RETCODE_OK;
   --  
   --      retcode = RTI_Connext_ReplierUntypedImpl_configure_params_for_reply(
   --          self, writeParams, related_request_info);
   --  
   --      if(retcode != DDS_RETCODE_OK)
   --      {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "failure on Writing reply");
   --          return retcode;
   --      }
   
   
   --      retcode = DDS_DataWriter_write_w_params_untypedI(
   --          self->_writer, data, writeParams);
   --  
   --       if(retcode != DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "failure on Writing reply");
   --      }
   --      return retcode;
   --  }
   
   function RTI_Connext_ReplierUntypedImpl_Send_Sample
     (Self                 : not null access RTI_Connext_ReplierUntypedImpl;
      Data                 : System.Address;
      Related_Request_Info : DDS.SampleIdentity_T;
      WriteParams          : in out DDS.WriteParams_T) return DDS.ReturnCode_T is
      Retcode : DDS.ReturnCode_T;
   begin
      retcode := RTI_Connext_ReplierUntypedImpl_Configure_Params_For_Reply 
        (Self,
         WriteParams,
         Related_Request_Info);
      
      if retcode = DDS.RETCODE_OK then
         return Self.Writer.Write_W_Params (Instance_Data => Data, Params => WriteParams);
      else
         return Retcode;
      end if;
   end;
 
end DDS.Request_Reply.Replieruntypedimpl;
