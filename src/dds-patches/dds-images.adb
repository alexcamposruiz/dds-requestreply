--  (c) Copyright, Real-Time Innovations, $Date:: 2012-02-16 #$
--  All rights reserved.
--
--  No duplications, whole or partial, manual or electronic, may be made
--  without express written permission.  Any such copies, or
--  revisions thereof, must display this notice unaltered.
--  This code contains trade secrets of Real-Time Innovations, Inc.

with System.Address_Image;
with Interfaces.C; use Interfaces.C;

package body DDS.Images is
   use Ada.Strings.Unbounded;
   use all type Interfaces.Unsigned_8;
   function Image (Index : DDS.Natural; Item  : QosPolicyCount; Indent : Standard.String := "") return Ada.Strings.Unbounded.Unbounded_String is
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Append (Ret, Indent & Index'Img);
      Append (Ret, "=> (" & Item.Policy_Id'Img & "," & Item.Count'Img & ")");
      return Ret;
   end Image;


   function Image (Index : DDS.Natural; Item : Octet; Indent : Standard.String := "") return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Index, Indent);
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Append (Ret, Item'Img);
      return Ret;
   end Image;



   ---------
   -- Put --
   ---------
   function Image
     (Item     : RequestedIncompatibleQosStatus; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Append (Ret, Indent & "Total_Count        :" & Item.Total_Count'Img & ASCII.LF);
      Append (Ret, Indent & "Total_Count_Change :" & Item.Total_Count'Img & ASCII.LF);
      Append (Ret, Indent & "Last_Policy_Id     :" & Item.Last_Policy_Id'Img & ASCII.LF);
      Append (Ret, Indent & "Policies           :" & ASCII.LF);
      --  Append (Ret, Image (Item.Policies, Indent & "  "));
      return Ret;
   end Image;

   function Image (Item  : QosPolicyCount; Indent : Standard.String := "")
                   return Ada.Strings.Unbounded.Unbounded_String is
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Append (Ret, Indent);
      Append (Ret, Item.Policy_Id'Img & ", " & Item.Count'Img);
      return Ret;
   end Image;

   function Image
     (Item     : LivelinessChangedStatus; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Append (Ret, Indent & "(Alive_Count  =>" & Item.Alive_Count'Img & ",");
      Append (Ret, Indent & "Not_Alive_Count =>" & Item.Not_Alive_Count'Img & ",");
      Append (Ret, Indent & "Alive_Count_Change =>" & Item.Alive_Count_Change'Img & ",");
      Append (Ret, Indent & "Not_Alive_Count_Change  =>" & Item.Not_Alive_Count_Change'Img & ",");
      Append (Ret, Indent & "Last_Publication_Handle =>" & Image (Item.Last_Publication_Handle) & ")");
      return Ret;
   end Image;

   function Image
     (Item     : SampleRejectedStatus; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is


   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, Indent & "(Total_Count          =>" & Item.Total_Count'Img & ",");
         Append (Ret, Indent & "Total_Count_Change   =>" & Item.Total_Count_Change'Img & ",");
         Append (Ret, Indent & "Last_Reason          =>" & Item.Last_Reason'Img & ",");
         Append (Ret, Indent & "Last_Instance_Handle =>" & Image (Item.Last_Instance_Handle) & ")");
      end return;
   end Image;

   function Image
     (Item     : DataReaderQoS; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is

   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, Indent & "Durability             :"); Append (Ret, Image (Item.Durability)); Append (Ret, ASCII.LF);
         Append (Ret, Indent & "Deadline               :"); Append (Ret, Image (Item.Deadline)); Append (Ret, ASCII.LF);
         Append (Ret, Indent & "Latency_Budget         :"); Append (Ret, Image (Item.Latency_Budget)); Append (Ret, ASCII.LF);
         Append (Ret, Indent & "Liveliness             :"); Append (Ret, Image (Item.Liveliness)); Append (Ret, ASCII.LF);
         Append (Ret, Indent & "Reliability            :"); Append (Ret, Image (Item.Reliability)); Append (Ret, ASCII.LF);
         Append (Ret, Indent & "Destination_Order      :"); Append (Ret, Image (Item.Destination_Order)); Append (Ret, ASCII.LF);
         Append (Ret, Indent & "History                :"); Append (Ret, Image (Item.History)); Append (Ret, ASCII.LF);
         Append (Ret, Indent & "Resource_Limits        :"); Append (Ret, Image (Item.Resource_Limits)); Append (Ret, ASCII.LF);
         Append (Ret, Indent & "User_Data              :"); Append (Ret, Image (Item.User_Data)); Append (Ret, ASCII.LF);
         Append (Ret, Indent & "Ownership              :"); Append (Ret, Image (Item.Ownership)); Append (Ret, ASCII.LF);
         Append (Ret, Indent & "Time_Based_Filter      :"); Append (Ret, Image (Item.Time_Based_Filter)); Append (Ret, ASCII.LF);
         Append (Ret, Indent & "Reader_Data_Lifecycle  :"); Append (Ret, Image (Item.Reader_Data_Lifecycle)); Append (Ret, ASCII.LF);
         Append (Ret, Indent & "Reader_Resource_Limits :"); Append (Ret, Image (Item.Reader_Resource_Limits)); Append (Ret, ASCII.LF);
         Append (Ret, Indent & "Protocol               :"); Append (Ret, Image (Item.Protocol)); Append (Ret, ASCII.LF);
         Append (Ret, Indent & "Transport_Selection    :"); Append (Ret, Image (Item.Transport_Selection)); Append (Ret, ASCII.LF);
         Append (Ret, Indent & "Unicast                :"); Append (Ret, Image (Item.Unicast)); Append (Ret, ASCII.LF);
         Append (Ret, Indent & "Multicast              :"); Append (Ret, Image (Item.Multicast)); Append (Ret, ASCII.LF);
         Append (Ret, Indent & "Type_Support           :"); Append (Ret, Image (Item.Type_Support)); Append (Ret, ASCII.LF);
         Append (Ret, Indent & "Property               :"); Append (Ret, Image (Item.Property)); Append (Ret, ASCII.LF);
      end return;
   end Image;

   function Image
     (Item     : DataWriterQos; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Item, Indent);
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin

      return Ret;
   end Image;

   function Image
     (Item     : DurabilityQosPolicy; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Append (Ret, Item.Kind'Img & ", " & Item.Direct_Communication'Img);
      return Ret;
   end Image;

   function Image
     (Item     : DeadlineQosPolicy; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Image (Item.Period);
   end Image;

   function Image
     (Item     : LatencyBudgetQosPolicy; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Image (Item.Duration);
   end Image;

   function Image
     (Item     : LivelinessQosPolicy; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Image (Item.Lease_Duration);
   end Image;

   function Image
     (Item     : ReliabilityQosPolicy; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Append (Ret, Item.Kind'Img & ", " & Image (Item.Max_Blocking_Time));
      return Ret;
   end Image;

   function Image
     (Item     : DestinationOrderQosPolicy; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Append (Ret, Item.Kind'Img & ", " & Item.Scope'Img);
      return Ret;
   end Image;

   function Image
     (Item     : HistoryQosPolicy; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Append (Ret, Item.Kind'Img & ", " & Item.Depth'Img & "," & Item.Refilter'Img);
      return Ret;
   end Image;

   function Image
     (Item     : ResourceLimitsQosPolicy; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Append (Ret, Item.Max_Samples'Img &
                ", " & Item.Max_Instances'Img &
                ", " & Item.Max_Samples_Per_Instance'Img &
                ", " & Item.Initial_Samples'Img &
                ", " & Item.Initial_Instances'Img);
      return Ret;
   end Image;

   function Image
     (Item     : UserDataQosPolicy; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, "(Value =>");
         Append (Ret, Image (Item.Value));
         Append (Ret, ")");
      end return;
   end Image;

   function Image
     (Item     : OwnershipQosPolicy; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, "(Kind =>");
         Append (Ret, Image (Item.Kind));
         Append (Ret, ")");
      end return;
   end Image;

   function Image
     (Item     : TimeBasedFilterQosPolicy; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Append (Ret, Image (Item.Minimum_Separation));
      return Ret;
   end Image;

   function Image
     (Item     : ReaderDataLifecycleQosPolicy; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Append (Ret, Image (Item.Autopurge_Nowriter_Samples_Delay));
      Append (Ret, ",");
      Append (Ret, Image (Item.Autopurge_Disposed_Samples_Delay));
      return Ret;
   end Image;

   function Image
     (Item     : DataReaderResourceLimitsQosPolicy; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Append (Ret, Indent & "Max_Remote_Writers                       : " & Item.Max_Remote_Writers'Img & ASCII.LF);
      Append (Ret, Indent & "Max_Remote_Writers_Per_Instance          : " & Item.Max_Remote_Writers_Per_Instance'Img & ASCII.LF);
      Append (Ret, Indent & "Max_Samples_Per_Remote_Writer            : " & Item.Max_Samples_Per_Remote_Writer'Img & ASCII.LF);
      Append (Ret, Indent & "Max_Infos                                : " & Item.Max_Infos'Img & ASCII.LF);
      Append (Ret, Indent & "Initial_Remote_Writers                   : " & Item.Initial_Remote_Writers'Img & ASCII.LF);
      Append (Ret, Indent & "Initial_Remote_Writers_Per_Instance      : " & Item.Initial_Remote_Writers_Per_Instance'Img & ASCII.LF);
      Append (Ret, Indent & "Initial_Infos                            : " & Item.Initial_Infos'Img & ASCII.LF);
      Append (Ret, Indent & "Initial_Outstanding_Reads                : " & Item.Initial_Outstanding_Reads'Img & ASCII.LF);
      Append (Ret, Indent & "Max_Outstanding_Reads                    : " & Item.Max_Outstanding_Reads'Img & ASCII.LF);
      Append (Ret, Indent & "Max_Samples_Per_Read                     : " & Item.Max_Samples_Per_Read'Img & ASCII.LF);
      Append (Ret, Indent & "Disable_Fragmentation_Support            : " & Item.Disable_Fragmentation_Support'Img & ASCII.LF);
      Append (Ret, Indent & "Max_Fragmented_Samples                   : " & Item.Max_Fragmented_Samples'Img & ASCII.LF);
      Append (Ret, Indent & "Initial_Fragmented_Samples               : " & Item.Initial_Fragmented_Samples'Img & ASCII.LF);
      Append (Ret, Indent & "Max_Fragmented_Samples_Per_Remote_Writer : " & Item.Max_Fragmented_Samples_Per_Remote_Writer'Img & ASCII.LF);
      Append (Ret, Indent & "Max_Fragments_Per_Sample                 : " & Item.Max_Fragments_Per_Sample'Img & ASCII.LF);
      Append (Ret, Indent & "Dynamically_Allocate_Fragmented_Samples  : " & Item.Dynamically_Allocate_Fragmented_Samples'Img & ASCII.LF);
      return Ret;
   end Image;

   function Image
     (Item     : DataReaderProtocolQosPolicy; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Append (Ret, Indent & "Virtual_Guid         :" & String'(Image (Item.Virtual_Guid)));
      Append (Ret, Indent & "Rtps_Object_Id       :" & Item.Rtps_Object_Id'Img);
      --  append (ret,Indent & "Rtps_Reliable_Reader :" & image(Item.Rtps_Reliable_Reader));
      Append (Ret, Indent & "Expects_Inline_Qos   :" & Item.Expects_Inline_Qos'Img);

      Append (Ret, "<TBD>");
      return Ret;
   end Image;

   function Image
     (Item     : TransportSelectionQosPolicy; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Item, Indent);
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Append (Ret, "<TBD>");
      return Ret;
   end Image;

   function Image
     (Item     : TransportUnicastQosPolicy; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Item, Indent);
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Append (Ret, "<TBD>");
      return Ret;
   end Image;

   function Image
     (Item     : TransportMulticastQosPolicy; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Item, Indent);
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Append (Ret, "<TBD>");
      return Ret;
   end Image;

   function Image
     (Item     : TypeSupportQosPolicy; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin

      Append (Ret, System.Address_Image (Item.Plugin_Data));
      return Ret;
   end Image;

   function Image
     (Item     : PropertyQosPolicy; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Item, Indent);
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Append (Ret, "<TBD>");
      return Ret;
   end Image;

   function Image
     (Item     : ServiceQosPolicy; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Append (Ret, Item.Kind'Img);
      return Ret;
   end Image;



   function Image
     (Item     : Duration_T; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, Duration'Image (Duration (Item.Sec) + Duration (Item.Nanosec) * 0.000_0001));
      end return;
   end Image;
   function Image
     (Item     : SubscriptionMatchedStatus; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
      Ret : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Append (Ret, " (Total_Count => " & Item.Total_Count'Img & ",");
      Append (Ret, "Total_Count_Change => " & Item.Total_Count_Change'Img & ",");
      Append (Ret, "Current_Count => " & Item.Current_Count'Img & ",");
      Append (Ret, "Current_Count_Change => " & Item.Current_Count_Change'Img & ")");
      return Ret;
   end Image;

   function Image
     (Item     : Guid_T; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);

   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, "(Value => ");
         Append (Ret, Image (Item.Value));
         Append (Ret, ")");
      end return;
   end Image;

   function Image
     (Item     : RtpsReliableReaderProtocol_T; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, "(" & Image (Item.Min_Heartbeat_Response_Delay) & "," &
                   Image (Item.Max_Heartbeat_Response_Delay) & "," &
                   Image (Item.Heartbeat_Suppression_Duration) & ")");
      end return;
   end Image;

   function Image
     (Item     : Octet; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
      I   : constant Octet := Item mod 16;
      J   : constant Octet := Item / 16;
      Img : constant array (Octet'(0) .. Octet'(15)) of Character := "0123456789ABCDEF";
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, Img (J) & Img (I));
      end return;
   end Image;

   function Image
     (Item     : InstanceHandle_T; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         if Item.isValid /=  0 then
            for I in unsigned (Item.keyHash.value'First) .. unsigned'Min (unsigned (Item.keyHash.value'Last), unsigned (Item.keyHash.length)) loop
               Append (Ret, Image (Octet (Item.keyHash.value (Standard.Integer (I)))));
            end loop;
         else
            Append (Ret, "<INVALID>");
         end if;
      end return;
   end Image;


   function Image
     (Item     : RequestedDeadlineMissedStatus; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, "(Total_Count => " & Item.Total_Count'Img & ",");
         Append (Ret, "Total_Count_Change =>" & Item.Total_Count_Change'Img & ", ");
         Append (Ret, "Last_Instance_Handle =>" &  Image (Item.Last_Instance_Handle) & ")");
      end return;
   end Image;

   function Image
     (Item     : SampleLostStatusKind; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         case Item is
            when   NOT_LOST => Append (Ret, "NOT_LOST");
            when   LOST_BY_WRITER => Append (Ret, "LOST_BY_WRITER");
            when   LOST_BY_INSTANCES_LIMIT => Append (Ret, "LOST_BY_INSTANCES_LIMIT");
            when   LOST_BY_REMOTE_WRITERS_PER_INSTANCE_LIMIT => Append (Ret, "LOST_BY_REMOTE_WRITERS_PER_INSTANCE_LIMIT");
            when   LOST_BY_INCOMPLETE_COHERENT_SET => Append (Ret, "LOST_BY_INCOMPLETE_COHERENT_SET");
            when   LOST_BY_LARGE_COHERENT_SET => Append (Ret, "LOST_BY_LARGE_COHERENT_SET");
            when   LOST_BY_SAMPLES_PER_REMOTE_WRITER_LIMIT => Append (Ret, "LOST_BY_SAMPLES_PER_REMOTE_WRITER_LIMIT");
            when   LOST_BY_VIRTUAL_WRITERS_LIMIT => Append (Ret, "LOST_BY_VIRTUAL_WRITERS_LIMIT");
            when   LOST_BY_REMOTE_WRITERS_PER_SAMPLE_LIMIT => Append (Ret, "LOST_BY_REMOTE_WRITERS_PER_SAMPLE_LIMIT");
            when   LOST_BY_AVAILABILITY_WAITING_TIME => Append (Ret, "LOST_BY_AVAILABILITY_WAITING_TIME");
            when   LOST_BY_REMOTE_WRITER_SAMPLES_PER_VIRTUAL_QUEUE_LIMIT => Append (Ret, "LOST_BY_REMOTE_WRITER_SAMPLES_PER_VIRTUAL_QUEUE_LIMIT");
            when others => Append (Ret, "<Unknown Code: " & Item'Img);
         end case;

      end return;
   end Image;

   function Image
     (Item     : SampleLostStatus; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, "(Total_Count => " & Item.Total_Count'Img & ",");
         Append (Ret, "Total_Count_Change =>" & Item.Total_Count_Change'Img & ", ");
         Append (Ret, "Last_Reason =>" &  Image (Item.Last_Reason) & ")");
      end return;
   end Image;
   function Image
     (Item     : StatusKind; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
      type Bits is array (1 .. Item'Size) of Boolean;
      pragma Pack (Bits);
      type map (part : Boolean := True) is record
      case part is
         when True => s : StatusKind;
         when False => P : Bits;
      end case;
      end record;
      temp : map;
   begin
      temp.s := Item;
      return ret : Ada.Strings.Unbounded.Unbounded_String do
         for i in temp.P'Range loop -- Belen: when part is true, P is undefined
            Append (ret, (if temp.P (i) then "1" else "_"));
         end loop;
      end return;
   end Image;
   function Image
     (Item     : Long; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, Item'Img);
      end return;
   end Image;
   function Image
     (Item     : Unsigned_Long; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, Item'Img);
      end return;
   end Image;
   function Image
     (Item     : SequenceNumber_T; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String  is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, "(High => " & Image (Item.High));
         Append (Ret, ",Low => " & Image (Item.Low) & ")");
      end return;
   end Image;
   function Image
     (Item     : DDS.String; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, """" & To_Standard_String (Item) & """");
      end return;
   end Image;

   function Image
     (Item     : DDS.Locator_T; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String  is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, "(Kind =>" & Image (Item.Kind) & ", ");
         Append (Ret, "Port =>" & Image (Item.Port) & ", ");
         Append (Ret, "Address =>" & Image (Item.Address) & ", ");
         Append (Ret, "Encapsulations =>" & Image (Item.Encapsulations) & ")");
      end return;
   end Image;


   function Image
     (Item     : DDS.Locator_Address_Array_T; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String  is
      pragma Unreferenced (Indent);
      Is_First : Boolean := True;
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, "(");
         for I of Item loop
            if not Is_First then
               Append (Ret, ", ");
            else
               Is_First := False;
            end if;
            Append (Ret, Image (I));
         end loop;
         Append (Ret, ")");
      end return;
   end Image;

   function Image (Item : in EncapsulationId_T; Indent : Standard.String := "")
                   return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, Item'Img);
      end return;
   end Image;

   function Image (Index : in Natural; Item : in EncapsulationId_T; Indent : Standard.String := "")
                   return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, Image (Index));
         Append (Ret, "=> ");
         Append (Ret, Image (Item));
      end return;
   end Image;

   function Image
     (Item     : DDS.SampleIdentity_T; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, "(Writer_Guid => ");
         Append (Ret, Standard.String'(Image (Item.Writer_Guid)));
         Append (Ret, ", Sequence_Number => ");
         Append (Ret, Unbounded_String'(Image (Item.Sequence_Number)));
         Append (Ret, ")");
      end return;
   end Image;

   function Image
     (Item     : DDS.Octet_Array; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
      Is_First : Boolean := True;
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, "(");
         for I of Item loop
            if not Is_First then
               Append (Ret, ", ");
            else
               Is_First := False;
            end if;
            Append (Ret, Image (I));
         end loop;
         Append (Ret, ")");
      end return;
   end Image;

   function Image
     (Item     : DDS.SampleStateKind; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, Item'Img);
      end return;
   end Image;

   function Image
     (Item     : DDS.ViewStateKind; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, Item'Img);
      end return;
   end Image;

   function Image
     (Item     : DDS.InstanceStateKind; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, Item'Img);
      end return;
   end Image;

   function Image
     (Item     : DDS.Cookie_T; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, "(Value => ");
         Append (Ret, Image (Item.Value));
         Append (Ret, ")");
      end return;
   end Image;

   function Image
     (Item     : DDS.WriteParams_T; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String
   is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, "(Replace_Auto => ");  Append (Ret, Image (Item.Replace_Auto));
         Append (Ret, ", Identity => ");  Append (Ret, Image (Item.Identity));
         Append (Ret, ", Related_Sample_Identity => ");  Append (Ret, Image (Item.Related_Sample_Identity));
         Append (Ret, ", Source_Timestamp => ");  Append (Ret, Image (Item.Source_Timestamp));
         Append (Ret, ", Cookie => ");  Append (Ret, Image (Item.Cookie));
         Append (Ret, ", Priority => ");  Append (Ret, Image (Item.Priority));
         Append (Ret, ", Flush_on_write => ");  Append (Ret, Image (Item.Flush_On_Write));
         Append (Ret, ")");
      end return;
   end Image;

   function Image
     (Item     : DDS.OwnershipQosPolicyKind; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, Item'Img);
      end return;
   end Image;

   function Image
     (Item     : DDS.Boolean; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String  is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, Item'Img);
      end return;
   end Image;

   function Image
     (Item     : DDS.Time_T; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, ("(Sec => "));
         Append (Ret, Image (Item.Sec));
         Append (Ret, (",Nanosec => "));
         Append (Ret, Image (Item.Nanosec));
         Append (Ret, (")"));
      end return;
   end Image;

   function Image
     (Item     : DDS.RtpsWellKnownPorts_T; Indent : Standard.String  := "")
      return Ada.Strings.Unbounded.Unbounded_String is
      pragma Unreferenced (Indent);
   begin
      return Ret : Ada.Strings.Unbounded.Unbounded_String do
         Append (Ret, "(Port_Base => " & Image (Item.Port_Base));
         Append (Ret, ",Domain_Id_Gain => " & Image (Item.Domain_Id_Gain));
         Append (Ret, ",Participant_Id_Gain => " & Image (Item.Participant_Id_Gain));
         Append (Ret, (",Builtin_Multicast_Port_Offset => "));
         Append (Ret, Image (Item.Builtin_Multicast_Port_Offset));
         Append (Ret, (",Builtin_Unicast_Port_Offset => "));
         Append (Ret, Image (Item.Builtin_Unicast_Port_Offset));
         Append (Ret, (",User_Multicast_Port_Offset => "));
         Append (Ret, Image (Item.User_Multicast_Port_Offset));
         Append (Ret, (",User_Unicast_Port_Offset => "));
         Append (Ret, Image (Item.User_Unicast_Port_Offset));
         Append (Ret, (")"));
      end return;
   end Image;


end DDS.Images;
