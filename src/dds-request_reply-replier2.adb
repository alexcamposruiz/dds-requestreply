with DDS.DataReader;
with Dds;
with DDS.Request_Reply.Connext_C_Replier; 
with DDS.Request_Reply.Connext_C_Entity_Params;
with Ada.Unchecked_Deallocation;
with DDS.Request_Reply.Connext_C_Untyped_Impl;
with DDS.Request_Reply.Untypedcommon;

package body DDS.Request_Reply.Replier is
   use DDS.Request_Reply;
   use Connext_C_Replier;
   use Connext_C_Entity_Params;
   use connext_c_untyped_impl;
   use Untypedcommon;
   
   --  void RTI_Connext_Replier_on_data_available(
   --      void* listener_data, DDS_DataReader* reader)
   --  {
   --      RTI_Connext_Replier* self = (RTI_Connext_Replier*) listener_data;
   --  
   --      DDSLog_testPrecondition(self != NULL, return)
   --      DDSLog_testPrecondition(self->listener.on_request_available != NULL, return)
   --  
   --      self->listener.on_request_available(&self->listener, self);
   --  }
   
   procedure RTI_Connext_Replier_On_Data_Available (Self : RTI_Connext_Replier_Access;
                                                    Reader : DDS.DataReader.Ref_Access) is 
   begin
      Self.Listener.On_Request_Available (Self);
   end;

   --  DDS_ReturnCode_t RTI_Connext_ReplierParams_toEntityParams(
   --      const RTI_Connext_ReplierParams* self, RTI_Connext_EntityParams* toParams)
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
   procedure RTI_Connext_ReplierParams_ToEntityParams (Self     : RTI_Connext_ReplierParams;
                                                       ToParams : out RTI_Connext_EntityParams) is
   begin
      ToParams.Participant := Self.Participant;
      Copy (ToParams.Datareader_Qos, Self.Datareader_Qos);
      Copy (ToParams.Datawriter_Qos, Self.Datawriter_Qos);
      ToParams.Publisher := Self.Publisher;
      Copy (ToParams.Qos_Library_Name , Self.Qos_Library_Name);
      Copy (ToParams.Qos_Profile_Name , Self.Qos_Profile_Name);
      Copy (ToParams.Reply_Topic_Name, Self.Reply_Topic_Name);
      Copy (ToParams.Request_Topic_Name, Self.Request_Topic_Name);
      Copy (ToParams.Service_Name, Self.Service_Name);
      ToParams.Subscriber := Self.Subscriber;
      
   end;
   
                                                    
   --  DDS_ReturnCode_t RTI_Connext_Replier_delete(RTI_Connext_Replier * self)
   --  {
   --      DDS_ReturnCode_t retcode = DDS_RETCODE_OK;
   --  
   --      if(self == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "self");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --  
   --      if (self->_impl != NULL) {
   --          retcode = RTI_Connext_EntityUntypedImpl_delete(self->_impl);
   --          if(retcode != DDS_RETCODE_OK) {
   --              DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                  "Failure deleting impl");
   --          }
   --      }
   --  
   --      RTIOsapiHeap_free(self);
   --  
   --      return retcode;
   --  }
   procedure RTI_Connext_Replier_Delete (Self : in out RTI_Connext_Replier_Access) is
      procedure Free is new Ada.Unchecked_Deallocation (RTI_Connext_Replier, RTI_Connext_Replier_Access);
   begin
      Free (Self);
   end;
   
   --  DDS_ReturnCode_t RTI_Connext_Replier_wait_for_requests(
   --      RTI_Connext_Replier* self,
   --      int min_count,
   --      const struct DDS_Duration_t* max_wait)
   --  {
   --      DDS_ReturnCode_t retcode = DDS_RETCODE_OK;
   --  


   --  
   --  
   --      retcode =  RTI_Connext_EntityUntypedImpl_wait_for_any_sample(
   --          self->_impl, max_wait, min_count);
   --  
   --      if(retcode != DDS_RETCODE_OK && retcode != DDS_RETCODE_TIMEOUT) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                           "wait for samples");
   --      }
   --      return retcode;
   --  }
   procedure RTI_Connext_Replier_Wait_For_Requests (Self : not null access RTI_Connext_Replier; 
                                                    Min_Count : DDS.Integer;
                                                    Max_Wait  : DDS.Duration_T) is
    Dummy_ret : DDS.ReturnCode_T;  
   begin
      Dummy_ret := RTI_Connext_EntityUntypedImpl_Wait_For_Any_Sample (RTI_Connext_EntityUntypedImpl (Self.all)'Access, Max_Wait => Max_Wait, Min_Sample_Count => Min_Count);
   end;
      
      
   
end DDS.Request_Reply.Replier;
