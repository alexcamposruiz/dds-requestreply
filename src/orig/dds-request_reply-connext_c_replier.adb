pragma Ada_2012;
package body DDS.Request_Reply.Connext_C_Replier is

   --------------------------------
   -- RTI_Connext_Replier_Delete --
   --------------------------------

   function RTI_Connext_Replier_Delete
     (Self : RTI_Connext_Replier_Access) return DDS.ReturnCode_T
   is
   begin
      return raise Program_Error with "Unimplemented function RTI_Connext_Replier_Delete";
   end RTI_Connext_Replier_Delete;

   -------------------------------------------
   -- RTI_Connext_Replier_Wait_For_Requests --
   -------------------------------------------

   function RTI_Connext_Replier_Wait_For_Requests
     (Self     : access RTI_Connext_Replier; Min_Count : DDS.Integer;
      Max_Wait : DDS.Duration_T) return DDS.ReturnCode_T
   is
   begin
      return raise Program_Error with "Unimplemented function RTI_Connext_Replier_Wait_For_Requests";
   end RTI_Connext_Replier_Wait_For_Requests;

   -------------------------------------------
   -- RTI_Connext_ReplierUntypedImpl_create --
   -------------------------------------------

   function RTI_Connext_ReplierUntypedImpl_create
     return RTI_Connext_ReplierUntypedImpl_Access
   is
   begin
      return raise Program_Error with "Unimplemented function RTI_Connext_ReplierUntypedImpl_create";
   end RTI_Connext_ReplierUntypedImpl_create;

   -----------------------------------------------
   -- RTI_Connext_ReplierUntypedImpl_Initialize --
   -----------------------------------------------

   function RTI_Connext_ReplierUntypedImpl_Initialize
     (Self : RTI_Connext_ReplierUntypedImpl; Params : RTI_Connext_EntityParams;
      Request_Type_Name : DDS.String; Reply_Type_Name : DDS.String;
      Request_Size      : DDS.Integer;
      Reader_Listener   : DDS.DataReaderListener.Ref_Access) return DDS
     .ReturnCode_T
   is
   begin
      return raise Program_Error with "Unimplemented function RTI_Connext_ReplierUntypedImpl_Initialize";
   end RTI_Connext_ReplierUntypedImpl_Initialize;

   ------------------------------------------------
   -- RTI_Connext_ReplierUntypedImpl_send_sample --
   ------------------------------------------------

   function RTI_Connext_ReplierUntypedImpl_send_sample
     (Self                 : RTI_Connext_ReplierUntypedImpl;
      Data                 : Interfaces.C.Extensions.Void_Ptr;
      Related_Request_Info : DDS.SampleIdentity_T;
      WriteParams          : DDS.WriteParams_T) return DDS.ReturnCode_T
   is
   begin
      return raise Program_Error
          with "Unimplemented function RTI_Connext_ReplierUntypedImpl_send_sample";
   end RTI_Connext_ReplierUntypedImpl_send_sample;

   ----------------------------------------------
   -- RTI_Connext_ReplierParams_toEntityParams --
   ----------------------------------------------

   function RTI_Connext_ReplierParams_toEntityParams
     (Self              : not null access RTI_Connext_ReplierParams;
      ToParams          : out RTI_Connext_EntityParams) return DDS.ReturnCode_T
   is
      pragma Unreferenced (ToParams);
   begin
      return raise Program_Error with "Unimplemented function RTI_Connext_ReplierParams_toEntityParams";
   end RTI_Connext_ReplierParams_toEntityParams;

end DDS.Request_Reply.Connext_C_Replier;
