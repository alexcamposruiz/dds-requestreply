with DDS.DataReader_Impl;
with DDS.DataReaderListener;
with DDS.DataWriter_Impl;
with DDS.DomainParticipant;
with DDS.Publisher;
with DDS.ReadCondition;
with DDS.Subscriber;
with DDS.WaitSet;
with Dds.Topic;
with DDS.TopicDescription;
with Interfaces.C.Extensions;
with RTIDDS.Low_Level.Ndds_Reda_Reda_FastBuffer_H;
with Ada.Finalization;
with System;
with DDS.Request_Reply.Connext_C_Entity_Params; use DDS.Request_Reply.Connext_C_Entity_Params;

package DDS.Request_Reply.Untypedcommon is

   use Dds;
   
   type RTI_Connext_EntityUntypedImpl is abstract new Ada.Finalization.Limited_Controlled with record
      Participant  : DDS.DomainParticipant.Ref_Access;
      Publisher    : DDS.Publisher.Ref_Access;
      Subscriber   : DDS.Subscriber.Ref_Access;
      Writer_Topic : DDS.Topic.Ref_Access;
      Reader_Topic : DDS.TopicDescription.Ref_Access;
   
      Writer       : DDS.DataWriter_Impl.Ref_Access;
      Reader       : DDS.DataReader_Impl.Ref_Access;
   
      Waitset      : DDS.WaitSet.Ref_Access;
      Not_Read_Sample_Cond : DDS.ReadCondition.Ref_Access;
      Any_Sample_Cond : DDS.ReadCondition.Ref_Access;
   
      Sample_Size  : DDS.long := -1;
      -- waitset_pool : RTIDDS.Low_Level.ndds_reda_reda_fastBuffer_h.REDAFastBufferPool;
      Waitset_Pool : Interfaces.C.Extensions.Void_Ptr;
   
      Max_Samples_Per_Read : DDS.long;
      
   end record;
   type RTI_Connext_EntityUntypedImpl_Access is access all RTI_Connext_EntityUntypedImpl'Class;
   
   function RTI_Connext_CreateWriterTopicFunc
     (Self   : access RTI_Connext_EntityUntypedImpl;
      Params : access RTI_Connext_EntityParams;
      Name   : DDS.String) return DDS.TopicDescription.Ref_Access is abstract;

   function Create_Writer_Topic
     (Self   : access RTI_Connext_EntityUntypedImpl;
      Params : access RTI_Connext_EntityParams;
      Name   : DDS.String) return DDS.TopicDescription.Ref_Access is  abstract;
   

   function RTI_Connext_Get_Or_Create_Topic 
     (Participant : DDS.DomainParticipant.Ref_Access;
      Name        : DDS.String;
      Type_Name   : DDS.String;
      Allow_Cft   : DDS.Boolean) return DDS.TopicDescription.Ref_Access
   is (Participant.Get_Or_Create_Topic (Name, Type_Name).As_Topicdescription);

   
  
   function RTI_Connext_Create_Request_Topic_Name_From_Service_Name (Service_Name : DDS.String) return DDS.String is
     (DDS.To_DDS_String (DDS.To_Standard_String (Service_Name) & "Request"));
                                                                      

   function RTI_Connext_Create_Reply_Topic_Name_From_Service_Name (Service_Name : DDS.String) return DDS.String is
     (DDS.To_DDS_String (DDS.To_Standard_String (Service_Name) & "Reply"));

   

   --  
   function RTI_Connext_EntityUntypedImpl_Initialize (Self             : in out RTI_Connext_EntityUntypedImpl;
                                                      Params           : RTI_Connext_EntityParams;                                                      
                                                      Writer_Type_Name : DDS.String;
                                                      Reader_Type_Name : DDS.String;
                                                      Sample_Size      : DDS.long;
                                                      Reader_Listener  : DDS.DataReaderListener.Ref_Access;
                                                      Role_Name        : DDS.String) return DDS.ReturnCode_T;
   
   
   function RTI_Connext_EntityUntypedImpl_Touch_Samples
     (Self           : not null access RTI_Connext_EntityUntypedImpl;
      Max_Count      : DDS.Integer;
      Read_Condition : DDS.ReadCondition.Ref_Access) return Integer;
   
      
   

   function RTI_Connext_EntityUntypedImpl_Wait_For_Any_Sample
     (Self             : not null access RTI_Connext_EntityUntypedImpl;
      Max_Wait         : DDS.Duration_T;
      Min_Sample_Count : DDS.Integer) return DDS.ReturnCode_T;

   
   function RTI_Connext_EntityUntypedImpl_Get_Sample_Loaned_W_Len
     (Self                    : not null access RTI_Connext_EntityUntypedImpl;
      Received_Data           : System.Address;
      Data_Count              : in out DDS.Natural;
      Is_Loan                 : in out DDS.Boolean;
      DataSeqContiguousBuffer : System.Address;
      Info_Seq                : not null access DDS.SampleInfo_Seq.Sequence;
      Data_Seq_Len            : DDS.long;
      Data_Seq_Max_Len        : DDS.long;
      Data_Seq_Has_Ownership  : DDS.Boolean;
      Max_Samples             : DDS.long;
      Read_Condition          : DDS.ReadCondition.Ref_Access;
      Take                    : DDS.Boolean) return DDS.ReturnCode_T;

   function RTI_Connext_SimpleReplierParams_To_Entityparams
     (Self : RTI_Connext_EntityParams'Class;
      ToParams : out RTI_Connext_EntityParams) return ReturnCode_T;
   function To_Entityparams
     (Self : RTI_Connext_EntityParams'Class;
      ToParams : out RTI_Connext_EntityParams) return ReturnCode_T renames RTI_Connext_SimpleReplierParams_To_Entityparams;
                                
end DDS.Request_Reply.Untypedcommon;
