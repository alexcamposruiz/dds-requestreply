package body DDS.Request_Reply.treqtrepsimplereplier is
   --  /* $Id$
   --  
   --   (c) Copyright, Real-Time Innovations, 2012-2016.
   --   All rights reserved.
   --   No duplications, whole or partial, manual or electronic, may be made
   --   without express written permission.  Any such copies, or
   --   revisions thereof, must display this notice unaltered.
   --   This code contains trade secrets of Real-Time Innovations, Inc.
   --  
   --   modification history
   --  ---------------------
   --  5.20,20aug14,acr Moved out function that previously was inside macro and
   --                   duplicated a symbol when declaring more than
   --                   one SimpleReplier for different types (REQREPLY-18)
   --  1.0a,2mar12,jch  Created.
   --  ============================================================================ */
   --  
   --  #include "log/log_makeheader.h"
   --  
   --  /*#include <stdlib.h>*/
   --  
   --  #ifndef log_common_h
   --    #include "log/log_common.h"
   --  #endif
   --  
   --  #ifndef connext_c_replier_h
   --    #include "connext_c/connext_c_replier.h"
   --  #endif
   --  
   --  #include "connext_c/connext_c_simple_replier.h"
   --  
   --  #ifndef connext_c_replier_impl_h
   --      #include "connext_c/connext_c_replier_impl.h"
   --  #endif
   --  
   --  #include "dds_c/dds_c_log_impl.h"
   --  
   --  #include "connext_c/connext_c_untyped_impl.h"
   --  
   --  /* TODO: add RTI_Connext_SimpleReplier type here
   --   * Type will contain TReqTRepReplier in it */
   --  /* TODO: consider abstracting out common TypeSupport defines to common.gen file & include it */
   --  
   --  #define DDS_CURRENT_SUBMODULE  DDS_SUBMODULE_MASK_DATA
   --  
   --  #if defined(TReq) && defined(TRep)
   --  
   --  #define TReqTRep_SimpleName_c(TReq, TRep) concatenate(TReq, TRep)
   --  #define TReqTRep_SimpleName TReqTRep_SimpleName_c(TReq, TRep)
   --  
   --  #ifdef TSimpleReplier
   --  #define TReqTRepSimpleReplier_name_c(SimpleReplier_name) SimpleReplier_name
   --  #define TReqTRepSimpleReplier_name TReqTRepSimpleReplier_name_c(TSimpleReplier)
   --  #define TReqTRepSimpleReplier TReqTRepSimpleReplier_name_c(TSimpleReplier)
   --  #else
   --  #define TReqTRepSimpleReplier_name_c(TReqTRep_SimpleName) concatenate(TReqTRep_SimpleName, SimpleReplier)
   --  #define TReqTRepSimpleReplier_name TReqTRepSimpleReplier_name_c(TReqTRep_SimpleName)
   --  #define TReqTRepSimpleReplier TReqTRepSimpleReplier_name_c(TReqTRep_name)
   --  #endif
   --  
   --  #define TReqTypeSupport_c(TReq) concatenate(TReq, TypeSupport)
   --  #define TReqTypeSupport TReqTypeSupport_c(TReq)
   --  
   --  #define TRepTypeSupport_c(TRep) concatenate(TRep, TypeSupport)
   --  #define TRepTypeSupport TRepTypeSupport_c(TRep)
   --  
   --  #define TRepTypeSupport_copy_data_c(TRepTypeSupport) concatenate(TRepTypeSupport, _copy_data)
   --  #define TRepTypeSupport_copy_data TRepTypeSupport_copy_data_c(TRepTypeSupport)
   --  
   --  #define TReqTypeSupport_register_type_c(TReqTypeSupport) concatenate(TReqTypeSupport, _register_type)
   --  #define TReqTypeSupport_register_type TReqTypeSupport_register_type_c(TReqTypeSupport)
   --  
   --  #define TReqTypeSupport_get_type_name_c(TReqTypeSupport) concatenate(TReqTypeSupport, _get_type_name)
   --  #define TReqTypeSupport_get_type_name TReqTypeSupport_get_type_name_c(TReqTypeSupport)
   --  
   --  #define TRepTypeSupport_register_type_c(TRepTypeSupport) concatenate(TRepTypeSupport, _register_type)
   --  #define TRepTypeSupport_register_type TRepTypeSupport_register_type_c(TRepTypeSupport)
   --  
   --  #define TRepTypeSupport_get_type_name_c(TRepTypeSupport) concatenate(TRepTypeSupport, _get_type_name)
   --  #define TRepTypeSupport_get_type_name TRepTypeSupport_get_type_name_c(TRepTypeSupport)
   --  
   --  #define TReqTRepSimpleReplier_on_data_available_c(TReqTRepSimpleReplier_name) concatenate(TReqTRepSimpleReplier_name, _on_data_available)
   --  #define TReqTRepSimpleReplier_on_data_available TReqTRepSimpleReplier_on_data_available_c(TReqTRepSimpleReplier_name)
   --  
   --  #define TReqDataReader_c(TReq) concatenate(TReq, DataReader)
   --  #define TReqDataReader TReqDataReader_c(TReq)
   --  
   --  #define TRepDataWriter_c(TRep) concatenate(TRep, DataWriter)
   --  #define TRepDataWriter TRepDataWriter_c(TRep)
   --  
   --  #define TReqSeq_c(TReq) concatenate(TReq, Seq)
   --  #define TReqSeq TReqSeq_c(TReq)
   --  
   --  #define TReqDataReader_narrow_c(TReqDataReader) concatenate(TReqDataReader, _narrow)
   --  #define TReqDataReader_narrow TReqDataReader_narrow_c(TReqDataReader)
   --  
   --  #define TRepDataWriter_narrow_c(TRepDataWriter) concatenate(TRepDataWriter, _narrow)
   --  #define TRepDataWriter_narrow TRepDataWriter_narrow_c(TRepDataWriter)
   --  
   --  #define TReqDataReader_take_c(TReqDataReader) concatenate(TReqDataReader, _take)
   --  #define TReqDataReader_take TReqDataReader_take_c(TReqDataReader)
   --  
   --  #define TReqSeq_get_length_c(TReqSeq) concatenate(TReqSeq, _get_length)
   --  #define TReqSeq_get_length TReqSeq_get_length_c(TReqSeq)
   --  
   --  #define TReqSeq_get_reference_c(TReqSeq) concatenate(TReqSeq, _get_reference)
   --  #define TReqSeq_get_reference TReqSeq_get_reference_c(TReqSeq)
   --  
   --  #define TRepDataWriter_write_w_params_c(TRepDataWriter) concatenate(TRepDataWriter, _write_w_params)
   --  #define TRepDataWriter_write_w_params TRepDataWriter_write_w_params_c(TRepDataWriter)
   --  
   --  #define TReqDataReader_return_loan_c(TReqDataReader) concatenate(TReqDataReader, _return_loan)
   --  #define TReqDataReader_return_loan TReqDataReader_return_loan_c(TReqDataReader)
   --  
   --  #define TReqTRepSimpleReplier_create_c(TReqTRepSimpleReplier_name) concatenate(TReqTRepSimpleReplier_name, _create)
   --  #define TReqTRepSimpleReplier_create TReqTRepSimpleReplier_create_c(TReqTRepSimpleReplier_name)
   --  
   --  #define TReqTRepSimpleReplier_create_w_params_c(TReqTRepSimpleReplier_name) concatenate(TReqTRepSimpleReplier_name, _create_w_params)
   --  #define TReqTRepSimpleReplier_create_w_params TReqTRepSimpleReplier_create_w_params_c(TReqTRepSimpleReplier_name)
   --  
   --  #define TReqTRepSimpleReplier_delete_c(TReqTRepSimpleReplier_name) concatenate(TReqTRepSimpleReplier_name, _delete)
   --  #define TReqTRepSimpleReplier_delete TReqTRepSimpleReplier_delete_c(TReqTRepSimpleReplier_name)
   --  
   --  #define TReqTRepSimpleReplier_get_request_datareader_c(TReqTRepSimpleReplier_name) concatenate(TReqTRepSimpleReplier_name, _get_request_datareader)
   --  #define TReqTRepSimpleReplier_get_request_datareader TReqTRepSimpleReplier_get_request_datareader_c(TReqTRepSimpleReplier_name)
   --  
   --  #define TReqTRepSimpleReplier_get_reply_datawriter_c(TReqTRepSimpleReplier_name) concatenate(TReqTRepSimpleReplier_name, _get_reply_datawriter)
   --  #define TReqTRepSimpleReplier_get_reply_datawriter TReqTRepSimpleReplier_get_reply_datawriter_c(TReqTRepSimpleReplier_name)
   --  
   --  void TReqTRepSimpleReplier_on_data_available(
   --      void* listener_data, DDS_DataReader* reader)
   --  {
   --      struct TReqSeq typed_seq = DDS_SEQUENCE_INITIALIZER;
   --      struct DDS_SampleInfoSeq info_seq = DDS_SEQUENCE_INITIALIZER;
   --      DDS_ReturnCode_t retcode = DDS_RETCODE_OK;
   --      int i = 0;
   --      TReqTRepSimpleReplier* self = (TReqTRepSimpleReplier*) listener_data;
   --  
   --      retcode = TReqTRepReplier_take_requests(
   --          (TReqTRepReplier *) self,
   --          &typed_seq, &info_seq,
   --          DDS_LENGTH_UNLIMITED);
   --  
   --      if (retcode != DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_GET_FAILURE_s,
   --                           "requests from Replier");
   --          return;
   --      }
   --  
   --      for (i = 0; i < TReqSeq_get_length(&typed_seq); ++i) {
   --          struct DDS_SampleIdentity_t id = DDS_UNKNOWN_SAMPLE_IDENTITY;
   --  
   --          TReq* sample = TReqSeq_get_reference(&typed_seq, i);
   --          struct DDS_SampleInfo* info =
   --              DDS_SampleInfoSeq_get_reference(&info_seq, i);
   --  
   --          TRep* reply = (TRep*)self->parent.simpleListener.on_request_available(
   --              &self->parent.simpleListener, (void *) sample, info);
   --  
   --          if (reply == NULL) {
   --              continue;
   --          }
   --  
   --          DDS_GUID_copy(&id.writer_guid,
   --                        &info->original_publication_virtual_guid);
   --          id.sequence_number = info->original_publication_virtual_sequence_number;
   --  
   --          retcode = TReqTRepReplier_send_reply(
   --                  (TReqTRepReplier *) self, reply, &id);
   --          if (retcode != DDS_RETCODE_OK) {
   --              DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                               "write reply");
   --          }
   --  
   --          self->parent.simpleListener.return_loan(
   --              &self->parent.simpleListener, (void*)reply);
   --      }
   --  
   --      retcode = TReqTRepReplier_return_loan(
   --          (TReqTRepReplier *) self, &typed_seq, &info_seq);
   --  
   --      if (retcode != DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                           "return loan to Replier");
   --      }
   --  }
   --  
   --  /* TODO: move out of macro */
   --  DDS_ReturnCode_t TReqTRepSimpleReplier_delete(TReqTRepSimpleReplier * self)
   --  {
   --      DDS_ReturnCode_t retcode = DDS_RETCODE_OK;
   --  
   --      /* TODO: error on precondition */
   --      if(self != NULL) {
   --          if(self->parent._impl != NULL) {
   --              RTI_Connext_EntityUntypedImpl_delete(self->parent._impl);
   --          }
   --          RTIOsapiHeap_free(self);
   --      }
   --  
   --      return retcode;
   --  }
   --  
   --  TReqTRepSimpleReplier* TReqTRepSimpleReplier_create(
   --      DDS_DomainParticipant * participant,
   --      char * service_name,
   --      RTI_Connext_SimpleReplierListener * listener)
   --  {
   --      TReqTRepSimpleReplier* replier = NULL;
   --  
   --      RTI_Connext_SimpleReplierParams params =
   --          RTI_Connext_SimpleReplierParams_INITIALIZER;
   --  
   --      params.participant = participant;
   --      params.service_name = (char *) service_name;
   --      params.simple_listener = listener;
   --  
   --      replier = TReqTRepSimpleReplier_create_w_params(&params);
   --      if(replier == NULL) {
   --          DDSLog_exception(&RTI_LOG_CREATION_FAILURE_s,
   --                           "SimpleReplier with params");
   --          return NULL;
   --      }
   --  
   --      return replier;
   --  }
   --  
   --  TReqTRepSimpleReplier* TReqTRepSimpleReplier_create_w_params(
   --      RTI_Connext_SimpleReplierParams* params)
   --  {
   --      TReqTRepSimpleReplier * replier = NULL;
   --      DDS_ReturnCode_t retCode = DDS_RETCODE_OK;
   --      struct DDS_DataReaderListener reader_listener =
   --          DDS_DataReaderListener_INITIALIZER;
   --      RTI_Connext_EntityParams entity_params;
   --  
   --      if(params == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "params");
   --          return NULL;
   --      }
   --  
   --      if (params->simple_listener == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "listener is required");
   --          return NULL;
   --      }
   --  
   --      RTIOsapiHeap_allocateStructure(&replier, TReqTRepSimpleReplier);
   --      if(replier == NULL) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "error creating a TReqTRepRequester");
   --          replier = NULL;
   --          goto finish;
   --      }
   --  
   --      replier->parent._impl = NULL;
   --      replier->parent.simpleListener = *params->simple_listener;
   --  
   --      replier->parent._impl = RTI_Connext_ReplierUntypedImpl_create();
   --      if(replier->parent._impl == NULL) {
   --          DDSLog_exception(&RTI_LOG_CREATION_FAILURE_s,
   --                           "ReplierUntypedImpl");
   --          goto finish;
   --      }
   --  
   --      reader_listener.on_data_available = TReqTRepSimpleReplier_on_data_available;
   --      reader_listener.as_listener.listener_data = replier;
   --  
   --      RTI_Connext_SimpleReplierParams_to_entityparams(params, &entity_params);
   --      retCode = RTI_Connext_ReplierUntypedImpl_initialize(
   --          replier->parent._impl,
   --          &entity_params,
   --          &TReqTypeSupport_register_type,
   --          TReqTypeSupport_get_type_name(),
   --          &TRepTypeSupport_register_type,
   --          TRepTypeSupport_get_type_name(),
   --          sizeof(TReq),
   --          &reader_listener);
   --  
   --      if(retCode != DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                           "initialize ReplierUntypedImpl");
   --          goto finish;
   --      }
   --  
   --      return replier;
   --  
   --  finish:
   --      if(replier != NULL) {
   --          TReqTRepSimpleReplier_delete(replier);
   --      }
   --      return NULL;
   --  }
   --  
   --  TReqDataReader* TReqTRepSimpleReplier_get_request_datareader(
   --      TReqTRepSimpleReplier* self)
   --  {
   --      return TReqTRepReplier_get_request_datareader((TReqTRepReplier* )self);
   --  }
   --  
   --  TRepDataWriter* TReqTRepSimpleReplier_get_reply_datawriter(
   --      TReqTRepSimpleReplier* self)
   --  {
   --      return TReqTRepReplier_get_reply_datawriter((TReqTRepReplier* )self);
   --  }
   --  
   --  #endif
   --  /* ----------------------------------------------------------------- */
   --  /* End of $Id$ */
end DDS.Request_Reply.treqtrepsimplereplier;
