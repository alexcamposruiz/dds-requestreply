with DDS.DomainParticipantListener;
with DDS.Treats_Generic;
with DDS.Entity;
with DDS.DomainParticipant;
with DDS.TopicListener;
with DDS.Topic;
with DDS.DomainParticipantFactory;
package DDS.Request_Reply is

   type Ref is limited interface;
   type Ref_Access  is access all Ref'Class;
   procedure DDSLog_Exception (Log : Standard.String) is null;

--     function Create_Request_Topic_Name_From_Service_Name
--       (Self             : not null access Ref'Class;
--        Service_Name     : DDS.String) return DDS.String is abstract;
--
--
--     function Create_Reply_Topic_Name_From_Service_Name
--       (Self             : not null access Ref'Class;
--        Service_Name     : DDS.String) return DDS.String is abstract;
end DDS.Request_Reply;
