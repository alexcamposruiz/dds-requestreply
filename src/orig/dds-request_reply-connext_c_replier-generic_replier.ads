with DDS.Typed_DataWriter_Generic;
with DDS.Typed_DataReader_Generic;

generic
   with package ReqDataWriter is new DDS.Typed_DataWriter_Generic (<>);
   with package ReqDataReader is new DDS.Typed_DataReader_Generic (<>);
package DDS.Request_Reply.Connext_C_Replier.Generic_REPLIER is
   package TReq renames ReqDataWRiter.Treats;
   package TRep renames ReqDataReader.Treats;

   type TReplier is new RTI_Connext_Replier with null record;
   type TReplier_Access is access all TReplier'Class;

   function Create ( Participant : DDS.DomainParticipant.Ref_Access;
                     Service_Name : DDS.String) return TReplier_Access;
   function Create_W_Params (Params  : RTI_Connext_ReplierParams) return TReplier_Access;


   function  Take_Request (Self        : not null access TReplier;
                           Request     : out TReq.Data_Type;
                           Sample_Info : out DDS.SampleInfo) return DDS.ReturnCode_T;


   function  Take_Requests (Self        : not null access TReplier;
                            Request     : out TReq.Data_Array;
                            Sample_Info : out DDS.SampleInfo_Seq.Sequence) return DDS.ReturnCode_T;

   function  Read_Request (Self        : not null access TReplier;
                           Request     : out TReq.Data_Type;
                           Sample_Info : out DDS.SampleInfo) return DDS.ReturnCode_T;

   function  Read_Requests (Self        : not null access TReplier;
                            Request     : out TReq.Data_Array;
                            Sample_Info : out DDS.SampleInfo_Seq.Sequence) return DDS.ReturnCode_T;

   function  Receive_Request (Self        : not null access TReplier;
                              Request     : out TReq.Data_Type;
                              Sample_Info : out DDS.SampleInfo;
                              Max_Wait    : DDS.Duration_T) return DDS.ReturnCode_T;

   function  Receive_Requests (Self             : not null access TReplier;
                               Request          : out TReq.Data_Array;
                               Sample_Info      : out DDS.SampleInfo_Seq.Sequence;
                               Min_Reply_Count  : DDS.long;
                               Max_Reply_Count  : DDS.long;
                               Max_Wait         : DDS.Duration_T) return DDS.ReturnCode_T;

   function Send_Reply (Self                 : not null access TReplier;
                        Reply                : TRep.Data_Type;
                        Related_Request_Info : DDS.SampleIdentity_T) return Dds.ReturnCode_T;

   function Get_Request_Datareader (Self : not null access TReplier) return DDS.DataReader.Ref_Access;

   function Get_Reply_Datawriter (Self : not null access TReplier) return DDS.DataWriter.Ref_Access;


   function Return_Loan (Self             : not null access TReplier;
                         Request          : out TReq.Data_Array;
                         Sample_Info      : out DDS.SampleInfo_Seq.Sequence) return Dds.ReturnCode_T;



end DDS.Request_Reply.Connext_C_Replier.Generic_REPLIER;
