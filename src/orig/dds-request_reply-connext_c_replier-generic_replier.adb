pragma Ada_2012;
package body DDS.Request_Reply.Connext_C_Replier.Generic_REPLIER is

   use type DDS.ReturnCode_T;

   With_Warnings : constant boolean := False;

   --  =========================================================================
   --  =========================================================================
   --
   --  DDS_ReturnCode_t TReqTRepReplier_loan_or_copy_samplesI(
   --      TReqTRepReplier * self,
   --      DDS_ReturnCode_t inRetCode,
   --      struct TReqSeq* received_data,
   --      DDS_Boolean isLoan,
   --      void **dataPtrArray,
   --      int dataCount,
   --      struct DDS_SampleInfoSeq* info_seq)
   --  {
   --      DDS_ReturnCode_t result = inRetCode;
   --
   --      if (inRetCode == DDS_RETCODE_NO_DATA) {
   --          TReqSeq_set_length(received_data, 0);
   --          goto done;
   --      }
   --
   --      if (inRetCode != DDS_RETCODE_OK) {
   --          goto done;
   --      }
   --
   --      if (isLoan) {
   --          /* loan buffer to sequence */
   --          if (!TReqSeq_loan_discontiguous(received_data,
   --                                          (TReq **)dataPtrArray, dataCount,
   --                                          dataCount)) {
   --              /* this should never happen */
   --              result = DDS_RETCODE_ERROR;
   --              /* since we failed to loan data to data seq, but data is already
   --                 taken, we will need to return it still.
   --                 Note that data will be lost in this case */
   --              RTI_Connext_EntityUntypedImpl_return_loan(
   --                  self->parent._impl, dataPtrArray, info_seq);
   --          }
   --      } else {
   --          /* data is already copied to dataSeqContiguousBuffer */
   --          if (!TReqSeq_set_length(received_data, dataCount)) {
   --              /* this should never happen */
   --              result = DDS_RETCODE_ERROR;
   --          }
   --      }
   --
   --    done:
   --
   --    return result;
   --  }
   function Loan_Or_Copy_SamplesI
     (Self          : TReplier;
      InRetCode     : DDS.ReturnCode_T;
      Received_Data : not null access ReqDataReader.Treats.Data_Sequences.Sequence;
      IsLoan        : DDS.Boolean;
      DataPtrArray  : not null access ReqDataReader.Treats.Data_Array;
      DataCount     : ReqDataReader.Treats.Index_Type;
      Info_Seq      : DDS.SampleInfo_Seq.Sequence) return DDS.ReturnCode_T is
      Result : DDS.ReturnCode_T := InRetCode;
      use ReqDataReader.Treats.Data_Sequences;
   begin
      if InRetCode = DDS.RETCODE_NO_DATA  then
         Set_Length (Received_Data, 0);
         return Result;
      end if;
      if IsLoan then
         -- /* loan buffer to sequence */
         pragma Compile_Time_Warning (With_Warnings, "Check");
         --           Loan_Discontiguous (Self => Received_Data,
         --                               Buffer => ReqDataReader.Treats.Element_Access'(DataPtrArray.all (DataPtrArray.all'First)'Access),
         --                               New_Length => DataCount,
         --                               New_Max    => DataCount);
         Set_Length (Received_Data, DataCount);
      end if;
      return DDS.RETCODE_OK;
   exception
      when others =>
         return Result;
         -- RTI.Connext_EntityUntypedImpl_Return_Loan (Self.Parent, DataPtrArray, Info_Seq);
   end;


   --  =========================================================================
   --  =========================================================================
   --  DDS_ReturnCode_t TReqTRepReplier_take_request(
   --      TReqTRepReplier* self,
   --      TReq * request,
   --      struct DDS_SampleInfo * sample_info)
   --  {
   --      DDS_ReturnCode_t retCode = DDS_RETCODE_OK;
   --
   --      struct DDS_SampleInfoSeq info_seq = DDS_SEQUENCE_INITIALIZER;
   --      void ** data = NULL;
   --      int count = 0;
   --      DDS_Boolean isLoan = DDS_BOOLEAN_TRUE;
   --
   --      if(self == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "self");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --      if(request == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "request");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --      if(sample_info == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "sample_info");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --      sample_info->valid_data = DDS_BOOLEAN_FALSE;
   --
   --      /* No read condition, get any reply */
   --      retCode = RTI_Connext_EntityUntypedImpl_get_sample_loaned(
   --          self->parent._impl,
   --          &data,
   --          &count,
   --          &isLoan,
   --          NULL,
   --          &info_seq,
   --          (DDS_Long)0, /* dataSeqLen */
   --          (DDS_Long)0, /* dataSeqMaxLen */
   --          DDS_BOOLEAN_TRUE, /* dataSeqHasOwnership */
   --          1,
   --          NULL,
   --          RTI_TRUE);
   --
   --      if (retCode != DDS_RETCODE_OK) {
   --          if (retCode != DDS_RETCODE_NO_DATA ) {
   --              DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                               "get sample");
   --          }
   --          return retCode;
   --      }
   --
   --      retCode = TReqTypeSupport_copy_data(request, *((TReq**)data));
   --      if(retCode != DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                           "copy sample");
   --          goto done;
   --      }
   --
   --      if(DDS_SampleInfoSeq_get_length(&info_seq) != 0) {
   --          /* TODO: implement copy function? */
   --          *sample_info = DDS_SampleInfoSeq_get(&info_seq, 0);
   --      }
   --
   --    done:
   --      RTI_Connext_EntityUntypedImpl_return_loan(self->parent._impl, data, &info_seq);
   --      return retCode;
   --  }
   ------------------
   -- Take_Request --
   ------------------

   function Take_Request
     (Self        : not null access TReplier;
      Request     : out TReq.Data_Type;
      Sample_Info : out DDS.SampleInfo) return DDS.ReturnCode_T
   is
      RetCode : ReturnCode_T;
      --
   --      struct DDS_SampleInfoSeq info_seq = DDS_SEQUENCE_INITIALIZER;
   --      void ** data = NULL;
   --      int count = 0;
   --      DDS_Boolean isLoan = DDS_BOOLEAN_TRUE;

   begin

            sample_info.valid_data := False;
   --
   --      /* No read condition, get any reply */
   --      retCode = RTI_Connext_EntityUntypedImpl_get_sample_loaned(
   --          self->parent._impl,
   --          &data,
   --          &count,
   --          &isLoan,
   --          NULL,
   --          &info_seq,
   --          (DDS_Long)0, /* dataSeqLen */
   --          (DDS_Long)0, /* dataSeqMaxLen */
   --          DDS_BOOLEAN_TRUE, /* dataSeqHasOwnership */
   --          1,
   --          NULL,
   --          RTI_TRUE);

       if (retCode /= DDS.RETCODE_OK) then
           if (retCode /= DDS.RETCODE_NO_DATA ) then
            DDSLog_Exception ("get sample");
         end if;
           return retCode;
       end if;
   --
   --      retCode = TReqTypeSupport_copy_data(request, *((TReq**)data));
   --      if(retCode != DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                           "copy sample");
   --          goto done;
   --      }
   --
   --      if(DDS_SampleInfoSeq_get_length(&info_seq) != 0) {
   --          /* TODO: implement copy function? */
   --          *sample_info = DDS_SampleInfoSeq_get(&info_seq, 0);
   --      }
   --
   --    done:
   --      RTI_Connext_EntityUntypedImpl_return_loan(self->parent._impl, data, &info_seq);
   --      return retCode;
      pragma Compile_Time_Warning (Standard.True,
                                   "Take_Request unimplemented");
      return raise Program_Error with "Unimplemented function Take_Request";
   end Take_Request;

   --
   --  /* TODO: do checking on params */
   --  DDS_ReturnCode_t TReqTRepReplier_take_requests(
   --      TReqTRepReplier* self,
   --      struct TReqSeq* requests,
   --      struct DDS_SampleInfoSeq * info_seq,
   --      DDS_Long max_request_count)
   --  {
   --
   --      DDS_Long dataSeqLen = 0;
   --      DDS_Long dataSeqMaxLen = 0;
   --      DDS_Boolean dataSeqHasOwnership = DDS_BOOLEAN_FALSE;
   --      DDS_Boolean isLoan = DDS_BOOLEAN_TRUE;
   --      void **dataPtrArray = NULL;
   --      int dataCount = 0;
   --      DDS_ReturnCode_t result = DDS_RETCODE_OK;
   --      TReq *dataSeqContiguousBuffer = NULL;
   --
   --      /* --- Check parameters --- */
   --      if (requests == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "requests is NULL");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --
   --      /* --- get dataSeq information --- */
   --      dataSeqLen = TReqSeq_get_length(requests);
   --      dataSeqMaxLen = TReqSeq_get_maximum(requests);
   --      dataSeqHasOwnership = TReqSeq_has_ownership(requests);
   --      dataSeqContiguousBuffer = TReqSeq_get_contiguous_bufferI(requests);
   --
   --      result = RTI_Connext_EntityUntypedImpl_get_sample_loaned(
   --          self->parent._impl,
   --          &dataPtrArray,
   --          &dataCount,
   --          &isLoan,
   --          (void*)dataSeqContiguousBuffer,
   --          info_seq,
   --          dataSeqLen,
   --          dataSeqMaxLen,
   --          dataSeqHasOwnership,
   --          max_request_count,
   --          NULL,
   --          RTI_TRUE);
   --
   --      result = TReqTRepReplier_loan_or_copy_samplesI(
   --          self, result, requests,
   --          isLoan, dataPtrArray, dataCount, info_seq);
   --
   --      if(result != DDS_RETCODE_OK && result != DDS_RETCODE_NO_DATA) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --              "error loan or copying data");
   --      }
   --
   --      return result;
   --  }
   -------------------
   -- Take_Requests --
   -------------------

   function Take_Requests
     (Self        : not null access TReplier;
      Request     : out TReq.Data_Array;
      Sample_Info : out DDS.SampleInfo_Seq.Sequence) return DDS.ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
                                   "Take_Requests unimplemented");
      return raise Program_Error with "Unimplemented function Take_Requests";
   end Take_Requests;

   --  =========================================================================
   --  =========================================================================
   --
   --  DDS_ReturnCode_t TReqTRepReplier_read_request(
   --      TReqTRepReplier* self,
   --      TReq * request,
   --      struct DDS_SampleInfo * sample_info)
   --  {
   --      DDS_ReturnCode_t retCode = DDS_RETCODE_OK;
   --
   --      struct DDS_SampleInfoSeq info_seq = DDS_SEQUENCE_INITIALIZER;
   --      void ** data = NULL;
   --      int count = 0;
   --      DDS_Boolean isLoan = DDS_BOOLEAN_TRUE;
   --
   --      if(self == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "self");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --      if(request == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "request");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --      if(sample_info == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "sample_info");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --      sample_info->valid_data = DDS_BOOLEAN_FALSE;
   --
   --      /* No read condition, get any reply */
   --      retCode = RTI_Connext_EntityUntypedImpl_get_sample_loaned(
   --          self->parent._impl,
   --          &data,
   --          &count,
   --          &isLoan,
   --          NULL,
   --          &info_seq,
   --          (DDS_Long)0, /* dataSeqLen */
   --          (DDS_Long)0, /* dataSeqMaxLen */
   --          DDS_BOOLEAN_TRUE, /* dataSeqHasOwnership */
   --          1,
   --          NULL,
   --          RTI_FALSE);
   --
   --      if (retCode != DDS_RETCODE_OK) {
   --          if (retCode != DDS_RETCODE_NO_DATA ) {
   --              DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                               "get sample");
   --          }
   --          return retCode;
   --      }
   --
   --      retCode = TReqTypeSupport_copy_data(request, *((TReq**)data));
   --      if(retCode != DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                           "copy sample");
   --          goto done;
   --      }
   --
   --      if(DDS_SampleInfoSeq_get_length(&info_seq) != 0) {
   --          /* TODO: implement copy function? */
   --          *sample_info = DDS_SampleInfoSeq_get(&info_seq, 0);
   --      }
   --
   --    done:
   --      RTI_Connext_EntityUntypedImpl_return_loan(self->parent._impl, data, &info_seq);
   --      return retCode;
   --  }
   --
   ------------------
   -- Read_Request --
   ------------------

   function Read_Request
     (Self        : not null access TReplier;
      Request     : out TReq.Data_Type;
      Sample_Info : out DDS.SampleInfo) return DDS.ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
                                   "Read_Request unimplemented");
      return raise Program_Error with "Unimplemented function Read_Request";
   end Read_Request;

   --  =========================================================================
   --  =========================================================================
   --  /* TODO: do checking on params */
   --  DDS_ReturnCode_t TReqTRepReplier_read_requests(
   --      TReqTRepReplier* self,
   --      struct TReqSeq* requests,
   --      struct DDS_SampleInfoSeq * info_seq,
   --      DDS_Long max_request_count)
   --  {
   --
   --      DDS_Long dataSeqLen = 0;
   --      DDS_Long dataSeqMaxLen = 0;
   --      DDS_Boolean dataSeqHasOwnership = DDS_BOOLEAN_FALSE;
   --      DDS_Boolean isLoan = DDS_BOOLEAN_TRUE;
   --      void **dataPtrArray = NULL;
   --      int dataCount = 0;
   --      DDS_ReturnCode_t result = DDS_RETCODE_OK;
   --      TReq *dataSeqContiguousBuffer = NULL;
   --
   --      /* --- Check parameters --- */
   --      if (requests == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "requests is NULL");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --
   --      /* --- get dataSeq information --- */
   --      dataSeqLen = TReqSeq_get_length(requests);
   --      dataSeqMaxLen = TReqSeq_get_maximum(requests);
   --      dataSeqHasOwnership = TReqSeq_has_ownership(requests);
   --      dataSeqContiguousBuffer = TReqSeq_get_contiguous_bufferI(requests);
   --
   --      result = RTI_Connext_EntityUntypedImpl_get_sample_loaned(
   --          self->parent._impl,
   --          &dataPtrArray,
   --          &dataCount,
   --          &isLoan,
   --          (void*)dataSeqContiguousBuffer,
   --          info_seq,
   --          dataSeqLen,
   --          dataSeqMaxLen,
   --          dataSeqHasOwnership,
   --          max_request_count,
   --          NULL,
   --          RTI_FALSE);
   --
   --      result = TReqTRepReplier_loan_or_copy_samplesI(
   --          self, result, requests,
   --          isLoan, dataPtrArray, dataCount, info_seq);
   --
   --      if(result != DDS_RETCODE_OK && result != DDS_RETCODE_NO_DATA) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --              "error loan or copying data");
   --      }
   --
   --      return result;
   --  }
   ------------------
   -- Read_Request --
   ------------------

   function Read_Requests
     (Self        :     not null access TReplier;
      Request     : out TReq.Data_Type;
      Sample_Info : out DDS.SampleInfo) return DDS.ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
                                   "Read_Request unimplemented");
      return raise Program_Error with "Unimplemented function Read_Request";
   end Read_Requests;


   --  =========================================================================
   --  =========================================================================
   --
   --  DDS_ReturnCode_t TReqTRepReplier_receive_request(
   --      TReqTRepReplier * self,
   --      TReq * request,
   --      struct DDS_SampleInfo * sample_info,
   --      const struct DDS_Duration_t * max_wait)
   --  {
   --      DDS_ReturnCode_t retCode = DDS_RETCODE_OK;
   --
   --      if(self == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "self");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --      if(request == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "request");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --      if(sample_info == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "sample_info");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --      if(max_wait == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "max_wait");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --      sample_info->valid_data = DDS_BOOLEAN_FALSE;
   --
   --      retCode = RTI_Connext_Replier_wait_for_requests(
   --          (RTI_Connext_Replier *) self, 1, max_wait);
   --      if (retCode != DDS_RETCODE_OK) {
   --          if (retCode != DDS_RETCODE_TIMEOUT) {
   --              DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                               "wait for requests");
   --          }
   --          return retCode;
   --      }
   --
   --      retCode = TReqTRepReplier_take_request(self, request, sample_info);
   --      if (retCode != DDS_RETCODE_OK) {
   --          if (retCode != DDS_RETCODE_NO_DATA) {
   --              DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                               "get request");
   --          }
   --          return retCode;
   --      }
   --
   --      return DDS_RETCODE_OK;
   --  }
   ---------------------
   -- Receive_Request --
   ---------------------

   function Receive_Request
     (Self        :     not null access TReplier; Request : out TReq.Data_Type;
      Sample_Info : out DDS.SampleInfo; Max_Wait : DDS.Duration_T) return DDS
     .ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
                                   "Receive_Request unimplemented");
      return raise Program_Error with "Unimplemented function Receive_Request";
   end Receive_Request;


   --  =========================================================================
   --  =========================================================================
   --
   --  DDS_ReturnCode_t TReqTRepReplier_receive_requests(
   --      TReqTRepReplier * self,
   --      struct TReqSeq * requests,
   --      struct DDS_SampleInfoSeq * info_seq,
   --      DDS_Long min_count,
   --      DDS_Long max_count,
   --      const struct DDS_Duration_t * max_wait)
   --  {
   --      DDS_ReturnCode_t retCode = DDS_RETCODE_OK;
   --
   --      if(self == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "self");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --      if(requests == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "requests");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --      if(info_seq == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "info_seq");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --      if(max_wait == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "max_wait");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --
   --      if (!RTI_Connext_EntityUntypedImpl_validate_receive_params(
   --          self->parent._impl, RTI_FUNCTION_NAME, min_count, max_count, max_wait)) {
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --
   --      retCode = RTI_Connext_Replier_wait_for_requests(
   --          (RTI_Connext_Replier *) self, min_count, max_wait);
   --      if (retCode != DDS_RETCODE_OK) {
   --          if (retCode != DDS_RETCODE_TIMEOUT) {
   --              DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                               "wait for requests");
   --          }
   --          return retCode;
   --      }
   --
   --      retCode = TReqTRepReplier_take_requests(
   --          self, requests, info_seq, max_count);
   --      if (retCode != DDS_RETCODE_OK) {
   --          if (retCode != DDS_RETCODE_NO_DATA) {
   --              DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                               "get requests");
   --          }
   --          return retCode;
   --      }
   --
   --      return DDS_RETCODE_OK;
   --  }
   --
   ----------------------
   -- Receive_Requests --
   ----------------------

   function Receive_Requests
     (Self            :     not null access TReplier; Request : out TReq.Data_Array;
      Sample_Info     : out DDS.SampleInfo_Seq.Sequence;
      Min_Reply_Count :     DDS.long; Max_Reply_Count : DDS.long;
      Max_Wait        :     DDS.Duration_T) return DDS.ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
                                   "Receive_Requests unimplemented");
      return raise Program_Error
        with "Unimplemented function Receive_Requests";
   end Receive_Requests;

   -------------------
   -- Read_Requests --
   -------------------

   function Read_Requests
     (Self        : not null access TReplier; Request : out TReq.Data_Array;
      Sample_Info : out DDS.SampleInfo_Seq.Sequence) return DDS.ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
                                   "Read_Requests unimplemented");
      return raise Program_Error with "Unimplemented function Read_Requests";
   end Read_Requests;


   --  =========================================================================
   --  =========================================================================
   --  /* TODO: add TReqTRepReplier_send_reply_w_params API */
   --  DDS_ReturnCode_t TReqTRepReplier_send_reply(
   --      TReqTRepReplier* self,
   --      TRep* reply,
   --      const struct DDS_SampleIdentity_t * related_request_id)
   --  {
   --      DDS_ReturnCode_t retCode = DDS_RETCODE_OK;
   --      struct DDS_WriteParams_t params = DDS_WRITEPARAMS_DEFAULT;
   --
   --      if(self == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "self");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --      if(reply == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "reply");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --      if(related_request_id == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "related_request_id");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --
   --      retCode = RTI_Connext_ReplierUntypedImpl_send_sample(
   --          self->parent._impl, (void*)reply, related_request_id, &params);
   --
   --      if(retCode != DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                           "send reply");
   --      }
   --      return retCode;
   --  }

   ----------------
   -- Send_Reply --
   ----------------

   function Send_Reply
     (Self                 : not null access TReplier; Reply : TRep.Data_Type;
      Related_Request_Info : DDS.SampleIdentity_T) return Dds.ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True, "Send_Reply unimplemented");
      return raise Program_Error with "Unimplemented function Send_Reply";
   end Send_Reply;

   --  =========================================================================
   --  =========================================================================
   --
   --  TRepDataWriter* TReqTRepReplier_get_reply_datawriter(TReqTRepReplier* self)
   --  {
   --
   --      DDS_DataWriter * internal_writer = NULL;
   --
   --      if(self == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "self");
   --          return NULL;
   --      }
   --
   --      internal_writer = RTI_Connext_EntityUntypedImpl_get_datawriter(self->parent._impl);
   --      if(internal_writer == NULL) {
   --          DDSLog_exception(&RTI_LOG_GET_FAILURE_s,
   --                           "reply DataWriter");
   --          return NULL;
   --      }
   --
   --      return TRepDataWriter_narrow(internal_writer);
   --  }
   ----------------------------
   --  Get_Reply_Datawriter  --
   ----------------------------
   function Get_Reply_Datawriter
     (Self : not null access TReplier) return DDS.DataWriter.Ref_Access
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
                                   "Get_Reply_Datawriter unimplemented");
      return raise Program_Error
        with "Unimplemented function Get_Reply_Datawriter";
   end Get_Reply_Datawriter;

   --  =========================================================================
   --  =========================================================================
   --
   --  TReqDataReader * TReqTRepReplier_get_request_datareader(TReqTRepReplier* self)
   --  {
   --
   --      DDS_DataReader* internal_reader = NULL;
   --
   --      if(self == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "self");
   --          return NULL;
   --      }
   --
   --      internal_reader = RTI_Connext_EntityUntypedImpl_get_datareader(self->parent._impl);
   --      if(internal_reader == NULL) {
   --          DDSLog_exception(&RTI_LOG_GET_FAILURE_s,
   --                           "request DataReader");
   --          return NULL;
   --      }
   --
   --      return TReqDataReader_narrow(internal_reader);
   --  }
   ----------------------------
   -- Get_Request_Datareader --
   ----------------------------

   function Get_Request_Datareader
     (Self : not null access TReplier) return DDS.DataReader.Ref_Access
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
                                   "Get_Request_Datareader unimplemented");
      return raise Program_Error
        with "Unimplemented function Get_Request_Datareader";
   end Get_Request_Datareader;




   --  =========================================================================
   --  =========================================================================
   --
   --  DDS_ReturnCode_t TReqTRepReplier_return_loan(
   --      TReqTRepReplier* self,
   --      struct TReqSeq *replies,
   --      struct DDS_SampleInfoSeq *info_seq)
   --  {
   --      DDS_ReturnCode_t retCode = DDS_RETCODE_OK;
   --      TReqDataReader * reader = NULL;
   --
   --      if(self == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "self");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --      if(replies == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "replies");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --      if(info_seq == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "info_seq");
   --          return DDS_RETCODE_BAD_PARAMETER;
   --      }
   --
   --      reader = TReqTRepReplier_get_request_datareader(self);
   --      if (reader == NULL) {
   --          DDSLog_exception(&RTI_LOG_GET_FAILURE_s,
   --                           "reader to return loan");
   --          return DDS_RETCODE_ERROR;
   --      }
   --
   --      retCode = TReqDataReader_return_loan(reader, replies, info_seq);
   --      if(retCode != DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                           "return loan");
   --          return retCode;
   --      }
   --
   --      return retCode;
   --  }
   -----------------
   -- Return_Loan --
   -----------------

   function Return_Loan
     (Self        : not null access TReplier; Request : out TReq.Data_Array;
      Sample_Info : out DDS.SampleInfo_Seq.Sequence) return Dds.ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True, "Return_Loan unimplemented");
      return raise Program_Error with "Unimplemented function Return_Loan";
   end Return_Loan;
   --
   --  /* ----------------------------------------------------------------- */
   --  /* End of $Id$ */
   Dummy : Integer;

   --  =========================================================================
   --  =========================================================================
   --
   --  TReqTRepReplier * TReqTRepReplier_create(
   --      DDS_DomainParticipant * participant,
   --      char* service_name)
   --  {
   --      TReqTRepReplier* replier = NULL;
   --
   --      RTI_Connext_ReplierParams params = RTI_Connext_ReplierParams_INITIALIZER;
   --
   --      params.participant = participant;
   --      params.service_name = (char*) service_name;
   --
   --      replier = TReqTRepReplier_create_w_params(&params);
   --      if(replier == NULL) {
   --          DDSLog_exception(&RTI_LOG_CREATION_FAILURE_s,
   --                           "replier with params");
   --          return NULL;
   --      }
   --
   --      return replier;
   --  }
   ------------
   -- Create --
   ------------
   function Create
     (Participant  : DDS.DomainParticipant.Ref_Access;
      Service_Name : DDS.String) return TReplier_Access
   is
      Params : RTI_Connext_ReplierParams;

   begin
      return Ret : TReplier_Access do
         Params.Participant := Participant;
         DDS.Copy (Params.Service_Name, Service_Name);
         Ret := Create_W_Params (Params);
         if Ret = null then
            raise Constraint_Error with "unable to create Replier";
         end if;
      end return;

   end Create;


   --  =========================================================================
   --  =========================================================================
   --
   --  TReqTRepReplier* TReqTRepReplier_create_w_params(
   --      const RTI_Connext_ReplierParams* params)
   --  {
   --      TReqTRepReplier* replier = NULL;
   --      struct DDS_DataReaderListener reader_listener =
   --          DDS_DataReaderListener_INITIALIZER;
   --      RTI_Connext_EntityParams entity_params;
   --      DDS_ReturnCode_t retcode;
   --
   --      if(params == NULL) {
   --          DDSLog_exception(&DDS_LOG_BAD_PARAMETER_s,
   --                           "params");
   --          return NULL;
   --      }
   --
   --      RTIOsapiHeap_allocateStructure(&replier, TReqTRepReplier);
   --      if(replier == NULL) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --              "error creating a TReqTRepReplier");
   --          goto finish;
   --      }
   --
   --      if (params->listener != NULL) {
   --          replier->parent.listener = *params->listener;
   --      } else {
   --          replier->parent.listener.on_request_available = NULL;
   --      }
   --
   --      replier->parent._impl = RTI_Connext_ReplierUntypedImpl_create();
   --      if(replier->parent._impl == NULL) {
   --          DDSLog_exception(&RTI_LOG_CREATION_FAILURE_s,
   --                           "ReplierUntypedImpl");
   --          goto finish;
   --      }
   --
   --      RTI_Connext_ReplierParams_toEntityParams(params, &entity_params);
   --
   --      reader_listener.on_data_available = RTI_Connext_Replier_on_data_available;
   --      reader_listener.as_listener.listener_data = replier;
   --
   --      retcode = RTI_Connext_ReplierUntypedImpl_initialize(
   --          replier->parent._impl,
   --          &entity_params,
   --          &TReqTypeSupport_register_type,
   --          TReqTypeSupport_get_type_name(),
   --          &TRepTypeSupport_register_type,
   --          TRepTypeSupport_get_type_name(),
   --          sizeof(TReq),
   --          params->listener != NULL ? &reader_listener : NULL);
   --
   --      if (retcode != DDS_RETCODE_OK) {
   --          DDSLog_exception(&RTI_LOG_ANY_FAILURE_s,
   --                           "initialize ReplierUntypedImpl");
   --          goto finish;
   --      }
   --
   --      return replier;
   --
   --  finish:
   --      if(replier != NULL) {
   --          RTI_Connext_Replier_delete((RTI_Connext_Replier *) replier);
   --      }
   --      return NULL;
   --  }
   --
   ---------------------
   -- Create_W_Params --
   ---------------------
   function Create_W_Params
     (Params      : RTI_Connext_ReplierParams) return TReplier_Access
   is
      RetCode : Dds.ReturnCode_T;
      Replier : TReplier_Access;
   begin
      Replier := new TReplier;
      if Params.Listener /= null then
         Replier.Listener := Params.Listener;
      end if;
      RetCode := RTI_Connext_ReplierParams_ToEntityParams (Params, Ret.Entity_Params);
      --      reader_listener.on_data_available = RTI_Connext_Replier_on_data_available;
      --      reader_listener.as_listener.listener_data = replier;
      return Replier;
   end Create_W_Params;











   --------------------------
   -- Get_Reply_Datawriter --
   --------------------------





end DDS.Request_Reply.Connext_C_Replier.Generic_REPLIER;
