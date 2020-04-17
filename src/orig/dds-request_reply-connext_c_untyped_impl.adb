pragma Ada_2012;
package body DDS.Request_Reply.connext_c_untyped_impl is

   ----------------------------------------------------
   -- RTI_Connext_EntityUntypedImpl_Wait_For_Samples --
   ----------------------------------------------------

   function RTI_Connext_EntityUntypedImpl_Wait_For_Samples
     (Self              : not null access RTI_Connext_EntityUntypedImpl;
      Max_Wait          : DDS.Duration_T; Min_Sample_Count : DDS.Natural;
      Waitset           : not null DDS.WaitSet.Ref_Access;
      Initial_Condition : DDS.ReadCondition.Ref_Access;
      Condition         : DDS.ReadCondition.Ref_Access) return Dds.ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "RTI_Connext_EntityUntypedImpl_Wait_For_Samples unimplemented");
      return raise Program_Error
          with "Unimplemented function RTI_Connext_EntityUntypedImpl_Wait_For_Samples";
   end RTI_Connext_EntityUntypedImpl_Wait_For_Samples;

   -----------------------------------------------------
   -- RTI_Connext_EntityUntypedImpl_Get_Sample_Loaned --
   -----------------------------------------------------

   function RTI_Connext_EntityUntypedImpl_Get_Sample_Loaned
     (Self           : not null access RTI_Connext_EntityUntypedImpl;
      Received_Data  : System.Address; Data_Count : out DDS.Integer;
      Is_Loan        : DDS.Boolean; DataSeqContiguousBuffer : System.Address;
      Info_Seq       : not null access DDS.SampleInfo_Seq.Sequence;
      Data_Seq_Len   : DDS.long; Data_Seq_Max_Len : DDS.long;
      Ownership      : DDS.Boolean; Max_Samples : DDS.long;
      Read_Condition : DDS.ReadCondition.Ref_Access; Take : DDS.Boolean)
      return Dds.ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "RTI_Connext_EntityUntypedImpl_Get_Sample_Loaned unimplemented");
      return raise Program_Error
          with "Unimplemented function RTI_Connext_EntityUntypedImpl_Get_Sample_Loaned";
   end RTI_Connext_EntityUntypedImpl_Get_Sample_Loaned;

   -----------------------------------------------
   -- RTI_Connext_EntityUntypedImpl_Send_Sample --
   -----------------------------------------------

   function RTI_Connext_EntityUntypedImpl_Send_Sample
     (Self : not null access RTI_Connext_EntityUntypedImpl;
      Data : System.Address; Info : not null access DDS.WriteParams_T)
      return DDS.ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "RTI_Connext_EntityUntypedImpl_Send_Sample unimplemented");
      return raise Program_Error
          with "Unimplemented function RTI_Connext_EntityUntypedImpl_Send_Sample";
   end RTI_Connext_EntityUntypedImpl_Send_Sample;

   -------------------------------------------------------
   -- RTI_Connext_EntityUntypedImpl_wait_for_any_sample --
   -------------------------------------------------------

   function RTI_Connext_EntityUntypedImpl_wait_for_any_sample
     (Self     : not null access RTI_Connext_EntityUntypedImpl;
      max_wait : Duration_t; Min_Sample_Count : Integer) return DDS
     .ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "RTI_Connext_EntityUntypedImpl_wait_for_any_sample unimplemented");
      return raise Program_Error
          with "Unimplemented function RTI_Connext_EntityUntypedImpl_wait_for_any_sample";
   end RTI_Connext_EntityUntypedImpl_wait_for_any_sample;

   -----------------------------------------------
   -- RTI_Connext_EntityUntypedImpl_Return_Loan --
   -----------------------------------------------

   function RTI_Connext_EntityUntypedImpl_Return_Loan
     (Self      : not null access RTI_Connext_EntityUntypedImpl;
      dataArray : System.Address;
      Info_Seq  : not null access SampleInfo_Seq.Sequence) return DDS
     .ReturnCode_T
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "RTI_Connext_EntityUntypedImpl_Return_Loan unimplemented");
      return raise Program_Error
          with "Unimplemented function RTI_Connext_EntityUntypedImpl_Return_Loan";
   end RTI_Connext_EntityUntypedImpl_Return_Loan;

   --------------------------------------------------
   -- RTI_Connext_EntityUntypedImpl_Get_Datawriter --
   --------------------------------------------------

   function RTI_Connext_EntityUntypedImpl_Get_Datawriter
     (Self : not null access RTI_Connext_EntityUntypedImpl)
      return DDS.DataWriter.Ref_Access
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "RTI_Connext_EntityUntypedImpl_Get_Datawriter unimplemented");
      return raise Program_Error
          with "Unimplemented function RTI_Connext_EntityUntypedImpl_Get_Datawriter";
   end RTI_Connext_EntityUntypedImpl_Get_Datawriter;

   --------------------------------------------------
   -- RTI_Connext_EntityUntypedImpl_Get_Datareader --
   --------------------------------------------------

   function RTI_Connext_EntityUntypedImpl_Get_Datareader
     (Self : not null access RTI_Connext_EntityUntypedImpl)
      return DDS.DataReader.Ref_Access
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "RTI_Connext_EntityUntypedImpl_Get_Datareader unimplemented");
      return raise Program_Error
          with "Unimplemented function RTI_Connext_EntityUntypedImpl_Get_Datareader";
   end RTI_Connext_EntityUntypedImpl_Get_Datareader;

   ------------------------------------------
   -- RTI_Connext_EntityUntypedImpl_Delete --
   ------------------------------------------

   function RTI_Connext_EntityUntypedImpl_Delete
     (Self : RTI_Connext_EntityUntypedImpl_Access) return ReturnCode_t
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "RTI_Connext_EntityUntypedImpl_Delete unimplemented");
      return raise Program_Error
          with "Unimplemented function RTI_Connext_EntityUntypedImpl_Delete";
   end RTI_Connext_EntityUntypedImpl_Delete;

   -----------------------------------------------------------
   -- RTI_Connext_EntityUntypedImpl_Validate_Receive_Params --
   -----------------------------------------------------------

   function RTI_Connext_EntityUntypedImpl_Validate_Receive_Params
     (Self        : not null access RTI_Connext_EntityUntypedImpl;
      METHOD_NAME : Standard.String; Min_Count : long; Max_Count : long;
      Max_Wait    : Duration_T) return Boolean
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "RTI_Connext_EntityUntypedImpl_Validate_Receive_Params unimplemented");
      return raise Program_Error
          with "Unimplemented function RTI_Connext_EntityUntypedImpl_Validate_Receive_Params";
   end RTI_Connext_EntityUntypedImpl_Validate_Receive_Params;

end DDS.Request_Reply.connext_c_untyped_impl;
