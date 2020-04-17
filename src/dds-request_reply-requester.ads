with DDS.ReadCondition;
with DDS.DataReader;
with DDS.DataWriter;
with DDS.Topic;
with DDS.Entity_Params;
with DDS.Request_Reply;
package DDS.Request_Reply.Requester is
   type Ref is limited interface and DDS.Request_Reply.Ref;
   type Ref_Access is access all Ref'Class;


   function Get_Request_Data_Writer
     (Self : not null access Ref)
      return DDS.DataWriter.Ref_Access is abstract;

   function Get_Reply_Data_Reader
     (Self : not null access Ref)
      return DDS.DataReader.Ref_Access is abstract;

   function Touch_Samples
     (Self           : not null access Ref;
      Max_Count      : DDS.Integer;
      Read_Condition : DDS.ReadCondition.Ref_Access) return Integer is abstract;

   function Wait_For_Any_Sample
     (Self             : not null access Ref;
      Max_Wait         : DDS.Duration_T;
      Min_Sample_Count : DDS.Integer) return DDS.ReturnCode_T is abstract;

   function Create_Request_Topic_Name_From_Service_Name
     (Self             : not null access Ref;
      Service_Name     : DDS.String) return DDS.String is abstract;

   function Create_Reply_Topic_Name_From_Service_Name
     (Self             : not null access Ref;
      Service_Name     : DDS.String) return DDS.String is abstract;

end DDS.Request_Reply.Requester;
