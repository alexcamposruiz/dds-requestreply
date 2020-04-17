with DDS.Publisher;
with DDS.Subscriber;
package DDS.Request_Reply.Impl is

   type Ref is limited new Request_Reply.Ref with private;
   type Ref_Access  is access all Ref'Class;
   procedure Log_Exception (Log : Standard.String) is null;

   function Create_Request_Topic_Name_From_Service_Name
     (Self             : not null access Ref;
      Service_Name     : DDS.String) return DDS.String is
     (DDS.To_DDS_String (DDS.To_Standard_String (Service_Name) & "Request"));


   function Create_Reply_Topic_Name_From_Service_Name
     (Self             : not null access Ref;
      Service_Name     : DDS.String) return DDS.String is
     (DDS.To_DDS_String (DDS.To_Standard_String (Service_Name) & "Reply"));

   function Create_Request_Topic (Self       : not null access Ref;
                                  Topic_Name : DDS.String;
                                  Type_Name  : DDS.String) return DDS.Topic.Ref_Access;
   function Create_Reply_Topic (Self       : not null access Ref;
                                Topic_Name : DDS.String;
                                Type_Name  : DDS.String) return DDS.Topic.Ref_Access;
   function Create_Request_Topic_With_Profile (Self               : not null access Ref;
                                               Topic_Name         : DDS.String;
                                               Type_Name          : DDS.String;
                                               Qos_Library_Name   : DDS.String;
                                               Qos_Profile_Name   : DDS.String) return DDS.Topic.Ref_Access;
   function Create_Reply_Topic_With_Profile (Self               : not null access Ref;
                                             Topic_Name         : DDS.String;
                                             Type_Name          : DDS.String;
                                             Qos_Library_Name   : DDS.String;
                                             Qos_Profile_Name   : DDS.String) return DDS.Topic.Ref_Access;
   procedure Validate (Self       : not null access Ref;
                       Publisher  : DDS.Publisher.Ref_Access;
                       Subscriber : DDS.Subscriber.Ref_Access);
private
   type Ref is limited new Request_Reply.Ref with null record;

end DDS.Request_Reply.Impl;
