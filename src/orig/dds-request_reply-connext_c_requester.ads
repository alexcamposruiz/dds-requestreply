with DDS.DataReader;
with DDS.DataWriter;
with Interfaces.C.Extensions;
with DDS.DomainParticipant;
with DDS.Publisher;
with DDS.Subscriber;
with DDS.Request_Reply.Untypedcommon; 
with DDS.Request_Reply.Connext_C_Entity_Params;

package DDS.Request_Reply.Connext_C_Requester is
   use Untypedcommon;
   use Connext_C_Entity_Params;
   DEFAULT_MAX_WAIT : constant DDS.Duration_T := DDS.To_Duration_T (1.0);

   type RTI_Connext_RequesterUntypedImpl is abstract new  RTI_Connext_EntityUntypedImpl with null record;
   type RTI_Connext_RequesterUntypedImpl_Access is access all RTI_Connext_RequesterUntypedImpl;
   
   function RTI_Connext_RequesterUntypedImpl_Wait_For_Replies
     (Self                 : not null access RTI_Connext_RequesterUntypedImpl;
      Max_Wait             : DDS.Duration_T := DEFAULT_MAX_WAIT;
      Min_Sample_Count     : DDS.Natural := 1;
      Related_Request_Info : DDS.SampleIdentity_T) return DDS.ReturnCode_T;
   
   function RTI_Connext_RequesterUntypedImpl_get_request_datawriter
     (Self : not null access RTI_Connext_RequesterUntypedImpl)
      return DDS.DataWriter.Ref_Access is
     (DDS.DataWriter.Ref_Access (Self.Writer));

   --  =========================================================================
   --  =========================================================================
   --  extern XMQCDllExport
   --  DDS_DataReader* RTI_Connext_RequesterUntypedImpl_get_request_datareader(
   --      RTI_Connext_RequesterUntypedImpl * self);
   function RTI_Connext_RequesterUntypedImpl_Get_Request_Datareader
     (Self : not null access RTI_Connext_RequesterUntypedImpl) 
      return DDS.DataReader.Ref_Access is
     (DDS.DataReader.Ref_Access (Self.Reader));
   
   
   type RTI_Connext_Requester is abstract new RTI_Connext_RequesterUntypedImpl with record 
      null;
   end record;
   
   
   
   type RTI_Connext_RequesterParams is record
      Participant        : DDS.DomainParticipant.Ref_Access;
      Service_Name       : DDS.String;
      Request_Topic_Name : DDS.String;
      Reply_Topic_Name   : DDS.String;
      Qos_Library_Name   : DDS.String;
      Qos_Profile_Name   : DDS.String;
      Datawriter_Qos     : DDS.DataWriterQos;
      Datareader_Qos     : DDS.DataReaderQos;
      Publisher          : DDS.Publisher.Ref_Access;
      Subscriber         : DDS.Subscriber.Ref_Access;      
   end record;
   
   function RTI_Connext_Requester_Delete (Self : RTI_Connext_Requester)return DDS.ReturnCode_T;

   
   function RTI_Connext_Requester_Wait_For_Replies 
     (Self      : RTI_Connext_Requester;
      Min_Count : DDS.long;
      Max_Wait  : DDS.Duration_T)return DDS.ReturnCode_T;
   
   

   
   function RTI_Connext_Requester_Wait_For_Replies_For_Related_Request 
     (Self               : RTI_Connext_Requester;
      Min_Count          : DDS.long;
      Max_Wait           : DDS.Duration_T;
      Related_Request_Id : DDS.SampleIdentity_T) return DDS.ReturnCode_T;
   
   

   function RTI_Connext_RequesterParams_To_RTI_Connext_EntityParams
     (Self : not null access RTI_Connext_RequesterParams;
      ToParams : out RTI_Connext_EntityParams) return DDS.ReturnCode_T;
   
   --  =========================================================================
   --  =========================================================================
   --  extern XMQCDllExport
   function RTI_Connext_RequesterUntypedImpl_Create
     (Params : RTI_Connext_RequesterParams;
      Request_Type_Name : DDS.String;
      Reply_Type_Name   : DDS.String;
      reply_size : DDS.Integer) return RTI_Connext_RequesterUntypedImpl_Access;
                                                     
   -- RTI_Connext_RequesterUntypedImpl_create(
   --      const RTI_Connext_RequesterParams * params,
   --      RegisterTypeFunc _request_type_fnc,
   --      const char * request_type_name,
   --      RegisterTypeFunc _reply_type_fnc,
   --      const char * reply_type_name,
   --      int reply_size);
   
   
   --  =========================================================================
   --  =========================================================================
   --  extern XMQCDllExport
   --  DDS_ReturnCode_t RTI_Connext_RequesterUntypedImpl_delete(
   --     RTI_Connext_RequesterUntypedImpl* self);
   
   --  =========================================================================
   --  =========================================================================
   --  extern XMQCDllExport
   --  DDS_ReturnCode_t RTI_Connext_RequesterUntypedImpl_wait_for_replies(
   --      RTI_Connext_RequesterUntypedImpl * self,
   --      const struct DDS_Duration_t * max_wait,
   --      int min_sample_count,
   --      const struct DDS_SampleIdentity_t* related_request_info);

   
   
   
   --  =========================================================================
   --  =========================================================================
   --  extern XMQCDllExport
   --  DDS_ReturnCode_t RTI_Connext_RequesterUntypedImpl_get_reply_loaned(
   --      RTI_Connext_RequesterUntypedImpl * self,
   --      void *** received_data,
   --      int * data_count,
   --      DDS_Boolean* is_loan,
   --      void* dataSeqContiguousBuffer,
   --      struct DDS_SampleInfoSeq* info_seq,
   --      DDS_Long data_seq_len,
   --      DDS_Long data_seq_max_len,
   --      DDS_Boolean ownership,
   --      DDS_Long max_samples,
   --      const struct DDS_SampleIdentity_t* related_request_id,
   --      RTIBool take);
   
   
   
   --  =========================================================================
   --  =========================================================================
   --  extern XMQCDllExport
   --  DDS_DataWriter* RTI_Connext_RequesterUntypedImpl_get_request_datawriter(
   --      RTI_Connext_RequesterUntypedImpl * self);

end DDS.Request_Reply.Connext_C_Requester;
