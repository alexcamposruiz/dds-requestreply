--  (c) Copyright, Real-Time Innovations, $Date;: 2012-10-31 #$
--  All rights reserved.
--
--  No duplications, whole or partial, manual or electronic, may be made
--  without express written permission.  Any such copies, or
--  revisions thereof, must display this notice unaltered.
--  This code contains trade secrets of Real-Time Innovations, Inc.

with Ada.Unchecked_Deallocation;

with Ada.Calendar;
with Ada.Real_Time;
with Interfaces;
private with Interfaces.C;
with Interfaces.C.Strings;

with DDS_Support;
with DDS_Support.Sequences_Generic;

with System;

private with RTIDDS.Low_Level.ndds_dds_c_dds_c_subscription_h;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_publication_h;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h;
private with RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_common_h;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_flowcontroller_h;
with RTIDDS.Low_Level.ndds_ndds_config_c_h;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_builtin_impl_h;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_typecode_h;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_typeobject_h;
with RTIDDS.Low_Level.ndds_pres_pres_common_impl_h;
with RTIDDS.Low_Level.ndds_osapi_osapi_hash_h;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_topic_h;
with Ada.Finalization;
with RTIDDS.Low_Level.ndds_reda_reda_fastBuffer_h;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_sqlfilter_h;
with RTIDDS.Low_Level.ndds_pres_pres_participant_h;
with RTIDDS.To_Chars_Ptr;
--  with Rtidds.Annotations; use Rtidds.Annotations;

pragma Elaborate_All (DDS_Support.Sequences_Generic);

--  <module name="DDSInfrastructureModule" actualName="Infrastructure Module">InfrastructureGroupDocs</module>
package DDS is
   use RTIDDS.Low_Level.ndds_ndds_config_c_h;


   --  Note that this package dependes heavely on the underlaying C implementation
   --  and will change when a full Ada implementation is avalible.
   --
   --  Worth to notice is that erros from the underlaying midlleware is
   --  translated to exceptions, since there is no posibillity to ignore
   --  function returns in Ada.
   --
   --  From osapi_types.h
   --

   Binding_Version : constant Standard.String := "5.10";

   --  -------------------------------------------------
   --                 CDR Primitive Types
   --  -------------------------------------------------

   type    Short              is new Interfaces.C.short;
   --  <defgroup>CdrGroupDocs</defgroup>
   --  <dref>Short</dref>

   type    Long               is new Interfaces.C.int;
   --  <dref>Long</dref>

   subtype Integer  is Long;
   subtype Natural  is Integer range 0 .. Integer'Last;
   subtype Positive is Integer range 1 .. Integer'Last;

   type Long_Long          is new Interfaces.Integer_64;
   --  <dref>LongLong</dref>

   type Unsigned_Short     is new Interfaces.Unsigned_16;
   --  <dref>UnsignedShort</dref>

   type Unsigned_Long      is new Interfaces.Unsigned_32;
   --  <dref>UnsignedLong</dref>

   type Unsigned_Long_Long is new Interfaces.Unsigned_64;
   --  <dref>UnsignedLongLong</dref>

   type Enum               is new Interfaces.Unsigned_32;
   --  <dref>CdrEnum</dref>

   type Float           is new Interfaces.IEEE_Float_32;
   --  <dref>Float</dref>

   type Double          is new Interfaces.IEEE_Float_64;
   --  <dref>Double</dref>

   type Long_Double     is new Interfaces.IEEE_Extended_Float;
   --  <dref>LongDouble</dref>

   subtype Char            is Standard.Character;
   --  <dref>Char</dref>

   subtype Wchar           is Standard.Wide_Character;
   --  <dref>Wchar</dref>

   subtype Octet           is Interfaces.Unsigned_8;
   --  <dref>Octet</dref>
   INFINITE : constant := -1;
   type Octets is record
      Length : Integer;
      Value  : System.Address;
   end record with
     Convention => C;
   --  <dref>Octets</dref>
   --  <dref name="length">Octets_length</dref>
   --  <dref name="value">Octets_value</dref>

   Null_Octets : constant Octets := (0, System.Null_Address);
   subtype Boolean         is Standard.Boolean;
   --  <dref>Boolean</dref>

   --  subtype String          is Interfaces.C.Strings.chars_ptr;

   type String  is limited record
      Data  : aliased Interfaces.C.Strings.chars_ptr := Interfaces.C.Strings.Null_Ptr;
      pragma Obsolescent (Data, "This is internal data and not to be referenced outside the DDS hierachy:" &
                            "use Operations on the whole record instead!");
   end record with
     Convention => C;
   --  <dref>String</dref>

   function Length (Item : String) return Natural;
   function "=" (L : DDS.String; R : Standard.String) return Standard.Boolean;
   function "=" (L : Standard.String; R : DDS.String) return Standard.Boolean;
   function "&" (L : DDS.String; R : Standard.String) return Standard.String;
   function "&" (L : Standard.String; R : DDS.String) return Standard.String;
   procedure Append (To : in out DDS.String; Data : DDS.String);
   procedure Append (To : in out DDS.String; Data : Standard.String);

   procedure Prepend (To : in out DDS.String; Data : DDS.String);
   procedure Prepend (To : in out DDS.String; Data : Standard.String);



   type KeyedString is record
      Key   : DDS.String;
      Value : DDS.String;
   end record with
     Convention => C;
   --  <dref>KeyedString</dref>
   --  <dref name="key">KeyedString_key</dref>
   --  <dref name="value">KeyedString_value</dref>

   type KeyedOctets is record
      Key    : DDS.String;
      Value  : Octets;
   end record with
     Convention => C;
   --  <dref>KeyedOctets</dref>
   --  <dref name="key">KeyedOctets_key</dref>
   --  <dref name="length">KeyedOctets_length</dref>
   --  <dref name="value">KeyedOctets_value</dref>


   NULL_STRING     : constant DDS.String := (Data => Interfaces.C.Strings.Null_Ptr);

   type Wchars_Ptr is access all Standard.Wide_Character
      with Convention => C;

   type Wide_String is limited record
      Data : Wchars_Ptr;
   end record with
     Convention => C;

   --  <dref>Wstring</dref>

   function WValue (Item : Wchars_Ptr) return Interfaces.C.char16_array;
   function "+" (Left : Wchars_Ptr; Right : Interfaces.C.size_t) return Wchars_Ptr;
   function Peek (From : Wchars_Ptr) return Standard.Wide_Character;

   --  Pointers on the previous types

   type    Short_Ptr              is access all Short;
   type    Long_Ptr               is access all Long;
   type    Long_Long_Ptr          is access all Long_Long;
   type    Unsigned_Short_Ptr     is access all Unsigned_Short;
   type    Unsigned_Long_Ptr      is access all Unsigned_Long;
   type    Unsigned_Long_Long_Ptr is access all Unsigned_Long_Long;
   type    Enum_Ptr               is access all Enum;
   type    Float_Ptr              is access all Float;
   type    Double_Ptr             is access all Double;
   type    Long_Double_Ptr        is access all Long_Double;
   type    Char_Ptr               is access all Char;
   type    Wchar_Ptr              is access all Wchar;
   type    Octet_Ptr              is access all Octet;
   type    Octets_Ptr             is access all Octets;
   type    Boolean_Ptr            is access all Boolean;
   type    String_Ptr             is access all String;
   type    KeyedString_Ptr        is access all KeyedString;
   type    KeyedOctets_Ptr        is access all KeyedOctets;
   type    Wide_String_Ptr        is access all Wide_String;

   --  ... and deallocation method for each pointer type

   procedure Deallocate is new Ada.Unchecked_Deallocation (Short, Short_Ptr);
   procedure Deallocate is new Ada.Unchecked_Deallocation (Long, Long_Ptr);
   procedure Deallocate is new Ada.Unchecked_Deallocation (Long_Long, Long_Long_Ptr);
   procedure Deallocate is new Ada.Unchecked_Deallocation (Unsigned_Short, Unsigned_Short_Ptr);
   procedure Deallocate is new Ada.Unchecked_Deallocation (Unsigned_Long, Unsigned_Long_Ptr);
   procedure Deallocate is new Ada.Unchecked_Deallocation (Unsigned_Long_Long, Unsigned_Long_Long_Ptr);
   procedure Deallocate is new Ada.Unchecked_Deallocation (Enum, Enum_Ptr);
   procedure Deallocate is new Ada.Unchecked_Deallocation (Float, Float_Ptr);
   procedure Deallocate is new Ada.Unchecked_Deallocation (Double, Double_Ptr);
   procedure Deallocate is new Ada.Unchecked_Deallocation (Long_Double, Long_Double_Ptr);
   procedure Deallocate is new Ada.Unchecked_Deallocation (Char, Char_Ptr);
   procedure Deallocate is new Ada.Unchecked_Deallocation (Wchar, Wchar_Ptr);
   procedure Deallocate is new Ada.Unchecked_Deallocation (Octet, Octet_Ptr);
   procedure Deallocate is new Ada.Unchecked_Deallocation (Boolean, Boolean_Ptr);
   procedure Deallocate is new Ada.Unchecked_Deallocation (String, String_Ptr);
   procedure Deallocate is new Ada.Unchecked_Deallocation (Wide_String, Wide_String_Ptr);

   DOMAIN_ID_MAX : constant := 250;

   type DomainId_T is new Long range 0 .. DOMAIN_ID_MAX
     with Default_Value => 0;
   --  <dref>DomainId_t</dref>

   Default_Domain  : constant DomainId_T := 0;

   --
   --  From dds_c/dds_c_infrastructure.h
   --

   --  -------------------------------------------------
   --                 CDR Primitive Types Array and Sequences
   --  -------------------------------------------------

   type Short_Array is array (Natural range <>) of aliased Short;
   procedure Initialize (Self  : in out Short);
   procedure Finalize (Self  : in out Short);
   procedure Copy (Dst : in out Short; Src : in Short);
   package Short_Seq is new DDS_Support.Sequences_Generic
     (Short,
      Short_Ptr,
      DDS.Natural,
      1,
      Short_Array);
   --  <defgroup>SequenceGroupDocs</defgroup>
   --  <dref>ShortSeq</dref>

   type Long_Array is array (Natural range <>) of aliased Long;
   procedure Initialize (Self  : in out Long);
   procedure Finalize (Self  : in out Long);
   procedure Copy (Dst : in out Long; Src : in Long);
   package Long_Seq is new DDS_Support.Sequences_Generic
     (Long,
      Long_Ptr,
      DDS.Natural,
      1,
      Long_Array);
   --  <dref>LongSeq</dref>

   type Long_Long_Array is array (Natural range <>) of aliased Long_Long;

   procedure Initialize (Self  : in out Long_Long);
   procedure Finalize (Self  : in out Long_Long);
   procedure Copy (Dst : in out Long_Long; Src : in Long_Long);
   package Long_Long_Seq is new DDS_Support.Sequences_Generic
     (Long_Long,
      Long_Long_Ptr,
      DDS.Natural,
      1,
      Long_Long_Array);
   --  <dref>LongLongSeq</dref>

   type Unsigned_Short_Array is array (Natural range <>) of aliased Unsigned_Short;
   procedure Initialize (Self  : in out Unsigned_Short);
   procedure Finalize (Self  : in out Unsigned_Short);
   procedure Copy (Dst : in out Unsigned_Short; Src : in Unsigned_Short);
   package Unsigned_Short_Seq is new DDS_Support.Sequences_Generic
     (Unsigned_Short,
      Unsigned_Short_Ptr,
      DDS.Natural,
      1,
      Unsigned_Short_Array);
   --  <dref>UnsignedShortSeq</dref>

   type Unsigned_Long_Array is array (Natural range <>) of aliased Unsigned_Long;
   procedure Initialize (Self  : in out Unsigned_Long);
   procedure Finalize (Self  : in out Unsigned_Long);
   procedure Copy (Dst : in out Unsigned_Long; Src : in Unsigned_Long);
   package Unsigned_Long_Seq is new DDS_Support.Sequences_Generic
     (Unsigned_Long,
      Unsigned_Long_Ptr,
      DDS.Natural,
      1,
      Unsigned_Long_Array);
   --  <dref>UnsignedLongSeq</dref>

   type Unsigned_Long_Long_Array is array (Natural range <>) of aliased Unsigned_Long_Long;
   procedure Initialize (Self  : in out Unsigned_Long_Long);
   procedure Finalize (Self  : in out Unsigned_Long_Long);
   procedure Copy (Dst : in out Unsigned_Long_Long; Src : in Unsigned_Long_Long);
   package Unsigned_Long_Long_Seq is new DDS_Support.Sequences_Generic
     (Unsigned_Long_Long,
      Unsigned_Long_Long_Ptr,
      DDS.Natural,
      1,
      Unsigned_Long_Long_Array);
   --  <dref>UnsignedLongLongSeq</dref>

   type Enum_Array is array (Natural range <>) of aliased Enum;
   procedure Initialize (Self  : in out Enum);
   procedure Finalize (Self  : in out Enum);
   procedure Copy (Dst : in out Enum; Src : in Enum);
   package Enum_Seq is new DDS_Support.Sequences_Generic
     (Enum,
      Enum_Ptr,
      DDS.Natural,
      1,
      Enum_Array);

   type Float_Array is array (Natural range <>) of aliased Float;
   procedure Initialize (Self  : in out Float);
   procedure Finalize (Self  : in out Float);
   procedure Copy (Dst : in out Float; Src : in Float);
   package Float_Seq is new DDS_Support.Sequences_Generic
     (Float,
      Float_Ptr,
      DDS.Natural,
      1,
      Float_Array);
   --  <dref>FloatSeq</dref>

   type Double_Array is array (Natural range <>) of aliased Double;
   procedure Initialize (Self  : in out Double);
   procedure Finalize (Self  : in out Double);
   procedure Copy (Dst : in out Double; Src : in Double);
   package Double_Seq is new DDS_Support.Sequences_Generic
     (Double,
      Double_Ptr,
      DDS.Natural,
      1,
      Double_Array);
   --  <dref>DoubleSeq</dref>

   type Long_Double_Array is array (Natural range <>) of aliased Long_Double;
   procedure Initialize (Self  : in out Long_Double);
   procedure Finalize (Self  : in out Long_Double);
   procedure Copy (Dst : in out Long_Double; Src : in Long_Double);
   package Long_Double_Seq is new DDS_Support.Sequences_Generic
     (Long_Double,
      Long_Double_Ptr,
      DDS.Natural,
      1,
      Long_Double_Array);
   --  <dref>LongDoubleSeq</dref>

   type Char_Array is array (Natural range <>) of aliased Char;
   procedure Initialize (Self  : in out Char);
   procedure Finalize (Self  : in out Char);
   procedure Copy (Dst : in out Char; Src : in Char);
   package Char_Seq is new DDS_Support.Sequences_Generic
     (Char,
      Char_Ptr,
      DDS.Natural,
      1,
      Char_Array);
   --  <dref>CharSeq</dref>

   type Wchar_Array is array (Natural range <>) of aliased Wchar;
   procedure Initialize (Self  : in out Wchar);
   procedure Finalize (Self  : in out Wchar);
   procedure Copy (Dst : in out Wchar; Src : in Wchar);
   package Wchar_Seq is new DDS_Support.Sequences_Generic
     (Wchar,
      Wchar_Ptr,
      DDS.Natural,
      1,
      Wchar_Array);
   --  <dref>WcharSeq</dref>

   type Octet_Array is array (Natural range <>) of aliased Octet;
   pragma Convention (C, Octet_Array);
   procedure Initialize (Self  : in out Octet);
   procedure Finalize (Self  : in out Octet);
   procedure Copy (Dst : in out Octet; Src : in Octet);
   package Octet_Seq is new DDS_Support.Sequences_Generic
     (Octet,
      Octet_Ptr,
      DDS.Natural,
      1,
      Octet_Array);
   --  <dref>OctetSeq</dref>

   function Octets_Of (Item : Octet_Array) return Octets is
     (Octets'(Length =>  Item'Length, Value => Item (Item'First)'Address));
   function Octets_Of (Item : Octet_Seq.Sequence) return Octets is
     (Octets'(Length =>  Item.Length, Value => Item.Contiguous_Buffer.all'Address));


   type Octets_Array is array (Natural range <>) of aliased Octets;
   pragma Convention (C, Octets_Array);
   procedure Initialize (Self : in out Octets);
   procedure Finalize (Self : in out Octets);
   procedure Copy (Dst : in out Octets; Src : in Octets);
   package Octets_Seq is new DDS_Support.Sequences_Generic
     (Octets,
      Octets_Ptr,
      DDS.Natural,
      1,
      Octets_Array);
   --  <dref>OctetsSeq</dref>

   type Boolean_Array is array (Natural range <>) of aliased Boolean;
   procedure Initialize (Self  : in out Boolean);
   procedure Finalize (Self  : in out Boolean);
   procedure Copy (Dst : in out Boolean; Src : in Boolean);
   package Boolean_Seq is new DDS_Support.Sequences_Generic
     (Boolean,
      Boolean_Ptr,
      DDS.Natural,
      1,
      Boolean_Array);
   --  <dref>BooleanSeq</dref>

   function To_DDS_String (Source : Standard.String) return DDS.String is
     (Data => RTIDDS.To_Chars_Ptr (Source));
   function To_Standard_String (Source : DDS.String) return Standard.String;


   procedure Copy (Dst : in out DDS.String; Src : in Standard.String);
   procedure Copy (Dst : in out Standard.String; Src : in DDS.String);
   function "=" (L, R  : DDS.String) return Boolean;

   type String_Array is array (Natural range <>) of aliased DDS.String;
   procedure Initialize (Self  : in out DDS.String);
   procedure Finalize (Self  : in out DDS.String);
   procedure Copy (Dst : in out DDS.String; Src : in DDS.String);
   package String_Seq is new DDS_Support.Sequences_Generic
     (DDS.String,
      String_Ptr,
      DDS.Natural,
      1,
      String_Array);
   --  <dref>StringSeq</dref>

   function To_DDS_KeyedString (Key : Standard.String; Source : Standard.String) return DDS.KeyedString;
   function To_Standard_String (Source : DDS.KeyedString) return Standard.String;
   function Get_Key_From_KeyedString (Source : DDS.KeyedString) return Standard.String;
   function "=" (L, R  : DDS.KeyedString) return Boolean;

   type KeyedString_Array is array (Natural range <>) of aliased DDS.KeyedString;
   procedure Initialize (Self  : in out DDS.KeyedString);
   procedure Finalize (Self  : in out DDS.KeyedString);
   procedure Copy (Dst : in out DDS.KeyedString; Src : in DDS.KeyedString);
   package KeyedString_Seq is new DDS_Support.Sequences_Generic
     (DDS.KeyedString,
      KeyedString_Ptr,
      DDS.Natural,
      1,
      KeyedString_Array);
   --  <dref>KeyedStringSeq</dref>

   function KeyedString_Of (Value : DDS.String; Key : DDS.String) return KeyedString;
   function KeyedString_Of (Key : DDS.String) return KeyedString;
   function KeyedString_Of (Value : Standard.String; Key : Standard.String) return KeyedString;
   function KeyedString_Of (Key : Standard.String) return KeyedString;
   --  NOTE that the above functions does not do any copying of data
   --   They are just generation references.

   type KeyedOctets_Array is array (Natural range <>) of aliased DDS.KeyedOctets;
   procedure Initialize (Self : in out DDS.KeyedOctets);
   procedure Finalize (Self : in out DDS.KeyedOctets);
   procedure Copy (Dst : in out DDS.KeyedOctets; Src : in DDS.KeyedOctets);
   package KeyedOctets_Seq is new DDS_Support.Sequences_Generic
     (DDS.KeyedOctets,
      KeyedOctets_Ptr,
      DDS.Natural,
      1,
      KeyedOctets_Array);
   --  <dref>KeyedOctetsSeq</dref>



   function KeyedOctets_Of (Key : String; Value : Octets := Null_Octets) return KeyedOctets;
   function KeyedOctets_Of (Key : String; Value : Octet_Array) return KeyedOctets;
   function KeyedOctets_Of (Key : String; Value : Octet_Seq.Sequence) return KeyedOctets;

   generic
      type Data_Type is private;
   function KeyedOctets_Of_Generic (Key : String; Value : Data_Type) return KeyedOctets;

   function To_DDS_Wide_String (Source : Standard.Wide_String) return DDS.Wide_String;
   function To_Standard_Wide_String (Source : DDS.Wide_String) return Standard.Wide_String;
   procedure Copy (Dst : in out DDS.Wide_String; Src : in Standard.Wide_String);
   procedure Copy (Dst : in out Standard.Wide_String; Src : in DDS.Wide_String);
   function "=" (L, R  : DDS.Wide_String) return Boolean;

   type Wide_String_Array is array (Natural range <>) of aliased DDS.Wide_String;
   procedure Initialize (Self  : in out DDS.Wide_String);
   procedure Finalize (Self  : in out DDS.Wide_String);
   procedure Copy (Dst : in out DDS.Wide_String; Src : in DDS.Wide_String);
   package Wide_String_Seq is new DDS_Support.Sequences_Generic
     (DDS.Wide_String,
      Wide_String_Ptr,
      DDS.Natural,
      1,
      Wide_String_Array);
   --  <dref>WstringSeq</dref>

   --  -------------------------------------------------
   --                 Time_t
   --  -------------------------------------------------

   type Time_T is record
      Sec     : Long := 0;
      Nanosec : Unsigned_Long := 0;
   end record with
     Convention => C;
   --  <defgroup>TimeSupportGroupDocs</defgroup>
   --  <dref>Time_t</dref>
   --  <dref name="Sec">TimeStamp_sec</dref>
   --  <dref name="Nanosec">TimeStamp_nanosec</dref>


   function "<" (L : Time_T; R : Time_T) return Boolean;

   function ">" (L : Time_T; R : Time_T) return Boolean;

   function "<=" (L : Time_T; R : Time_T) return Boolean;

   function ">=" (L : Time_T; R : Time_T) return Boolean;

   function "+" (L : Time_T; R : Time_T) return Time_T;

   Time_Zero       : constant Time_T := (0, 0);
   --  <dref>Time_t_ZERO</dref>

   TIME_INVALID_SEC : constant Long      := -1;
   --  <dref>Time_t_INVALID_SEC</dref>

   TIME_INVALID_NSEC : constant Unsigned_Long      := 4_294_967_295;
   --  <dref>Time_t_INVALID_NSEC</dref>

   Time_Invalid    : constant Time_T := (TIME_INVALID_SEC, TIME_INVALID_NSEC);
   --  <dref>Time_t_INVALID</dref>

   function Time_Is_Zero
     (T : Time_T)
      return Boolean;
   --  <dref>Time_t_is_zero</dref>

   function Time_Is_Invalid
     (T : Time_T)
      return Boolean;
   --  <dref>Time_t_is_invalid</dref>

   function To_Time (T : Time_T) return Ada.Calendar.Time;
   function To_Time (T : Time_T) return Ada.Real_Time.Time;
   function To_Time_T (T : Ada.Calendar.Time) return Time_T;
   function To_Time_T (T : Ada.Real_Time.Time) return Time_T;
   --  -------------------------------------------------
   --                 Duration_t
   --  -------------------------------------------------

   type Duration_T is record -- Default DURATION_ZERO
      Sec     : Long := 0;
      Nanosec : Unsigned_Long := 0;
   end record with
     Convention => C;
   --  <dref>Duration_t</dref>
   --  <dref name="Sec">TimeStamp_sec</dref>
   --  <dref name="Nanosec">TimeStamp_nanosec</dref>

   DURATION_ZERO_SEC : constant Long := 0;
   --  <dref>Duration_t_ZERO_SEC</dref>

   DURATION_ZERO_NSEC : constant Unsigned_Long := 0;
   --  <dref>Duration_t_ZERO_NSEC</dref>

   DURATION_ZERO     : Duration_T := (DURATION_ZERO_SEC, DURATION_ZERO_NSEC);
   --  <dref>Duration_t_ZERO</dref>

   DURATION_INFINITE_SEC : constant Long := 2_147_483_647;
   --  <dref>Duration_t_INFINITE_SEC</dref>

   DURATION_INFINITE_NSEC : constant Unsigned_Long := 2_1474_83_647;
   --  <dref>Duration_t_INFINITE_NSEC</dref>

   DURATION_INFINITE : constant Duration_T :=
                         (DURATION_INFINITE_SEC, DURATION_INFINITE_NSEC);
   --  <dref>Duration_t_INFINITE</dref>

   DURATION_AUTO_SEC : constant Long := 2_1474_83_647;
   --  <dref>Duration_t_AUTO_SEC</dref>

   DURATION_AUTO_NSEC : constant Unsigned_Long := 0;
   --  <dref>Duration_t_AUTO_NSEC</dref>

   DURATION_AUTO     : constant Duration_T :=
                         (DURATION_AUTO_SEC, DURATION_AUTO_NSEC);
   --  <dref>Duration_t_AUTO</dref>

   --  <dref>Duration_t_is_zero</dref>
   function Duration_Is_Zero
     (D : Duration_T)
      return Boolean;

   --  <dref>Duration_t_is_infinite</dref>
   function Duration_Is_Infinite
     (D : Duration_T)
      return Boolean;

   --  <dref>Duration_t_is_auto</dref>
   function Duration_Is_Auto
     (D : Duration_T)
      return Boolean;

   function To_Duration (D : Duration_T) return Standard.Duration;
   function To_Duration_T (D : Standard.Duration) return Duration_T;
   --  <internal>
   --  Converts a standard.Duration to Duration_T and will raise
   --  Constraint error if the conversion is impossible except for the
   --  Value Duration'Last that will return "DURATION_INFINITE".
   --  </internal>

   --  -------------------------------------------------
   --                 InstanceHandle_t
   --  -------------------------------------------------

   type Builtin_Topic_Key_Type_Native is new Interfaces.Unsigned_32;

   type InstanceHandle_T is new RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_InstanceHandle_t;
   --  <dref>InstanceHandle_t</dref>

   Null_InstanceHandle_T : aliased constant InstanceHandle_T := InstanceHandle_T (RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_HANDLE_NIL);
   HANDLE_NIL      : aliased constant InstanceHandle_T := Null_InstanceHandle_T;
   --  <dref>InstanceHandle_t_NIL</dref>

   type InstanceHandle_T_Access is access all InstanceHandle_T;

   type InstanceHandle_T_Array is array (Natural range <>) of aliased InstanceHandle_T;
   procedure Initialize (Self  : in out InstanceHandle_T);
   procedure Finalize (Self  : in out InstanceHandle_T);
   procedure Copy (Dst : in out InstanceHandle_T; Src : in InstanceHandle_T);
   --    package InstanceHandle_Seq is new Ada.Containers.Vectors (Positive, InstanceHandle_T);

   package InstanceHandle_Seq is new DDS_Support.Sequences_Generic
     (InstanceHandle_T,
      InstanceHandle_T_Access,
      DDS.Natural,
      1,
      InstanceHandle_T_Array);
   --  <dref>InstanceHandleSeq</dref>

   --  <dref>InstanceHandle_t_equals</dref>
   function InstanceHandle_Equals
     (Self : not null access InstanceHandle_T; Other : not null access InstanceHandle_T) return Boolean;

   function "=" (Self : not null access InstanceHandle_T; Other : not null access InstanceHandle_T)
                 return Boolean renames InstanceHandle_Equals;

   --  <dref>InstanceHandle_t_is_nil</dref>
   function InstanceHandle_Is_Nil
     (Self : not null access InstanceHandle_T) return Boolean;

   --  -------------------------------------------------
   --                 Guid_t
   --  -------------------------------------------------
   subtype GUID_T_Value_Array is  Octet_Array (0 .. 15);
   type Guid_T is record
      Value : aliased GUID_T_Value_Array := (others => 0);
   end record with
     Convention => C;
   --  <defgroup>GUIDSupportGroupDocs</defgroup>
   --  <dref>GUID_t</dref>
   --  <dref name="Value">GUID_t_value</dref>

   type Guid_T_Access is access all Guid_T;

   GUID_AUTO : aliased constant Guid_T := (Value => (others => 0));
   --  <dref>GUID_t_AUTO</dref>

   GUID_UNKNOWN : Guid_T renames GUID_AUTO;
   --  <dref>GUID_t_UNKNOWN</dref>

   --  <dref>GUID_t_equals</dref>
   function Guid_Equals
     (Self  : not null Guid_T_Access;
      Other : not null Guid_T_Access)
      return Boolean;

   --  <dref>GUID_t_compare</dref>
   function Guid_Compare
     (Self  : not null Guid_T_Access;
      Other : not null Guid_T_Access)
      return Boolean;

   --  <dref>GUID_t_copy</dref>
   procedure Guid_Copy
     (Self  : Guid_T_Access;
      Other : Guid_T_Access);

   pragma Import (C, Guid_Copy, "DDS_GUID_copy");

   procedure Guid_Print (Self   : Guid_T_Access;
                         Desc   : String;
                         Indent : Unsigned_Long);

   pragma Import (C, Guid_Print, "DDS_GUID_print");

   procedure Guid_Zero (Self   : Guid_T_Access);

   pragma Import (C, Guid_Zero, "DDS_GUID_zero");

   function Image (Item : Guid_T) return DDS.String;
   function Image (Item : Guid_T) return Standard.String;

   function Value (Item : Standard.String) return Guid_T with
     Pre => (Item'Length = GUID_T_Value_Array'Length * 2);

   --  -------------------------------------------------
   --                 SequenceNumber_t
   --  -------------------------------------------------

   type SequenceNumber_T is record
      High : aliased DDS.Long := 0;
      Low  : aliased DDS.Unsigned_Long := 0;
   end record with
     Convention => C;
   --  <defgroup>SequenceNumberSupportGroupDocs</defgroup>
   --  <dref>SequenceNumber_t</dref>
   --  <dref name="High">SequenceNumber_t_high</dref>
   --  <dref name="Low">SequenceNumber_t_low</dref>

   type SequenceNumber_T_Access is access all  SequenceNumber_T;

   SEQUENCE_NUMBER_UNKNOWN : constant  SequenceNumber_T := (High => -1, Low =>  4294967295);
   --  <dref>SequenceNumber_t_UNKNOWN</dref>

   SEQUENCE_NUMBER_ZERO    : constant  SequenceNumber_T := (High =>  0, Low =>  0);
   --  <dref>SequenceNumber_t_ZERO</dref>


   SEQUENCE_NUMBER_MAX     : constant  SequenceNumber_T := (High =>  2147483647, Low =>  4294967295);
   --  <dref>SequenceNumber_t_MAX</dref>

   AUTO_SEQUENCE_NUMBER    : constant SequenceNumber_T := (High => -1, Low =>  4294967295);
   --  <dref>SequenceNumber_t_AUTO</dref>


   function "-" (L, R : SequenceNumber_T) return SequenceNumber_T;
   function "+" (L, R : SequenceNumber_T) return SequenceNumber_T;
   function ">" (L, R : SequenceNumber_T) return Boolean;
   function "<" (L, R : SequenceNumber_T) return Boolean;

   procedure Increment (Item : in out SequenceNumber_T);
   procedure Decrement (Item : in out SequenceNumber_T);
   function Image (Item : SequenceNumber_T) return Standard.String;

   --  -------------------------------------------------
   --                 OriginalWriterInfo_t
   --  -------------------------------------------------

   type OriginalWriterInfo_T is record
      Writer_Guid     : Guid_T;
      Sequence_Number : SequenceNumber_T;
   end record with
     Convention => C;
   --  <dref internal="true"></dref>


   --  -------------------------------------------------
   --                 ReturnCode_t
   --  -------------------------------------------------

   ERROR                   : exception;
   --  <defgroup>ReturnCodeGroupDocs</defgroup>
   --  <dref>ReturnCode_t</dref>
   --  <dref>ReturnCode_t_RETCODE_ERROR</dref>

   UNSUPPORTED             : exception;
   --  <dref>ReturnCode_t_RETCODE_UNSUPPORTED</dref>

   BAD_PARAMETER           : exception;
   --  <dref>ReturnCode_t_RETCODE_BAD_PARAMETER</dref>

   PRECONDITION_NOT_MET    : exception;
   --  <dref>ReturnCode_t_RETCODE_PRECONDITION_NOT_MET</dref>

   OUT_OF_RESOURCES        : exception;
   --  <dref>ReturnCode_t_RETCODE_OUT_OF_RESOURCES</dref>

   NOT_ENABLED             : exception;
   --  <dref>ReturnCode_t_RETCODE_NOT_ENABLED</dref>

   IMMUTABLE_POLICY        : exception;
   --  <dref>ReturnCode_t_RETCODE_IMMUTABLE_POLICY</dref>

   INCONSISTENT_POLICY     : exception;
   --  <dref>ReturnCode_t_RETCODE_INCONSISTENT_POLICY</dref>

   ALREADY_DELETED         : exception;
   --  <dref>ReturnCode_t_RETCODE_ALREADY_DELETED</dref>

   TIMEOUT                 : exception;
   --  <dref>ReturnCode_t_RETCODE_TIMEOUT</dref>

   NO_DATA                 : exception;
   --  <dref>ReturnCode_t_RETCODE_NO_DATA</dref>

   ILLEGAL_OPERATION       : exception;
   --  <dref>ReturnCode_t_RETCODE_ILLEGAL_OPERATION</dref>

   NOT_ALLOWED_BY_SECURITY : exception;
   --  <dref>ReturnCode_t_RETCODE_NOT_ALLOWED_BY_SECURITY</dref>

   type ReturnCode_T is
     (RETCODE_OK,
      --  Successful return.
      RETCODE_ERROR,
      --  Generic, unspecified error.

      RETCODE_UNSUPPORTED,
      --  Unsupported operation. Can only returned by operations that are unsupported.
      RETCODE_BAD_PARAMETER,
      RETCODE_PRECONDITION_NOT_MET,
      RETCODE_OUT_OF_RESOURCES,
      RETCODE_NOT_ENABLED,
      RETCODE_IMMUTABLE_POLICY,
      RETCODE_INCONSISTENT_POLICY,
      RETCODE_ALREADY_DELETED,
      RETCODE_TIMEOUT,
      RETCODE_NO_DATA,
      RETCODE_ILLEGAL_OPERATION,
      RETCODE_NOT_ALLOWED_BY_SECURITY
     ) with Default_Value => RETCODE_OK;

   pragma Convention (C, ReturnCode_T);

   procedure Ret_Code_To_Exception (Code : ReturnCode_T; Message : Standard.String := "");

   --  -------------------------------------------------
   --                 Status Types
   --  -------------------------------------------------

   type StatusKind is new Unsigned_Long;
   --  <dref>StatusKind</dref>

   INCONSISTENT_TOPIC_STATUS         : constant StatusKind := 2#0000_0000_0000_0001#;
   --  <dref>StatusKind_INCONSISTENT_TOPIC_STATUS</dref>

   OFFERED_DEADLINE_MISSED_STATUS    : constant StatusKind := 2#0000_0000_0000_0010#;
   --  <dref>StatusKind_OFFERED_DEADLINE_MISSED_STATUS</dref>

   REQUESTED_DEADLINE_MISSED_STATUS  : constant StatusKind := 2#0000_0000_0000_0100#;
   --  <dref>StatusKind_REQUESTED_DEADLINE_MISSED_STATUS</dref>

   OFFERED_INCOMPATIBLE_QOS_STATUS   : constant StatusKind := 2#0000_0000_0010_0000#;
   --  <dref>StatusKind_OFFERED_INCOMPATIBLE_QOS_STATUS</dref>

   REQUESTED_INCOMPATIBLE_QOS_STATUS : constant StatusKind := 2#0000_0000_0100_0000#;
   --  <dref>StatusKind_REQUESTED_INCOMPATIBLE_QOS_STATUS</dref>

   SAMPLE_LOST_STATUS                : constant StatusKind := 2#0000_0000_1000_0000#;
   --  <dref>StatusKind_SAMPLE_LOST_STATUS</dref>

   SAMPLE_REJECTED_STATUS            : constant StatusKind := 2#0000_0001_0000_0000#;
   --  <dref>StatusKind_SAMPLE_REJECTED_STATUS</dref>

   DATA_ON_READERS_STATUS            : constant StatusKind := 2#0000_0010_0000_0000#;
   --  <dref>StatusKind_DATA_ON_READERS_STATUS</dref>

   DATA_AVAILABLE_STATUS             : constant StatusKind := 2#0000_0100_0000_0000#;
   --  <dref>StatusKind_DATA_AVAILABLE_STATUS</dref>

   LIVELINESS_LOST_STATUS            : constant StatusKind := 2#0000_1000_0000_0000#;
   --  <dref>StatusKind_LIVELINESS_LOST_STATUS</dref>

   LIVELINESS_CHANGED_STATUS         : constant StatusKind := 2#0001_0000_0000_0000#;
   --  <dref>StatusKind_LIVELINESS_CHANGED_STATUS</dref>

   PUBLICATION_MATCH_STATUS          : constant StatusKind := 2#0010_0000_0000_0000#;
   --  <dref>StatusKind_PUBLICATION_MATCHED_STATUS</dref>

   SUBSCRIPTION_MATCH_STATUS         : constant StatusKind := 2#0100_0000_0000_0000#;
   --  <dref>StatusKind_SUBSCRIPTION_MATCHED_STATUS</dref>
   pragma Warnings (Off);
   function "+" (Left, Right : StatusKind) return StatusKind renames "or";
   pragma Warnings (On);

   --   /* --- Begin extended statuses --- */
   --   /* Previously, the "right"-most 24 bits of the StatusMask were reserved
   --    * for standard statuses, with the remaining 8 bits for extended statuses.
   --    Now, as of 4.5b, with more than 8 extended statuses, and with no "official"
   --    documented requirement of having only 8 bits, additional bits are being
   --    designated for extended statuses.
   --    */

   DATA_WRITER_APPLICATION_ACKNOWLEDGMENT_STATUS : constant StatusKind :=
                                                     2#0000_0000_0100_0000_0000_0000_0000_0000#;
   --  <dref>StatusKind_DATA_WRITER_APPLICATION_ACKNOWLEDGMENT_STATUS</dref>

   DATA_WRITER_INSTANCE_REPLACED_STATUS       : constant StatusKind :=
                                                  2#0000_0000_1000_0000_0000_0000_0000_0000#;
   --  <dref>StatusKind_DATA_WRITER_INSTANCE_REPLACED_STATUS</dref>

   RELIABLE_WRITER_CACHE_CHANGED_STATUS       : constant StatusKind :=
                                                  2#0000_0001_0000_0000_0000_0000_0000_0000#;
   --  <dref>StatusKind_RELIABLE_WRITER_CACHE_CHANGED_STATUS</dref>

   RELIABLE_READER_ACTIVITY_CHANGED_STATUS    : constant StatusKind :=
                                                  2#0000_0010_0000_0000_0000_0000_0000_0000#;
   --  <dref>StatusKind_RELIABLE_READER_ACTIVITY_CHANGED_STATUS</dref>

   DATA_WRITER_CACHE_STATUS                   : constant StatusKind :=
                                                  2#0000_0100_0000_0000_0000_0000_0000_0000#;
   --  <dref>StatusKind_DATA_WRITER_CACHE_STATUS</dref>

   DATA_WRITER_PROTOCOL_STATUS                : constant StatusKind :=
                                                  2#0000_1000_0000_0000_0000_0000_0000_0000#;
   --  <dref>StatusKind_DATA_WRITER_PROTOCOL_STATUS</dref>

   DATA_READER_CACHE_STATUS                   : constant StatusKind :=
                                                  2#0001_0000_0000_0000_0000_0000_0000_0000#;
   --  <dref>StatusKind_DATA_READER_CACHE_STATUS</dref>

   DATA_READER_PROTOCOL_STATUS                : constant StatusKind :=
                                                  2#0010_0000_0000_0000_0000_0000_0000_0000#;
   --  <dref>StatusKind_DATA_READER_PROTOCOL_STATUS</dref>

   DATA_WRITER_DESTINATION_UNREACHABLE_STATUS : constant StatusKind :=
                                                  2#0100_0000_0000_0000_0000_0000_0000_0000#;
   --  <dref internal="true"></dref>

   DATA_WRITER_SAMPLE_REMOVED_STATUS          : constant StatusKind :=
                                                  2#1000_0000_0000_0000_0000_0000_0000_0000#;
   --  <dref internal="true"></dref>

   subtype StatusMask is StatusKind;
   --  <defgroup>StatusKindGroupDocs</defgroup>
   --  <dref>StatusMask</dref>
   --  <dref>Shared_status_mask_description</dref>

   STATUS_MASK_NONE : constant StatusMask := 2#0000_0000_0000_0000_0000_0000_0000_0000#;
   --  <dref>STATUS_MASK_NONE</dref>

   STATUS_MASK_ALL  : constant StatusMask := 2#1111_1111_1111_1111_1111_1111_1111_1111#;
   --  <dref>STATUS_MASK_ALL</dref>

   type StatusKind_Access is access constant StatusKind;

   --  -------------------------------------------------
   --                 Thread Settings
   --  -------------------------------------------------

   type ThreadSettings is new Unsigned_Long;
   --  <defgroup>ThreadSettingsGroupDocs</defgroup>

   subtype ThreadSettingsKindMask is ThreadSettings;
   --  <dref>ThreadSettingsKindMask</dref>

   THREAD_SETTINGS_OPTION_DEFAULT             : constant := 16#00#;

   THREAD_SETTINGS_OPTION_FLOATING_POINT      : constant := 16#01#;
   --  <dref>ThreadSettingsKind</dref>
   --  <dref>ThreadSettingsKind_THREAD_SETTINGS_FLOATING_POINT</dref>

   THREAD_SETTINGS_OPTION_STDIO               : constant := 16#02#;
   --  <dref>ThreadSettingsKind_THREAD_SETTINGS_STDIO</dref>

   THREAD_SETTINGS_OPTION_REALTIME_PRIORITY   : constant := 16#08#;

   --  <dref>ThreadSettingsKind_THREAD_SETTINGS_REALTIME_PRIORITY</dref>

   THREAD_SETTINGS_OPTION_PRIORITY_ENFORCE    : constant := 16#10#;
   --  <dref>ThreadSettingsKind_THREAD_SETTINGS_PRIORITY_ENFORCE</dref>

   THREAD_SETTINGS_OPTION_CANCEL_ASYNCHRONOUS : constant := 16#20#;
   --  <dref>ThreadSettingsKind_THREAD_SETTINGS_CANCEL_ASYNCHRONOUS</dref>

   THREAD_SETTINGS_KIND_MASK_DEFAULT          : constant ThreadSettingsKindMask :=
                                                  THREAD_SETTINGS_OPTION_DEFAULT;
   --  <dref>THREAD_SETTINGS_KIND_MASK_DEFAULT</dref>

   type ThreadSettingsCpuRotationKind_T is new Unsigned_Long;
   --  <dref>ThreadSettingsCpuRotationKind</dref>

   THREAD_SETTINGS_CPU_NO_ROTATION            : constant ThreadSettingsCpuRotationKind_T := 0;
   --  <dref>ThreadSettingsCpuRotationKind_THREAD_SETTINGS_CPU_NO_ROTATION</dref>

   THREAD_SETTINGS_CPU_RR_ROTATION            : constant ThreadSettingsCpuRotationKind_T := 1;
   --  <dref>ThreadSettingsCpuRotationKind_THREAD_SETTINGS_CPU_RR_ROTATION</dref>

   THREAD_SETTINGS_CPU_ROTATION_DEFAULT       : constant ThreadSettingsCpuRotationKind_T :=
                                                  THREAD_SETTINGS_CPU_NO_ROTATION;
   --  <dref internal="true"></dref>

   type ThreadSettings_T is record
      Mask         : aliased ThreadSettingsKindMask := THREAD_SETTINGS_OPTION_DEFAULT;
      Priority     : aliased Long := -9999999;
      Stack_Size   : aliased Long := -1;
      Cpu_List     : aliased Long_Seq.Sequence;
      Cpu_Rotation : aliased ThreadSettingsCpuRotationKind_T := THREAD_SETTINGS_CPU_ROTATION_DEFAULT;
   end record with
     Convention => C;
   --  <dref>ThreadSettings_t</dref>
   --  <dref name="Mask">ThreadSettings_t_mask</dref>
   --  <dref name="Priority">ThreadSettings_t_priority</dref>
   --  <dref name="Stack_Size">ThreadSettings_t_stack_size</dref>
   --  <dref name="Cpu_List">ThreadSettings_t_cpu_list</dref>
   --  <dref name="Cpu_Rotation">ThreadSettings_t_cpu_rotation</dref>

   type ThreadSettings_T_Access is access all  ThreadSettings_T;

   procedure ThreadSettings_T_Get_Default (Self  : not null ThreadSettings_T_Access);

   pragma Import (C, ThreadSettings_T_Get_Default, "DDS_ThreadSettings_get_default");

   function ThreadSettings_T_Is_Equal
     (Self  : not null ThreadSettings_T_Access;
      Other : not null ThreadSettings_T_Access)
      return Boolean;

   --  -------------------------------------------------
   --                 QoS Types
   --  -------------------------------------------------

   type QosPolicyId_T is new Unsigned_Long;
   --  <defgroup>QosPoliciesGroupDocs</defgroup>
   --  <dref>QosPolicyId_t</dref>

   QOS_POLICY_COUNT : constant Long := 63;
   --  <dref>QOS_POLICY_COUNT</dref>

   INVALID_QOS_POLICY_ID : constant QosPolicyId_T := 0;
   --  <dref>QosPolicyId_t_INVALID_QOS_POLICY_ID</dref>

   USERDATA_QOS_POLICY_ID : constant QosPolicyId_T := 1;
   --  <dref>QosPolicyId_t_USERDATA_QOS_POLICY_ID</dref>

   DURABILITY_QOS_POLICY_ID : constant QosPolicyId_T := 2;
   --  <dref>QosPolicyId_t_DURABILITY_QOS_POLICY_ID</dref>

   PRESENTATION_QOS_POLICY_ID : constant QosPolicyId_T := 3;
   --  <dref>QosPolicyId_t_PRESENTATION_QOS_POLICY_ID</dref>

   DEADLINE_QOS_POLICY_ID : constant QosPolicyId_T := 4;
   --  <dref>QosPolicyId_t_DEADLINE_QOS_POLICY_ID</dref>

   LATENCYBUDGET_QOS_POLICY_ID : constant QosPolicyId_T := 5;
   --  <dref>QosPolicyId_t_LATENCYBUDGET_QOS_POLICY_ID</dref>

   OWNERSHIP_QOS_POLICY_ID : constant QosPolicyId_T := 6;
   --  <dref>QosPolicyId_t_OWNERSHIP_QOS_POLICY_ID</dref>

   OWNERSHIPSTRENGTH_QOS_POLICY_ID : constant QosPolicyId_T := 7;
   --  <dref>QosPolicyId_t_OWNERSHIPSTRENGTH_QOS_POLICY_ID</dref>

   LIVELINESS_QOS_POLICY_ID : constant QosPolicyId_T := 8;
   --  <dref>QosPolicyId_t_LIVELINESS_QOS_POLICY_ID</dref>

   TIMEBASEDFILTER_QOS_POLICY_ID : constant QosPolicyId_T := 9;
   --  <dref>QosPolicyId_t_TIMEBASEDFILTER_QOS_POLICY_ID</dref>

   PARTITION_QOS_POLICY_ID : constant QosPolicyId_T := 10;
   --  <dref>QosPolicyId_t_PARTITION_QOS_POLICY_ID</dref>

   RELIABILITY_QOS_POLICY_ID : constant QosPolicyId_T := 11;
   --  <dref>QosPolicyId_t_RELIABILITY_QOS_POLICY_ID</dref>

   DESTINATIONORDER_QOS_POLICY_ID : constant QosPolicyId_T := 12;
   --  <dref>QosPolicyId_t_DESTINATIONORDER_QOS_POLICY_ID</dref>

   HISTORY_QOS_POLICY_ID : constant QosPolicyId_T := 13;
   --  <dref>QosPolicyId_t_HISTORY_QOS_POLICY_ID</dref>

   RESOURCELIMITS_QOS_POLICY_ID : constant QosPolicyId_T := 14;
   --  <dref>QosPolicyId_t_RESOURCELIMITS_QOS_POLICY_ID</dref>

   ENTITYFACTORY_QOS_POLICY_ID : constant QosPolicyId_T := 15;
   --  <dref>QosPolicyId_t_ENTITYFACTORY_QOS_POLICY_ID</dref>

   WRITERDATALIFECYCLE_QOS_POLICY_ID : constant QosPolicyId_T := 16;
   --  <dref>QosPolicyId_t_WRITERDATALIFECYCLE_QOS_POLICY_ID</dref>

   READERDATALIFECYCLE_QOS_POLICY_ID : constant QosPolicyId_T := 17;
   --  <dref>QosPolicyId_t_READERDATALIFECYCLE_QOS_POLICY_ID</dref>

   TOPICDATA_QOS_POLICY_ID : constant QosPolicyId_T := 18;
   --  <dref>QosPolicyId_t_TOPICDATA_QOS_POLICY_ID</dref>

   GROUPDATA_QOS_POLICY_ID : constant QosPolicyId_T := 19;
   --  <dref>QosPolicyId_t_GROUPDATA_QOS_POLICY_ID</dref>

   TRANSPORTPRIORITY_QOS_POLICY_ID : constant QosPolicyId_T := 20;
   --  <dref>QosPolicyId_t_TRANSPORTPRIORITY_QOS_POLICY_ID</dref>

   LIFESPAN_QOS_POLICY_ID : constant QosPolicyId_T := 21;
   --  <dref>QosPolicyId_t_LIFESPAN_QOS_POLICY_ID</dref>

   DURABILITYSERVICE_QOS_POLICY_ID : constant QosPolicyId_T := 22;
   --  <dref>QosPolicyId_t_DURABILITYSERVICE_QOS_POLICY_ID</dref>

   DATA_REPRESENTATION_QOS_POLICY_ID : constant QosPolicyId_T := 23;
   --  <dref>QosPolicyId_t_DATA_REPRESENTATION_QOS_POLICY_ID</dref>

   TYPE_CONSISTENCY_ENFORCEMENT_QOS_POLICY_ID : constant QosPolicyId_T := 24;
   --  <dref>QosPolicyId_t_TYPE_CONSISTENCY_ENFORCEMENT_QOS_POLICY_ID</dref>

   DATATAG_QOS_POLICY_ID : constant QosPolicyId_T := 25;
   --  <dref>QosPolicyId_t_DATATAG_QOS_POLICY_ID</dref>

   WIREPROTOCOL_QOS_POLICY_ID : constant QosPolicyId_T := 1000;
   --  <dref>QosPolicyId_t_WIREPROTOCOL_QOS_POLICY_ID</dref>

   DISCOVERY_QOS_POLICY_ID : constant QosPolicyId_T := 1001;
   --  <dref>QosPolicyId_t_DISCOVERY_QOS_POLICY_ID</dref>

   DATAREADERRESOURCELIMITS_QOS_POLICY_ID : constant QosPolicyId_T := 1003;
   --  <dref>QosPolicyId_t_DATAREADERRESOURCELIMITS_QOS_POLICY_ID</dref>

   DATAWRITERRESOURCELIMITS_QOS_POLICY_ID : constant QosPolicyId_T := 1004;
   --  <dref>QosPolicyId_t_DATAWRITERRESOURCELIMITS_QOS_POLICY_ID</dref>

   DATAREADERPROTOCOL_QOS_POLICY_ID : constant QosPolicyId_T := 1005;
   --  <dref>QosPolicyId_t_DATAREADERPROTOCOL_QOS_POLICY_ID</dref>

   DATAWRITERPROTOCOL_QOS_POLICY_ID : constant QosPolicyId_T := 1006;
   --  <dref>QosPolicyId_t_DATAWRITERPROTOCOL_QOS_POLICY_ID</dref>

   DOMAINPARTICIPANTRESOURCELIMITS_QOS_POLICY_ID : constant QosPolicyId_T := 1007;
   --  <dref>QosPolicyId_t_DOMAINPARTICIPANTRESOURCELIMITS_QOS_POLICY_ID</dref>

   EVENT_QOS_POLICY_ID : constant QosPolicyId_T := 1008;
   --  <dref>QosPolicyId_t_EVENT_QOS_POLICY_ID</dref>

   DATABASE_QOS_POLICY_ID : constant QosPolicyId_T := 1009;
   --  <dref>QosPolicyId_t_DATABASE_QOS_POLICY_ID</dref>

   RECEIVERPOOL_QOS_POLICY_ID : constant QosPolicyId_T := 1010;
   --  <dref>QosPolicyId_t_RECEIVERPOOL_QOS_POLICY_ID</dref>

   DISCOVERYCONFIG_QOS_POLICY_ID : constant QosPolicyId_T := 1011;
   --  <dref>QosPolicyId_t_DISCOVERYCONFIG_QOS_POLICY_ID</dref>

   EXCLUSIVEAREA_QOS_POLICY_ID : constant QosPolicyId_T := 1012;
   --  <dref>QosPolicyId_t_EXCLUSIVEAREA_QOS_POLICY_ID</dref>

   USEROBJECT_QOS_POLICY_ID : constant QosPolicyId_T := 1013;
   --  <dref internal="true">QosPolicyId_t_USEROBJECT_QOS_POLICY_ID</dref>

   SYSTEMRESOURCELIMITS_QOS_POLICY_ID : constant QosPolicyId_T := 1014;
   --  <dref>QosPolicyId_t_SYSTEMRESOURCELIMITS_QOS_POLICY_ID</dref>

   TRANSPORTSELECTION_QOS_POLICY_ID : constant QosPolicyId_T := 1015;
   --  <dref>QosPolicyId_t_TRANSPORTSELECTION_QOS_POLICY_ID</dref>

   TRANSPORTUNICAST_QOS_POLICY_ID : constant QosPolicyId_T := 1016;
   --  <dref>QosPolicyId_t_TRANSPORTUNICAST_QOS_POLICY_ID</dref>

   TRANSPORTMULTICAST_QOS_POLICY_ID : constant QosPolicyId_T := 1017;
   --  <dref>QosPolicyId_t_TRANSPORTMULTICAST_QOS_POLICY_ID</dref>

   TRANSPORTBUILTIN_QOS_POLICY_ID : constant QosPolicyId_T := 1018;
   --  <dref>QosPolicyId_t_TRANSPORTBUILTIN_QOS_POLICY_ID</dref>

   TYPESUPPORT_QOS_POLICY_ID : constant QosPolicyId_T := 1019;
   --  <dref>QosPolicyId_t_TYPESUPPORT_QOS_POLICY_ID</dref>

   PROPERTY_QOS_POLICY_ID : constant QosPolicyId_T := 1020;
   --  <dref>QosPolicyId_t_PROPERTY_QOS_POLICY_ID</dref>

   PUBLISHMODE_QOS_POLICY_ID : constant QosPolicyId_T := 1021;
   --  <dref>QosPolicyId_t_PUBLISHMODE_QOS_POLICY_ID</dref>

   ASYNCHRONOUSPUBLISHER_QOS_POLICY_ID : constant QosPolicyId_T := 1022;
   --  <dref>QosPolicyId_t_ASYNCHRONOUSPUBLISHER_QOS_POLICY_ID</dref>

   ENTITYNAME_QOS_POLICY_ID : constant QosPolicyId_T := 1023;
   --  <dref>QosPolicyId_t_ENTITYNAME_QOS_POLICY_ID</dref>

   SERVICE_QOS_POLICY_ID : constant QosPolicyId_T := 1025;
   --  <dref internal="true"></dref>

   BATCH_QOS_POLICY_ID : constant QosPolicyId_T := 1026;
   --  <dref>QosPolicyId_t_BATCH_QOS_POLICY_ID</dref>

   PROFILE_QOS_POLICY_ID : constant QosPolicyId_T := 1027;
   --  <dref>QosPolicyId_t_PROFILE_QOS_POLICY_ID</dref>

   LOCATORFILTER_QOS_POLICY_ID : constant QosPolicyId_T := 1028;
   --  <dref>QosPolicyId_t_LOCATORFILTER_QOS_POLICY_ID</dref>

   MULTICHANNEL_QOS_POLICY_ID : constant QosPolicyId_T := 1029;
   --  <dref>QosPolicyId_t_MULTICHANNEL_QOS_POLICY_ID</dref>

   TRANSPORTENCAPSULATION_QOS_POLICY_ID : constant QosPolicyId_T := 1030;
   --  <dref internal="true"></dref>

   PUBLISHERPROTOCOL_QOS_POLICY_ID : constant QosPolicyId_T := 1031;
   --  <dref internal="true"></dref>

   SUBSCRIBERPROTOCOL_QOS_POLICY_ID : constant QosPolicyId_T := 1032;
   --  <dref internal="true"></dref>

   TOPICPROTOCOL_QOS_POLICY_ID : constant QosPolicyId_T := 1033;
   --  <dref internal="true"></dref>

   DOMAINPARTICIPANTPROTOCOL_QOS_POLICY_ID : constant QosPolicyId_T := 1034;
   --  <dref internal="true"></dref>

   AVAILABILITY_QOS_POLICY_ID : constant QosPolicyId_T := 1035;
   --  <dref>QosPolicyId_t_AVAILABILITY_QOS_POLICY_ID</dref>

   TRANSPORTMULTICASTMAPPING_QOS_POLICY_ID : constant QosPolicyId_T := 1036;
   --  QosPolicyId_t_TRANSPORTMULTICASTMAPPING_QOS_POLICY_ID -- documentation removed in ifdoc

   LOGGING_QOS_POLICY_ID : constant QosPolicyId_T := 1037;
   --  <dref>QosPolicyId_t_LOGGING_QOS_POLICY_ID</dref>

   TOPICQUERYDISPATCH_QOS_POLICY_ID : constant QosPolicyId_T := 1038;
   --  <dref>QosPolicyId_t_TOPICQUERYDISPATCH_QOS_POLICY_ID</dref>

   DATAWRITERTRANSFERMODE_QOS_POLICY_ID : constant QosPolicyId_T := 1039;
   --  <dref>QosPolicyId_t_DATAWRITERTRANSFERMODE_QOS_POLICY_ID</dref>

   type QosPolicyCount is record
      Policy_Id : aliased QosPolicyId_T := INVALID_QOS_POLICY_ID;
      Count     : aliased Long := 0;
   end record with
     Convention => C;
   --  <dref>QosPolicyCount</dref>
   --  <dref name="Policy_Id">QosPolicyCount_policy_id</dref>
   --  <dref name="Count">QosPolicyCount_count</dref>

   type QosPolicyCount_Access is access all QosPolicyCount;

   type QosPolicyCount_Array is array (Natural range <>) of aliased QosPolicyCount;
   procedure Initialize (Self  : in out QosPolicyCount);
   procedure Finalize (Self  : in out QosPolicyCount);
   procedure Copy (Dst : in out QosPolicyCount; Src : in QosPolicyCount);

   package QosPolicyCount_Seq is new DDS_Support.Sequences_Generic
     (QosPolicyCount,
      QosPolicyCount_Access,
      DDS.Natural,
      1,
      QosPolicyCount_Array);
   --  <dref>QosPolicyCountSeq</dref>

   --  -------------------------------------------------
   --                 Entity Types
   --  -------------------------------------------------

   type EntityKind_T is (UNKNOWN_ENTITY_KIND,
                         PARTICIPANT_ENTITY_KIND,
                         PUBLISHER_ENTITY_KIND,
                         SUBSCRIBER_ENTITY_KIND,
                         TOPIC_ENTITY_KIND,
                         DATAREADER_ENTITY_KIND,
                         DATAWRITER_ENTITY_KIND);
   pragma Annotate (EntityKind_T, Source, RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_EntityKind_t);

   --  -------------------------------------------------
   --                 USER_DATA
   --  -------------------------------------------------

   USERDATA_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("UserData");
   --  <defgroup>UserDataQosGroupDocs</defgroup>
   --  <dref>USERDATA_QOS_POLICY_NAME</dref>

   type UserDataQosPolicy is limited record
      Value : aliased Octet_Seq.Sequence;
   end record with
     Convention => C;
   --  <dref>UserDataQosPolicy</dref>
   --  <dref name="Value">UserDataQosPolicy_value</dref>

   --     USER_DATA_QOS_POLICY_DEFAULT : constant UserDataQosPolicy :=
   --                                      (Value => Octet_Seq.DEFAULT_SEQUENCE);

   --  -------------------------------------------------
   --                 TOPIC_DATA
   --  -------------------------------------------------

   TOPICDATA_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("TopicData");
   --  <defgroup>TopicDataQosGroupDocs</defgroup>
   --  <dref>TOPICDATA_QOS_POLICY_NAME</dref>


   type TopicDataQosPolicy is limited record
      Value : aliased Octet_Seq.Sequence;
   end record with
     Convention => C;
   --  <dref>TopicDataQosPolicy</dref>
   --  <dref name="Value">TopicDataQosPolicy_value</dref>

   --     TOPIC_DATA_QOS_POLICY_DEFAULT : constant TopicDataQosPolicy :=
   --                                       (Value => Octet_Seq.DEFAULT_SEQUENCE);

   --  -------------------------------------------------
   --                 DATA_TAGS
   --  -------------------------------------------------

   --  <defgroup>DataTagQosGroupDocs</defgroup>
   type Tags_T is limited record
      Name  : aliased DDS.String;
      Value : aliased DDS.String;
   end record with Convention => C;
   --  <dref>Tags</dref>
   --  <dref name="Name">Tags_T_name</dref>
   --  <dref name="Value">Tags_T_value</dref>

   type Tags_T_Access is access all Tags_T with Convention => C;
   type Tags_T_Array is array
     (Natural range <>) of aliased Tags_T;
   procedure Initialize (Self  : in out Tags_T);
   procedure Finalize (Self  : in out Tags_T);
   procedure Copy (Dst : in out Tags_T;
                   Src : in Tags_T);

   package Tags_Seq is new DDS_Support.Sequences_Generic
     (Tags_T,
      Tags_T_Access,
      DDS.Natural,
      1,
      Tags_T_Array);
   --  <dref>TagSeq</dref>

   type DataTagQosPolicy is limited record
      Value : aliased Tags_Seq.Sequence;
   end record with Convention => C;
   --  <dref>DataTagQosPolicy</dref>
   --  <dref name="Value">DataTags_tags</dref>

   function Lookup_Tag
      (Policy : in DataTagQosPolicy;
       Name   : in DDS.String) return Tags_T_Access;
   --  <dref name="lookup_tag">DataTagQosPolicyHelper_lookup_tag</dref>

   procedure Assert_Tag
      (Policy : in DataTagQosPolicy;
       Name   : in DDS.String;
       Value  : in DDS.String);
   --  <dref name="assert_tag">DataTagQosPolicyHelper_assert_tag</dref>

   procedure Add_Tag
      (Policy : in DataTagQosPolicy;
       Name   : in DDS.String;
       Value  : in DDS.String);
   --  <dref name="add_tag">DataTagQosPolicyHelper_add_tag</dref>

   procedure Remove_Tag
      (Policy : in DataTagQosPolicy;
       Name   : in DDS.String);
   --  <dref name="remove_tag">DataTagQosPolicyHelper_remove_tag</dref>

   function Get_Number_Of_Tags
      (Policy : in DataTagQosPolicy) return DDS.Long;
   --  <dref name="get_number_of_tags">DataTagQosPolicyHelper_get_number_of_tags</dref>

   --  -------------------------------------------------
   --                 GROUP_DATA
   --  -------------------------------------------------

   GROUPDATA_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("GroupData");
   --  <defgroup>GroupDataQosGroupDocs</defgroup>
   --  <dref>GROUPDATA_QOS_POLICY_NAME</dref>

   type GroupDataQosPolicy is limited record
      Value : aliased Octet_Seq.Sequence;
   end record with
     Convention => C;
   --  <dref>GroupDataQosPolicy</dref>
   --  <dref name="Value">GroupDataQosPolicy_value</dref>

   --     GROUP_DATA_QOS_POLICY_DEFAULT : constant GroupDataQosPolicy :=
   --                                       (Value => Octet_Seq.DEFAULT_SEQUENCE);

   --  -------------------------------------------------
   --                 TOPIC_PROTOCOL (eXtension QoS)
   --  -------------------------------------------------

   TOPICPROTOCOL_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("TopicProtocol");
   --  <dref internal="true"></dref>


   type TopicProtocolQosPolicy is limited record
      Vendor_Specific_Entity : Boolean := False;
   end record with
     Convention => C;
   --  <dref internal="true"></dref>

   TOPIC_PROTOCOL_QOS_POLICY_DEFAULT : constant TopicProtocolQosPolicy :=
                                         (Vendor_Specific_Entity => False);
   --  <dref internal="true"></dref>

   --  ----------------------------------------------------------
   --                 DOMAIN_PARTICIPANT_PROTOCOL (eXtension QoS)
   --  ----------------------------------------------------------

   DOMAINPARTICIPANTPROTOCOL_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("DomainParticipantProtocol");
   --  <dref internal="true"></dref>

   type DomainParticipantProtocolQosPolicy is limited record
      Vendor_Specific_Entity : Boolean := False;
   end record with
     Convention => C;
   --  <dref internal="true"></dref>

   DOMAIN_PARTICIPANT_PROTOCOL_QOS_POLICY_DEFAULT : constant DomainParticipantProtocolQosPolicy :=
                                                      (Vendor_Specific_Entity => False);
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 DURABILITY
   --  -------------------------------------------------

   DURABILITY_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("Durability");
   --  <defgroup>DurabilityQosGroupDocs</defgroup>
   --  <dref>DURABILITY_QOS_POLICY_NAME</dref>

   type DurabilityQosPolicyKind is new Unsigned_Long;
   --  <dref>DurabilityQosPolicyKind</dref>

   VOLATILE_DURABILITY_QOS : constant DurabilityQosPolicyKind := 0;
   --  <dref>DurabilityQosPolicyKind_VOLATILE_DURABILITY_QOS</dref>

   TRANSIENT_LOCAL_DURABILITY_QOS : constant DurabilityQosPolicyKind := 1;
   --  <dref>DurabilityQosPolicyKind_TRANSIENT_LOCAL_DURABILITY_QOS</dref>

   TRANSIENT_DURABILITY_QOS : constant DurabilityQosPolicyKind := 2;
   --  <dref>DurabilityQosPolicyKind_TRANSIENT_DURABILITY_QOS</dref>

   PERSISTENT_DURABILITY_QOS : constant DurabilityQosPolicyKind := 3;
   --  <dref>DurabilityQosPolicyKind_PERSISTENT_DURABILITY_QOS</dref>

   type DurabilityQosPolicy is record
      Kind                 : aliased DurabilityQosPolicyKind := VOLATILE_DURABILITY_QOS;
      Direct_Communication : aliased DDS.Boolean := True;
   end record with
     Convention => C;
   --  <dref>DurabilityQosPolicy</dref>
   --  <dref name="Kind">DurabilityQosPolicy_kind</dref>
   --  <dref name="Direct_Communication">DurabilityQosPolicy_direct_communication</dref>


   DURABILITY_QOS_POLICY_DEFAULT : constant DurabilityQosPolicy :=
                                     (Kind                 => VOLATILE_DURABILITY_QOS,
                                      Direct_Communication => True);
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 PRESENTATION
   --  -------------------------------------------------

   PRESENTATION_QOS_POLICY_NAME  : constant DDS.String := To_DDS_String ("Presentation");
   --  <defgroup>PresentationQosGroupDocs</defgroup>
   --  <dref>PRESENTATION_QOS_POLICY_NAME</dref>

   type PresentationQosPolicyAccessScopeKind is new Unsigned_Long;
   --  <dref>PresentationQosPolicyAccessScopeKind</dref>

   INSTANCE_PRESENTATION_QOS : constant PresentationQosPolicyAccessScopeKind := 0;
   --  <dref>PresentationQosPolicyAccessScopeKind_INSTANCE_PRESENTATION_QOS</dref>

   TOPIC_PRESENTATION_QOS : constant PresentationQosPolicyAccessScopeKind := 1;
   --  <dref>PresentationQosPolicyAccessScopeKind_TOPIC_PRESENTATION_QOS</dref>

   GROUP_PRESENTATION_QOS : constant PresentationQosPolicyAccessScopeKind := 2;
   --  <dref>PresentationQosPolicyAccessScopeKind_GROUP_PRESENTATION_QOS</dref>

   HIGHEST_OFFERED_PRESENTATION_QOS : constant PresentationQosPolicyAccessScopeKind := 3;
   --  <dref>PresentationQosPolicyAccessScopeKind_HIGHEST_OFFERED_PRESENTATION_QOS</dref>

   type PresentationQosPolicy  is record
      Access_Scope    : aliased PresentationQosPolicyAccessScopeKind := INSTANCE_PRESENTATION_QOS;
      Coherent_Access : aliased DDS.Boolean := False;
      Ordered_Access  : aliased DDS.Boolean := False;
   end record with
     Convention => C;
   --  <dref>PresentationQosPolicy</dref>
   --  <dref name="Access_Scope">PresentationQosPolicy_access_scope</dref>
   --  <dref name="Coherent_Access">PresentationQosPolicy_coherent_access</dref>
   --  <dref name="Ordered_Access">PresentationQosPolicy_ordered_access</dref>


   PRESENTATION_QOS_POLICY_DEFAULT : constant PresentationQosPolicy :=
                                       (INSTANCE_PRESENTATION_QOS,
                                        False,
                                        False);
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 DEADLINE
   --  -------------------------------------------------

   DEADLINE_QOS_POLICY_NAME        : constant DDS.String := To_DDS_String ("Deadline");
   --  <defgroup>DeadlineQosGroupDocs</defgroup>
   --  <dref>DEADLINE_QOS_POLICY_NAME</dref>

   type DeadlineQosPolicy is record
      Period : aliased Duration_T :=  DURATION_INFINITE;
   end record with
     Convention => C;
   --  <dref>DeadlineQosPolicy</dref>
   --  <dref name="Period">DeadlineQosPolicy_period</dref>


   DEADLINE_QOS_POLICY_DEFAULT : constant DeadlineQosPolicy :=
                                   (Period => DURATION_INFINITE);
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 LATENCY_BUDGET
   --  -------------------------------------------------

   LATENCYBUDGET_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("LatencyBudget");
   --  <defgroup>LatencyBudgetQosGroupDocs</defgroup>
   --  <dref>LATENCYBUDGET_QOS_POLICY_NAME</dref>

   type LatencyBudgetQosPolicy is record
      Duration : aliased Duration_T := DURATION_ZERO;
   end record with
     Convention => C;
   --  <dref>LatencyBudgetQosPolicy</dref>
   --  <dref name="Duration">LatencyBudgetQosPolicy_duration</dref>


   LATENCY_BUDGET_QOS_POLICY_DEFAULT : constant LatencyBudgetQosPolicy :=
                                         (Duration => DURATION_ZERO);
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 OWNERSHIP
   --  -------------------------------------------------

   OWNERSHIP_QOS_POLICY_NAME         : constant DDS.String := To_DDS_String ("Ownership");
   --  <defgroup>OwnershipQosGroupDocs</defgroup>
   --  <dref>OWNERSHIP_QOS_POLICY_NAME</dref>

   type OwnershipQosPolicyKind is new Unsigned_Long;
   --  <dref>OwnershipQosPolicyKind</dref>

   SHARED_OWNERSHIP_QOS : constant OwnershipQosPolicyKind := 0;
   --  <dref>OwnershipQosPolicyKind_SHARED_OWNERSHIP_QOS</dref>

   EXCLUSIVE_OWNERSHIP_QOS : constant OwnershipQosPolicyKind := 1;
   --  <dref>OwnershipQosPolicyKind_EXCLUSIVE_OWNERSHIP_QOS</dref>

   type OwnershipQosPolicy is record
      Kind : aliased OwnershipQosPolicyKind := SHARED_OWNERSHIP_QOS;
   end record with
     Convention => C;
   --  <dref>OwnershipQosPolicy</dref>
   --  <dref name="Kind">OwnershipQosPolicy_kind</dref>


   OWNERSHIP_QOS_POLICY_DEFAULT : constant OwnershipQosPolicy :=
                                    (Kind => SHARED_OWNERSHIP_QOS);
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 OWNERSHIP_STRENGTH
   --  -------------------------------------------------

   OWNERSHIPSTRENGTH_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("OwnershipStrength");
   --  <defgroup>OwnershipStrengthQosGroupDocs</defgroup>
   --  <dref>OWNERSHIPSTRENGTH_QOS_POLICY_NAME</dref>

   type OwnershipStrengthQosPolicy is record
      Value : aliased Long := 0;
   end record with
     Convention => C;
   --  <dref>OwnershipStrengthQosPolicy</dref>
   --  <dref name="Value">OwnershipStrengthQosPolicy_value</dref>


   OWNERSHIP_STRENGTH_QOS_POLICY_DEFAULT : constant OwnershipStrengthQosPolicy :=
                                             (Value => 0);
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 LIVELINESS
   --  -------------------------------------------------

   LIVELINESS_QOS_POLICY_NAME            : constant DDS.String := To_DDS_String ("Liveliness");
   --  <defgroup>LivelinessQosGroupDocs</defgroup>
   --  <dref>LIVELINESS_QOS_POLICY_NAME</dref>

   type LivelinessQosPolicyKind is new Unsigned_Long;
   --  <dref>LivelinessQosPolicyKind</dref>

   AUTOMATIC_LIVELINESS_QOS : constant LivelinessQosPolicyKind := 0;
   --  <dref>LivelinessQosPolicyKind_AUTOMATIC_LIVELINESS_QOS</dref>

   MANUAL_BY_PARTICIPANT_LIVELINESS_QOS : constant LivelinessQosPolicyKind := 1;
   --  <dref>LivelinessQosPolicyKind_MANUAL_BY_PARTICIPANT_LIVELINESS_QOS</dref>

   MANUAL_BY_TOPIC_LIVELINESS_QOS : constant LivelinessQosPolicyKind := 2;
   --  <dref>LivelinessQosPolicyKind_MANUAL_BY_TOPIC_LIVELINESS_QOS</dref>

   type LivelinessQosPolicy is record
      Kind                          : aliased LivelinessQosPolicyKind := AUTOMATIC_LIVELINESS_QOS;
      Lease_Duration                : aliased Duration_T := DURATION_INFINITE;
      Assertions_Per_Lease_Duration : aliased Long := 3;
   end record with
     Convention => C;
   --  <dref>LivelinessQosPolicy</dref>
   --  <dref name="Kind">LivelinessQosPolicy_kind</dref>
   --  <dref name="Lease_Duration">LivelinessQosPolicy_lease_duration</dref>
   --  <dref name="Assertions_Per_Lease_Duration">LivelinessQosPolicy_assertions_per_lease_duration</dref>


   LIVELINESS_QOS_POLICY_DEFAULT : constant LivelinessQosPolicy :=
                                     (Kind                          => AUTOMATIC_LIVELINESS_QOS,
                                      Lease_Duration                => DURATION_INFINITE,
                                      Assertions_Per_Lease_Duration => 3);
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 TIME_BASED_FILTER
   --  -------------------------------------------------

   TIMEBASEDFILTER_QOS_POLICY_NAME : constant DDS.String  := To_DDS_String ("TimeBasedFilter");
   --  <defgroup>TimeBasedFilterQosGroupDocs</defgroup>
   --  <dref>TIMEBASEDFILTER_QOS_POLICY_NAME</dref>

   type TimeBasedFilterQosPolicy is record
      Minimum_Separation : aliased Duration_T :=  DURATION_ZERO;
   end record with
     Convention => C;
   --  <dref>TimeBasedFilterQosPolicy</dref>
   --  <dref name="Minimum_Separation">TimeBasedFilterQosPolicy_minimum_separation</dref>

   TIME_BASED_FILTER_QOS_POLICY_DEFAULT : constant  TimeBasedFilterQosPolicy :=
                                            (Minimum_Separation => DURATION_ZERO);
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 PARTITION
   --  -------------------------------------------------

   PARTITION_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("Partition");
   --  <defgroup>PartitionQosGroupDocs</defgroup>
   --  <dref>PARTITION_QOS_POLICY_NAME</dref>

   type PartitionQosPolicy is record
      Name : aliased String_Seq.Sequence;
   end record with
     Convention => C;
   --  <dref>PartitionQosPolicy</dref>
   --  <dref name="Name">PartitionQosPolicy_name</dref>

   --     PARTITION_QOS_POLICY_DEFAULT : constant PartitionQosPolicy :=
   --                                      (Name => String_Seq.DEFAULT_SEQUENCE);

   --  -------------------------------------------------
   --                 RELIABILITY
   --  -------------------------------------------------

   RELIABILITY_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("Reliability");
   --  <defgroup>ReliabilityQosGroupDocs</defgroup>
   --  <dref>RELIABILITY_QOS_POLICY_NAME</dref>

   type ReliabilityQosPolicyKind is new Unsigned_Long;
   --  <dref>ReliabilityQosPolicyKind</dref>

   BEST_EFFORT_RELIABILITY_QOS : constant ReliabilityQosPolicyKind := 0;
   --  <dref>ReliabilityQosPolicyKind_BEST_EFFORT_RELIABILITY_QOS</dref>

   RELIABLE_RELIABILITY_QOS : constant ReliabilityQosPolicyKind := 1;
   --  <dref>ReliabilityQosPolicyKind_RELIABLE_RELIABILITY_QOS</dref>

   type ReliabilityQosPolicyAcknowledgmentModeKind is new Unsigned_Long;
   --  <dref>ReliabilityQosPolicyAcknowledgmentModeKind</dref>

   PROTOCOL_ACKNOWLEDGMENT_MODE : constant ReliabilityQosPolicyAcknowledgmentModeKind := 0;
   --  <dref>ReliabilityQosPolicyAcknowledgmentModeKind_PROTOCOL_ACKNOWLEDGMENT_MODE</dref>

   APPICATION_AUTO_ACKNOWLEDGMENT_MODE : constant ReliabilityQosPolicyAcknowledgmentModeKind := 1;
   --  <dref>ReliabilityQosPolicyAcknowledgmentModeKind_APPLICATION_AUTO_ACKNOWLEDGMENT_MODE</dref>

   APPICATION_ORDERED_ACKNOWLEDGMENT_MODE : constant ReliabilityQosPolicyAcknowledgmentModeKind := 2;
   --  <dref>ReliabilityQosPolicyAcknowledgmentModeKind_APPLICATION_ORDERED_ACKNOWLEDGMENT_MODE</dref>

   APPICATION_EXPLICIT_ACKNOWLEDGMENT_MODE : constant ReliabilityQosPolicyAcknowledgmentModeKind := 3;
   --  <dref>ReliabilityQosPolicyAcknowledgmentModeKind_APPLICATION_EXPLICIT_ACKNOWLEDGMENT_MODE</dref>

   type ReliabilityQosPolicy is record
      Kind                : aliased ReliabilityQosPolicyKind := BEST_EFFORT_RELIABILITY_QOS;
      Max_Blocking_Time   : aliased Duration_T := (0, 100_000_000);
      Acknowledgment_Kind : aliased ReliabilityQosPolicyAcknowledgmentModeKind := PROTOCOL_ACKNOWLEDGMENT_MODE;
   end record with
     Convention => C;
   --  <dref>ReliabilityQosPolicy</dref>
   --  <dref name="Kind">ReliabilityQosPolicy_kind</dref>
   --  <dref name="Max_Blocking_Time">ReliabilityQosPolicy_max_blocking_time</dref>
   --  <dref name="Acknowledgment_Kind">ReliabilityQosPolicy_acknowledgment_kind</dref>

   RELIABILITY_QOS_POLICY_DEFAULT : constant ReliabilityQosPolicy :=
                                      (BEST_EFFORT_RELIABILITY_QOS, (0, 100_000_000), PROTOCOL_ACKNOWLEDGMENT_MODE);
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 DESTINATION_ORDER
   --  -------------------------------------------------

   DESTINATIONORDER_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("DestinationOrder");
   --  <defgroup>DestinationOrderQosGroupDocs</defgroup>
   --  <dref>DESTINATIONORDER_QOS_POLICY_NAME</dref>

   type DestinationOrderQosPolicyKind is new Unsigned_Long;
   --  <dref>DestinationOrderQosPolicyKind</dref>

   BY_RECEPTION_TIMESTAMP_DESTINATIONORDER_QOS : constant DestinationOrderQosPolicyKind := 0;
   --  <dref>DestinationOrderQosPolicyKind_BY_RECEPTION_TIMESTAMP_DESTINATIONORDER_QOS</dref>

   BY_SOURCE_TIMESTAMP_DESTINATIONORDER_QOS : constant DestinationOrderQosPolicyKind := 1;
   --  <dref>DestinationOrderQosPolicyKind_BY_SOURCE_TIMESTAMP_DESTINATIONORDER_QOS</dref>

   type DestinationOrderQosPolicyScopeKind is new Unsigned_Long;
   --  <dref internal="true">DestinationOrderQosPolicyScopeKind</dref>

   INSTANCE_SCOPE_DESTINATIONORDER_QOS : constant DestinationOrderQosPolicyScopeKind := 0;
   --  <dref internal="true">DestinationOrderQosPolicyScopeKind_INSTANCE_SCOPE_DESTINATIONORDER_QOS</dref>

   TOPIC_SCOPE_DESTINATIONORDER_QOS : constant DestinationOrderQosPolicyScopeKind := 1;
   --  <dref internal="true">DestinationOrderQosPolicyScopeKind_TOPIC_SCOPE_DESTINATIONORDER_QOS</dref>

   type DestinationOrderQosPolicy is record
      Kind                       : aliased DestinationOrderQosPolicyKind := BY_RECEPTION_TIMESTAMP_DESTINATIONORDER_QOS;
      Scope                      : aliased DestinationOrderQosPolicyScopeKind := INSTANCE_SCOPE_DESTINATIONORDER_QOS;
      Source_Timestamp_Tolerance : aliased Duration_T := DURATION_ZERO;
   end record;
   --  <dref>DestinationOrderQosPolicy</dref>
   --  <dref name="Kind">DestinationOrderQosPolicy_kind</dref>
   --  <dref internal="true" name="Scope">DestinationOrderQosPolicy_scope</dref>
   --  <dref name="source_timestamp_tolerance">DestinationOrderQosPolicy_source_timestamp_tolerance</dref>

   pragma Convention (C, DestinationOrderQosPolicy);

   DESTINATION_ORDER_QOS_POLICY_DEFAULT : constant DestinationOrderQosPolicy :=
                                            (BY_RECEPTION_TIMESTAMP_DESTINATIONORDER_QOS,
                                             INSTANCE_SCOPE_DESTINATIONORDER_QOS,
                                             DURATION_ZERO);
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 HISTORY
   --  -------------------------------------------------

   HISTORY_QOS_POLICY_NAME              : constant DDS.String := To_DDS_String ("History");
   --  <defgroup>HistoryQosGroupDocs</defgroup>
   --  <dref>HISTORY_QOS_POLICY_NAME</dref>

   type HistoryQosPolicyKind is new Unsigned_Long;
   --  <dref>HistoryQosPolicyKind</dref>

   KEEP_LAST_HISTORY_QOS                : constant HistoryQosPolicyKind := 0;
   --  <dref>HistoryQosPolicyKind_KEEP_LAST_HISTORY_QOS</dref>

   KEEP_ALL_HISTORY_QOS                 : constant HistoryQosPolicyKind := 1;
   --  <dref>HistoryQosPolicyKind_KEEP_ALL_HISTORY_QOS</dref>

   type RefilterQosPolicyKind is new Unsigned_Long;
   --  <dref>RefilterQosPolicyKind</dref>

   NONE_REFILTER_QOS                    : constant RefilterQosPolicyKind := 0;
   --  <dref>RefilterQosPolicyKind_NONE_REFILTER_QOS</dref>

   ALL_REFILTER_QOS                     : constant RefilterQosPolicyKind := 1;
   --  <dref>RefilterQosPolicyKind_ALL_REFILTER_QOS</dref>

   ON_DEMAND_REFILTER_QOS               : constant RefilterQosPolicyKind := 2;
   --  <dref>RefilterQosPolicyKind_ON_DEMAND_REFILTER_QOS</dref>

   type HistoryQosPolicy is record
      Kind     : aliased HistoryQosPolicyKind := KEEP_LAST_HISTORY_QOS;
      Depth    : aliased Long := 1;
      Refilter : aliased RefilterQosPolicyKind := NONE_REFILTER_QOS;
   end record with
     Convention => C;
   --  <dref>HistoryQosPolicy</dref>
   --  <dref name="Kind">HistoryQosPolicy_kind</dref>
   --  <dref name="Depth">HistoryQosPolicy_depth</dref>
   --  <dref name="Refilter">HistoryQosPolicy_refilter</dref>

   HISTORY_QOS_POLICY_DEFAULT           : constant HistoryQosPolicy :=
                                            (KEEP_LAST_HISTORY_QOS,
                                             1,
                                             NONE_REFILTER_QOS);
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 LENGTH_UNLIMITED
   --  -------------------------------------------------

   LENGTH_UNLIMITED                     : constant Long  := -1;
   --  <dref>LENGTH_UNLIMITED</dref>

   --  -------------------------------------------------
   --                 DURABILITY_SERVICE
   --  -------------------------------------------------

   DURABILITYSERVICE_QOS_POLICY_NAME    : constant DDS.String := To_DDS_String ("DurabilityService");
   --  <defgroup>DurabilityServiceQosGroupDocs</defgroup>
   --  <dref>DURABILITY_QOS_POLICY_NAME</dref>

   type DurabilityServiceQosPolicy is record
      Service_Cleanup_Delay    : aliased Duration_T := DURATION_ZERO;
      History_Kind             : aliased HistoryQosPolicyKind := KEEP_LAST_HISTORY_QOS;
      History_Depth            : aliased Long := 1;
      Max_Samples              : aliased Long := LENGTH_UNLIMITED;
      Max_Instances            : aliased Long := LENGTH_UNLIMITED;
      Max_Samples_Per_Instance : aliased Long := LENGTH_UNLIMITED;
   end record with
     Convention => C;
   --  <dref>DurabilityServiceQosPolicy</dref>
   --  <dref name="Service_Cleanup_Delay">DurabilityServiceQosPolicy_service_cleanup_delay</dref>
   --  <dref name="History_Kind">DurabilityServiceQosPolicy_history_kind</dref>
   --  <dref name="History_Depth">DurabilityServiceQosPolicy_history_depth</dref>
   --  <dref name="Max_Samples">DurabilityServiceQosPolicy_max_samples</dref>
   --  <dref name="Max_Instances">DurabilityServiceQosPolicy_max_instances</dref>
   --  <dref name="Max_Samples_Per_Instance">DurabilityServiceQosPolicy_max_samples_per_instance</dref>


   DURABILITY_SERVICE_QOS_POLICY_DEFAULT : constant DurabilityServiceQosPolicy :=
                                             (DURATION_ZERO,
                                              KEEP_LAST_HISTORY_QOS,
                                              1,
                                              LENGTH_UNLIMITED,
                                              LENGTH_UNLIMITED,
                                              LENGTH_UNLIMITED);
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 RESOURCE_LIMITS
   --  -------------------------------------------------

   RESOURCELIMITS_QOS_POLICY_NAME        : constant DDS.String := To_DDS_String ("ResourceLimits");
   --  <defgroup>ResourceLimitsQosGroupDocs</defgroup>
   --  <dref>RESOURCELIMITS_QOS_POLICY_NAME</dref>

   type ResourceLimitsQosPolicy is record
      Max_Samples              : aliased Long := LENGTH_UNLIMITED;
      Max_Instances            : aliased Long := LENGTH_UNLIMITED;
      Max_Samples_Per_Instance : aliased Long := LENGTH_UNLIMITED;
      Initial_Samples          : aliased Long := 32;
      Initial_Instances        : aliased Long := 32;
      Instance_Hash_Buckets    : aliased Long := 32;
   end record;
   --  <dref>ResourceLimitsQosPolicy</dref>
   --  <dref name="Max_Samples">ResourceLimitsQosPolicy_max_samples</dref>
   --  <dref name="Max_Instances">ResourceLimitsQosPolicy_max_instances</dref>
   --  <dref name="Max_Samples_Per_Instance">ResourceLimitsQosPolicy_max_samples_per_instance</dref>
   --  <dref name="Initial_Samples">ResourceLimitsQosPolicy_initial_samples</dref>
   --  <dref name="Initial_Instances">ResourceLimitsQosPolicy_initial_instances</dref>
   --  <dref name="Instance_Hash_Buckets">ResourceLimitsQosPolicy_instance_hash_buckets</dref>

   pragma Convention (C, ResourceLimitsQosPolicy);

   RESOURCE_LIMITS_QOS_POLICY_DEFAULT : constant ResourceLimitsQosPolicy :=
                                          (LENGTH_UNLIMITED,
                                           LENGTH_UNLIMITED,
                                           LENGTH_UNLIMITED,
                                           32,
                                           32,
                                           32);
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 TRANSPORT_PRIORITY
   --  -------------------------------------------------

   TRANSPORTPRIORITY_QOS_POLICY_NAME  : constant DDS.String := To_DDS_String ("TransportPriority");
   --  <defgroup>TransportPriorityQosGroupDocs</defgroup>
   --  <dref>TRANSPORTPRIORITY_QOS_POLICY_NAME</dref>

   type TransportPriorityQosPolicy is record
      Value : aliased Long := 0;
   end record with
     Convention => C;
   --  <dref>TransportPriorityQosPolicy</dref>
   --  <dref name="Value">TransportPriorityQosPolicy_value</dref>

   TRANSPORT_PRIORITY_QOS_POLICY_DEFAULT : constant TransportPriorityQosPolicy :=
                                             (Value => 0);
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 LIFESPAN
   --  -------------------------------------------------

   LIFESPAN_QOS_POLICY_NAME              : constant DDS.String := To_DDS_String ("Lifespan");
   --  <defgroup>LifespanQosGroupDocs</defgroup>
   --  <dref>LIFESPAN_QOS_POLICY_NAME</dref>

   type LifespanQosPolicy is record
      Duration : aliased Duration_T := DURATION_INFINITE;
   end record with
     Convention => C;
   --  <dref>LifespanQosPolicy</dref>
   --  <dref name="Duration">LifespanQosPolicy_duration</dref>


   LIFESPAN_QOS_POLICY_DEFAULT        : constant LifespanQosPolicy :=
                                          (Duration => DURATION_INFINITE);
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 WRITER_DATA_LIFECYCLE
   --  -------------------------------------------------

   WRITERDATALIFECYCLE_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("WriterDataLifecycle");
   --  <defgroup>WriterDataLifecycleQosGroupDocs</defgroup>
   --  <dref>WRITERDATALIFECYCLE_QOS_POLICY_NAME</dref>

   type WriterDataLifecycleQosPolicy is record
      Autodispose_Unregistered_Instances     : aliased DDS.Boolean := True;
      Autopurge_Unregistered_Instances_Delay : aliased DDS.Duration_T := DURATION_INFINITE;
      Autopurge_Disposed_Instances_Delay     : aliased DDS.Duration_T := DURATION_INFINITE;
   end record with
     Convention => C;
   --  <dref>WriterDataLifecycleQosPolicy</dref>
   --  <dref name="Autodispose_Unregistered_Instances">WriterDataLifecycleQosPolicy_autodispose_unregistered_instances</dref>
   --  <dref name="Autopurge_Unregistered_Instances_Delay">WriterDataLifecycleQosPolicy_autopurge_unregistered_instances_delay</dref>
   --  <dref name="Autopurge_Disposed_Instances_Delay">WriterDataLifecycleQosPolicy_autopurge_disposed_instances_delay</dref>

   WRITER_DATA_LIFECYCLE_QOS_POLICY_DEFAULT : constant WriterDataLifecycleQosPolicy :=
                                                (Autodispose_Unregistered_Instances     => True,
                                                 Autopurge_Unregistered_Instances_Delay => DURATION_INFINITE,
                                                 Autopurge_Disposed_Instances_Delay     => DURATION_INFINITE);
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 READER_DATA_LIFECYCLE
   --  -------------------------------------------------

   READERDATALIFECYCLE_QOS_POLICY_NAME      : constant DDS.String := To_DDS_String ("ReaderDataLifecycle");
   --  <defgroup>ReaderDataLifecycleQosGroupDocs</defgroup>
   --  <dref>READERDATALIFECYCLE_QOS_POLICY_NAME</dref>

   type ReaderDataLifecycleQosPolicy is record
      Autopurge_Nowriter_Samples_Delay   : aliased Duration_T := DURATION_INFINITE;
      Autopurge_Disposed_Samples_Delay   : aliased Duration_T := DURATION_INFINITE;
      Autopurge_Disposed_Instances_Delay : aliased Duration_T := DURATION_INFINITE;
   end record with
     Convention => C;
   --  <dref>ReaderDataLifecycleQosPolicy</dref>
   --  <dref name="Autopurge_Nowriter_Samples_Delay">ReaderDataLifecycleQosPolicy_autopurge_nowriter_samples_delay</dref>
   --  <dref name="Autopurge_Disposed_Samples_Delay">ReaderDataLifecycleQosPolicy_autopurge_disposed_samples_delay</dref>
   --  <dref name="Autopurge_Disposed_Instances_Delay">ReaderDataLifecycleQosPolicy_autopurge_disposed_instances_delay</dref>

   READER_DATA_LIFECYCLE_QOS_POLICY_DEFAULT : constant ReaderDataLifecycleQosPolicy :=
                                                (Autopurge_Nowriter_Samples_Delay   => DURATION_INFINITE,
                                                 Autopurge_Disposed_Samples_Delay   => DURATION_INFINITE,
                                                 Autopurge_Disposed_Instances_Delay => DURATION_INFINITE);
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 ENTITY_FACTORY
   --  -------------------------------------------------

   ENTITYFACTORY_QOS_POLICY_NAME            : constant DDS.String := To_DDS_String ("EntityFactory");
   --  <defgroup>EntityFactoryQosGroupDocs</defgroup>
   --  <dref>ENTITYFACTORY_QOS_POLICY_NAME</dref>

   type EntityFactoryQosPolicy is record
      Autoenable_Created_Entities : aliased DDS.Boolean := True;
   end record with
     Convention => C;
   --  <dref>EntityFactoryQosPolicy</dref>
   --  <dref name="Autoenable_Created_Entities">EntityFactoryQosPolicy_autoenable_created_entities</dref>

   ENTITY_FACTORY_QOS_POLICY_DEFAULT  : constant EntityFactoryQosPolicy :=
                                          (Autoenable_Created_Entities => True);
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 EXTENDED QOS SUPPORT
   --  -------------------------------------------------

   --!!!
   --!!! RTI DDS Extensions
   --!!!

   --  -------------------------------------------------
   --                 AllocationSettings_t
   --  -------------------------------------------------

   type AllocationSettings_T is record
      Initial_Count     : aliased Long := 0;
      Max_Count         : aliased Long := 0;
      Incremental_Count : aliased Long := 0;
   end record with
     Convention => C;
   --  <defgroup>ExtendedQosSupportGroupDocs</defgroup>
   --  <dref>AllocationSettings_t</dref>
   --  <dref name="Initial_Count">AllocationSettings_t_initial_count</dref>
   --  <dref name="Max_Count">AllocationSettings_t_max_count</dref>
   --  <dref name="Incremental_Count">AllocationSettings_t_incremental_count</dref>

   AllocationSettings_T_AUTO : constant AllocationSettings_T := (
      Initial_Count     => RTIDDS.Low_Level.ndds_reda_reda_fastBuffer_h.REDA_FAST_BUFFER_POOL_AUTO,
      Max_Count         => RTIDDS.Low_Level.ndds_reda_reda_fastBuffer_h.REDA_FAST_BUFFER_POOL_AUTO,
      Incremental_Count => RTIDDS.Low_Level.ndds_reda_reda_fastBuffer_h.REDA_FAST_BUFFER_POOL_AUTO);

   type  AllocationSettings_T_Access is access all  AllocationSettings_T;

   function "+" (Left, Right : aliased AllocationSettings_T) return AllocationSettings_T;

   --  -------------------------------------------------
   --                 RtpsReliableReaderProtocol_t
   --  -------------------------------------------------

   type RtpsReliableReaderProtocol_T is record
      Min_Heartbeat_Response_Delay       : aliased Duration_T := (0, 0);
      Max_Heartbeat_Response_Delay       : aliased Duration_T := (0, 500_000_000);
      Heartbeat_Suppression_Duration     : aliased Duration_T := (0, 62_500_000);
      Nack_Period                        : aliased Duration_T := (5, 0);
      Receive_Window_Size                : aliased Long := 256;
      Round_Trip_Time                    : aliased Duration_T := (0, 0);
      App_Ack_Period                     : aliased Duration_T := (5, 0);
      Min_App_Ack_Response_Keep_Duration : aliased Duration_T := (0, 0);
      Samples_Per_App_Ack                : aliased Long := 1;
   end record with Convention => C;
   --  <dref>RtpsReliableReaderProtocol_t</dref>
   --  <dref name="Min_Heartbeat_Response_Delay">RtpsReliableReaderProtocol_t_min_heartbeat_response_delay</dref>
   --  <dref name="Max_Heartbeat_response_Delay">RtpsReliableReaderProtocol_t_max_heartbeat_response_delay</dref>
   --  <dref name="Heartbeat_Suppression_Duration">RtpsReliableReaderProtocol_t_heartbeat_suppression_duration</dref>
   --  <dref name="Nack_Period">RtpsReliableReaderProtocol_t_nack_period</dref>
   --  <dref name="Receive_Window_Size">RtpsReliableReaderProtocol_t_receive_window_size</dref>
   --  <dref name="Round_Trip_Time">RtpsReliableReaderProtocol_t_round_trip_time</dref>
   --  <dref name="App_Ack_Period">RtpsReliableReaderProtocol_t_app_ack_period</dref>
   --  <dref name="Min_App_Ack_Response_Keep_Duration">RtpsReliableReaderProtocol_t_min_app_ack_response_keep_duration</dref>
   --  <dref name="Samples_Per_App_Ack">RtpsReliableReaderProtocol_t_samples_per_app_ack</dref>

   RTPS_RELIABLE_READER_PROTOCOL_DEFAULT : aliased constant RtpsReliableReaderProtocol_T :=
                                             (Min_Heartbeat_Response_Delay       => (0, 0),
                                              Max_Heartbeat_Response_Delay       => (0, 500_000_000),
                                              Heartbeat_Suppression_Duration     => (0, 62_500_000),
                                              Nack_Period                        => (5, 0),
                                              Receive_Window_Size                => 256,
                                              Round_Trip_Time                    => (0, 0),
                                              App_Ack_Period                     => (5, 0),
                                              Min_App_Ack_Response_Keep_Duration => (0, 0),
                                              Samples_Per_App_Ack                => 1);
   --  <dref internal="true"></dref>

   RTPS_RELIABLE_READER_PROTOCOL_DISCOVERY_CONFIG_DEFAULT :
   aliased  constant RtpsReliableReaderProtocol_T := (Min_Heartbeat_Response_Delay       => (0, 0),
                                                      Max_Heartbeat_Response_Delay       => (0, 0),
                                                      Heartbeat_Suppression_Duration     => (0, 62_500_000),
                                                      Nack_Period                        => (5, 0),
                                                      Receive_Window_Size                => 256,
                                                      Round_Trip_Time                    => (0, 0),
                                                      App_Ack_Period                     => (5, 0),
                                                      Min_App_Ack_Response_Keep_Duration => (0, 0),
                                                      Samples_Per_App_Ack                => 1);
   --  <dref internal="true"></dref>

   RTPS_PARTICIPANT_MESSAGE_READER_DISCOVERY_CONFIG_DEFAULT :
   aliased constant RtpsReliableReaderProtocol_T := (Min_Heartbeat_Response_Delay       => (0, 0),
                                                     Max_Heartbeat_Response_Delay       => (0, 0),
                                                     Heartbeat_Suppression_Duration     => (0, 62_500_000),
                                                     Nack_Period                        => (5, 0),
                                                     Receive_Window_Size                => 256,
                                                     Round_Trip_Time                    => (0, 0),
                                                     App_Ack_Period                     => (5, 0),
                                                     Min_App_Ack_Response_Keep_Duration => (0, 0),
                                                     Samples_Per_App_Ack                => 1);
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 RtpsReliableWriterProtocol_t
   --  -------------------------------------------------

   type RtpsReliableWriterProtocol_T is record -- RTPS_RELIABLE_WRITER_PROTOCOL_DEFAULT is default
      Low_Watermark                                                     : aliased Long := 0;
      High_Watermark                                                    : aliased Long := 1;
      Heartbeat_Period                                                  : aliased Duration_T := (3, 0);
      Fast_Heartbeat_Period                                             : aliased Duration_T := (3, 0);
      Late_Joiner_Heartbeat_Period                                      : aliased Duration_T := (3, 0);
      Virtual_Heartbeat_Period                                          : aliased Duration_T := DURATION_INFINITE;
      Samples_Per_Virtual_Heartbeat                                     : aliased Long := -1;
      Max_Heartbeat_Retries                                             : aliased Long := 10;
      Inactivate_Nonprogressing_Readers                                 : aliased Boolean := False;
      Heartbeats_Per_Max_Samples                                        : aliased Long := 8;
      Min_Nack_Response_Delay                                           : aliased Duration_T := (0, 0);
      Max_Nack_Response_Delay                                           : aliased Duration_T := (0, 200_000_000);
      Nack_Suppression_Duration                                         : aliased Duration_T := (0, 0);
      Max_Bytes_Per_Nack_Response                                       : aliased Long := 131072;
      Disable_Positive_Acks_Min_Sample_Keep_Duration                    : aliased Duration_T := (0, 1_000_000);
      Disable_Positive_Acks_Max_Sample_Keep_Duration                    : aliased Duration_T := (1, 0);
      Disable_Positive_Acks_Sample_Min_Separation                       : aliased Duration_T := (0, 1_000_000);
      Disable_Positive_Acks_Enable_Adaptive_Sample_Keep_Duration        : aliased Boolean := True;
      Disable_Positive_Acks_Enable_Spin_Wait                            : aliased Boolean := False;
      Disable_Positive_Acks_Decrease_Sample_Keep_Duration_Factor        : aliased Long := 0;
      Disable_Positive_Acks_Increase_Sample_Keep_Duration_Factor        : aliased Long := 3;
      Min_Send_Window_Size                                              : aliased Long := 32;
      Max_Send_Window_Size                                              : aliased Long := 256;
      Send_Window_Update_Period                                         : aliased Duration_T := (3, 0);
      Send_Window_Increase_Factor                                       : aliased Long := 105;
      Send_Window_Decrease_Factor                                       : aliased Long := 70;
      Enable_Multicast_Periodic_Heartbeat                               : aliased Boolean := False;
      Multicast_Resend_Threshold                                        : aliased Long := 2;
   end record with
     Convention => C;
   --  <dref>RtpsReliableWriterProtocol_t</dref>
   --  <dref name="low_watermark">RtpsReliableWriterProtocol_t_low_watermark</dref>
   --  <dref name="high_watermark">RtpsReliableWriterProtocol_t_high_watermark</dref>
   --  <dref name="heartbeat_period">RtpsReliableWriterProtocol_t_heartbeat_period</dref>
   --  <dref name="fast_heartbeat_period">RtpsReliableWriterProtocol_t_fast_heartbeat_period</dref>
   --  <dref name="late_joiner_heartbeat_period">RtpsReliableWriterProtocol_t_late_joiner_heartbeat_period</dref>
   --  <dref name="virtual_heartbeat_period">RtpsReliableWriterProtocol_t_virtual_heartbeat_period</dref>
   --  <dref name="samples_per_virtual_heartbeat">RtpsReliableWriterProtocol_t_samples_per_virtual_heartbeat</dref>
   --  <dref name="max_heartbeat_retries">RtpsReliableWriterProtocol_t_max_heartbeat_retries</dref>
   --  <dref name="inactivate_nonprogresing_readers">RtpsReliableWriterProtocol_t_inactivate_nonprogressing_readers</dref>
   --  <dref name="heartbeats_per_max_samples">RtpsReliableWriterProtocol_t_heartbeats_per_max_samples</dref>
   --  <dref name="min_nack_response_delay">RtpsReliableWriterProtocol_t_min_nack_response_delay</dref>
   --  <dref name="max_nack_response_delay">RtpsReliableWriterProtocol_t_max_nack_response_delay</dref>
   --  <dref name="nack_suppression_duration">RtpsReliableWriterProtocol_t_nack_suppression_duration</dref>
   --  <dref name="max_bytes_per_nack_response">RtpsReliableWriterProtocol_t_max_bytes_per_nack_response</dref>
   --  <dref name="disable_positive_acks_min_sample_keep_duration">RtpsReliableWriterProtocol_t_disable_positive_acks_min_sample_keep_duration</dref>
   --  <dref name="disable_positive_acks_max_sample_keep_duration">RtpsReliableWriterProtocol_t_disable_positive_acks_max_sample_keep_duration</dref>
   --  <dref internal="true" name="disable_positive_acks_sample_min_separation">RtpsReliableWriterProtocol_t_disable_positive_acks_sample_min_separation</dref>
   --  <dref name="disable_positive_acks_enable_adaptive_sample_keep_duration">RtpsReliableWriterProtocol_t_disable_positive_acks_enable_adaptive_sample_keep_duration</dref>
   --  <dref name="disable_positive_acks_enable_spin_wait">RtpsReliableWriterProtocol_t_disable_positive_acks_enable_spin_wait</dref>
   --  <dref name="disable_positive_acks_decrease_sample_keep_duration_factor">RtpsReliableWriterProtocol_t_disable_positive_acks_decrease_sample_keep_duration_factor</dref>
   --  <dref name="disable_positive_acks_increase_sample_keep_duration_factor">RtpsReliableWriterProtocol_t_disable_positive_acks_increase_sample_keep_duration_factor</dref>
   --  <dref name="min_send_window_size">RtpsReliableWriterProtocol_t_min_send_window_size</dref>
   --  <dref name="max_send_window_size">RtpsReliableWriterProtocol_t_max_send_window_size</dref>
   --  <dref name="send_window_update_period">RtpsReliableWriterProtocol_t_send_window_update_period</dref>
   --  <dref name="send_window_increase_factor">RtpsReliableWriterProtocol_t_send_window_increase_factor</dref>
   --  <dref name="send_window_decrease_factor">RtpsReliableWriterProtocol_t_send_window_decrease_factor</dref>
   --  <dref name="enable_multicast_periodic_heartbeat">RtpsReliableWriterProtocol_t_enable_multicast_periodic_heartbeat</dref>
   --  <dref name="multicast_resend_threshold">RtpsReliableWriterProtocol_t_multicast_resend_threshold</dref>

   --  for RtpsReliableWriterProtocol_T'Alignment use 8;
   --  pragma Annotate (RtpsReliableWriterProtocol_T, Source => RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_RtpsReliableWriterProtocol_t);

   RTPS_RELIABLE_WRITER_PROTOCOL_DEFAULT :
   constant RtpsReliableWriterProtocol_T := (Low_Watermark                                                    => 0,
                                             High_Watermark                                                   => 1,
                                             Heartbeat_Period                                                 => (3, 0),
                                             Fast_Heartbeat_Period                                            => (3, 0),
                                             Late_Joiner_Heartbeat_Period                                     => (3, 0),
                                             Virtual_Heartbeat_Period                                         => DURATION_INFINITE,
                                             Samples_Per_Virtual_Heartbeat                                    => -1,
                                             Max_Heartbeat_Retries                                            => 10,
                                             Inactivate_Nonprogressing_Readers                                => False,
                                             Heartbeats_Per_Max_Samples                                       => 8,
                                             Min_Nack_Response_Delay                                          => (0, 0),
                                             Max_Nack_Response_Delay                                          => (0, 200_000_000),
                                             Nack_Suppression_Duration                                        => (0, 0),
                                             Max_Bytes_Per_Nack_Response                                      => 131072,
                                             Disable_Positive_Acks_Min_Sample_Keep_Duration                   => (0, 1_000_000),
                                             Disable_Positive_Acks_Max_Sample_Keep_Duration                   => (1, 0),
                                             Disable_Positive_Acks_Sample_Min_Separation                      => (0, 100_000),
                                             Disable_Positive_Acks_Enable_Adaptive_Sample_Keep_Duration       => True,
                                             Disable_Positive_Acks_Enable_Spin_Wait                           => False,
                                             Disable_Positive_Acks_Decrease_Sample_Keep_Duration_Factor       => 0,
                                             Disable_Positive_Acks_Increase_Sample_Keep_Duration_Factor       => 3,
                                             Min_Send_Window_Size                                             => 32,
                                             Max_Send_Window_Size                                             => 256,
                                             Send_Window_Update_Period                                        => (3, 0),
                                             Send_Window_Increase_Factor                                      => 105,
                                             Send_Window_Decrease_Factor                                      => 70,
                                             Enable_Multicast_Periodic_Heartbeat                              => False,
                                             Multicast_Resend_Threshold                                       => 2
                                            );
   --  <dref internal="true"></dref>

   RTPS_RELIABLE_WRITER_PROTOCOL_DISCOVERY_CONFIG_DEFAULT  :
   constant RtpsReliableWriterProtocol_T := (Low_Watermark                                                      => 0,
                                             High_Watermark                                                     => 1,
                                             Heartbeat_Period                                                   => (3, 0),
                                             Fast_Heartbeat_Period                                              => (3, 0),
                                             Late_Joiner_Heartbeat_Period                                       => (3, 0),
                                             Virtual_Heartbeat_Period                                           => DURATION_INFINITE,
                                             Samples_Per_Virtual_Heartbeat                                      => -1,
                                             Max_Heartbeat_Retries                                              => 10,
                                             Inactivate_Nonprogressing_Readers                                  => False,
                                             Heartbeats_Per_Max_Samples                                         => 8,
                                             Min_Nack_Response_Delay                                            => (0, 0),
                                             Max_Nack_Response_Delay                                            => (0, 0),
                                             Nack_Suppression_Duration                                          => (0, 0),
                                             Max_Bytes_Per_Nack_Response                                        => 131072,
                                             Disable_Positive_Acks_Min_Sample_Keep_Duration                     => (0, 1_000_000),
                                             Disable_Positive_Acks_Max_Sample_Keep_Duration                     => (1, 0),
                                             Disable_Positive_Acks_Sample_Min_Separation                        => (0, 100_000),
                                             Disable_Positive_Acks_Enable_Adaptive_Sample_Keep_Duration         => True,
                                             Disable_Positive_Acks_Enable_Spin_Wait                             => False,
                                             Disable_Positive_Acks_Decrease_Sample_Keep_Duration_Factor         => 95,
                                             Disable_Positive_Acks_Increase_Sample_Keep_Duration_Factor         => 150,
                                             Min_Send_Window_Size                                               => -1,
                                             Max_Send_Window_Size                                               => -1,
                                             Send_Window_Update_Period                                          => (3, 0),
                                             Send_Window_Increase_Factor                                        => 105,
                                             Send_Window_Decrease_Factor                                        => 50,
                                             Enable_Multicast_Periodic_Heartbeat                                => False,
                                             Multicast_Resend_Threshold                                         => 2
                                            );
   --  <dref internal="true"></dref>

   RTPS_PARTICIPANT_MESSAGE_WRITER_DISCOVERY_CONFIG_DEFAULT  :
   constant RtpsReliableWriterProtocol_T := (Low_Watermark                                                      => 0,
                                             High_Watermark                                                     => 1,
                                             Heartbeat_Period                                                   => (1, 0),
                                             Fast_Heartbeat_Period                                              => (1, 0),
                                             Late_Joiner_Heartbeat_Period                                       => (1, 0),
                                             Virtual_Heartbeat_Period                                           => DURATION_INFINITE,
                                             Samples_Per_Virtual_Heartbeat                                      => -1,
                                             Max_Heartbeat_Retries                                              => 10,
                                             Inactivate_Nonprogressing_Readers                                  => False,
                                             Heartbeats_Per_Max_Samples                                         => 1,
                                             Min_Nack_Response_Delay                                            => (0, 0),
                                             Max_Nack_Response_Delay                                            => (0, 0),
                                             Nack_Suppression_Duration                                          => (0, 0),
                                             Max_Bytes_Per_Nack_Response                                        => 9216,
                                             Disable_Positive_Acks_Min_Sample_Keep_Duration                     => (0, 1_000_000),
                                             Disable_Positive_Acks_Max_Sample_Keep_Duration                     => (1, 0),
                                             Disable_Positive_Acks_Sample_Min_Separation                        => (0, 100_000),
                                             Disable_Positive_Acks_Enable_Adaptive_Sample_Keep_Duration         => True,
                                             Disable_Positive_Acks_Enable_Spin_Wait                             => False,
                                             Disable_Positive_Acks_Decrease_Sample_Keep_Duration_Factor         => 95,
                                             Disable_Positive_Acks_Increase_Sample_Keep_Duration_Factor         => 150,
                                             Min_Send_Window_Size                                               => -1,
                                             Max_Send_Window_Size                                               => -1,
                                             Send_Window_Update_Period                                          => (1, 0),
                                             Send_Window_Increase_Factor                                        => 105,
                                             Send_Window_Decrease_Factor                                        => 50,
                                             Enable_Multicast_Periodic_Heartbeat                                => False,
                                             Multicast_Resend_Threshold                                         => 2
                                            );
   --  <dref internal="true"></dref>

   --  -------------------------------------------------
   --                 UserObjectSettings_t
   --  -------------------------------------------------

   type UserObjectSettings_T is record
      Size      : aliased Long := 0;
      Alignment : aliased Long := 0;
   end record with
     Convention => C;
   --  <dref internal="true">UserObjectSettings_t</dref>
   --  <dref internal="true" name="Size">UserObjectSettings_t_size</dref>
   --  <dref internal="true" name="Alignment">UserObjectSettings_t_alignment</dref>

   --  -------------------------------------------------
   --                 TransportUnicastSettings_t
   --  -------------------------------------------------

   type TransportUnicastSettings_T is record
      Transports   : aliased String_Seq.Sequence;
      Receive_Port : aliased Long := 0;
   end record with
     Convention => C;
   --  <defgroup>TransportUnicastSettingsGroupDocs</defgroup>
   --  <dref>TransportUnicastSettings_t</dref>
   --  <dref name="Transport">TransportUnicastSettings_t_transports</dref>
   --  <dref name="Receive_Port">TransportUnicastSettings_t_receive_port</dref>

   type TransportUnicastSettings_T_Access is access all TransportUnicastSettings_T;
   type TransportUnicastSettings_T_Array is array
     (Natural range <>) of aliased TransportUnicastSettings_T;
   procedure Initialize (Self  : in out TransportUnicastSettings_T);
   procedure Finalize (Self  : in out TransportUnicastSettings_T);
   procedure Copy (Dst : in out TransportUnicastSettings_T;
                   Src : in TransportUnicastSettings_T);

   package TransportUnicastSettings_Seq is new DDS_Support.Sequences_Generic
     (TransportUnicastSettings_T,
      TransportUnicastSettings_T_Access,
      DDS.Natural,
      1,
      TransportUnicastSettings_T_Array);
   --  <dref>TransportUnicastSettingsSeq</dref>

   --  -------------------------------------------------
   --                 TransportMulticastSettings_t
   --  -------------------------------------------------

   type TransportMulticastSettings_T is record
      Transports      : DDS.String_Seq.Sequence;
      Receive_Address : DDS.String;
      Receive_Port    : Long := 0;
   end record with
     Convention => C;
   --  <defgroup>TransportMulticastSettingsGroupDocs</defgroup>
   --  <dref>TransportMulticastSettings_t</dref>
   --  <dref name="Transports">TransportMulticastSettings_t_transports</dref>
   --  <dref name="Receive_Address">TransportMulticastSettings_t_receive_address</dref>
   --  <dref name="Receive_Port">TransportMulticastSettings_t_receive_port</dref>

   --     TRANSPORT_MULTICAST_LOCATORS_DEFAULT : constant TransportMulticastSettings_T :=
   --       (Transports => DDS.String_Seq.DEFAULT_SEQUENCE,
   --        Receive_Address => DDS.NULL_STRING,
   --        Receive_Port => 0);

   type TransportMulticastSettings_T_Access is access all TransportMulticastSettings_T;
   type TransportMulticastSettings_T_Array is array
     (Natural range <>) of aliased TransportMulticastSettings_T;
   procedure Initialize (Self  : in out TransportMulticastSettings_T);
   procedure Finalize (Self  : in out TransportMulticastSettings_T);
   procedure Copy (Dst : in out TransportMulticastSettings_T;
                   Src : in TransportMulticastSettings_T);

   package TransportMulticastSettings_Seq is new DDS_Support.Sequences_Generic
     (TransportMulticastSettings_T,
      TransportMulticastSettings_T_Access,
      DDS.Natural,
      1,
      TransportMulticastSettings_T_Array);
   --  <dref>TransportMulticastSettingsSeq</dref>

   --  -------------------------------------------------
   --             TransportMulticastMappingFunction_t
   --  -------------------------------------------------

   type TransportMulticastMappingFunction_T is record
      Dll             : DDS.String;
      Function_Name   : DDS.String;
   end record with
     Convention => C;
   --  <defgroup>TransportMulticastMappingGroupDocs</defgroup>
   --  <dref>TransportMulticastMappingFunction_t</dref>
   --  <dref name="dll">TransportMulticastMappingFunction_t_dll</dref>
   --  <dref name="function_name">TransportMulticastMappingFunction_t_function_name</dref>

   --   TRANSPORT_MULTICAST_MAPPING_FUNCTION_DEFAULT : constant TransportMulticastMappingFunction_T :=
   --                                          (dll => DDS.NULL_STRING,
   --                                          function_name => DDS.NULL_STRING);


   --  -------------------------------------------------
   --              TransportMulticastMapping_t
   -----------------------------------------------------

   type TransportMulticastMapping_T is record
      Addresses          : DDS.String;
      Topic_Expression   : DDS.String;
      Mapping_Function   : TransportMulticastMappingFunction_T;
   end record with
     Convention => C;
   --  <dref>TransportMulticastMapping_t</dref>
   --  <dref name="addresses">TransportMulticastMapping_t_addresses</dref>
   --  <dref name="topic_expression">TransportMulticastMapping_t_topic_expression</dref>
   --  <dref name="mapping_function">TransportMulticastMapping_t_mapping_function</dref>

   --   TRANSPORT_MULTICAST_MAPPING_DEFAULT : constant TransportMulticastMapping_T :=
   --                              (addresses          => DDS.NULL_STRING,
   --                              topic_expression   => DDS.NULL_STRING,
   --                              mapping_function   => TRANSPORT_MULTICAST_MAPPING_FUNCTION_DEFAULT);

   type TransportMulticastMapping_T_Access is access all TransportMulticastMapping_T;
   type TransportMulticastMapping_T_Array is array
     (Natural range <>) of aliased TransportMulticastMapping_T;
   procedure Initialize (Self  : in out TransportMulticastMapping_T);
   procedure Finalize (Self  : in out TransportMulticastMapping_T);
   procedure Copy (Dst : in out TransportMulticastMapping_T;
                   Src : in TransportMulticastMapping_T);

   package TransportMulticastMapping_Seq is new DDS_Support.Sequences_Generic
     (TransportMulticastMapping_T,
      TransportMulticastMapping_T_Access,
      DDS.Natural,
      1,
      TransportMulticastMapping_T_Array);
   --  <dref>TransportMulticastMappingSeq</dref>


   --  -------------------------------------------------
   --                 TransportEncapsulationSettings
   --  -------------------------------------------------

   type EncapsulationId_T is new Unsigned_Short;
   --  <defgroup internal="true">TransportEncapsulationSettingsGroupDocs</defgroup>
   --  <dref internal="true">EncapsulationId_t</dref>

   type EncapsulationId_T_Access is access all EncapsulationId_T;
   type EncapsulationId_T_Array is array
     (Natural range <>) of aliased EncapsulationId_T;
   procedure Initialize (Self  : in out EncapsulationId_T);
   procedure Finalize (Self  : in out EncapsulationId_T);
   procedure Copy (Dst : in out EncapsulationId_T;
                   Src : in EncapsulationId_T);

   package EncapsulationId_Seq is new DDS_Support.Sequences_Generic
     (EncapsulationId_T,
      EncapsulationId_T_Access,
      DDS.Natural,
      1,
      EncapsulationId_T_Array);
   --  <dref internal="true">EncapsulationIdSeq</dref>

   ENCAPSULATION_ID_CDR_BE : constant EncapsulationId_T := 0;
   --  <dref internal="true">ENCAPSULATION_ID_CDR_BE</dref>

   ENCAPSULATION_ID_CDR_LE : constant EncapsulationId_T := 1;
   --  <dref internal="true">ENCAPSULATION_ID_CDR_LE</dref>

   ENCAPSULATION_ID_CDR_NATIVE : constant EncapsulationId_T := System.Bit_Order'Pos (System.Default_Bit_Order);
   --  <dref internal="true">ENCAPSULATION_ID_CDR_NATIVE</dref>

   ENCAPSULATION_ID_CDR2_BE : constant EncapsulationId_T := 0;
   --  <dref internal="true">ENCAPSULATION_ID_CDR2_BE</dref>

   ENCAPSULATION_ID_CDR2_LE : constant EncapsulationId_T := 1;
   --  <dref internal="true">ENCAPSULATION_ID_CDR2_LE</dref>

   ENCAPSULATION_ID_CDR2_NATIVE : constant EncapsulationId_T := System.Bit_Order'Pos (System.Default_Bit_Order);
   --  <dref internal="true">ENCAPSULATION_ID_CDR2_NATIVE</dref>

   ENCAPSULATION_ID_SHMEM_REF_PLAIN : EncapsulationId_T := 16#C000#;
   --  <dref internal="true">ENCAPSULATION_ID_SHMEM_REF_PLAIN</dref>

   ENCAPSULATION_ID_SHMEM_REF_FLAT_DATA : EncapsulationId_T := 16#C001#;
   --  <dref internal="true">ENCAPSULATION_ID_SHMEM_REF_FLAT_DATA</dref>

   type TransportEncapsulationSettings_T is record
      Transports     : aliased DDS.String_Seq.Sequence;
      Encapsulations : aliased EncapsulationId_Seq.Sequence;
   end record with
     Convention => C;
   --  <dref internal="true">TransportEncapsulationSettings_t</dref>
   --  <dref internal="true" name="Transports">TransportEncapsulationSettings_t_transports</dref>
   --  <dref internal="true" name="Encapsulations">TransportEncapsulationSettings_t_encapsulations</dref>

   --     TRANSPORT_ENCAPSULATION_SETTINGS_DEFAULT : constant TransportEncapsulationSettings_T :=
   --                   (Transports => DDS.String_Seq.DEFAULT_SEQUENCE,
   --                Encapsulations => EncapsulationId_Seq.DEFAULT_SEQUENCE);

   type TransportEncapsulationSettings_T_Access is access all TransportEncapsulationSettings_T;
   type TransportEncapsulationSettings_T_Array is array
     (Natural range <>) of aliased TransportEncapsulationSettings_T;
   procedure Initialize (Self  : in out TransportEncapsulationSettings_T);
   procedure Finalize (Self  : in out TransportEncapsulationSettings_T);
   procedure Copy (Dst : in out TransportEncapsulationSettings_T;
                   Src : in TransportEncapsulationSettings_T);

   package TransportEncapsulationSettings_Seq is new DDS_Support.Sequences_Generic
     (TransportEncapsulationSettings_T,
      TransportEncapsulationSettings_T_Access,
      DDS.Natural,
      1,
      TransportEncapsulationSettings_T_Array);
   --  <dref internal="true">TransportEncapslationSettingsSeq</dref>

   --  -------------------------------------------------
   --                 DATA_REPRESENTATION
   --  -------------------------------------------------

   type DataRepresentationId_T is new RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_DataRepresentationId_t
      with Convention => C;
   --  <defgroup>DataRepresentationQosGroupDocs</defgroup>
   --  <dref>DataRepresentationId_t</dref>

   XCDR_DATA_REPRESENTATION : aliased constant DataRepresentationId_T :=
      DataRepresentationId_T (RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_XCDR_DATA_REPRESENTATION);

   XML_DATA_REPRESENTATION  : aliased constant DataRepresentationId_T :=
      DataRepresentationId_T (RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_XML_DATA_REPRESENTATION);

   XCDR2_DATA_REPRESENTATION : aliased constant DataRepresentationId_T :=
      DataRepresentationId_T (RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_XCDR2_DATA_REPRESENTATION);

   AUTO_DATA_REPRESENTATION : aliased constant DataRepresentationId_T :=
      DataRepresentationId_T (RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_XCDR2_DATA_REPRESENTATION);

   type DataRepresentationId_T_Access is access all DataRepresentationId_T;
   type DataRepresentationId_T_Array is array
     (Natural range <>) of aliased DataRepresentationId_T;
   procedure Initialize (Self : in out DataRepresentationId_T);
   procedure Finalize   (Self : in out DataRepresentationId_T);
   procedure Copy (Dst : in out DataRepresentationId_T;
                   Src : in DataRepresentationId_T);

   package DataRepresentationId_Seq is new DDS_Support.Sequences_Generic
     (DataRepresentationId_T,
      DataRepresentationId_T_Access,
      DDS.Natural,
      1,
      DataRepresentationId_T_Array);
   --  <dref>DataRepresentationIdSeq</dref>

   type DataRepresentationQosPolicy is limited record
      Value : aliased DataRepresentationId_Seq.Sequence;
   end record with
      Convention => C;
   --  <dref>DataRepresentationQosPolicy</dref>
   --  <dref name="Value">DataRepresentationQosPolicy_value</dref>

   function Contains
      (Policy : in DataRepresentationQosPolicy;
       Id     : in DataRepresentationId_T) return Standard.Boolean;
   --  <dref internal="true">DataRepresentationQosPolicy_contains</dref>

   function Equals
      (Left, Right : in DataRepresentationQosPolicy) return Standard.Boolean;
   --  <dref internal="true">DataRepresentationQosPolicy_equals</dref>

   function "="
      (Left, Right : in DataRepresentationQosPolicy) return Standard.Boolean
      renames Equals;
   --  <dref internal="true">DataRepresentationQosPolicy_equals</dref>

   function Get_Native_Encapsulation
      (Id : in DataRepresentationId_T) return EncapsulationId_T;
   pragma Import (C, Get_Native_Encapsulation, "DDS_DataRepresentationQosPolicy_getNativeEncapsulation");
   --  <dref>DataRepresentationQosPolicy_getNativeEncapsulation</dref>


   --  --------------------------------------------------
   --                 TRANSPORT_SELECTION (eXtension QoS)
   --  --------------------------------------------------

   TRANSPORTSELECTION_QOS_POLICY_NAME : constant DDS.String  := To_DDS_String ("TransportSelection");
   --  <defgroup>TransportSelectionQosGroupDocs</defgroup>
   --  <dref>TRANSPORTSELECTION_QOS_POLICY_NAME</dref>

   type TransportSelectionQosPolicy is record
      Enabled_Transports : aliased DDS.String_Seq.Sequence;
   end record with
     Convention => C;
   --  <dref>TransportSelectionQosPolicy</dref>
   --  <dref name="Enabled_Transports">TransportSelectionQosPolicy_enabled_transports</dref>

   --     TRANSPORT_SELECTION_QOS_POLICY_DEFAULT : constant TransportSelectionQosPolicy :=
   --                                                (Enabled_Transports => DDS.String_Seq.DEFAULT_SEQUENCE);

   --  --------------------------------------------------
   --                 TRANSPORT_UNICAST (eXtension QoS)
   --  --------------------------------------------------

   TRANSPORTUNICAST_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("TransportUnicast");
   --  <defgroup>TransportUnicastQosGroupDocs</defgroup>
   --  <dref>TRANSPORTUNICAST_QOS_POLICY_NAME</dref>

   type TransportUnicastQosPolicy is record
      Value :  TransportUnicastSettings_Seq.Sequence;
   end record with
     Convention => C;
   --  <dref>TransportUnicastQosPolicy</dref>
   --  <dref name="Value">TransportUnicastQosPolicy_value</dref>

   --     TRANSPORT_UNICAST_QOS_POLICY_DEFAULT : constant TransportUnicastQosPolicy :=
   --                                              (Value => TransportUnicastSettings_Seq.DEFAULT_SEQUENCE);

   --  --------------------------------------------------
   --                 TRANSPORT_MULTICAST (eXtension QoS)
   --  --------------------------------------------------

   TRANSPORTMULTICAST_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("TransportMulticast");
   --  <defgroup>TransportMulticastQosGroupDocs</defgroup>
   --  <dref>TRANSPORTMULTICAST_QOS_POLICY_NAME</dref>

   type TransportMulticastQosPolicyKind is new Unsigned_Long;
   --  <dref>TransportMulticastQosPolicyKind</dref>

   AUTOMATIC_TRANSPORT_MULTICAST_QOS : constant TransportMulticastQosPolicyKind := 0;
   --  <dref>TransportMulticastQosPolicyKind_AUTOMATIC_TRANSPORT_MULTICAST_QOS</dref>

   UNICAST_ONLY_TRANSPORT_MULTICAST_QOS : constant TransportMulticastQosPolicyKind := 1;
   --  <dref>TransportMulticastQosPolicyKind_UNICAST_ONLY_TRANSPORT_MULTICAST_QOS</dref>


   type TransportMulticastQosPolicy is record
      Value : TransportMulticastSettings_Seq.Sequence;
      Kind  : TransportMulticastQosPolicyKind := AUTOMATIC_TRANSPORT_MULTICAST_QOS;
   end record with
     Convention => C;
   --  <dref>TransportMulticastQosPolicy</dref>
   --  <dref name="Value">TransportMulticastQosPolicy_value</dref>
   --  <dref name="Kind">TransportMulticastQosPolicy_kind</dref>

   --     TRANSPORT_MULTICAST_QOS_POLICY_DEFAULT : constant TransportMulticastQosPolicy :=
   --                                                (Value => TransportMulticastSettings_Seq.DEFAULT_SEQUENCE);
   --

   --  ------------------------------------------------------
   --                 TRANSPORT_MULTICAST_MAPPING (eXtension QoS)
   --  ------------------------------------------------------

   TRANSPORTMULTICASTMAPPING_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("TransportMulticastMapping");
   --  <defgroup>TransportMulticastMappingQosGroupDocs</defgroup>
   --  <dref>TRANSPORTMULTICASTMAPPING_QOS_POLICY_NAME</dref>

   type TransportMulticastMappingQosPolicy is record
      Value : TransportMulticastMapping_Seq.Sequence;
   end record with
     Convention => C;
   --  <dref>TransportMulticastMappingQosPolicy</dref>
   --  <dref name="Value">TransportMulticastMappingQosPolicy_value</dref>

   --  TRANSPORT_MULTICAST_MAPPING_QOS_POLICY_DEFAULT : constant TransportMulticastMappingQosPolicy :=
   --                                      (Value => TransportMulticastMapping_Seq.DEFAULT_SEQUENCE);


   --  ------------------------------------------------------
   --                 TRANSPORT_ENCAPSULATION (eXtension QoS)
   --  ------------------------------------------------------

   TRANSPORTENCAPSULATION_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("TransportEncapsulation");
   --  <defgroup internal="true">TransportEncapsulationQosGroupDocs</defgroup>
   --  <dref internal="true">TRANSPORTENCAPSULATION_QOS_POLICY_NAME</dref>

   type TransportEncapsulationQosPolicy is record
      Value : aliased TransportEncapsulationSettings_Seq.Sequence;
   end record with
     Convention => C;
   --  <dref internal="true">TransportEncapsulationQosPolicy</dref>
   --  <dref internal="true" name="Value">TransportEncapsulationQosPolicy_value</dref>

   --     TRANSPORT_ENCAPSULATION_QOS_POLICY_DEFAULT : constant TransportEncapsulationQosPolicy :=
   --                   (Value => TransportEncapsulationSettings_Seq.DEFAULT_SEQUENCE);

   --  ------------------------------------------------------
   --                 DISCOVERY (eXtension QoS)
   --  ------------------------------------------------------

   DISCOVERY_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("Discovery");
   --  <defgroup>DiscoveryQosGroupDocs</defgroup>
   --  <dref>DISCOVERY_QOS_POLICY_NAME</dref>
   --  <defgroup>NDDS_DISCOVERY_PEERS</defgroup>

   type DiscoveryQosPolicy is record
      Enabled_Transports                          : aliased String_Seq.Sequence;
      Initial_Peers                               : aliased String_Seq.Sequence;
      Multicast_Receive_Addresses                 : aliased String_Seq.Sequence;
      Metatraffic_Transport_Priority              : aliased Long := 0;
      Accept_Unknown_Peers                        : aliased DDS.Boolean := True;
      Enable_Endpoint_Discovery                   : aliased DDS.Boolean := True;
   end record with
     Convention => C;
   --  <dref>DiscoveryQosPolicy</dref>
   --  <dref name="Enabled_Transports">DiscoveryQosPolicy_enabled_transports</dref>
   --  <dref name="Initial_Peers">DiscoveryQosPolicy_initial_peers</dref>
   --  <dref name="Multicast_Receive_Addresses">DiscoveryQosPolicy_multicast_receive_addresses</dref>
   --  <dref name="Metatraffic_Transport_Priority">DiscoveryQosPolicy_metatraffic_transport_priority</dref>
   --  <dref name="Accept_Unknown_Peers">DiscoveryQosPolicy_accept_unknown_peers</dref>
   --  <dref name="Enable_Endpoint_Discovery">DiscoveryQosPolicy_enable_endpoint_discovery</dref>

   --     DISCOVERY_QOS_POLICY_DEFAULT : constant  DiscoveryQosPolicy :=
   --                                      (Enabled_Transports             => String_Seq.DEFAULT_SEQUENCE,
   --                                       Initial_Peers                  => String_Seq.DEFAULT_SEQUENCE,
   --                                       Multicast_Receive_Addresses    => String_Seq.DEFAULT_SEQUENCE,
   --                                       Metatraffic_Transport_Priority => 0,
   --                                       Accept_Unknown_Peers           => TRUE,
   --                                       Spare1                         => False,
   --                                       Spare2                         => False,
   --                                       Spare3                         => False);

   --  ------------------------------------------------------
   --                 Discovery_ParticipantInformation
   --  ------------------------------------------------------

   type Discovery_ParticipantInformation is record
      Participant_Discovery_Id         : aliased Long := 0;
      Participant_Discovery_Version    : aliased Long := 0;
      Participant_Discovery_Vendor_Id  : aliased Long := 0;
      Participant_Discovery_Parameters : aliased Octet_Seq.Sequence;
   end record with
     Convention => C;
   --  <dref internal="true">Discovery_ParticipantInformation</dref>
   --  <dref internal="true" name="Participant_Discovery_Id">Discovery_ParticipantInformation_participant_discovery_id</dref>
   --  <dref internal="true" name="Participant_Discovery_Version">Discovery_ParticipantInformation_participant_discovery_version</dref>
   --  <dref internal="true" name="Participant_Discovery_Vendor_Id">Discovery_ParticipantInformation_participant_discovery_vendor_id</dref>
   --  <dref internal="true" name="Participant_Discovery_Parameters">Discovery_ParticipantInformation_participant_parameters</dref>

   type Discovery_ParticipantInformation_Access is access all Discovery_ParticipantInformation;
   type Discovery_ParticipantInformation_Array is array
     (Natural range <>) of aliased Discovery_ParticipantInformation;
   procedure Initialize (Self  : in out Discovery_ParticipantInformation);
   procedure Finalize (Self  : in out Discovery_ParticipantInformation);
   procedure Copy (Dst : in out Discovery_ParticipantInformation;
                   Src : in Discovery_ParticipantInformation);

   package Discovery_ParticipantInformationSeq is new DDS_Support.Sequences_Generic
     (Discovery_ParticipantInformation,
      Discovery_ParticipantInformation_Access,
      DDS.Natural,
      1,
      Discovery_ParticipantInformation_Array);
   --  <dref internal="true">Discovery_ParticipantInformationSeq</dref>

   --  ------------------------------------------------------
   --                 Discovery_EndpointInformation
   --  ------------------------------------------------------

   type Discovery_EndpointInformation is record
      Endpoint_Discovery_Id         : aliased Long := 0;
      Endpoint_Discovery_Version    : aliased Long := 0;
      Endpoint_Discovery_Vendor_Id  : aliased Long := 0;
      Endpoint_Discovery_Parameters : aliased Octet_Seq.Sequence;
   end record with
     Convention => C;
   --  <dref internal="true">Discovery_EndpointInformation</dref>
   --  <dref internal="true" name="Endpoint_Discovery_Id">Discovery_EndpointInformation_participant_discovery_id</dref>
   --  <dref internal="true" name="Endpoint_Discovery_Version">Discovery_EndpointInformation_participant_discovery_version</dref>
   --  <dref internal="true" name="Endpoint_Discovery_Vendor_Id">Discovery_EndpointInformation_participant_discovery_vendor_id</dref>
   --  <dref internal="true" name="Endpoint_Discovery_Parameters">Discovery_EndpointInformation_participant_parameters</dref>

   type Discovery_EndpointInformation_Access is access all Discovery_EndpointInformation;
   type Discovery_EndpointInformation_Array is array
     (Natural range <>) of aliased Discovery_EndpointInformation;
   procedure Initialize (Self  : in out Discovery_EndpointInformation);
   procedure Finalize (Self  : in out Discovery_EndpointInformation);
   procedure Copy (Dst : in out Discovery_EndpointInformation;
                   Src : in Discovery_EndpointInformation);

   package Discovery_EndpointInformationSeq is new DDS_Support.Sequences_Generic
     (Discovery_EndpointInformation,
      Discovery_EndpointInformation_Access,
      DDS.Natural,
      1,
      Discovery_EndpointInformation_Array);
   --  <dref internal="true">Discovery_EndpointInformationSeq</dref>

   --  ------------------------------------------------------
   --                 TRANSPORTBUILTIN (eXtension QoS)
   --  ------------------------------------------------------

   TRANSPORTBUILTIN_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("TransportBuiltin");
   --  <defgroup>TransportBuiltinQosGroupDocs</defgroup>
   --  <dref>TRANSPORTBUILTIN_QOS_POLICY_NAME</dref>

   type TransportBuiltinKind is new Unsigned_Long;
   --  <dref>TransportBuiltinKind</dref>

   TRANSPORTBUILTIN_UDPv4 : constant TransportBuiltinKind := 2 ** 0;
   --  <dref>TransportBuiltinKind_TRANSPORTBUILTIN_UDPv4</dref>

   TRANSPORTBUILTIN_SHMEM : constant TransportBuiltinKind := 2 ** 1;
   --  <dref>TransportBuiltinKind_TRANSPORTBUILTIN_SHMEM</dref>

   TRANSPORTBUILTIN_INTRA : constant TransportBuiltinKind := 2 ** 2;
   --  <dref internal="true">TransportBuiltinKind_TRANSPORTBUILTIN_INTRA</dref>

   TRANSPORTBUILTIN_UDPv6 : constant TransportBuiltinKind := 2 ** 3;
   --  <dref>TransportBuiltinKind_TRANSPORTBUILTIN_UDPv6</dref>

   TRANSPORTBUILTIN_INTRA_ALIAS : constant DDS.String := To_DDS_String ("builtin.intra");
   --  <dref internal="true">TransportBuiltinKind_INTRA_ALIAS</dref>

   TRANSPORTBUILTIN_SHMEM_ALIAS : constant DDS.String := To_DDS_String ("builtin.shmem");
   --  <dref>TransportBuiltinKind_SHMEM_ALIAS</dref>


   TRANSPORTBUILTIN_UDPv4_ALIAS : constant DDS.String := To_DDS_String ("builtin.udpv4");
   --  <dref>TransportBuiltinKind_UDPv4_ALIAS</dref>


   TRANSPORTBUILTIN_UDPv6_ALIAS : constant DDS.String := To_DDS_String ("builtin.udpv");
   --  <dref>TransportBuiltinKind_UDPv6_ALIAS</dref>


   subtype TransportBuiltinKindMask is TransportBuiltinKind;
   --  <dref>TransportBuiltinKindMask</dref>

   TRANSPORTBUILTIN_MASK_NONE : constant TransportBuiltinKindMask := 0;
   --  <dref>TransportBuiltinKindMask_NONE</dref>

   TRANSPORTBUILTIN_MASK_DEFAULT : constant TransportBuiltinKindMask :=
                                     (TRANSPORTBUILTIN_UDPv4 or TRANSPORTBUILTIN_SHMEM);
   --  <dref>TransportBuiltinKindMask_DEFAULT</dref>

   TRANSPORTBUILTIN_MASK_ALL  : constant TransportBuiltinKindMask := 16#FFFF_FFFF#;
   --  <dref>TransportBuiltinKindMask_ALL</dref>

   type TransportBuiltinQosPolicy is record
      Mask : TransportBuiltinKindMask;
   end record with
     Convention => C;
   --  <dref>TransportBuiltinQosPolicy</dref>
   --  <dref name="Mask">TransportBuiltinQosPolicy_mask</dref>

   TRANSPORT_BUILTIN_QOS_POLICY_DEFAULT : constant TransportBuiltinQosPolicy :=
                                            (Mask => TRANSPORTBUILTIN_MASK_DEFAULT);
   --  <dref internal="true"></dref>

   --  ------------------------------------------------------
   --                 WIRE_PROTOCOL (eXtension QoS)
   --  ------------------------------------------------------

   type RtpsWellKnownPorts_T is record
      Port_Base                     : aliased Long := 7400;
      Domain_Id_Gain                : aliased Long := 10;
      Participant_Id_Gain           : aliased Long := 1000;
      Builtin_Multicast_Port_Offset : aliased Long := 2;
      Builtin_Unicast_Port_Offset   : aliased Long := 0;
      User_Multicast_Port_Offset    : aliased Long := 1;
      User_Unicast_Port_Offset      : aliased Long := 3;
   end record with
     Convention => C;
   --  <defgroup>WireProtocolQosGroupDocs</defgroup>
   --  <dref>RtpsWellKnownPorts_t</dref>
   --  <dref name="Port_Base">RtpsWellKnownPorts_t_port_base</dref>
   --  <dref name="Domain_Id_Gain">RtpsWellKnownPorts_t_domain_id_gain</dref>
   --  <dref name="Participant_Id_Gain">RtpsWellKnownPorts_t_participant_id_gain</dref>
   --  <dref name="Builtin_Multicast_Port_Offset">RtpsWellKnownPorts_t_builtin_multicast_port_offset</dref>
   --  <dref name="Builtin_Unicast_Port_Offset">RtpsWellKnownPorts_t_builtin_unicast_port_offset</dref>
   --  <dref name="User_Multicast_Port_Offset">RtpsWellKnownPorts_t_user_multicast_port_offset</dref>
   --  <dref name="User_Unicast_Port_Offset">RtpsWellKnownPorts_t_user_unicast_port_offset</dref>

   RTI_BACKWARDS_COMPATIBLE_RTPS_WELL_KNOWN_PORTS : constant RtpsWellKnownPorts_T
     := (Port_Base                     =>  7400,
         Domain_Id_Gain                =>  10,
         Participant_Id_Gain           =>  1000,
         Builtin_Multicast_Port_Offset =>  2,
         Builtin_Unicast_Port_Offset   =>  0,
         User_Multicast_Port_Offset    =>  1,
         User_Unicast_Port_Offset      =>  3);
   --  <dref>RTI_BACKWARDS_COMPATIBLE_RTPS_WELL_KNOWN_PORTS</dref>

   INTEROPERABLE_RTPS_WELL_KNOWN_PORTS : constant RtpsWellKnownPorts_T
     := (Port_Base                     =>  7400,
         Domain_Id_Gain                =>  250,
         Participant_Id_Gain           =>  2,
         Builtin_Multicast_Port_Offset =>  0,
         Builtin_Unicast_Port_Offset   =>  10,
         User_Multicast_Port_Offset    =>  1,
         User_Unicast_Port_Offset      =>  11);
   --  <dref>INTEROPERABLE_RTPS_WELL_KNOWN_PORTS</dref>


   RTPS_WELL_KNOWN_PORTS_DEFAULT : constant RtpsWellKnownPorts_T :=
                                     (Port_Base                     => 7400,
                                      Domain_Id_Gain                => 10,
                                      Participant_Id_Gain           => 1000,
                                      Builtin_Multicast_Port_Offset => 2,
                                      Builtin_Unicast_Port_Offset   => 0,
                                      User_Multicast_Port_Offset    => 1,
                                      User_Unicast_Port_Offset      => 3);
   --  <dref internal="true"></dref>

   type RtpsReservedPortKind is new Unsigned_Long;
   --  <dref>RtpsReservedPortKind</dref>

   RTPS_RESERVED_PORT_BUILTIN_UNICAST   : constant RtpsReservedPortKind := 2#0001#;
   --  <dref>RtpsReservedPortKind_BUILTIN_UNICAST</dref>

   RTPS_RESERVED_PORT_BUILTIN_MULTICAST : constant RtpsReservedPortKind := 2#0010#;
   --  <dref>RtpsReservedPortKind_BUILTIN_MULTICAST</dref>

   RTPS_RESERVED_PORT_USER_UNICAST      : constant RtpsReservedPortKind := 2#0100#;
   --  <dref>RtpsReservedPortKind_USER_UNICAST</dref>

   RTPS_RESERVED_PORT_USER_MULTICAST    : constant RtpsReservedPortKind := 2#1000#;
   --  <dref>RtpsReservedPortKind_USER_MULTICAST</dref>

   subtype RtpsReservedPortKindMask is RtpsReservedPortKind;
   --  <dref>RtpsReservedPortKindMask</dref>

   RTPS_RESERVED_PORT_MASK_DEFAULT : constant RtpsReservedPortKindMask :=
                                       (RTPS_RESERVED_PORT_BUILTIN_UNICAST or RTPS_RESERVED_PORT_BUILTIN_MULTICAST or
                                                                            RTPS_RESERVED_PORT_USER_UNICAST);
   --  <dref>RTPS_RESERVED_PORT_MASK_DEFAULT</dref>

   RTPS_RESERVED_PORT_MASK_NONE  : constant RtpsReservedPortKindMask := 0;
   --  <dref>RTPS_RESERVED_PORT_MASK_NONE</dref>

   RTPS_RESERVED_PORT_MASK_ALL   : constant RtpsReservedPortKindMask := 16#FFFF_FFFF#;
   --  <dref>RTPS_RESERVED_PORT_MASK_ALL</dref>

   WIREPROTOCOL_QOS_POLICY_NAME  : constant DDS.String := To_DDS_String ("WireProtocol");
   --  <dref>WIREPROTOCOL_QOS_POLICY_NAME</dref>


   type WireProtocolQosPolicyAutoKind is new Unsigned_Long;
   --  <dref>WireProtocolQosPolicyAutoKind</dref>

   RTPS_AUTO_ID_FROM_IP : constant WireProtocolQosPolicyAutoKind := 0;
   --  <dref>WireProtocolQosPolicyAutoKind_RTPS_AUTO_ID_FROM_IP</dref>

   RTPS_AUTO_ID_FROM_MAC : constant WireProtocolQosPolicyAutoKind := 1;
   --  <dref>WireProtocolQosPolicyAutoKind_RTPS_AUTO_ID_FROM_MAC</dref>

   RTPS_AUTO_ID    : constant Unsigned_Long := 0;

   type WireProtocolQosPolicy is record
      Participant_Id          : aliased Long := -1;
      Rtps_Host_Id            : aliased Unsigned_Long := RTPS_AUTO_ID;
      Rtps_App_Id             : aliased Unsigned_Long := RTPS_AUTO_ID;
      Rtps_Instance_Id        : aliased Unsigned_Long := RTPS_AUTO_ID;
      Rtps_Well_Known_Ports   : aliased RtpsWellKnownPorts_T := RTPS_WELL_KNOWN_PORTS_DEFAULT;
      Rtps_Reserved_Port_Mask : aliased Long := 0;
      Rtps_Auto_Id_Kind       : aliased WireProtocolQosPolicyAutoKind := RTPS_AUTO_ID_FROM_IP;
      Compute_Crc             : aliased Boolean := False;
      Check_Crc               : aliased Boolean := False;
   end record with
     Convention => C;
   --  <dref>WireProtocolQosPolicy</dref>
   --  <dref name="Participant_Id">WireProtocolQosPolicy_participant_id</dref>
   --  <dref name="Rtps_Host_Id">WireProtocolQosPolicy_rtps_host_id</dref>
   --  <dref name="Rtps_App_Id">WireProtocolQosPolicy_rtps_app_id</dref>
   --  <dref name="Rtps_Instance_Id">WireProtocolQosPolicy_rtps_instance_id</dref>
   --  <dref name="Rtps_Well_Known_Ports">WireProtocolQosPolicy_rtps_well_known_ports</dref>
   --  <dref name="rtps_reserved_port_mask">WireProtocolQosPolicy_rtps_reserved_port_mask</dref>
   --  <dref name="rtps_auto_id_kind">WireProtocolQosPolicy_rtps_auto_id_kind</dref>

   --  <dref>WireProtocolQosPolicy_RTPS_AUTO_ID</dref>

   WIRE_PROTOCOL_QOS_POLICY_DEFAULT : constant WireProtocolQosPolicy :=
                                        (Participant_Id          => -1, -- Automatic
                                         Rtps_Host_Id            => RTPS_AUTO_ID,
                                         Rtps_App_Id             => RTPS_AUTO_ID,
                                         Rtps_Instance_Id        => RTPS_AUTO_ID,
                                         Rtps_Well_Known_Ports   => RTPS_WELL_KNOWN_PORTS_DEFAULT,
                                         Rtps_Reserved_Port_Mask => 2#0000_0000_0000_0000#,
                                         Rtps_Auto_Id_Kind       => RTPS_AUTO_ID_FROM_IP,
                                         Compute_Crc             => False,
                                         Check_Crc               => False);
   --  <dref internal="true"></dref>

   --  ------------------------------------------------------
   --                 Locator_t
   --  ------------------------------------------------------

   LOCATOR_ADDRESS_LENGTH_MAX  : constant Unsigned_Long := 16;
   --  <dref>Locator_t_ADDRESS_LENGTH_MAX</dref>

   type Locator_Address_Array_T is array (0 .. LOCATOR_ADDRESS_LENGTH_MAX - 1) of Octet;

   type Locator_T is record
      Kind           : aliased Long := 0;
      Port           : aliased Unsigned_Long := 0;
      Address        : aliased Locator_Address_Array_T := (others => 0);
      Encapsulations : aliased EncapsulationId_Seq.Sequence;
   end record with
     Convention => C;
   --  <dref>Locator_t</dref>
   --  <dref name="Kind">Locator_t_kind</dref>
   --  <dref name="Port">Locator_t_port</dref>
   --  <dref name="Address">Locator_t_address</dref>
   --  <dref internal="true" name="Encapsulations">Locator_t_encapsulations</dref>

   type Locator_T_Access is access all Locator_T;
   type Locator_T_Array is array (Natural range <>) of aliased Locator_T;
   procedure Initialize (Self  : in out Locator_T);
   procedure Finalize (Self  : in out Locator_T);
   procedure Copy (Dst : in out Locator_T; Src : in Locator_T);

   package Locator_Seq is new DDS_Support.Sequences_Generic
     (Locator_T,
      Locator_T_Access,
      DDS.Natural,
      1,
      Locator_T_Array);
   --  <dref>LocatorSeq</dref>

   LOCATOR_INVALID : constant Locator_T :=
                       (Kind           => -1,
                        Port           => 0,
                        Address        => (others => 00),
                        Encapsulations => EncapsulationId_Seq.DEFAULT_SEQUENCE);
   --  <dref>Locator_t_INVALID</dref>

   LOCATOR_KIND_INVALID : constant Long := -1;
   --  <dref>Locator_t_KIND_INVALID</dref>

   LOCATOR_PORT_INVALID : constant Unsigned_Long := 0;
   --  <dref>Locator_t_PORT_INVALID</dref>

   LOCATOR_ADDRESS_INVALID : constant Locator_Address_Array_T := (others => 0);
   --  <dref>Locator_t_ADDRESS_INVALID</dref>

   LOCATOR_KIND_ANY : constant Long := 0;
   --  <dref internal="true">Locator_t_KIND_ANY</dref>

   LOCATOR_KIND_UDPv4 : constant Long := 1;
   --  <dref>Locator_t_KIND_UDPv4</dref>


   LOCATOR_KIND_SHMEM  : constant Long := 2;
   --  <dref>Locator_t_KIND_SHMEM</dref>

   LOCATOR_KIND_INTRA  : constant Long := 3;
   --  <dref internal="true">Locator_t_KIND_INTRA</dref>

   LOCATOR_KIND_UDPv6 : constant Long := 5;
   --  <dref>Locator_t_KIND_UDPv6</dref>

   LOCATOR_KIND_DTLS : constant Long := 6;
   --  <dref internal="true">Locator_t_KIND_DTLS</dref>

   LOCATOR_KIND_WAN : constant Long := 7;
   --  <dref internal="true">Locator_t_KIND_WAN</dref>

   LOCATOR_KIND_TCPV4_LAN : constant Long := 8;
   --  <dref internal="true">Locator_t_KIND_TCPV4_LAN</dref>

   LOCATOR_KIND_TCPV4_WAN : constant Long := 9;
   --  <dref internal="true">Locator_t_KIND_TCPV4_WAN</dref>

   LOCATOR_KIND_TLSV4_LAN : constant Long := 10;
   --  <dref internal="true">Locator_t_KIND_TLSV4_LAN</dref>

   LOCATOR_KIND_TLSV4_WAN : constant Long := 11;
   --  <dref internal="true">Locator_t_KIND_TLSV4_WAN</dref>

   LOCATOR_KIND_RESERVED : constant Long := 1000;
   --  <dref internal>Locator_t_KIND_RESERVED</dref>

   --  ------------------------------------------------------
   --                 ProtocolVersion_t
   --  ------------------------------------------------------

   type ProtocolVersion_T  is record
      Major : aliased Octet := 0;
      Minor : aliased Octet := 0;
   end record with
     Convention => C;
   --  <dref>ProtocolVersion_t</dref>
   --  <dref name="Major">ProtocolVersion_t_major</dref>
   --  <dref name="Minor">ProtocolVersion_t_minor</dref>

   PROTOCOL_VERSION_DEFAULT : constant ProtocolVersion_T :=
                                (Major => 0,
                                 Minor => 0);
   --  <dref internal="true"></dref>

   PROTOCOLVERSION_1_0      : constant ProtocolVersion_T :=
                                (Major => 1,
                                 Minor => 0);
   --  <dref>ProtocolVersion_t_PROTOCOLVERSION_1_0</dref>

   PROTOCOLVERSION_1_1      : constant ProtocolVersion_T :=
                                (Major => 1,
                                 Minor => 1);
   --  <dref>ProtocolVersion_t_PROTOCOLVERSION_1_1</dref>

   PROTOCOLVERSION_1_2      : constant ProtocolVersion_T :=
                                (Major => 1,
                                 Minor => 2);
   --  <dref>ProtocolVersion_t_PROTOCOLVERSION_1_2</dref>

   PROTOCOLVERSION_2_0      : constant ProtocolVersion_T :=
                                (Major => 2,
                                 Minor => 0);
   --  <dref>ProtocolVersion_t_PROTOCOLVERSION_2_0</dref>

   PROTOCOLVERSION_2_1      : constant ProtocolVersion_T :=
                                (Major => 2,
                                 Minor => 1);
   --  <dref>ProtocolVersion_t_PROTOCOLVERSION_2_1</dref>

   PROTOCOLVERSION          : constant ProtocolVersion_T :=
                                (Major => 2,
                                 Minor => 1);
   --  <dref>ProtocolVersion_t_PROTOCOLVERSION</dref>

   --  ------------------------------------------------------
   --                 Version_t
   --  ------------------------------------------------------

   VENDOR_ID_LENGTH_MAX     : constant := 2;
   --  <dref>VendorId_t_LENGTH_MAX</dref>

   type VendorId_Array_T is array (0 .. VENDOR_ID_LENGTH_MAX - 1) of Octet;

   type VendorId_T is record
      VendorId : aliased VendorId_Array_T := (others => 0);
   end record with
     Convention => C;
   --  <dref>VendorId_t</dref>
   --  <dref name="VendorId">VendorId_t_vendorId</dref>

   VENDOR_ID_DEFAULT : constant  VendorId_T := (VendorId => (0, 0));
   --  <dref internal="true"></dref>

   VENDORID_UNKNOWN  : constant  VendorId_T := (VendorId => (0, 0));
   --  <dref internal="true"></dref>

   --  ------------------------------------------------------
   --                 ProductVersion_t
   --  ------------------------------------------------------

   type ProductVersion_T is record
      Major    : aliased Char := Char (ASCII.NUL);
      Minor    : aliased Char := Char (ASCII.NUL);
      Release  : aliased Char := '0';
      Revision : aliased Char := Char (ASCII.NUL);
   end record with
     Convention => C;
   --  <dref>ProductVersion_t</dref>
   --  <dref name="Major">ProductVersion_t_major</dref>
   --  <dref name="Minor">ProductVersion_t_minor</dref>
   --  <dref name="Release">ProductVersion_t_release</dref>
   --  <dref name="Revision">ProductVersion_t_revision</dref>

   PRODUCTVERSION_UNKNOWN : constant ProductVersion_T :=
                              (Major    => Char (ASCII.NUL),
                               Minor    => Char (ASCII.NUL),
                               Release  => '0',
                               Revision => Char (ASCII.NUL));
   --  <dref>ProductVersion_t_UNKNOWN</dref>

   --  ----------------------------------------------------------
   --                 DATA_READER_RESOURCE_LIMITS (eXtension QoS)
   --  ----------------------------------------------------------

   DATAREADERRESOURCELIMITS_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("DataReaderResourceLimits");
   --  <defgroup>DataReaderResourceLimitsQosGroupDocs</defgroup>
   --  <dref>DATAREADERRESOURCELIMITS_QOS_POLICY_NAME</dref>

   type DataReaderResourceLimitsQosPolicy is record
      Max_Remote_Writers                          : aliased Long := -1;
      Max_Remote_Writers_Per_Instance             : aliased Long := -1;
      Max_Samples_Per_Remote_Writer               : aliased Long := -1;
      Max_Infos                                   : aliased Long := -1;
      Initial_Remote_Writers                      : aliased Long := 2;
      Initial_Remote_Writers_Per_Instance         : aliased Long := 2;
      Initial_Infos                               : aliased Long := 32;
      Initial_Outstanding_Reads                   : aliased Long := 2;
      Max_Outstanding_Reads                       : aliased Long := -1;
      Max_Samples_Per_Read                        : aliased Long := 1024;
      Disable_Fragmentation_Support               : aliased DDS.Boolean := False;
      Max_Fragmented_Samples                      : aliased Long := 1024;
      Initial_Fragmented_Samples                  : aliased Long := 4;
      Max_Fragmented_Samples_Per_Remote_Writer    : aliased Long := 256;
      Max_Fragments_Per_Sample                    : aliased Long := 512;
      Dynamically_Allocate_Fragmented_Samples     : aliased DDS.Boolean := False;
      Max_Total_Instances                         : aliased Long := 32;
      Max_Remote_Virtual_Writers                  : aliased Long := -1;
      Initial_Remote_Virtual_Writers              : aliased Long := 2;
      Max_Remote_Virtual_Writers_Per_Instance     : aliased Long := -1;
      Initial_Remote_Virtual_Writers_Per_Instance : aliased Long := 2;
      Max_Remote_Writers_Per_Sample               : aliased Long := 3;
      Max_Query_Condition_Filters                 : aliased Long := 4;
      Max_App_Ack_Response_Length                 : aliased Long := 1;
      Keep_Minimum_State_For_Instances            : aliased DDS.Boolean := True;
      Initial_Topic_Queries                       : aliased Long := 1;
      Max_Topic_Queries                           : aliased Long := -1;
      Shmem_Ref_Transfer_Mode_Attached_Segment_Allocation : aliased AllocationSettings_T := AllocationSettings_T_AUTO;
   end record with
     Convention => C;
   --  <dref>DataReaderResourceLimitsQosPolicy</dref>
   --  <dref name="Max_Remote_Writers">DataReaderResourceLimitsQosPolicy_max_remote_writers</dref>
   --  <dref name="Max_Remote_Writers_Per_Instance">DataReaderResourceLimitsQosPolicy_max_remote_writers_per_instance</dref>
   --  <dref name="Max_Samples_Per_Remote_Writer">DataReaderResourceLimitsQosPolicy_max_samples_per_remote_writer</dref>
   --  <dref name="Max_Infos">DataReaderResourceLimitsQosPolicy_max_infos</dref>
   --  <dref name="Initial_Remote_Writers">DataReaderResourceLimitsQosPolicy_initial_remote_writers</dref>
   --  <dref name="Initial_Remote_Writers_Per_Instance">DataReaderResourceLimitsQosPolicy_initial_remote_writers_per_instance</dref>
   --  <dref name="Initial_Infos">DataReaderResourceLimitsQosPolicy_initial_infos</dref>
   --  <dref name="Initial_Outstanding_Reads">DataReaderResourceLimitsQosPolicy_initial_outstanding_reads</dref>
   --  <dref name="Max_Outstanding_Reads">DataReaderResourceLimitsQosPolicy_max_outstanding_reads</dref>
   --  <dref name="Max_Samples_Per_Read">DataReaderResourceLimitsQosPolicy_max_samples_per_read</dref>
   --  <dref name="Disable_Fragmentation_Support">DataReaderResourceLimitsQosPolicy_disable_fragmentation_support</dref>
   --  <dref name="Max_Fragmented_Samples">DataReaderResourceLimitsQosPolicy_max_fragmented_samples</dref>
   --  <dref name="Initial_Fragmented_Samples">DataReaderResourceLimitsQosPolicy_initial_fragmented_samples</dref>
   --  <dref name="Max_Fragmented_Samples_Per_Remote_Writer">DataReaderResourceLimitsQosPolicy_max_fragmented_samples_per_remote_writer</dref>
   --  <dref name="Max_Fragments_Per_Samples">DataReaderResourceLimitsQosPolicy_max_fragments_per_sample</dref>
   --  <dref name="Dynamically_Allocate_Fragmented_Samples">DataReaderResourceLimitsQosPolicy_dynamically_allocate_fragmented_samples</dref>
   --  <dref name="Max_Total_Instances">DataReaderResourceLimitsQosPolicy_max_total_instances</dref>
   --  <dref name="Max_Remote_Virtual_Writers">DataReaderResourceLimitsQosPolicy_max_remote_virtual_writers</dref>
   --  <dref name="Initial_Remote_Virtual_Writers">DataReaderResourceLimitsQosPolicy_initial_remote_virtual_writers</dref>
   --  <dref name="Max_Remote_Virtual_Writers_Per_Instance">DataReaderResourceLimitsQosPolicy_max_remote_virtual_writers_per_instance</dref>
   --  <dref name="Initial_Remote_Virtual_Writers_Per_Instance">DataReaderResourceLimitsQosPolicy_initial_remote_virtual_writers_per_instance</dref>
   --  <dref name="Max_Remote_Writers_Per_Sample">DataReaderResourceLimitsQosPolicy_max_remote_writers_per_sample</dref>
   --  <dref name="Max_Query_Condition_Filters">DataReaderResourceLimitsQosPolicy_max_query_condition_filters</dref>
   --  <dref name="Max_App_Ack_Response_Length">DataReaderResourceLimitsQosPolicy_max_app_ack_response_length</dref>
   --  <dref name="Keep_Minimum_State_For_Instances">DataReaderResourceLimitsQosPolicy_keep_minimum_state_for_instances</dref>
   --  <dref internal="true" name="Initial_Topic_Queries">DataReaderResourceLimitsQosPolicy_initial_topic_queries</dref>
   --  <dref internal="true" name="Max_Topic_Queries">DataReaderResourceLimitsQosPolicy_max_topic_queries</dref>
   --  <dref internal="true" name="Shmem_Ref_Transfer_Mode_Attached_Segment_Allocation">DataReaderResourceLimitsQosPolicy_shmem_ref_transfer_mode_attached_segment_allocation</dref>

   AUTO_MAX_TOTAL_INSTANCES : constant Long := 0;
   --  <dref>AUTO_MAX_TOTAL_INSTANCES</dref>

   DATA_READER_RESOURCE_LIMITS_QOS_POLICY_DEFAULT :   constant DataReaderResourceLimitsQosPolicy :=
                                                      (Max_Remote_Writers                          => -1,
                                                       Max_Remote_Writers_Per_Instance             => -1,
                                                       Max_Samples_Per_Remote_Writer               => -1,
                                                       Max_Infos                                   => -1,
                                                       Initial_Remote_Writers                      =>  2,
                                                       Initial_Remote_Writers_Per_Instance         => 2,
                                                       Initial_Infos                               => 32,
                                                       Initial_Outstanding_Reads                   => 2,
                                                       Max_Outstanding_Reads                       =>  -1,
                                                       Max_Samples_Per_Read                        =>  1024,
                                                       Disable_Fragmentation_Support               =>  False,
                                                       Max_Fragmented_Samples                      =>  1024,
                                                       Initial_Fragmented_Samples                  =>  4,
                                                       Max_Fragmented_Samples_Per_Remote_Writer    =>  256,
                                                       Max_Fragments_Per_Sample                    =>  512,
                                                       Dynamically_Allocate_Fragmented_Samples     => False,
                                                       Max_Total_Instances                         => 32,
                                                       Max_Remote_Virtual_Writers                  => -1,
                                                       Initial_Remote_Virtual_Writers              => 2,
                                                       Max_Remote_Virtual_Writers_Per_Instance     => -1,
                                                       Initial_Remote_Virtual_Writers_Per_Instance => 2,
                                                       Max_Remote_Writers_Per_Sample               => 3,
                                                       Max_Query_Condition_Filters                 => 4,
                                                       Max_App_Ack_Response_Length                 => 1,
                                                       Keep_Minimum_State_For_Instances            => True,
                                                       Initial_Topic_Queries                       => 1,
                                                       Max_Topic_Queries                           => -1,
                                                       Shmem_Ref_Transfer_Mode_Attached_Segment_Allocation => AllocationSettings_T_AUTO);
   --  <dref internal="true"></dref>

   --  ----------------------------------------------------------
   --                 DATA_WRITER_RESOURCE_LIMITS (eXtension QoS)
   --  ----------------------------------------------------------

   DATAWRITERRESOURCELIMITS_QOS_POLICY_NAME       : constant DDS.String := To_DDS_String ("DataWriterResourceLimits");
   --  <defgroup>DataWriterResourceLimitsQosGroupDocs</defgroup>
   --  <dref>DATAWRITERRESOURCELIMITS_QOS_POLICY_NAME</dref>

   type DataWriterResourceLimitsInstanceReplacementKind is new Unsigned_Long;
   --  <dref>DataWriterResourceLimitsInstanceReplacementKind</dref>

   UNREGISTERED_INSTANCE_REPLACEMENT : constant DataWriterResourceLimitsInstanceReplacementKind := 0;
   --  <dref>DataWriterResourceLimitsInstanceReplacementKind_UNREGISTERED_INSTANCE_REPLACEMENT</dref>

   ALIVE_INSTANCE_REPLACEMENT : constant DataWriterResourceLimitsInstanceReplacementKind := 1;
   --  <dref>DataWriterResourceLimitsInstanceReplacementKind_ALIVE_INSTANCE_REPLACEMENT</dref>

   DISPOSED_INSTANCE_REPLACEMENT : constant DataWriterResourceLimitsInstanceReplacementKind := 2;
   --  <dref>DataWriterResourceLimitsInstanceReplacementKind_DISPOSED_INSTANCE_REPLACEMENT</dref>

   ALIVE_THEN_DISPOSED_INSTANCE_REPLACEMENT : constant DataWriterResourceLimitsInstanceReplacementKind := 3;
   --  <dref>DataWriterResourceLimitsInstanceReplacementKind_ALIVE_THEN_DISPOSED_INSTANCE_REPLACEMENT</dref>

   DISPOSED_THEN_ALIVE_INSTANCE_REPLACEMENT : constant DataWriterResourceLimitsInstanceReplacementKind := 4;
   --  <dref>DataWriterResourceLimitsInstanceReplacementKind_DISPOSED_THEN_ALIVE_INSTANCE_REPLACEMENT</dref>

   ALIVE_OR_DISPOSED_INSTANCE_REPLACEMENT : constant DataWriterResourceLimitsInstanceReplacementKind := 5;
   --  <dref>DataWriterResourceLimitsInstanceReplacementKind_ALIVE_OR_DISPOSED_INSTANCE_REPLACEMENT</dref>

   type DataWriterResourceLimitsQosPolicy is record
      Initial_Concurrent_Blocking_Threads : aliased DDS.Long := 1;
      Max_Concurrent_Blocking_Threads     : aliased DDS.Long := -1;
      Max_Remote_Reader_Filters           : aliased DDS.Long := 32;
      Initial_Batches                     : aliased DDS.Long := 8;
      Max_Batches                         : aliased DDS.Long := -1;
      Cookie_Max_Length                   : aliased DDS.Long := -1;
      Instance_Replacement                : aliased DataWriterResourceLimitsInstanceReplacementKind := UNREGISTERED_INSTANCE_REPLACEMENT;
      Replace_Empty_Instances             : aliased DDS.Boolean := False;
      Autoregister_Instances              : aliased DDS.Boolean := False;
      Initial_Virtual_Writers             : aliased DDS.Long :=  1;
      Max_Virtual_Writers                 : aliased DDS.Long := -1;
      Max_Remote_Readers                  : aliased DDS.Long := -1;
      Max_App_Ack_Remote_Readers          : aliased DDS.Long := -1;
      Initial_Active_Topic_Queries        : aliased DDS.Long :=  1;
      Max_Topic_Queries                   : aliased DDS.Long := -1;
      Writer_Loaned_Sample_Allocation     : aliased AllocationSettings_T := AllocationSettings_T_AUTO;
      Initialize_Writer_Loaned_Sample     : aliased DDS.Boolean := False;
   end record with Convention => C;
   --  <dref>DataWriterResourceLimitsQosPolicy</dref>
   --  <dref name="Initial_Concurrent_Blocking_Threads">DataWriterResourceLimitsQosPolicy_initial_concurrent_blocking_threads</dref>
   --  <dref name="Max_Concurrent_Blocking_Threads">DataWriterResourceLimitsQosPolicy_max_concurrent_blocking_threads</dref>
   --  <dref name="Max_Remote_Reader_Filters">DataWriterResourceLimitsQosPolicy_max_remote_reader_filters</dref>
   --  <dref name="Initial_Batches">DataWriterResourceLimitsQosPolicy_initial_batches</dref>
   --  <dref name="Max_Batches">DataWriterResourceLimitsQosPolicy_max_batches</dref>
   --  <dref name="Cookie_Max_Length">DataWriterResourceLimitsQosPolicy_cookie_max_length</dref>
   --  <dref name="Instance_Replacement">DataWriterResourceLimitsQosPolicy_instance_replacement</dref>
   --  <dref name="Replace_Empty_Instances">DataWriterResourceLimitsQosPolicy_replace_empty_instances</dref>
   --  <dref name="Autoregister_Instances">DataWriterResourceLimitsQosPolicy_autoregister_instances</dref>
   --  <dref name="Initial_Virtual_Writers">DataWriterResourceLimitsQosPolicy_initial_virtual_writers</dref>
   --  <dref name="Max_Virtual_Writers">DataWriterResourceLimitsQosPolicy_max_virtual_writers</dref>
   --  <dref name="Max_Remote_Readers">DataWriterResourceLimitsQosPolicy_max_remote_readers</dref>
   --  <dref name="Max_App_Ack_Remote_Readers">DataWriterResourceLimitsQosPolicy_max_app_ack_remote_readers</dref>
   --  <dref internal="true" name="Initial_Active_Topic_Queries">DataWriterResourceLimitsQosPolicy_initial_active_topic_queries</dref>
   --  <dref internal="true" name="Max_Topic_Queries">DataWriterResourceLimitsQosPolicy_max_topic_queries</dref>
   --  <dref internal="true" name="Writer_Loaned_Sample_Allocation">DataWriterResourceLimitsQosPolicy_writer_loaned_sample_allocation</dref>
   --  <dref internal="true" name="Initialize_Writer_Loaned_Sample">DataWriterResourceLimitsQosPolicy_initialize_writer_loaned_sample</dref>

   DATA_WRITER_RESOURCE_LIMITS_QOS_POLICY_DEFAULT : constant DataWriterResourceLimitsQosPolicy :=
                                                      (Initial_Concurrent_Blocking_Threads => 1,
                                                       Max_Concurrent_Blocking_Threads     => -1,
                                                       Max_Remote_Reader_Filters           => 32,
                                                       Initial_Batches                     => 8,
                                                       Max_Batches                         => -1,
                                                       Cookie_Max_Length                   => -1,
                                                       Instance_Replacement                => UNREGISTERED_INSTANCE_REPLACEMENT,
                                                       Replace_Empty_Instances             => False,
                                                       Autoregister_Instances              => False,
                                                       Initial_Virtual_Writers             =>  1,
                                                       Max_Virtual_Writers                 => -1,
                                                       Max_Remote_Readers                  => -1,
                                                       Max_App_Ack_Remote_Readers          => -1,
                                                       Initial_Active_Topic_Queries        =>  1,
                                                       Max_Topic_Queries                   => -1,
                                                       Writer_Loaned_Sample_Allocation     => AllocationSettings_T_AUTO,
                                                       Initialize_Writer_Loaned_Sample     => False);
   --  <dref internal="true"></dref>

   --  ----------------------------------------------------------
   --                 SERVICE (eXtension QoS)
   --  ----------------------------------------------------------

   SERVICE_QOS_POLICY_NAME                        : constant DDS.String := To_DDS_String ("Service");
   --  <defgroup>ServiceQosGroupDocs</defgroup>
   --  <dref internal="true">SERVICE_QOS_POLICY_NAME</dref>

   type ServiceQosPolicyKind is new Unsigned_Long;
   --  <dref>ServiceQosPolicyKind</dref>

   NO_SERVICE_QOS : constant ServiceQosPolicyKind := 0;
   --  <dref>ServiceQosPolicyKind_NO_SERVICE_QOS</dref>

   PERSISTENCE_SERVICE_QOS : constant ServiceQosPolicyKind := 1;
   --  <dref>ServiceQosPolicyKind_PERSISTENCE_SERVICE_QOS</dref>

   QUEUING_SERVICE_QOS : constant ServiceQosPolicyKind := 2;
   --  <dref>ServiceQosPolicyKind_QUEUING_SERVICE_QOS</dref>

   ROUTING_SERVICE_QOS : constant ServiceQosPolicyKind := 3;
   --  <dref>ServiceQosPolicyKind_ROUTING_SERVICE_QOS</dref>

   RECORDING_SERVICE_QOS : constant ServiceQosPolicyKind := 4;
   --  <dref>ServiceQosPolicyKind_RECORDING_SERVICE_QOS</dref>

   REPLAY_SERVICE_QOS : constant ServiceQosPolicyKind := 5;
   --  <dref>ServiceQosPolicyKind_REPLAY_SERVICE_QOS</dref>

   DATABASE_INTEGRATION_SERVICE_QOS : constant ServiceQosPolicyKind := 6;
   --  <dref>ServiceQosPolicyKind_DATABASE_INTEGRATION_SERVICE_QOS</dref>

   DDS_WEB_INTEGRATION_SERVICE_QOS : constant ServiceQosPolicyKind := 7;
   --  <dref>ServiceQosPolicyKind_WEB_INTEGRATION_SERVICE_QOS</dref>

   type ServiceQosPolicy is record
      Kind : ServiceQosPolicyKind;
   end record  with Convention => C;
   --  <dref>ServiceQosPolicy</dref>
   --  <dref name="Kind">ServiceQosPolicy_kind</dref>

   SERVICE_QOS_POLICY_DEFAULT : constant ServiceQosPolicy :=
                                  (Kind => NO_SERVICE_QOS);
   --  <dref internal="true"></dref>

   --  ----------------------------------------------------------
   --                 PUBLISHER_PROTOCOL (eXtension QoS)
   --  ----------------------------------------------------------

   PUBLISHERPROTOCOL_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("PublisherProtocol");
   --  <defgroup internal="true">PublisherProtocolQosGroupDocs</defgroup>
   --  <dref internal="true">PUBLISHERPROTOCOL_QOS_POLICY_NAME</dref>

   type PublisherProtocolQosPolicy is record
      Vendor_Specific_Entity : DDS.Boolean := False;
   end record with Convention => C;
   --  <dref internal="true">PublisherProtocolQosPolicy</dref>
   --  <dref internal="true" name="vendor_specific_entity"a>PublisherProtocolQosPolicy_vendor_specific_entity</dref>

   PUBLISHER_PROTOCOL_QOS_POLICY_DEFAULT : constant PublisherProtocolQosPolicy :=
                                             (Vendor_Specific_Entity => False);
   --  <dref internal="true"></dref>

   --  ----------------------------------------------------------
   --                 SUBSCRIBER_PROTOCOL (eXtension QoS)
   --  ----------------------------------------------------------

   SUBSCRIBERPROTOCOL_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("SubscriberProtocol");
   --  <defgroup internal="true">SubscriberProtocolQosGroupDocs</defgroup>
   --  <dref internal="true">SUBSCRIBERPROTOCOL_QOS_POLICY_NAME</dref>

   type SubscriberProtocolQosPolicy is record
      Vendor_Specific_Entity : DDS.Boolean := False;
   end record with Convention => C;
   --  <dref internal="true">SubscriberProtocolQosPolicy</dref>
   --  <dref internal="true" name="vendor_specific_entity"a>SubscriberProtocolQosPolicy_vendor_specific_entity</dref>


   SUBSCRIBER_PROTOCOL_QOS_POLICY_DEFAULT : constant SubscriberProtocolQosPolicy :=
                                              (Vendor_Specific_Entity => False);
   --  <dref internal="true"></dref>

   --  ----------------------------------------------------------
   --                 DATAREADER_PROTOCOL (eXtension QoS)
   --  ----------------------------------------------------------

   DATAREADERPROTOCOL_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("DataReaderProtocol");
   --  <defgroup>DataReaderProtocolQosGroupDocs</defgroup>
   --  <dref>DATAREADERPROTOCOL_QOS_POLICY_NAME</dref>

   type DataReaderProtocolQosPolicy is record
      Virtual_Guid                                : aliased Guid_T;
      Rtps_Object_Id                              : aliased Unsigned_Long := RTPS_AUTO_ID;
      Expects_Inline_Qos                          : aliased DDS.Boolean := False;
      Disable_Positive_Acks                       : aliased DDS.Boolean := False;
      Propagate_Dispose_Of_Unregistered_Instances : aliased DDS.Boolean := False;
      Propagate_Unregister_Of_Disposed_Instances  : aliased DDS.Boolean := False;
      Rtps_Reliable_Reader                        : aliased RtpsReliableReaderProtocol_T := RTPS_RELIABLE_READER_PROTOCOL_DEFAULT;
      Vendor_Specific_Entity                      : aliased DDS.Boolean := False;
      Meta_Entity                                 : aliased DDS.Boolean := False;
   end record with Convention => C;
   --  <dref>DataReaderProtocolQosPolicy</dref>
   --  <dref name="Virtual_Guid">DataReaderProtocolQosPolicy_virtual_guid</dref>
   --  <dref name="Rtps_Object_Id">DataReaderProtocolQosPolicy_rtps_object_id</dref>
   --  <dref name="Expects_Inline_Qos">DataReaderProtocolQosPolicy_expects_inline_qos</dref>
   --  <dref name="disable_positive_acks">DataReaderProtocolQosPolicy_disable_positive_acks</dref>
   --  <dref name="propagate_dispose_of_unregistered_instances">DataReaderProtocolQosPolicy_propagate_dispose_of_unregistered_instances</dref>
   --  <dref name="propagate_unregister_of_disposed_instances">DataReaderProtocolQosPolicy_propagate_unregister_of_disposed_instances</dref>
   --  <dref name="Rtps_Reliable_Reader">DataReaderProtocolQosPolicy_rtps_reliable_reader</dref>
   --  <dref internal="true" name="vendor_specific_entity">DataReaderProtocolQosPolicy_vendor_specific_entity</dref>
   --  <dref internal="true" name="Meta_Entity">DataReaderProtocolQosPolicy_Meta_Entity</dref>

   DATA_READER_PROTOCOL_QOS_POLICY_DEFAULT : constant DataReaderProtocolQosPolicy :=
                                               (Virtual_Guid                                => (Value => (others => 0)),
                                                Rtps_Object_Id                              => RTPS_AUTO_ID,
                                                Expects_Inline_Qos                          => False,
                                                Disable_Positive_Acks                       => False,
                                                Propagate_Dispose_Of_Unregistered_Instances => False,
                                                Propagate_Unregister_Of_Disposed_Instances  => False,
                                                Rtps_Reliable_Reader                        => RTPS_RELIABLE_READER_PROTOCOL_DEFAULT,
                                                Vendor_Specific_Entity                      => False,
                                                Meta_Entity                                 => False);
   --  <dref internal="true"></dref>

   --  ----------------------------------------------------------
   --                 DATAWRITER_PROTOCOL (eXtension QoS)
   --  ----------------------------------------------------------

   DATAWRITERPROTOCOL_QOS_POLICY_NAME      : constant DDS.String := To_DDS_String ("DataWriterProtocol");
   --  <defgroup>DataWriterProtocolQosGroupDocs</defgroup>
   --  <dref>DATAWRITERPROTOCOL_QOS_POLICY_NAME</dref>

   type DataWriterProtocolQosPolicy is record
      Virtual_Guid                       : aliased Guid_T;
      Rtps_Object_Id                     : aliased Unsigned_Long := RTPS_AUTO_ID;
      Push_On_Write                      : aliased DDS.Boolean := False;
      Disable_Positive_Acks              : aliased DDS.Boolean := False;
      Disable_Inline_Keyhash             : aliased DDS.Boolean := False;
      Serialize_Key_With_Dispose         : aliased DDS.Boolean := False;
      Propagate_App_Ack_With_No_Response : aliased DDS.Boolean := True;
      Rtps_Reliable_Writer               : aliased RtpsReliableWriterProtocol_T := RTPS_RELIABLE_WRITER_PROTOCOL_DEFAULT;
      Initial_Virtual_Sequence_Number    : aliased DDS.SequenceNumber_T := (-2147483648, 16#FFFF_FFFF#);
      Vendor_Specific_Entity             : aliased DDS.Boolean := False;
   end record with Convention => C;
   --  <dref>DataWriterProtocolQosPolicy</dref>
   --  <dref name="Virtual_Guid">DataWriterProtocolQosPolicy_virtual_guid</dref>
   --  <dref name="Rtps_Object_Id">DataWriterProtocolQosPolicy_rtps_object_id</dref>
   --  <dref name="Push_On_Write">DataWriterProtocolQosPolicy_push_on_write</dref>
   --  <dref name="Disable_Positive_Acks">DataWriterProtocolQosPolicy_disable_positive_acks</dref>
   --  <dref name="Disable_Inline_Keyhash">DataWriterProtocolQosPolicy_disable_inline_keyhash</dref>
   --  <dref name="Serialize_Key_With_Dispose">DataWriterProtocolQosPolicy_serialize_key_with_dispose</dref>
   --  <dref name="Propagate_App_Ack_With_No_Response">DataWriterProtocolQosPolicy_propagate_app_ack_with_no_response</dref>
   --  <dref name="Rtps_Reliable_Writer">DataWriterProtocolQosPolicy_rtps_reliable_writer</dref>
   --  <dref name="Initial_Virtual_Sequence_Number">DataWriterProtocolQosPolicy_initial_virtual_sequence_number</dref>
   --  <dref internal="true" name="Vendor_Specific_Entity">DataWriterProtocolQosPolicy_vendor_specific_entity</dref>

   DATA_WRITER_PROTOCOL_QOS_POLICY_DEFAULT : constant DataWriterProtocolQosPolicy :=
                                               (Virtual_Guid                       => (Value => (others => 0)),
                                                Rtps_Object_Id                     => RTPS_AUTO_ID,
                                                Push_On_Write                      => True,
                                                Disable_Positive_Acks              => False,
                                                Disable_Inline_Keyhash             => False,
                                                Serialize_Key_With_Dispose         => False,
                                                Propagate_App_Ack_With_No_Response => True,
                                                Rtps_Reliable_Writer               => RTPS_RELIABLE_WRITER_PROTOCOL_DEFAULT,
                                                Initial_Virtual_Sequence_Number    => (-2147483648, 16#FFFF_FFFF#),
                                                Vendor_Specific_Entity             => False);
   --  <dref internal="true"></dref>

   --  ----------------------------------------------------------
   --                 SYSTEM_RESOURCE_LIMITS (eXtension QoS)
   --  ----------------------------------------------------------

   SYSTEMRESOURCELIMITS_QOS_POLICY_NAME    : constant DDS.String := To_DDS_String ("SystemResourceLimits");
   --  <defgroup>SystemResourceLimitsQosGroupDocs</defgroup>
   --  <dref>SYSTEMRESOURCELIMITS_QOS_POLICY_NAME</dref>

   type SystemResourceLimitsQosPolicy is record
      Max_Objects_Per_Thread : Long := 1024;
   end record with Convention => C;
   --  <dref>SystemResourceLimitsQosPolicy</dref>
   --  <dref name="Max_Objects_Per_Thread">SystemResourceLimitsQosPolicy_max_objects_per_thread</dref>

   SYSTEM_RESOURCE_LIMITS_QOS_POLICY_DEFAULT : constant SystemResourceLimitsQosPolicy :=
                                                 (Max_Objects_Per_Thread => 1024);
   --  <dref internal="true"></dref>

   --  ----------------------------------------------------------
   --                 DOMAIN_PARTICIPANT_RESOURCE_LIMITS (eXtension QoS)
   --  ----------------------------------------------------------

   DOMAINPARTICIPANTRESOURCELIMITS_QOS_POLICY_NAME :  constant DDS.String := To_DDS_String ("DomainParticipantResourceLimits");
   --  <defgroup>DomainParticipantResourceLimitsQosGroupDocs</defgroup>
   --  <dref>DOMAINPARTICIPANTRESOURCELIMITS_QOS_POLICY_NAME</dref>

   DomainParticipantResourceLimitsQosPolicy_MATCH_INIT : constant DDS.Long := 32;

   type DomainParticipantResourceLimitsIgnoredEntityReplacementKind is new Unsigned_Long;
   --  <dref>DomainParticipantResourceLimitsIgnoredEntityReplacementKind</dref>

   NO_REPLACEMENT_IGNORED_ENTITY_REPLACEMENT :
   constant DomainParticipantResourceLimitsIgnoredEntityReplacementKind := 0;
   --  <dref>DomainParticipantResourceLimitsIgnoredEntityReplacementKind_NO_REPLACEMENT_IGNORED_ENTITY_REPLACEMENT</dref>

   DDS_NOT_ALIVE_FIRST_IGNORED_ENTITY_REPLACEMENT :
   constant DomainParticipantResourceLimitsIgnoredEntityReplacementKind := 1;
   --  <dref>DomainParticipantResourceLimitsIgnoredEntityReplacementKind_NOT_ALIVE_FIRST_IGNORED_ENTITY_REPLACEMENT</dref>

   type DomainParticipantResourceLimitsQosPolicy is record
      Local_Writer_Allocation                               : aliased AllocationSettings_T := (16, -1, -1);
      Local_Reader_Allocation                               : aliased AllocationSettings_T := (16, -1, -1);
      Local_Publisher_Allocation                            : aliased AllocationSettings_T := (4, -1, -1);
      Local_Subscriber_Allocation                           : aliased AllocationSettings_T := (4, -1, -1);
      Local_Topic_Allocation                                : aliased AllocationSettings_T := (16, -1, -1);
      Remote_Writer_Allocation                              : aliased AllocationSettings_T := (64, -1, -1);
      Remote_Reader_Allocation                              : aliased AllocationSettings_T := (64, -1, -1);
      Remote_Participant_Allocation                         : aliased AllocationSettings_T := (16, -1, -1);
      Matching_Writer_Reader_Pair_Allocation                : aliased AllocationSettings_T := (DomainParticipantResourceLimitsQosPolicy_MATCH_INIT, -1, -1);
      Matching_Reader_Writer_Pair_Allocation                : aliased AllocationSettings_T := (DomainParticipantResourceLimitsQosPolicy_MATCH_INIT, -1, -1);
      Ignored_Entity_Allocation                             : aliased AllocationSettings_T := (8, -1, -1);
      Content_Filtered_Topic_Allocation                     : aliased AllocationSettings_T := (4, -1, -1);
      Content_Filter_Allocation                             : aliased AllocationSettings_T := (4, -1, -1);
      Read_Condition_Allocation                             : aliased AllocationSettings_T := (4, -1, -1);
      Query_Condition_Allocation                            : aliased AllocationSettings_T := (4, -1, -1);
      Outstanding_Asynchronous_Sample_Allocation            : aliased AllocationSettings_T := (64, -1, -1);
      Flow_Controller_Allocation                            : aliased AllocationSettings_T := (4, -1, -1);
      Local_Writer_Hash_Buckets                             : aliased Long := 4;
      Local_Reader_Hash_Buckets                             : aliased Long := 4;
      Local_Publisher_Hash_Buckets                          : aliased Long := 1;
      Local_Subscriber_Hash_Buckets                         : aliased Long := 1;
      Local_Topic_Hash_Buckets                              : aliased Long := 4;
      Remote_Writer_Hash_Buckets                            : aliased Long := 16;
      Remote_Reader_Hash_Buckets                            : aliased Long := 16;
      Remote_Participant_Hash_Buckets                       : aliased Long := 4;
      Matching_Writer_Reader_Pair_Hash_Buckets              : aliased Long := 32;
      Matching_Reader_Writer_Pair_Hash_Buckets              : aliased Long := 32;
      Ignored_Entity_Hash_Buckets                           : aliased Long := 1;
      Content_Filtered_Topic_Hash_Buckets                   : aliased Long := 1;
      Content_Filter_Hash_Buckets                           : aliased Long := 1;
      Flow_Controller_Hash_Buckets                          : aliased Long := 1;
      Max_Gather_Destinations                               : aliased Long := 8;
      Participant_User_Data_Max_Length                      : aliased Long := 256;
      Inter_Participant_Data_Max_Length                     : aliased Long := 256;
      Topic_Data_Max_Length                                 : aliased Long := 256;
      Publisher_Group_Data_Max_Length                       : aliased Long := 256;
      Subscriber_Group_Data_Max_Length                      : aliased Long := 256;
      Writer_User_Data_Max_Length                           : aliased Long := 256;
      Reader_User_Data_Max_Length                           : aliased Long := 256;
      Max_Partitions                                        : aliased Long := 64;
      Max_Partition_Cumulative_Characters                   : aliased Long := 256;
      Default_Partition_Matches_All                         : aliased Boolean := False;
      Allow_No_Partitions                                   : aliased Boolean := False;
      Type_Code_Max_Serialized_Length                       : aliased Long := 0;
      Type_Object_Max_Serialized_Length                     : aliased Long := 8192;
      Serialized_Type_Object_Dynamic_Allocation_Threshold   : aliased Long := 8192;
      Type_Object_Max_Deserialized_Length                   : aliased Long := -1;
      Deserialized_Type_Object_Dynamic_Allocation_Threshold : aliased Long := 4096;
      Contentfilter_Property_Max_Length                     : aliased Long := 256;
      Channel_Seq_Max_Length                                : aliased Long := 32;
      Channel_Filter_Expression_Max_Length                  : aliased Long := 256;
      Participant_Property_List_Max_Length                  : aliased Long := 32;
      Participant_Property_String_Max_Length                : aliased Long := 4096;
      Writer_Property_List_Max_Length                       : aliased Long := 32;
      Writer_Property_String_Max_Length                     : aliased Long := 1024;
      Reader_Property_List_Max_Length                       : aliased Long := 32;
      Reader_Property_String_Max_Length                     : aliased Long := 1024;
      Plugin_Info_Parameter_Max_Length                      : aliased Long := 265;
      Max_Endpoint_Groups                                   : aliased Long := 32;
      Max_Endpoint_Group_Cumulative_Characters              : aliased Long := 1024;
      Transport_Info_List_Max_Length                        : aliased Long := 12;
      Ignored_Entity_Replacement_Kind                       : aliased DomainParticipantResourceLimitsIgnoredEntityReplacementKind
        := NO_REPLACEMENT_IGNORED_ENTITY_REPLACEMENT;
      Remote_Topic_Query_Allocation                         : aliased AllocationSettings_T := (1, -1, -1);
      Remote_Topic_Query_Hash_Buckets                       : aliased Long := 1;
      Writer_Data_Tag_List_Max_Length                       : aliased Long := 0;
      Writer_Data_Tag_String_Max_Length                     : aliased Long := 0;
      Reader_Data_Tag_List_Max_Length                       : aliased Long := 0;
      Reader_Data_Tag_String_Max_Length                     : aliased Long := 0;
      Shmem_Ref_Transfer_Mode_Max_Segments                  : aliased Unsigned_Long
        := RTIDDS.Low_Level.ndds_pres_pres_participant_h.PRES_SHMEM_REF_TRANSFER_MODE_MAX_SEGMENTS;
   end record with Convention => C;
   --  <dref>DomainParticipantResourceLimitsQosPolicy</dref>
   --  <dref name="local_writer_allocation">DomainParticipantResourceLimitsQosPolicy_local_writer_allocation</dref>
   --  <dref name="local_reader_allocation">DomainParticipantResourceLimitsQosPolicy_local_reader_allocation</dref>
   --  <dref name="local_publisher_allocation">DomainParticipantResourceLimitsQosPolicy_local_publisher_allocation</dref>
   --  <dref name="local_subscriber_allocation">DomainParticipantResourceLimitsQosPolicy_local_subscriber_allocation</dref>
   --  <dref name="local_topic_allocation">DomainParticipantResourceLimitsQosPolicy_local_topic_allocation</dref>
   --  <dref name="remote_writer_allocation">DomainParticipantResourceLimitsQosPolicy_remote_writer_allocation</dref>
   --  <dref name="remote_reader_allocation">DomainParticipantResourceLimitsQosPolicy_remote_reader_allocation</dref>
   --  <dref name="remote_partiicpant_allocation">DomainParticipantResourceLimitsQosPolicy_remote_participant_allocation</dref>
   --  <dref name="matching_writer_reader_pair_allocation">DomainParticipantResourceLimitsQosPolicy_matching_writer_reader_pair_allocation</dref>
   --  <dref name="matching_reader_writer_pair_allocation">DomainParticipantResourceLimitsQosPolicy_matching_reader_writer_pair_allocation</dref>
   --  <dref name="ignored_entity_allocation">DomainParticipantResourceLimitsQosPolicy_ignored_entity_allocation</dref>
   --  <dref name="content_filtered_topic_allocation">DomainParticipantResourceLimitsQosPolicy_content_filtered_topic_allocation</dref>
   --  <dref name="content_filter_allocation">DomainParticipantResourceLimitsQosPolicy_content_filter_allocation</dref>
   --  <dref name="read_condition_allocation">DomainParticipantResourceLimitsQosPolicy_read_condition_allocation</dref>
   --  <dref name="query_condition_allocation">DomainParticipantResourceLimitsQosPolicy_query_condition_allocation</dref>
   --  <dref name="outstanding_asynchronous_sample_allocation">DomainParticipantResourceLimitsQosPolicy_outstanding_asynchronous_sample_allocation</dref>
   --  <dref name="flow_controller_allocation">DomainParticipantResourceLimitsQosPolicy_flow_controller_allocation</dref>
   --  <dref name="local_writer_hash_buckets">DomainParticipantResourceLimitsQosPolicy_local_writer_hash_buckets</dref>
   --  <dref name="local_reader_hash_buckets">DomainParticipantResourceLimitsQosPolicy_local_reader_hash_buckets</dref>
   --  <dref name="local_publisher_hash_buckets">DomainParticipantResourceLimitsQosPolicy_local_publisher_hash_buckets</dref>
   --  <dref name="local_subscriber_hash_buckets">DomainParticipantResourceLimitsQosPolicy_local_subscriber_hash_buckets</dref>
   --  <dref name="local_topic_hash_buckets">DomainParticipantResourceLimitsQosPolicy_local_topic_hash_buckets</dref>
   --  <dref name="remote_writer_hash_buckets">DomainParticipantResourceLimitsQosPolicy_remote_writer_hash_buckets</dref>
   --  <dref name="remote_reader_hash_buckets">DomainParticipantResourceLimitsQosPolicy_remote_reader_hash_buckets</dref>
   --  <dref name="remote_participant_hash_buckets">DomainParticipantResourceLimitsQosPolicy_remote_participant_hash_buckets</dref>
   --  <dref name="matching_writer_reader_pair_hash_buckets">DomainParticipantResourceLimitsQosPolicy_matching_writer_reader_pair_hash_buckets</dref>
   --  <dref name="matching_reader_writer_pair_hash_buckets">DomainParticipantResourceLimitsQosPolicy_matching_reader_writer_pair_hash_buckets</dref>
   --  <dref name="ignored_entity_hash_buckets">DomainParticipantResourceLimitsQosPolicy_ignored_entity_hash_buckets</dref>
   --  <dref name="content_filtered_topic_hash_buckets">DomainParticipantResourceLimitsQosPolicy_content_filtered_topic_hash_buckets</dref>
   --  <dref name="content_filter_hash_buckets">DomainParticipantResourceLimitsQosPolicy_content_filter_hash_buckets</dref>
   --  <dref name="flow_controller_hash_buckets">DomainParticipantResourceLimitsQosPolicy_flow_controller_hash_buckets</dref>
   --  <dref name="max_gather_destinations">DomainParticipantResourceLimitsQosPolicy_max_gather_destinations</dref>
   --  <dref name="participant_user_data_max_length">DomainParticipantResourceLimitsQosPolicy_participant_user_data_max_length</dref>
   --  <dref internal="true" name="inter_participant_data_max_length">DomainParticipantResourceLimitsQosPolicy_inter_participant_data_max_length</dref>
   --  <dref name="topic_data_max_length">DomainParticipantResourceLimitsQosPolicy_topic_data_max_length</dref>
   --  <dref name="publisher_group_data_max_length">DomainParticipantResourceLimitsQosPolicy_publisher_group_data_max_length</dref>
   --  <dref name="subscriber_group_data_max_length">DomainParticipantResourceLimitsQosPolicy_subscriber_group_data_max_length</dref>
   --  <dref name="writer_user_data_max_length">DomainParticipantResourceLimitsQosPolicy_writer_user_data_max_length</dref>
   --  <dref name="reader_user_data_max_length">DomainParticipantResourceLimitsQosPolicy_reader_user_data_max_length</dref>
   --  <dref name="max_partitions">DomainParticipantResourceLimitsQosPolicy_max_partitions</dref>
   --  <dref name="max_partition_cumulative_characters">DomainParticipantResourceLimitsQosPolicy_max_partition_cumulative_characters</dref>
   --  <dref internal="true" name="default_partition_matches_all">DomainParticipantResourceLimitsQosPolicy_default_partition_matches_all</dref>
   --  <dref internal="true" name="allow_no_partitions">DomainParticipantResourceLimitsQosPolicy_allow_no_partitions</dref>
   --  <dref name="type_code_max_serialized_length">DomainParticipantResourceLimitsQosPolicy_type_code_max_serialized_length</dref>
   --  <dref name="Type_Object_Max_Serialized_Length">DomainParticipantResourceLimitsQosPolicy_type_object_max_serialized_length</dref>
   --  <dref internal="true" name="Serialized_Type_Object_Dynamic_Allocation_Threshold">DomainParticipantResourceLimitsQosPolicy_serialized_type_object_dynamic_allocation_threshold</dref>
   --  <dref name="Type_Object_Max_Deserialized_Length">DomainParticipantResourceLimitsQosPolicy_type_object_max_deserialized_length</dref>
   --  <dref name="Deserialized_Type_Object_Dynamic_Allocation_Threshold">DomainParticipantResourceLimitsQosPolicy_deserialized_type_object_dynamic_allocation_threshold</dref>
   --  <dref name="contentfilter_property_max_length">DomainParticipantResourceLimitsQosPolicy_contentfilter_property_max_length</dref>
   --  <dref name="channel_seq_max_length">DomainParticipantResourceLimitsQosPolicy_channel_seq_max_length</dref>
   --  <dref name="channel_filter_expression_max_length">DomainParticipantResourceLimitsQosPolicy_channel_filter_expression_max_length</dref>
   --  <dref name="participant_property_list_max_length">DomainParticipantResourceLimitsQosPolicy_participant_property_list_max_length</dref>
   --  <dref name="participant_property_string_max_length">DomainParticipantResourceLimitsQosPolicy_participant_property_string_max_length</dref>
   --  <dref name="writer_property_list_max_length">DomainParticipantResourceLimitsQosPolicy_writer_property_list_max_length</dref>
   --  <dref name="writer_property_string_max_length">DomainParticipantResourceLimitsQosPolicy_writer_property_string_max_length</dref>
   --  <dref name="reader_property_list_max_length">DomainParticipantResourceLimitsQosPolicy_reader_property_list_max_length</dref>
   --  <dref name="reader_property_string_max_length">DomainParticipantResourceLimitsQosPolicy_reader_property_string_max_length</dref>
   --  <dref internal="true" name="plugin_info_parameter_max_length">DomainParticipantResourceLimitsQosPolicy_plugin_info_parameter_max_length</dref>
   --  <dref name="max_endpoint_groups">DomainParticipantResourceLimitsQosPolicy_max_endpoint_groups</dref>
   --  <dref name="max_endpoint_group_cumulative_characters">DomainParticipantResourceLimitsQosPolicy_max_endpoint_group_cumulative_characters</dref>
   --  <dref name="transport_info_list_max_length">DomainParticipantResourceLimitsQosPolicy_transport_info_list_max_length</dref>
   --  <dref name="ignored_entity_replacement_kind">DomainParticipantResourceLimitsQosPolicy_ignored_entity_replacement_kind</dref>
   --  <dref internal="true" name="Remote_Topic_Query_Allocation">DomainParticipantResourceLimitsQosPolicy_remote_topic_query_allocation</dref>
   --  <dref internal="true" name="Remote_Topic_Query_Hash_Buckets">DomainParticipantResourceLimitsQosPolicy_remote_topic_query_hash_buckets</dref>
   --  <dref internal="true" name="Writer_Data_Tag_List_Max_Length">DomainParticipantResourceLimitsQosPolicy_writer_data_tag_list_max_length</dref>
   --  <dref internal="true" name="Writer_Data_Tag_String_Max_Length">DomainParticipantResourceLimitsQosPolicy_writer_data_tag_string_max_length</dref>
   --  <dref internal="true" name="Reader_Data_Tag_List_Max_Length">DomainParticipantResourceLimitsQosPolicy_reader_data_tag_list_max_length</dref>
   --  <dref internal="true" name="Reader_Data_Tag_String_Max_Length">DomainParticipantResourceLimitsQosPolicy_reader_data_tag_string_max_length</dref>
   --  <dref internal="true" name="Shmem_Ref_Transfer_Mode_Max_Segments">DomainParticipantResourceLimitsQosPolicy_shmem_ref_transfer_mode_max_segments</dref>

   DOMAIN_PARTICIPANT_RESOURCE_LIMITS_QOS_POLICY_DEFAULT :
   constant DomainParticipantResourceLimitsQosPolicy :=
                                                             (Local_Writer_Allocation                               => (16, -1, -1),
                                                              Local_Reader_Allocation                               => (16, -1, -1),
                                                              Local_Publisher_Allocation                            => (4, -1, -1),
                                                              Local_Subscriber_Allocation                           => (4, -1, -1),
                                                              Local_Topic_Allocation                                => (16, -1, -1),
                                                              Remote_Writer_Allocation                              => (64, -1, -1),
                                                              Remote_Reader_Allocation                              => (64, -1, -1),
                                                              Remote_Participant_Allocation                         => (16, -1, -1),
                                                              Matching_Writer_Reader_Pair_Allocation                =>
                                                                (DomainParticipantResourceLimitsQosPolicy_MATCH_INIT, -1, -1),
                                                              Matching_Reader_Writer_Pair_Allocation                =>
                                                                (DomainParticipantResourceLimitsQosPolicy_MATCH_INIT, -1, -1),
                                                              Ignored_Entity_Allocation                             => (8, -1, -1),
                                                              Content_Filtered_Topic_Allocation                     => (4, -1, -1),
                                                              Content_Filter_Allocation                             => (4, -1, -1),
                                                              Read_Condition_Allocation                             => (4, -1, -1),
                                                              Query_Condition_Allocation                            => (4, -1, -1),
                                                              Outstanding_Asynchronous_Sample_Allocation            => (64, -1, -1),
                                                              Flow_Controller_Allocation                            => (4, -1, -1),
                                                              Local_Writer_Hash_Buckets                             => 4,
                                                              Local_Reader_Hash_Buckets                             => 4,
                                                              Local_Publisher_Hash_Buckets                          => 1,
                                                              Local_Subscriber_Hash_Buckets                         => 1,
                                                              Local_Topic_Hash_Buckets                              => 4,
                                                              Remote_Writer_Hash_Buckets                            => 16,
                                                              Remote_Reader_Hash_Buckets                            => 16,
                                                              Remote_Participant_Hash_Buckets                       => 4,
                                                              Matching_Writer_Reader_Pair_Hash_Buckets              => 32,
                                                              Matching_Reader_Writer_Pair_Hash_Buckets              => 32,
                                                              Ignored_Entity_Hash_Buckets                           => 1,
                                                              Content_Filtered_Topic_Hash_Buckets                   => 1,
                                                              Content_Filter_Hash_Buckets                           => 1,
                                                              Flow_Controller_Hash_Buckets                          => 1,
                                                              Max_Gather_Destinations                               => 8,
                                                              Participant_User_Data_Max_Length                      => 256,
                                                              Inter_Participant_Data_Max_Length                     => 256,
                                                              Topic_Data_Max_Length                                 => 256,
                                                              Publisher_Group_Data_Max_Length                       => 256,
                                                              Subscriber_Group_Data_Max_Length                      => 256,
                                                              Writer_User_Data_Max_Length                           => 256,
                                                              Reader_User_Data_Max_Length                           => 256,
                                                              Max_Partitions                                        => 64,
                                                              Max_Partition_Cumulative_Characters                   => 256,
                                                              Default_Partition_Matches_All                         => False,
                                                              Allow_No_Partitions                                   => False,
                                                              Type_Code_Max_Serialized_Length                       => 0,
                                                              Type_Object_Max_Serialized_Length                     => 8192,
                                                              Serialized_Type_Object_Dynamic_Allocation_Threshold   => 8192,
                                                              Type_Object_Max_Deserialized_Length                   => -1,
                                                              Deserialized_Type_Object_Dynamic_Allocation_Threshold => 4096,
                                                              Contentfilter_Property_Max_Length                     => 256,
                                                              Channel_Seq_Max_Length                                => 32,
                                                              Channel_Filter_Expression_Max_Length                  => 256,
                                                              Participant_Property_List_Max_Length                  => 32,
                                                              Participant_Property_String_Max_Length                => 1024,
                                                              Writer_Property_List_Max_Length                       => 32,
                                                              Writer_Property_String_Max_Length                     => 1024,
                                                              Reader_Property_List_Max_Length                       => 32,
                                                              Reader_Property_String_Max_Length                     => 1024,
                                                              Plugin_Info_Parameter_Max_Length                      => 256,
                                                              Max_Endpoint_Groups                                   => 32,
                                                              Max_Endpoint_Group_Cumulative_Characters              => 1024,
                                                              Transport_Info_List_Max_Length                        => 12,
                                                              Ignored_Entity_Replacement_Kind                       => NO_REPLACEMENT_IGNORED_ENTITY_REPLACEMENT,
                                                              Remote_Topic_Query_Allocation                         => (1, -1, -1),
                                                              Remote_Topic_Query_Hash_Buckets                       => 1,
                                                              Writer_Data_Tag_List_Max_Length                       => 0,
                                                              Writer_Data_Tag_String_Max_Length                     => 0,
                                                              Reader_Data_Tag_List_Max_Length                       => 0,
                                                              Reader_Data_Tag_String_Max_Length                     => 0,
                                                              Shmem_Ref_Transfer_Mode_Max_Segments                  => RTIDDS.Low_Level.ndds_pres_pres_participant_h.PRES_SHMEM_REF_TRANSFER_MODE_MAX_SEGMENTS);
   --  <dref internal="true"></dref>


   --  ----------------------------------------------------------
   --                 EVENT (eXtension QoS)
   --  ----------------------------------------------------------

   EVENT_QOS_POLICY_NAME                                 : constant DDS.String := To_DDS_String ("Event");
   --  <defgroup>EventQosGroupDocs</defgroup>
   --  <dref>EVENT_QOS_POLICY_NAME</dref>

   type EventQosPolicy is record
      Thread        : aliased ThreadSettings_T;
      Initial_Count : aliased Long := 256;
      Max_Count     : aliased Long := -1;
   end record with Convention => C;
   --  <dref>EventQosPolicy</dref>
   --  <dref name="Thread">EventQosPolicy_thread</dref>
   --  <dref name="Initial_Count">EventQosPolicy_initial_count</dref>
   --  <dref name="Max_Count">EventQosPolicy_max_count</dref>

   --        EVENT_QOS_POLICY_DEFAULT : constant EventQosPolicy :=
   --                                     (Thread        => THREAD_SETTINGS_DEFAULT,
   --                                      Initial_Count => 256,
   --                                      Max_Count     => -1);

   --  ----------------------------------------------------------
   --                 DATABASE (eXtension QoS)
   --  ----------------------------------------------------------

   DATABASE_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("Database");
   --  <defgroup>DatabaseQosGroupDocs</defgroup>
   --  <dref>DATABASE_QOS_POLICY_NAME</dref>

   type DatabaseQosPolicy is record
      Thread                      : aliased ThreadSettings_T;
      Shutdown_Timeout            : aliased Duration_T := (15, 0);
      Cleanup_Period              : aliased Duration_T := (61, 0);
      Shutdown_Cleanup_Period     : aliased Duration_T := (1, 0);
      Initial_Records             : aliased Long := 1024;
      Max_Skiplist_Level          : aliased Long := 7;
      Table_Allocation_Block_Size : aliased Long := 48;
      Max_Weak_References         : aliased Long := -1;
      Initial_Weak_References     : aliased Long := 2049;
   end record with Convention => C;
   --  <dref>DatabaseQosPolicy</dref>
   --  <dref name="Thread">DatabaseQosPolicy_thread</dref>
   --  <dref name="Shutdown_Timeout">DatabaseQosPolicy_shutdown_timeout</dref>
   --  <dref name="Cleanup_Period">DatabaseQosPolicy_cleanup_period</dref>
   --  <dref name="Shutdown_Cleanup_Period">DatabaseQosPolicy_shutdown_cleanup_period</dref>
   --  <dref name="Initial_Records">DatabaseQosPolicy_initial_records</dref>
   --  <dref name="Max_Skiplist_Level">DatabaseQosPolicy_max_skiplist_level</dref>
   --  <dref internal="true" name="Table_Allocation_Block_Sizee">DatabaseQosPolicy_table_allocation_block_size</dref>
   --  <dref name="Max_Weak_References">DatabaseQosPolicy_max_weak_references</dref>
   --  <dref name="Initial_Weak_References">DatabaseQosPolicy_initial_weak_references</dref>

   --     DATABASE_QOS_POLICY_DEFAULT :  constant DatabaseQosPolicy :=
   --                                     (Thread                      => THREAD_SETTINGS_DEFAULT,
   --                                      Shutdown_Timeout            => (15, 0),
   --                                      Cleanup_Period              => (61, 0),
   --                                      Shutdown_Cleanup_Period     => (1, 0),
   --                                      Initial_Records             => 1024,
   --                                      Max_Skiplist_Level          => 7,
   --                                      Table_Allocation_Block_Size => 48,
   --                                      Max_Weak_References         => -1,
   --                                      Initial_Weak_References     => 2049);

   --  ----------------------------------------------------------
   --                 RECEIVER_POOL (eXtension QoS)
   --  ----------------------------------------------------------

   RECEIVERPOOL_QOS_POLICY_NAME : DDS.String := To_DDS_String ("ReceiverPool");
   --  <defgroup>ReceiverPoolQosGroupDocs</defgroup>
   --  <dref>RECEIVERPOOL_QOS_POLICY_NAME</dref>

   ReceiverPoolQosPolicy_MAX_RECEIVE_THREADS_DEFAULT : constant Long := -1;

   type ReceiverPoolQosPolicy is record
      Thread                  : aliased ThreadSettings_T;
      Initial_Receive_Threads : aliased Long := 4;
      Max_Receive_Threads     : aliased Long := ReceiverPoolQosPolicy_MAX_RECEIVE_THREADS_DEFAULT;
      Buffer_Size             : aliased Long := 9216;
      Buffer_Alignment        : aliased Long := 16;
      Is_Timestamp_Enabled    : aliased DDS.Boolean := True;
   end record with Convention => C;
   --  <dref>ReceiverPoolQosPolicy</dref>
   --  <dref name="Thread">ReceiverPoolQosPolicy_thread</dref>
   --  <dref internal="true" name="Initial_Receive_Threads">ReceiverPoolQosPolicy_initial_receive_threads</dref>
   --  <dref internal="true" name="Max_Receive_Threads">ReceiverPoolQosPolicy_max_receive_threads</dref>
   --  <dref name="Buffer_Size">ReceiverPoolQosPolicy_buffer_size</dref>
   --  <dref name="Buffer_Alignment">ReceiverPoolQosPolicy_buffer_alignment</dref>
   --  <dref internal="true" name="Is_Timestamp_Enabled">ReceiverPoolQosPolicy_is_timestamp_enabled</dref>


   --     RECEIVER_POOL_QOS_POLICY_DEFAULT : constant ReceiverPoolQosPolicy :=
   --                                          (Thread                  => THREAD_SETTINGS_DEFAULT,
   --                                           Initial_Receive_Threads => 4,
   --                                           Max_Receive_Threads     => ReceiverPoolQosPolicy_MAX_RECEIVE_THREADS_DEFAULT,
   --                                           Buffer_Size             => 9216,
   --                                           Buffer_Alignment        => 16,
   --                                           Is_Timestamp_Enabled    => TRUE);

   --  ----------------------------------------------------------
   --                  BuiltinTopicReaderResourceLimits_t
   --  ----------------------------------------------------------

   type BuiltinTopicReaderResourceLimits_T is record
      Initial_Samples                          : aliased Long := 64;
      Max_Samples                              : aliased Long := -1;
      Initial_Infos                            : aliased Long := 64;
      Max_Infos                                : aliased Long := -1;
      Initial_Outstanding_Reads                : aliased Long := 2;
      Max_Outstanding_Reads                    : aliased Long := -1;
      Max_Samples_Per_Read                     : aliased Long := 1024;
      Disable_Fragmentation_Support            : aliased DDS.Boolean := False;
      Max_Fragmented_Samples                   : aliased Long := 1024;
      Initial_Fragmented_Samples               : aliased Long := 4;
      Max_Fragmented_Samples_Per_Remote_Writer : aliased Long := 256;
      Max_Fragments_Per_Sample                 : aliased Long := 512;
      Dynamically_Allocate_Fragmented_Samples  : aliased DDS.Boolean := False;
   end record with Convention => C;
   --  <dref>BuiltinTopicReaderResourceLimits_t</dref>
   --  <dref name="Initial_Samples">BuiltinTopicReaderResourceLimits_t_initial_samples</dref>
   --  <dref name="Max_Samples">BuiltinTopicReaderResourceLimits_t_max_samples</dref>
   --  <dref name="Initial_Infos">BuiltinTopicReaderResourceLimits_t_initial_infos</dref>
   --  <dref name="Max_Infos">BuiltinTopicReaderResourceLimits_t_max_infos</dref>
   --  <dref name="Initial_Outstanding_Reads">BuiltinTopicReaderResourceLimits_t_initial_outstanding_reads</dref>
   --  <dref name="Max_Outstanding_Reads">BuiltinTopicReaderResourceLimits_t_max_outstanding_reads</dref>
   --  <dref name="Max_Samples_Per_Read">BuiltinTopicReaderResourceLimits_t_max_samples_per_read</dref>
   --  <dref name="Disable_Fragmentation_Support">BuiltinTopicReaderResourceLimits_t_disable_fragmentation_support</dref>
   --  <dref name="Max_Fragmented_Samples">BuiltinTopicReaderResourceLimits_t_max_fragmented_samples</dref>
   --  <dref name="Initial_Fragmented_Samples">BuiltinTopicReaderResourceLimits_t_initial_fragmented_samples</dref>
   --  <dref name="Max_Fragmented_Samples_Per_Remote_Writer">BuiltinTopicReaderResourceLimits_t_max_fragmented_samples_per_remote_writer</dref>
   --  <dref name="Max_Fragments_Per_Sample">BuiltinTopicReaderResourceLimits_t_max_fragments_per_sample</dref>
   --  <dref name="Dynamically_allocate_Fragmented_Samples">BuiltinTopicReaderResourceLimits_t_dynamically_allocate_fragmented_samples</dref>

   BUILTIN_TOPIC_READER_RESOURCE_LIMITS_DEFAULT : constant BuiltinTopicReaderResourceLimits_T :=
                                                    (Initial_Samples                          => 64,
                                                     Max_Samples                              => -1,
                                                     Initial_Infos                            => 64,
                                                     Max_Infos                                => -1,
                                                     Initial_Outstanding_Reads                => 2,
                                                     Max_Outstanding_Reads                    => -1,
                                                     Max_Samples_Per_Read                     => 1024,
                                                     Disable_Fragmentation_Support            => False,
                                                     Max_Fragmented_Samples                   => 1024,
                                                     Initial_Fragmented_Samples               => 4,
                                                     Max_Fragmented_Samples_Per_Remote_Writer => 256,
                                                     Max_Fragments_Per_Sample                 => 512,
                                                     Dynamically_Allocate_Fragmented_Samples  => False);
   --  <dref internal="true"></dref>

   BUILTIN_TOPIC_KEY_TYPE_NATIVE_LENGTH         : constant := 4;
   --  <dref internal="true"></dref>

   type  BuiltinTopicKey_Array_T is array
     (0 .. BUILTIN_TOPIC_KEY_TYPE_NATIVE_LENGTH - 1) of Builtin_Topic_Key_Type_Native;

   type BuiltinTopicKey_T is record
      Value : BuiltinTopicKey_Array_T := (others => 0);
   end record with Convention => C;
   --  <defgroup>BuiltInTopicCommonGroupDocs</defgroup>
   --  <dref>BuiltinTopicKey_t</dref>
   --  <dref name="Value">BuiltinTopicKey_t_value</dref>

   type BuiltinTopicKey_T_Access is access all BuiltinTopicKey_T;

   BuiltinTopicKey_T_INITIALIZER : constant BuiltinTopicKey_T :=
                                     (Value => (0, 0, 0, 0));
   --  <dref internal="true"></dref>

   function BuiltinTopicKey_Equals (A : in BuiltinTopicKey_T_Access;
                                    B : in BuiltinTopicKey_T_Access)
                                    return DDS.Boolean;
   --  <dref internal="true"></dref>

   --  ----------------------------------------------------------
   --                  PUBLISHMODE (eXtension QoS)
   --  ----------------------------------------------------------

   PUBLISHMODE_QOS_POLICY_NAME   : constant DDS.String := To_DDS_String ("PublishMode");
   --  <defgroup>PublishModeQosGroupDocs</defgroup>
   --  <dref>PUBLISHMODE_QOS_POLICY_NAME</dref>

   type PublishModeQosPolicyKind is new Unsigned_Long;
   --  <dref>PublishModeQosPolicyKind</dref>

   SYNCHRONOUS_PUBLISH_MODE_QOS  : constant PublishModeQosPolicyKind := 0;
   --  <dref>PublishModeQosPolicyKind_SYNCHRONOUS_PUBLISH_MODE_QOS</dref>

   ASYNCHRONOUS_PUBLISH_MODE_QOS : constant PublishModeQosPolicyKind := 1;
   --  <dref>PublishModeQosPolicyKind_ASYNCHRONOUS_PUBLISH_MODE_QOS</dref>

   PUBLICATION_PRIORITY_UNDEFINED : constant Long := 0;
   --  <dref>PUBLICATION_PRIORITY_UNDEFINED</dref>

   PUBLICATION_PRIORITY_AUTOMATIC : constant Long := -1;
   --  <dref>PUBLICATION_PRIORITY_AUTOMATIC</dref>

   type PublishModeQosPolicy is record
      Kind                 : aliased PublishModeQosPolicyKind := SYNCHRONOUS_PUBLISH_MODE_QOS;
      Flow_Controller_Name : aliased DDS.String;
      Priority             : aliased Long := PUBLICATION_PRIORITY_UNDEFINED;
   end record with Convention => C;
   --  <dref>PublishModeQosPolicy</dref>
   --  <dref name="Kind">PublishModeQosPolicy_kind</dref>
   --  <dref name="Flow_Controller_Name">PublishModeQosPolicy_flow_controller_name</dref>
   --  <dref name="Priority">PublishModeQosPolicy_priority</dref>

   PUBLISH_MODE_QOS_POLICY_DEFAULT : constant PublishModeQosPolicy :=
                                       (Kind                      => SYNCHRONOUS_PUBLISH_MODE_QOS,
                                        Flow_Controller_Name      => (Data => DDS.NULL_STRING.Data),
                                        Priority                  => PUBLICATION_PRIORITY_UNDEFINED
                                       );
   --  <dref internal="true"></dref>

   --  ----------------------------------------------------------
   --                  DISCOVERY_CONFIG (eXtension QoS)
   --  ----------------------------------------------------------

   DISCOVERYCONFIG_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("DiscoveryConfig");
   --  <defgroup>DiscoveryConfigQosGroupDocs</defgroup>
   --  <dref>DISCOVERYCONFIG_QOS_POLICY_NAME</dref>

   type DiscoveryConfigBuiltinPluginKind is new DDS.Unsigned_Long;
   --  <dref>DiscoveryConfigBuiltinPluginKind</dref>

   subtype DiscoveryConfigBuiltinPluginKindMask is  DiscoveryConfigBuiltinPluginKind;
   --  <dref>DiscoveryConfigBuiltinPluginKindMask</dref>

   DISCOVERYCONFIG_BUILTIN_SPDP  : constant  DiscoveryConfigBuiltinPluginKindMask := 2#0001#;
   --  <dref internal="true">DiscoveryConfigBuiltinPluginKind_DISCOVERYCONFIG_BUILTIN_SPDP</dref>

   DISCOVERYCONFIG_BUILTIN_SEDP  : constant  DiscoveryConfigBuiltinPluginKindMask := 2#0010#;
   --  <dref internal="true">DiscoveryConfigBuiltinPluginKind_DISCOVERYCONFIG_BUILTIN_SEDP</dref>

   DISCOVERYCONFIG_BUILTIN_SDP   : constant  DiscoveryConfigBuiltinPluginKindMask :=
                                     (DISCOVERYCONFIG_BUILTIN_SPDP or DISCOVERYCONFIG_BUILTIN_SEDP);
   --  <dref>DiscoveryConfigBuiltinPluginKind_DISCOVERYCONFIG_BUILTIN_SDP</dref>

   DISCOVERYCONFIG_BUILTIN_EDS   : constant  DiscoveryConfigBuiltinPluginKindMask := 2#0100#;
   --  <dref internal="true">DiscoveryConfigBuiltinPluginKind_DISCOVERYCONFIG_BUILTIN_EDS</dref>

   DISCOVERYCONFIG_BUILTIN_PLUGIN_MASK_ALL     :
   constant  DiscoveryConfigBuiltinPluginKindMask := 16#EFFF#;
   --  <dref>DISCOVERYCONFIG_BUILTIN_PLUGIN_MASK_ALL</dref>

   DISCOVERYCONFIG_BUILTIN_PLUGIN_MASK_NONE    :
   constant  DiscoveryConfigBuiltinPluginKindMask := 0;
   --  <dref>DISCOVERYCONFIG_BUILTIN_PLUGIN_MASK_NONE</dref>

   DISCOVERYCONFIG_BUILTIN_PLUGIN_MASK_DEFAULT :
   constant  DiscoveryConfigBuiltinPluginKindMask := DISCOVERYCONFIG_BUILTIN_SDP;
   --  <dref>DISCOVERYCONFIG_BUILTIN_PLUGIN_MASK_DEFAULT</dref>

   type DiscoveryPluginPromiscuityKind is new Unsigned_Long;
   --  <dref internal="true">DiscoveryPluginPromiscouityKind</dref>

   DISCOVERYPLUGIN_DISCOVER_MATCHING_REMOTE_ENTITIES_PROMISCUITY : constant DiscoveryPluginPromiscuityKind := 1;
   --  <dref internal="true">DiscoveryPluginPromiscouityKind_DISCOVERYPLUGIN_DISCOVER_MATCHING_REMOTE_ENTITIES_PROMISCUITY</dref>

   DISCOVERYPLUGIN_DISCOVER_ALL_REMOTE_ENTITIES_PROMISCUITY : constant DiscoveryPluginPromiscuityKind := 16#FFFF#;
   --  <dref internal="true">DiscoveryPluginPromiscouityKind_DISCOVERYPLUGIN_DISCOVER_ALL_REMOTE_ENTITIES_PROMISCUITY</dref>

   type RemoteParticipantPurgeKind is new Unsigned_Long;
   --  <dref>RemoteParticipantPurgeKind</dref>

   LIVELINESS_BASED_REMOTE_PARTICIPANT_PURGE : constant RemoteParticipantPurgeKind := 0;
   --  <dref>RemoteParticipantPurgeKind_LIVELINESS_BASED_REMOTE_PARTICIPANT_PURGE</dref>

   NO_REMOTE_PARTICIPANT_PURGE   : constant RemoteParticipantPurgeKind := 1;
   --  <dref>RemoteParticipantPurgeKind_NO_REMOTE_PARTICIPANT_PURGE</dref>

   type DiscoveryBuiltinReaderFragmentationResourceLimits_T is record
      Disable_Fragmentation_Support            : aliased DDS.Boolean := False;
      Max_Fragmented_Samples                   : aliased Long := 1024;
      Initial_Fragmented_Samples               : aliased Long := 4;
      Max_Fragmented_Samples_Per_Remote_Writer : aliased Long := 256;
      Max_Fragments_Per_Sample                 : aliased Long := 512;
      Dynamically_Allocate_Fragmented_Samples  : aliased DDS.Boolean := False;
   end record with Convention => C;
   --  <dref internal="true">DiscoveryBuiltinReaderFragmentationResourceLimits_t</dref>
   --  <dref internal="true" name="Disable_Fragmentation_Support">DiscoveryBuiltinReaderFragmentationResourceLimits_t_disable_fragmentation_support</dref>
   --  <dref internal="true" name="Max_Fragmented_Samples">DiscoveryBuiltinReaderFragmentationResourceLimits_t_max_fragmented_samples</dref>
   --  <dref internal="true" name="Initial_Fragmented_Samples">DiscoveryBuiltinReaderFragmentationResourceLimits_t_initial_fragmented_samples</dref>
   --  <dref internal="true" name="Max_Fragmented_Per_Samples_Per_Remote_Writer">DiscoveryBuiltinReaderFragmentationResourceLimits_t_max_fragmented_per_samples_per_remote_writer</dref>
   --  <dref internal="true" name="Max_Fragments_Per_Sample">DiscoveryBuiltinReaderFragmentationResourceLimits_t_max_fragments_per_sample</dref>
   --  <dref internal="true" name="Dynamically_Allocate_Fragmented_Samples">DiscoveryBuiltinReaderFragmentationResourceLimits_t_dynamically_allocate_fragmented_samples</dref>


   DISCOVERY_BUILTIN_READER_FRAGMENTATION_RESOURCE_LIMITS_DEFAULT : constant DiscoveryBuiltinReaderFragmentationResourceLimits_T :=
                                                                      (Disable_Fragmentation_Support            => False,
                                                                       Max_Fragmented_Samples                   => 1024,
                                                                       Initial_Fragmented_Samples               => 4,
                                                                       Max_Fragmented_Samples_Per_Remote_Writer => 256,
                                                                       Max_Fragments_Per_Sample                 => 512,
                                                                       Dynamically_Allocate_Fragmented_Samples  => False);
   --  <dref internal="true"></dref>

   --  ----------------------------------------------------------
   --                  TYPESUPPORT (eXtension QoS)
   --  ----------------------------------------------------------

   TYPESUPPORT_QOS_POLICY_NAME                                    : constant DDS.String := To_DDS_String ("TypeSupport");
   --  <defgroup>TypeSupportQosGroupDocs</defgroup>
   --  <dref>TYPESUPPORT_QOS_POLICY_NAME</dref>

   type CdrPaddingKind is
     (ZERO_CDR_PADDING,
      NOT_SET_CDR_PADDING,
      AUTO_CDR_PADDING);
   pragma Convention (C, CdrPaddingKind);
   --  <dref>CdrPaddingKind</dref>
   --  <dref name="ZERO_CDR_PADDING">CdrPaddingKind_ZERO_CDR_PADDING</dref>
   --  <dref name="NOT_SET_CDR_PADDING">CdrPaddingKind_NOT_SET_CDR_PADDING</dref>
   --  <dref name="AUTO_CDR_PADDING">CdrPaddingKind_AUTO_CDR_PADDING</dref>


   type TypeSupportQosPolicy is record
      Plugin_Data      : aliased DDS_Support.Void_Ptr;
      Cdr_Padding_Kind : aliased CdrPaddingKind;
   end record with Convention => C;
   --  <dref>TypeSupportQosPolicy</dref>
   --  <dref name="Plugin_Data">TypeSupportQosPolicy_plugin_data</dref>
   --  <dref name="cdr_padding_kind">TypeSupportQosPolicy_cdr_padding_kind</dref>

   TYPESUPPORT_QOS_POLICY_DEFAULT : constant TypeSupportQosPolicy :=
                                      (Plugin_Data      => System.Null_Address,
                                       Cdr_Padding_Kind => AUTO_CDR_PADDING);
   --  <dref internal="true"></dref>

   --  ----------------------------------------------------------
   --                  ASYNCHRONOUS_PUBLISHER (eXtension QoS)
   --  ----------------------------------------------------------

   type ThreadBlockingKind is new Unsigned_Long;
   --  <defgroup>AsynchronousPublisherQosGroupDocs</defgroup>
   --  <dref internal="true">ThreadBlockingKind</dref>

   SEMAPHORE_BLOCKING_KIND       : constant ThreadBlockingKind := 0;
   --  <dref internal="true">ThreadBlockingKind_SEMAPHORE_BLOCKING_KIND</dref>

   SPIN_BLOCKING_KIND            : constant ThreadBlockingKind := 1;
   --  <dref internal="true">ThreadBlockingKind_SPIN_BLOCKING_KIND</dref>

   ASYNCHRONOUSPUBLISHER_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("AsynchronousPublisher");
   --  <dref>ASYNCHRONOUSPUBLISHER_QOS_POLICY_NAME</dref>

   type AsynchronousPublisherQosPolicy is record
      Disable_Asynchronous_Write       : aliased DDS.Boolean := False;
      Thread                           : aliased ThreadSettings_T;
      Disable_Asynchronous_Batch       : aliased Boolean  := False;
      Asynchronous_Batch_Thread        : aliased ThreadSettings_T;
      Asynchronous_Batch_Blocking_Kind : aliased ThreadBlockingKind := 0;
      Disable_Topic_Query_Publication  : aliased DDS.Boolean := False;
      Topic_Query_Publication_Thread   : aliased ThreadSettings_T;
   end record with Convention => C;
   --  <dref>AsynchronousPublisherQosPolicy</dref>
   --  <dref name="Disable_Asynchronous_Write">AsynchronousPublisherQosPolicy_disable_asynchronous_write</dref>
   --  <dref name="Thread">AsynchronousPublisherQosPolicy_thread</dref>
   --  <dref name="disable_asynchronous_batch">AsynchronousPublisherQosPolicy_disable_asynchronous_batch</dref>
   --  <dref internal="true" name="asynchronous_batch_blocking_kind">AsynchronousPublisherQosPolicy_asynchronous_batch_blocking_kind</dref>
   --  <dref internal="true" name="Disable_Topic_Query_Publication">AsynchronousPublisherQosPolicy_disable_topic_query_publication</dref>
   --  <dref internal="true" name="Topic_Query_Publication_Thread">AsynchronousPublisherQosPolicy_topic_query_publication_thread</dref>


   --     ASYNCHRONOUS_PUBLISHER_QOS_POLICY_DEFAULT : constant AsynchronousPublisherQosPolicy :=
   --                                                   (Disable_Asynchronous_Write       => FALSE,
   --                                                    Thread                           => THREAD_SETTINGS_DEFAULT,
   --                                                    disable_asynchronous_batch       => False,
   --                                                    asynchronous_batch_thread        => THREAD_SETTINGS_DEFAULT,
   --                                                    asynchronous_batch_blocking_kind => 0);


   type DiscoveryConfigQosPolicy is record
      Participant_Liveliness_Lease_Duration                  : aliased Duration_T := (100, 0);
      Participant_Liveliness_Assert_Period                   : aliased Duration_T := (30, 0);
      Remote_Participant_Purge_Kind                          : aliased RemoteParticipantPurgeKind := LIVELINESS_BASED_REMOTE_PARTICIPANT_PURGE;
      Max_Liveliness_Loss_Detection_Period                   : aliased Duration_T := (60, 0);
      Initial_Participant_Announcements                      : aliased Long := 5;
      Min_Initial_Participant_Announcement_Period            : aliased Duration_T := (1, 0);
      Max_Initial_Participant_Announcement_Period            : aliased Duration_T := (1, 0);
      Participant_Reader_Resource_Limits                     : aliased BuiltinTopicReaderResourceLimits_T := BUILTIN_TOPIC_READER_RESOURCE_LIMITS_DEFAULT;
      Publication_Reader                                     : aliased RtpsReliableReaderProtocol_T := RTPS_RELIABLE_READER_PROTOCOL_DISCOVERY_CONFIG_DEFAULT;
      Publication_Reader_Resource_Limits                     : aliased BuiltinTopicReaderResourceLimits_T;
      Subscription_Reader                                    : aliased RtpsReliableReaderProtocol_T;
      Subscription_Reader_Resource_Limits                    : aliased BuiltinTopicReaderResourceLimits_T;
      Publication_Writer                                     : aliased RtpsReliableWriterProtocol_T;
      Publication_Writer_Data_Lifecycle                      : aliased WriterDataLifecycleQosPolicy;
      Subscription_Writer                                    : aliased RtpsReliableWriterProtocol_T;
      Subscription_Writer_Data_Lifecycle                     : aliased WriterDataLifecycleQosPolicy;
      Endpoint_Plugin_Redundancy_Level                       : aliased Long;
      Builtin_Discovery_Plugins                              : aliased DiscoveryConfigBuiltinPluginKindMask;
      Participant_Message_Reader_Reliability_Kind            : aliased ReliabilityQosPolicyKind;
      Participant_Message_Reader                             : aliased RtpsReliableReaderProtocol_T;
      Participant_Message_Writer                             : aliased RtpsReliableWriterProtocol_T;
      Publication_Writer_Publish_Mode                        : aliased PublishModeQosPolicy;
      Subscription_Writer_Publish_Mode                       : aliased PublishModeQosPolicy;
      Asynchronous_Publisher                                 : aliased AsynchronousPublisherQosPolicy;
      Default_Domain_Announcement_Period                     : aliased Duration_T;
      Ignore_Default_Domain_Announcements                    : aliased Boolean;
      Service_Request_Writer                                 : aliased RtpsReliableWriterProtocol_T;
      Service_Request_Writer_Data_Lifecycle                  : aliased WriterDataLifecycleQosPolicy;
      Service_Request_Writer_Publish_Mode                    : aliased PublishModeQosPolicy;
      Service_Request_Reader                                 : aliased RtpsReliableReaderProtocol_T;
      Locator_Reachability_Assert_Period                     : aliased Duration_T;
      Locator_Reachability_Lease_Duration                    : aliased Duration_T;
      Locator_Reachability_Change_Detection_Period           : aliased Duration_T;
      Secure_Volatile_Writer_Publish_Mode                    : aliased PublishModeQosPolicy;
      Endpoint_Type_Object_LB_Serialization_Threshold        : aliased Long;
      --- <<Private data>>
      Sedp_Rely_On_Spdp_Only                                 : aliased Boolean;
      Publication_Writer_Latency_Budget                      : aliased LatencyBudgetQosPolicy;
      Publication_Writer_Push_On_Write                       : aliased Boolean;
      Subscription_Writer_Latency_Budget                     : aliased LatencyBudgetQosPolicy;
      Subscription_Writer_Push_On_Write                      : aliased Boolean;
      Participant_State_Writer                               : aliased RtpsReliableWriterProtocol_T;
      Participant_State_Writer_Latency_Budget                : aliased LatencyBudgetQosPolicy;
      Participant_State_Writer_Push_On_Write                 : aliased Boolean;
      Participant_State_Writer_Publish_Mode                  : aliased PublishModeQosPolicy;
      Participant_Proxy_Reader                               : aliased RtpsReliableReaderProtocol_T;
      Participant_Proxy_Reader_Fragmentation_Resource_Limits : aliased DiscoveryBuiltinReaderFragmentationResourceLimits_T;
      Plugin_Promiscuity_Kind                                : aliased DiscoveryPluginPromiscuityKind;
   end record with Convention => C;
   --  <dref>DiscoveryConfigQosPolicy</dref>
   --  <dref name="participant_liveliness_lease_duration">DiscoveryConfigQosPolicy_participant_liveliness_lease_duration</dref>
   --  <dref name="participant_liveliness_assert_period">DiscoveryConfigQosPolicy_participant_liveliness_assert_period</dref>
   --  <dref name="remote_participant_purge_kind">DiscoveryConfigQosPolicy_remote_participant_purge_kind</dref>
   --  <dref name="max_liveliness_loss_detection_period">DiscoveryConfigQosPolicy_max_liveliness_loss_detection_period</dref>
   --  <dref name="initial_participant_announcements">DiscoveryConfigQosPolicy_initial_participant_announcements</dref>
   --  <dref name="min_initial_participant_announcement_period">DiscoveryConfigQosPolicy_min_initial_participant_announcement_period</dref>
   --  <dref name="max_initial_participant_announcement_period">DiscoveryConfigQosPolicy_max_initial_participant_announcement_period</dref>
   --  <dref name="participant_reader_resource_limits">DiscoveryConfigQosPolicy_participant_reader_resource_limits</dref>
   --  <dref name="publication_reader">DiscoveryConfigQosPolicy_publication_reader</dref>
   --  <dref name="publication_reader_resource_limits">DiscoveryConfigQosPolicy_publication_reader_resource_limits</dref>
   --  <dref name="subscription_reader">DiscoveryConfigQosPolicy_subscription_reader</dref>
   --  <dref name="subscription_reader_resource_limits">DiscoveryConfigQosPolicy_subscription_reader_resource_limits</dref>
   --  <dref name="publication_writer">DiscoveryConfigQosPolicy_publication_writer</dref>
   --  <dref name="publication_writer_data_lifecycle">DiscoveryConfigQosPolicy_publication_writer_data_lifecycle</dref>
   --  <dref name="subscription_writer">DiscoveryConfigQosPolicy_subscription_writer</dref>
   --  <dref name="subscription_writer_data_lifecycle">DiscoveryConfigQosPolicy_subscription_writer_data_lifecycle</dref>
   --  <dref internal="true" name="endpoint_plugin_redundancy_level">DiscoveryConfigQosPolicy_endpoint_plugin_redundancy_level</dref>
   --  <dref name="Builtin_Discovery_Plugins">DiscoveryConfigQosPolicy_builtin_discovery_plugins</dref>
   --  <dref name="Participant_Message_Reader_Reliability_Kind">DiscoveryConfigQosPolicy_participant_message_reader_reliability_kind</dref>
   --  <dref name="participant_message_reader">DiscoveryConfigQosPolicy_participant_message_reader</dref>
   --  <dref name="participant_message_writer">DiscoveryConfigQosPolicy_participant_message_writer</dref>
   --  <dref name="Publication_Writer_Publish_Mode">DiscoveryConfigQosPolicy_publication_writer_publish_mode</dref>
   --  <dref name="Subscription_Writer_Publish_Mode">DiscoveryConfigQosPolicy_subscription_writer_publish_mode</dref>
   --  <dref name="Asynchronous_Publisher">DiscoveryConfigQosPolicy_asynchronous_publisher</dref>
   --  <dref name="default_domain_announcement_period">DiscoveryConfigQosPolicy_default_domain_announcement_period</dref>
   --  <dref name="ignore_default_domain_announcements">DiscoveryConfigQosPolicy_ignore_default_domain_announcements</dref>
   --  <dref internal="true" name="Service_Request_Writer_Data_Lifecycle">DiscoveryConfigQosPolicy_Service_Request_Writer_Data_Lifecycle</dref>
   --  <dref internal="true" name="Service_Request_Writer_Publish_Mode">DiscoveryConfigQosPolicy_Service_Request_Writer_Publish_Mode</dref>
   --  <dref internal="true" name="Service_Request_Reader">DiscoveryConfigQosPolicy_Service_Request_Reader</dref>
   --  <dref internal="true" name="Locator_Reachability_Assert_Period">DiscoveryConfigQosPolicy_Locator_Reachability_Assert_Period </dref>
   --  <dref internal="true" name="Locator_Reachability_Lease_Duration">DiscoveryConfigQosPolicy_Locator_Reachability_Lease_Duration</dref>
   --  <dref internal="true" name="Locator_Reachability_Change_Detection_Period">DiscoveryConfigQosPolicy_Locator_Reachability_Change_Detection_Period</dref>
   --  <dref internal="true" name="Secure_Volatile_Writer_Publish_Mode">DiscoveryConfigQosPolicy_secure_volatile_writer_publish_mode</dref>
   --  <dref internal="true" name="Endpoint_Type_Object_LB_Serialization_Threshold">DiscoveryConfigQosPolicy_Endpoint_Type_Object_LB_Serialization_Threshold</dref>
   --  <dref internal="true" name="sedp_rely_on_spdp_only">DiscoveryConfigQosPolicy_publication_sedp_rely_on_spdp_only</dref>
   --  <dref internal="true" name="publication_writer_latency_budget">DiscoveryConfigQosPolicy_publication_writer_latency_budget</dref>
   --  <dref internal="true" name="publication_writer_push_on_write">DiscoveryConfigQosPolicy_publication_writer_push_on_write</dref>
   --  <dref internal="true" name="subscription_writer_latency_budget">DiscoveryConfigQosPolicy_subscription_writer_latency_budget</dref>
   --  <dref internal="true" name="subscription_writer_push_on_write">DiscoveryConfigQosPolicy_subscription_writer_push_on_write</dref>
   --  <dref internal="true" name="participant_state_writer">DiscoveryConfigQosPolicy_participant_state_writer</dref>
   --  <dref internal="true" name="participant_state_writer_latency_budget">DiscoveryConfigQosPolicy_participant_state_writer_latency_budget</dref>
   --  <dref internal="true" name="participant_state_writer_push_on_write">DiscoveryConfigQosPolicy_participant_state_writer_push_on_write</dref>
   --  <dref internal="true" name="participant_state_writer_publish_mode">DiscoveryConfigQosPolicy_participant_state_writer_publish_mode</dref>
   --  <dref internal="true" name="participant_proxy_reader">DiscoveryConfigQosPolicy_participant_proxy_reader</dref>
   --  <dref internal="true" name="participant_proxy_reader_fragmentation_resource_limits">DiscoveryConfigQosPolicy_participant_proxy_reader_fragmentation_resource_limits</dref>
   --  <dref internal="true" name="plugin_promiscuity_kind">DiscoveryConfigQosPolicy_plugin_promiscuity_kind</dref>


   --   DISCOVERY_CONFIG_QOS_POLICY_DEFAULT : constant DiscoveryConfigQosPolicy :=
   --                                           (participant_liveliness_lease_duration                  => (100, 0),
   --                                            participant_liveliness_assert_period                   => (30, 0),
   --                                            remote_participant_purge_kind                          => LIVELINESS_BASED_REMOTE_PARTICIPANT_PURGE,
   --                                            max_liveliness_loss_detection_period                   => (60, 0),
   --                                            initial_participant_announcements                      => 5,
   --                                            min_initial_participant_announcement_period            => (1, 0),
   --                                            max_initial_participant_announcement_period            => (1, 0),
   --                                            participant_reader_resource_limits                     =>
   --                                              BUILTIN_TOPIC_READER_RESOURCE_LIMITS_DEFAULT,
   --                                            publication_reader                                     =>
   --                                              RTPS_RELIABLE_READER_PROTOCOL_DISCOVERY_CONFIG_DEFAULT,
   --                                            publication_reader_resource_limits                     =>
   --                                              BUILTIN_TOPIC_READER_RESOURCE_LIMITS_DEFAULT,
   --                                            subscription_reader                                    =>
   --                                              RTPS_RELIABLE_READER_PROTOCOL_DISCOVERY_CONFIG_DEFAULT,
   --                                            subscription_reader_resource_limits                    =>
   --                                              BUILTIN_TOPIC_READER_RESOURCE_LIMITS_DEFAULT,
   --                                            publication_writer                                     =>
   --                                              RTPS_RELIABLE_WRITER_PROTOCOL_DISCOVERY_CONFIG_DEFAULT,
   --                                            publication_writer_data_lifecycle                      =>
   --                                              WRITER_DATA_LIFECYCLE_QOS_POLICY_DEFAULT,
   --                                            subscription_writer                                    =>
   --                                              RTPS_RELIABLE_WRITER_PROTOCOL_DISCOVERY_CONFIG_DEFAULT,
   --                                            subscription_writer_data_lifecycle                     =>
   --                                              WRITER_DATA_LIFECYCLE_QOS_POLICY_DEFAULT,
   --                                            endpoint_plugin_redundancy_level                       => -1,
   --                                            Builtin_Discovery_Plugins                              =>
   --                                              DISCOVERYCONFIG_BUILTIN_PLUGIN_MASK_DEFAULT,
   --                                            participant_message_reader                             =>
   --                                              RTPS_PARTICIPANT_MESSAGE_READER_DISCOVERY_CONFIG_DEFAULT,
   --                                            participant_message_writer                             =>
   --                                              RTPS_PARTICIPANT_MESSAGE_WRITER_DISCOVERY_CONFIG_DEFAULT,
   --                                            Publication_Writer_Publish_mode                        =>
   --                                               (Kind                      => PUBLISH_MODE_QOS_POLICY_DEFAULT.Kind,
   --                                                Flow_Controller_Name      => (data => PUBLISH_MODE_QOS_POLICY_DEFAULT.Flow_Controller_Name.data),
   --                                                Priority                  => PUBLISH_MODE_QOS_POLICY_DEFAULT.Priority),
   --                                            Subscription_Writer_Publish_mode                       =>
   --                                               (Kind                      => PUBLISH_MODE_QOS_POLICY_DEFAULT.Kind,
   --                                                Flow_Controller_Name      => (data => PUBLISH_MODE_QOS_POLICY_DEFAULT.Flow_Controller_Name.data),
   --                                                Priority                  => PUBLISH_MODE_QOS_POLICY_DEFAULT.Priority),
   --                                            Asynchronous_Publisher                                 =>
   --                                                (Disable_Asynchronous_Write => FALSE,
   --                                                 Thread                     => (
   --                                 (Mask         => THREAD_SETTINGS_OPTION_DEFAULT,
   --                                  Priority     => Long (RTIDDS.Osapi_Thread.PRIORITY_DEFAULT),
   --                                  Stack_Size   => Long (RTIDDS.Osapi_Thread.STACK_SIZE_DEFAULT),
   --                                  Cpu_List     => DDS.Long_Seq.DEFAULT_SEQUENCE,
   --                                  Cpu_Rotation => THREAD_SETTINGS_CPU_ROTATION_DEFAULT)),
   --                                                 disable_asynchronous_batch => False,
   --                                                 asynchronous_batch_thread  => (
   --                                 (Mask         => THREAD_SETTINGS_OPTION_DEFAULT,
   --                                  Priority     => Long (RTIDDS.Osapi_Thread.PRIORITY_DEFAULT),
   --                                  Stack_Size   => Long (RTIDDS.Osapi_Thread.STACK_SIZE_DEFAULT),
   --                                  Cpu_List     => DDS.Long_Seq.DEFAULT_SEQUENCE,
   --                                  Cpu_Rotation => THREAD_SETTINGS_CPU_ROTATION_DEFAULT)),
   --                                                 asynchronous_batch_blocking_kind => 0),
   --                                            --   /***************** HIDDEN FROM USER ********************************/
   --                                            sedp_rely_on_spdp_only                                 => False,
   --                                            publication_writer_latency_budget                      =>
   --                                              LATENCY_BUDGET_QOS_POLICY_DEFAULT,
   --                                            publication_writer_push_on_write                       => True,
   --                                            subscription_writer_latency_budget                     =>
   --                                              LATENCY_BUDGET_QOS_POLICY_DEFAULT,
   --                                            subscription_writer_push_on_write                      => True,
   --                                            participant_state_writer
   --                                                                                                   => RTPS_RELIABLE_WRITER_PROTOCOL_DISCOVERY_CONFIG_DEFAULT,
   --                                            participant_state_writer_latency_budget                =>
   --                                              LATENCY_BUDGET_QOS_POLICY_DEFAULT,
   --                                            participant_state_writer_push_on_write                 => True,
   --                                            participant_state_writer_publish_mode                  =>
   --                                               (Kind                      => PUBLISH_MODE_QOS_POLICY_DEFAULT.Kind,
   --                                                Flow_Controller_Name      => (data => PUBLISH_MODE_QOS_POLICY_DEFAULT.Flow_Controller_Name.data),
   --                                                Priority                  => PUBLISH_MODE_QOS_POLICY_DEFAULT.Priority),
   --                                            participant_proxy_reader                               =>
   --                                              RTPS_RELIABLE_READER_PROTOCOL_DISCOVERY_CONFIG_DEFAULT,
   --                                            participant_proxy_reader_fragmentation_resource_limits =>
   --                                              DISCOVERY_BUILTIN_READER_FRAGMENTATION_RESOURCE_LIMITS_DEFAULT,
   --                                            plugin_promiscuity_kind                                =>
   --                                              DISCOVERYPLUGIN_DISCOVER_MATCHING_REMOTE_ENTITIES_PROMISCUITY);
   --  <dref internal="true"></dref>

   --  ----------------------------------------------------------
   --                  USEROBJECT (eXtension QoS)
   --  ----------------------------------------------------------

   USEROBJECT_QOS_POLICY_NAME    : constant DDS.String := To_DDS_String ("UserObject");
   --  <defgroup internal="true">UserObjectQosGroupDocs</defgroup>
   --  <dref internal="true">USEROBJECT_QOS_POLICY_NAME</dref>

   type UserObjectQosPolicy is record
      Participant_User_Object            : aliased UserObjectSettings_T;
      Topic_User_Object                  : aliased UserObjectSettings_T;
      Content_Filtered_Topic_User_Object : aliased UserObjectSettings_T;
      Publisher_User_Object              : aliased UserObjectSettings_T;
      Data_Writer_User_Object            : aliased UserObjectSettings_T;
      Subscriber_User_Object             : aliased UserObjectSettings_T;
      Data_Reader_User_Object            : aliased UserObjectSettings_T;
      Read_Condition_User_Object         : aliased UserObjectSettings_T;
      Query_Condition_User_Object        : aliased UserObjectSettings_T;
      Index_Condition_User_Object        : aliased UserObjectSettings_T;
      Flow_Controller_User_Object        : aliased UserObjectSettings_T;
   end record with Convention => C;
   --  <dref internal="true">UserObjectQosPolicy</dref>
   --  <dref internal="true" name="Participant_User_Object">UserObjectQosPolicy_participant_user_object</dref>
   --  <dref internal="true" name="Topic_User_Object">UserObjectQosPolicy_topic_user_object</dref>
   --  <dref internal="true" name="Content_Filtered_Topic_User_Object">UserObjectQosPolic_content_filtered_topic_user_object</dref>
   --  <dref internal="true" name="Publisher_User_Object">UserObjectQosPolicy_publisher_user_object</dref>
   --  <dref internal="true" name="Data_Writer_User_Object">UserObjectQosPolicy_data_writer_user_object</dref>
   --  <dref internal="true" name="Subscriber_User_Object">UserObjectQosPolicy_subscriber_user_object</dref>
   --  <dref internal="true" name="Data_Reader_User_Object">UserObjectQosPolicy_data_reader_user_object</dref>
   --  <dref internal="true" name="Read_Condition_User_Object">UserObjectQosPolicy_read_condition_user_object</dref>
   --  <dref internal="true" name="Query_Condition_User_Object">UserObjectQosPolicy_query_condition_user_object</dref>
   --  <dref internal="true" name="Index_Condition_User_Object">UserObjectQosPolicy_index_condition_user_object</dref>
   --  <dref internal="true" name="Flow_Controller_User_Object">UserObjectQosPolicy_flow_controller_user_object</dref>

   USER_OBJECT_QOS_POLICY_DEFAULT : constant UserObjectQosPolicy :=
                                      (others => (0, 0));
   --  <dref internal="true"></dref>

   --  ----------------------------------------------------------
   --                  EXCLUSIVEAREA (eXtension QoS)
   --  ----------------------------------------------------------

   EXCLUSIVEAREA_QOS_POLICY_NAME  : constant DDS.String := To_DDS_String ("ExclusiveArea");
   --  <defgroup>ExclusiveAreaQosGroupDocs</defgroup>
   --  <dref>EXCLUSIVEAREA_QOS_POLICY_NAME</dref>

   type ExclusiveAreaQosPolicy is record
      Use_Shared_Exclusive_Area : aliased DDS.Boolean;
      Level                     : aliased DDS.Long;
   end record with Convention => C;
   --  <dref>ExclusiveAreaQosPolicy</dref>
   --  <dref name="User_Shared_Exclusive_Area">ExclusiveAreaQosPolicy_use_shared_exclusive_area</dref>
   --  <dref internal="true" name="Level">ExclusiveAreaQosPolicy_level</dref>

   EXCLUSIVE_AREA_AUTO_LEVEL     : constant DDS.Long := -1;
   --  <dref internal="true">ExclusiveAreaQosPolicy_AUTO_LEVEL</dref>

   EXCLUSIVE_AREA_QOS_POLICY_DEFAULT : constant ExclusiveAreaQosPolicy :=
                                         (Use_Shared_Exclusive_Area => False,
                                          Level                     => EXCLUSIVE_AREA_AUTO_LEVEL);
   --  <dref internal="true"></dref>

   --  ----------------------------------------------------------
   --                  DATAWRITERTRANSFERMODE
   --  ----------------------------------------------------------

   DATAWRITERTRANSFERMODE_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("DataWriterTransferMode");
   --  <defgroup>DataWriterTransferModeQosGroupDocs</defgroup>
   --  <dref>DATAWRITERTRANSFERMODE_QOS_POLICY_NAME</dref>

   type DataWriterShmemRefTransferModeSettings is record
      Enable_Data_Consistency_Check : aliased DDS.Boolean;
   end record with Convention => C;
   --  <dref>DataWriterShmemRefTransferModeSettings</dref>
   --  <dref name="Enable_Data_Consistency_Check">DataWriterShmemRefTransferModeSettings_enable_data_consistency_check</dref>

   DataWriterShmemRefTransferModeSettings_INITIALIZER : constant DataWriterShmemRefTransferModeSettings :=
      (Enable_Data_Consistency_Check => True);

   type DataWriterShmemRefTransferModeSettings_Access is access all DataWriterShmemRefTransferModeSettings;

   function DataWriterShmemRefTransferModeSettings_Equals
      (Self  : in DataWriterShmemRefTransferModeSettings_Access;
       Other : in DataWriterShmemRefTransferModeSettings_Access)
      return DDS.Boolean;
   --  <dref internal="true">DataWriterShmemRefTransferModeSettings_Equals</dref>

   pragma Warnings (Off, DataWriterShmemRefTransferModeSettings_Equals);
   pragma Import (C, DataWriterShmemRefTransferModeSettings_Equals, "DDS_DataWriterShmemRefTransferModeSettings_equals");

   type DataWriterTransferModeQosPolicy is record
      Shmem_Ref_Settings : aliased DataWriterShmemRefTransferModeSettings;
   end record with Convention => C;
   --  <dref>DataWriterTransferModeQosPolicy</dref>
   --  <dref name="Shmem_Ref_Settings">DataWriterTransferModeQosPolicy_shmem_ref_settings</dref>

   DataWriterTransferModeQosPolicy_INITIALIZER : constant DataWriterTransferModeQosPolicy :=
      (Shmem_Ref_Settings => DataWriterShmemRefTransferModeSettings_INITIALIZER);

   type DataWriterTransferModeQosPolicy_Access is access all DataWriterTransferModeQosPolicy;

   function DataWriterTransferModeQosPolicy_equals
      (Self  : in DataWriterTransferModeQosPolicy_Access;
       Other : in DataWriterTransferModeQosPolicy_Access)
      return DDS.Boolean;
   --  <dref internal="true">DataWriterTransferModeQosPolicy_equals</dref>

   pragma Warnings (Off, DataWriterTransferModeQosPolicy_equals);
   pragma Import (C, DataWriterTransferModeQosPolicy_equals, "DDS_DataWriterTransferModeQosPolicy_equals");

   --  ----------------------------------------------------------
   --                  TOPICQUERYDISPATCH (eXtension QoS)
   --  ----------------------------------------------------------

   TOPIC_QUERY_DISPATCH_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("TopicQueryDispatch");
   --  <defgroup>TopicQueryDispatchQosGroupDocs</defgroup>
   --  <dref>TOPICQUERYDISPATCH_QOS_POLICY_NAME</dref>

   type TopicQueryDispatchQosPolicy is record
      Enable                      : aliased DDS.Boolean;
      Publication_Period          : aliased Duration_T;
      Samples_Per_Period          : aliased DDS.Long;
   end record with Convention => C;
   --  <dref>TopicQueryDispatchQosPolicy</dref>
   --  <dref name="Publication_Period">TopicQueryDispatchQosPolicy_publication_period</dref>
   --  <dref name="Samples_Per_Period">TopicQueryDispatchQosPolicy_samples_per_period</dref>

   TOPIC_QUERY_DISPATCH_QOS_POLICY_DEFAULT : constant TopicQueryDispatchQosPolicy :=
                                               (
                                                Enable                      => False,
                                                Publication_Period          => (16#0000_0001#, 16#0000_0000#),
                                                Samples_Per_Period          => -1
                                               );
   --  <dref internal="true"></dref>

   --  ----------------------------------------------------------
   --                  BATCH (eXtension QoS)
   --  ----------------------------------------------------------

   BATCH_QOS_POLICY_NAME         : constant DDS.String := To_DDS_String ("Batch");
   --  <defgroup>BatchQosGroupDocs</defgroup>
   --  <dref>BATCH_QOS_POLICY_NAME</dref>

   type BatchQosPolicy is record
      Enable                      : aliased DDS.Boolean;
      Max_Data_Bytes              : aliased DDS.Long;
      Max_Meta_Data_Bytes         : aliased DDS.Long;
      Max_Samples                 : aliased DDS.Long;
      Max_Flush_Delay             : aliased Duration_T;
      Source_Timestamp_Resolution : aliased Duration_T;
      Thread_Safe_Write           : aliased DDS.Boolean;
   end record with Convention => C;
   --  <dref>BatchQosPolicy</dref>
   --  <dref name="enable">BatchQosPolicy_enable</dref>
   --  <dref name="max_data_bytes">BatchQosPolicy_max_data_bytes</dref>
   --  <dref internal="true" name="max_meta_data_bytes">BatchQosPolicy_max_meta_data_bytes</dref>
   --  <dref name="max_samples">BatchQosPolicy_max_samples</dref>
   --  <dref name="max_flush_delay">BatchQosPolicy_max_flush_delay</dref>
   --  <dref name="source_timestamp_resolution">BatchQosPolicy_source_timestamp_resolution</dref>
   --  <dref name="thread_safe_write">BatchQosPolicy_thread_safe_write</dref>

   BATCH_QOS_POLICY_DEFAULT      : constant BatchQosPolicy :=
                                     (
                                      Enable                      => False,
                                      Max_Data_Bytes              => 1024,
                                      Max_Meta_Data_Bytes         => LENGTH_UNLIMITED,
                                      Max_Samples                 => LENGTH_UNLIMITED,
                                      Max_Flush_Delay             => (16#7FFF_FFFF#, 16#7FFF_FFFF#),
                                      Source_Timestamp_Resolution => (16#7FFF_FFFF#, 16#7FFF_FFFF#),
                                      Thread_Safe_Write           => True
                                     );
   --  <dref internal="true"></dref>

   --  ----------------------------------------------------------
   --       TYPE_CONSISTENCY_ENFORCEMENT (XTYPES)
   --  ----------------------------------------------------------

   TYPE_CONSISTENCY_ENFORCEMENT_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("TypeConsistencyEnforcement");
   --  <defgroup>TypeConsistencyEnforcementQosGroupDocs</defgroup>
   --  <dref>TYPE_CONSISTENCY_ENFORCEMENT_QOS_POLICY_NAME</dref>

   type TypeConsistencyKind is new Unsigned_Long;
   --  <dref>TypeConsistencyKind</dref>

   DISALLOW_TYPE_COERCION        : constant TypeConsistencyKind := 0;
   --  <dref>TypeConsistencyKind_DISALLOW_TYPE_COERCION</dref>

   ALLOW_TYPE_COERCION           : constant TypeConsistencyKind := 1;
   --  <dref>TypeConsistencyKind_ALLOW_TYPE_COERCION</dref>

   AUTO_TYPE_COERCION            : constant TypeConsistencyKind := 2;
   --  <dref>TypeConsistencyKind_AUTO_TYPE_COERCION</dref>

   type TypeConsistencyEnforcementQosPolicy is record
      Kind                      : aliased TypeConsistencyKind;
      Ignore_Sequence_Bounds    : aliased Boolean;
      Ignore_String_Bounds      : aliased Boolean;
      Ignore_Member_Names       : aliased Boolean;
      Prevent_Type_Widening     : aliased Boolean;
      Force_Type_Validation     : aliased Boolean;
      Ignore_Enum_Literal_Names : aliased Boolean;
   end record with Convention => C;
   --  <dref>TypeConsistencyEnforcementQosPolicy</dref>
   --  <dref name="kind">TypeConsistencyEnforcementQosPolicy_kind</dref>
   --  <dref name="Ignore_Sequence_Bounds">TypeConsistencyEnforcementQosPolicy_ignore_sequence_bounds</dref>
   --  <dref name="Ignore_String_Bounds">TypeConsistencyEnforcementQosPolicy_ignore_string_bounds</dref>
   --  <dref name="Ignore_Member_Names">TypeConsistencyEnforcementQosPolicy_ignore_member_names</dref>
   --  <dref name="Prevent_Type_Widening">TypeConsistencyEnforcementQosPolicy_prevent_type_widening</dref>
   --  <dref name="Force_Type_Validation">TypeConsistencyEnforcementQosPolicy_force_type_validation</dref>
   --  <dref name="Ignore_Enum_Literal_Names">TypeConsistencyEnforcementQosPolicy_ignore_enum_literal_names</dref>

   TYPE_CONSISTENCY_ENFORCEMENT_QOS_POLICY_DEFAULT : constant TypeConsistencyEnforcementQosPolicy :=
                                                       (
                                                        Kind => ALLOW_TYPE_COERCION,
                                                        Ignore_Sequence_Bounds => False,
                                                        Ignore_String_Bounds => False,
                                                        Ignore_Member_Names => False,
                                                        Prevent_Type_Widening => False,
                                                        Force_Type_Validation => False,
                                                        Ignore_Enum_Literal_Names => False
                                                       );
   --  <dref internal="true"></dref>

   --  ----------------------------------------------------------
   --                  LOCATORFILTER (eXtension QoS)
   --  ----------------------------------------------------------

   type LocatorFilter_T is record
      Locators          : aliased Locator_Seq.Sequence;
      Filter_Expression : DDS.String;
   end record with Convention => C;
   --  <defgroup>LocatorFilterQosGroupDocs</defgroup>
   --  <dref>LocatorFilter_t</dref>
   --  <dref name="locators">LocatorFilter_t_locators</dref>
   --  <dref name="filter_expression">LocatorFilter_t_filter_expression</dref>


   type LocatorFilter_T_Access is access all LocatorFilter_T;
   type LocatorFilter_T_Array is array
     (Natural range <>) of aliased LocatorFilter_T;
   procedure Initialize (Self : in out LocatorFilter_T);
   procedure Finalize (Self : in out LocatorFilter_T);
   procedure Copy (Dst : in out LocatorFilter_T;
                   Src : in LocatorFilter_T);
   package LocatorFilter_Seq is new DDS_Support.Sequences_Generic
     (LocatorFilter_T,
      LocatorFilter_T_Access,
      DDS.Natural,
      1,
      LocatorFilter_T_Array);
   --  <dref>LocatorFilterSeq</dref>

   LOCATORFILTER_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("LocatorFilter");
   --  <dref>LOCATORFILTER_QOS_POLICY_NAME</dref>

   type LocatorFilterQosPolicy is record
      Locator_Filters : aliased DDS.LocatorFilter_Seq.Sequence;
      Filter_Name     : aliased DDS.String;
   end record with Convention => C;
   --  <dref>LocatorFilterQosPolicy</dref>
   --  <dref name="locator_filters">LocatorFilterQosPolicy_locator_filters</dref>
   --  <dref name="filer_name">LocatorFilterQosPolicy_filter_name</dref>

   --     LOCATOR_FILTER_QOS_POLICY_DEFAULT : constant LocatorFilterQosPolicy :=
   --       (
   --        locator_filters => DDS.LocatorFilter_Seq.DEFAULT_SEQUENCE,
   --        filter_name => DDS.NULL_STRING
   --       );

   --  ----------------------------------------------------------
   --                  MULTICHANNEL (eXtension QoS)
   --  ----------------------------------------------------------

   type ChannelSettings_T is record
      Multicast_Settings : aliased TransportMulticastSettings_Seq.Sequence;
      Filter_Expression  : DDS.String;
      Priority           : DDS.Long;
   end record with Convention => C;
   --  <defgroup>MultiChannelQosGroupDocs</defgroup>
   --  <dref>ChannelSettings_t</dref>
   --  <dref name="multicast_settings">ChannelSettings_t_multicast_settings</dref>
   --  <dref name="filter_expression">ChannelSettings_t_filter_expression</dref>
   --  <dref name="priority">ChannelSettings_t_priority</dref>

   type ChannelSettings_T_Access is access all ChannelSettings_T;
   type ChannelSettings_T_Array is array
     (Natural range <>) of aliased ChannelSettings_T;
   procedure Initialize (Self : in out ChannelSettings_T);
   procedure Finalize (Self : in out ChannelSettings_T);
   procedure Copy (Dst : in out ChannelSettings_T;
                   Src : in ChannelSettings_T);

   package ChannelSettings_Seq is new DDS_Support.Sequences_Generic
     (ChannelSettings_T,
      ChannelSettings_T_Access,
      DDS.Natural,
      1,
      ChannelSettings_T_Array);
   --  <dref>ChannelSettingsSeq</dref>

   MULTICHANNEL_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("MultiChannel");
   --  <dref>MULTICHANNEL_QOS_POLICY_NAME</dref>

   type MultiChannelQosPolicy is record
      Channels    : aliased DDS.ChannelSettings_Seq.Sequence;
      Filter_Name : aliased DDS.String;
   end record with Convention => C;
   --  <dref>MultiChannelQosPolicy</dref>
   --  <dref name="channels">MultiChannelQosPolicy_channels</dref>
   --  <dref name="filter_name">MultiChannelQosPolicy_filter_name</dref>


   --     MULTICHANNEL_QOS_POLICY_DEFAULT : constant MultiChannelQosPolicy :=
   --       (
   --        channels    => DDS.ChannelSettings_Seq.DEFAULT_SEQUENCE,
   --        filter_name => DDS.NULL_STRING
   --       );

   --  ----------------------------------------------------------
   --                  PROPERTY (eXtension QoS)
   --  ----------------------------------------------------------

   type Property_T is record
      Name      : aliased DDS.String;
      Value     : aliased DDS.String;
      Propagate : aliased DDS.Boolean;
   end record with Convention => C;
   --  <defgroup>PropertyQosGroupDocs</defgroup>
   --  <dref>Property_t</dref>
   --  <dref name="Name">Property_t_name</dref>
   --  <dref name="Value">Property_t_value</dref>
   --  <dref name="Propagate">Property_t_propagate</dref>

   type Property_T_Access is access all Property_T;

   type Property_T_Array is array (Natural range <>) of aliased Property_T;
   procedure Initialize (Self  : in out Property_T);
   procedure Finalize (Self  : in out Property_T);
   procedure Copy (Dst : in out Property_T; Src : in Property_T);

   package Property_T_Seq is new DDS_Support.Sequences_Generic
     (Property_T,
      Property_T_Access,
      DDS.Natural,
      1,
      Property_T_Array);
   --  <dref>PropertySeq</dref>

   type Property_T_Seq_Access is access all Property_T_Seq.Sequence;

   PROPERTY_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("Property");
   --  <dref>PROPERTY_QOS_POLICY_NAME</dref>

   type PropertyQosPolicy is record
      Value :  aliased Property_T_Seq.Sequence;
   end record with Convention => C;
   --  <dref>PropertyQosPolicy</dref>
   --  <dref name="Value">PropertyQosPolicy_value</dref>

   type PropertyQosPolicy_Access is access all PropertyQosPolicy;

   PROPERTY_QOS_POLICY_DEFAULT : constant PropertyQosPolicy :=
                                   (Value => Property_T_Seq.DEFAULT_SEQUENCE);



   function Contains (P    : PropertyQosPolicy;
                      Name : Standard.String) return Boolean;
   function Contains (P    : PropertyQosPolicy;
                      Name : DDS.String) return Boolean;

   function Length (P : PropertyQosPolicy) return Natural;

   procedure Append (P         : in out PropertyQosPolicy;
                     Name      : Standard.String;
                     Value     : Standard.String;
                     Propagate : Boolean := False);
   procedure Append (P         : in out PropertyQosPolicy;
                     Name      : DDS.String;
                     Value     : DDS.String;
                     Propagate : Boolean := False);

   procedure Delete (P : in out PropertyQosPolicy; Name : Standard.String);
   procedure Delete (P : in out PropertyQosPolicy; Name : DDS.String);

   function Get (P    : PropertyQosPolicy;
                 Name : Standard.String) return Standard.String;
   function Get (P    : PropertyQosPolicy;
                 Name : DDS.String) return DDS.String;

   procedure Add_Property (Policy    : in PropertyQosPolicy_Access;
                           Name      : in Standard.String;
                           Value     : in Standard.String;
                           Propagate : in DDS.Boolean);
   --  <dref>PropertyQosPolicyHelper_add_property</dref>

   procedure Remove_Property (Policy    : in PropertyQosPolicy_Access;
                              Name      : in Standard.String);
   --  <dref>PropertyQosPolicyHelper_remove_property</dref>

   --  ----------------------------------------------------------
   --                  WaitSetProperty_t
   --  ----------------------------------------------------------

   type WaitSetProperty_T is record
      Max_Event_Count : aliased Interfaces.C.long; -- Use the same definition of long as in C
      Max_Event_Delay : aliased Duration_T;
   end record with Convention => C;
   --  <dref>WaitSetProperty_t</dref>
   --  <dref name="max_event_count">WaitSetProperty_t_max_event_count</dref>
   --  <dref name="max_event_delay">WaitSetProperty_t_max_event_delay</dref>


   --  ----------------------------------------------------------
   --                  EndpointGroup_t
   --  ----------------------------------------------------------

   type EndpointGroup_T is record
      Role_Name    : aliased DDS.String;
      Quorum_Count : aliased Integer := 0;
   end record with Convention => C;
   --  <dref>EndpointGroup_t</dref>
   --  <dref name="role_name">EndpointGroup_t_role_name</dref>
   --  <dref name="quorum_count">EndpointGroup_t_quorum_count</dref>

   type EndpointGroup_T_Access is access all EndpointGroup_T;

   type EndpointGroup_T_Array is array (Natural range <>) of aliased EndpointGroup_T;

   pragma Convention (C, EndpointGroup_T_Array);

   procedure Initialize (Self  : in out EndpointGroup_T);
   procedure Finalize (Self  : in out EndpointGroup_T);
   procedure Copy (Dst : in out EndpointGroup_T; Src : in EndpointGroup_T);

   package EndpointGroup_T_Seq is new DDS_Support.Sequences_Generic
     (Element        => EndpointGroup_T,
      Element_Access => EndpointGroup_T_Access,
      Index_Type     => Natural,
      First_Element  => 1,
      Element_Array  => EndpointGroup_T_Array);
   --  <dref>EndpointGroupSeq</dref>

   type EndpointGroup_T_Seq_Access is access all EndpointGroup_T_Seq.Sequence;

   --  ----------------------------------------------------------
   --                  AvailabilityQosPolicy
   --  ----------------------------------------------------------

   type AvailabilityQosPolicy is record
      Enable_Required_Subscriptions          : aliased Boolean := False;
      Max_Data_Availability_Waiting_Time     : aliased Duration_T := (1, 0);
      Max_Endpoint_Availability_Waiting_Time : aliased Duration_T := (1, 0);
      Required_Matched_Endpoint_Groups       : aliased EndpointGroup_T_Seq.Sequence;
   end record with Convention => C;
   --  <defgroup>AvailabilityQosGroupDocs</defgroup>
   --  <dref >AvailabilityQosPolicy</dref>
   --  <dref name="enable_required_subscriptions">AvailabilityQosPolicy_enable_required_subscriptions</dref>
   --  <dref name="max_data_availability_waiting_time">AvailabilityQosPolicy_max_data_availability_waiting_time</dref>
   --  <dref name="max_endpoint_availability_waiting_time">AvailabilityQosPolicy_max_endpoint_availability_waiting_time</dref>
   --  <dref name="required_matched_endpoint_groups">AvailabilityQosPolicy_required_matched_endpoint_groups</dref>

   AVAILABILITY_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("Availability");
   --  <dref>AVAILABILITY_QOS_POLICY_NAME</dref>

   --  #define DDS_AVAILABILITY_QOS_POLICY_DEFAULT {
   --  { 0xffffffffL, 0UL }, /* max_data_availability_waiting_time */\
   --  { 0xffffffffL, 0UL }, /* max_endpoint_availability_waiting_time */ \
   --  EndpointGroup_T_Seq.Sequence.DEFAULT_SEQUENCE /* required_matched_endpoint_groups */ \

   --  package QosPolicyCount_Seq is new DDS_Support.Sequences_Generic
   --  (QosPolicyCount,
   --   QosPolicyCount_Access,
   --   DDS.Natural,
   --   1,
   --   QosPolicyCount_Array);
   --  <dref>QosPolicyCountSeq</dref>

   --  ----------------------------------------------------------
   --                  ContentFilterProperty_t
   --  ----------------------------------------------------------

   type ContentFilterProperty_T is record
      Content_Filter_Topic_Name : aliased DDS.String;
      Related_Topic_Name        : aliased DDS.String;
      Filter_Class_Name         : aliased DDS.String;
      Filter_Expression         : aliased DDS.String;
      Expression_Parameters     : aliased DDS.String_Seq.Sequence;
   end record with Convention => C;
   --  <dref>ContentFilterProperty_t</dref>
   --  <dref name="Content_Filter_Topic_Name">ContentFilterProperty_t_content_filter_topic_name</dref>
   --  <dref name="Related_Topic_Name">ContentFilterProperty_t_related_topic_name</dref>
   --  <dref name="Filter_Class_Name">ContentFilterProperty_t_filter_class_name</dref>
   --  <dref name="Filter_Expression">ContentFilterProperty_t_filter_expression</dref>
   --  <dref name="Expression_Parameters">ContentFilterProperty_t_expression_parameters</dref>

   --     CONTENT_FILTER_PROPERTY_DEFAULT : constant ContentFilterProperty_T :=
   --                                         (Content_Filter_Topic_Name => NULL_STRING,
   --                                          Related_Topic_Name        => NULL_STRING,
   --                                          Filter_Class_Name         => NULL_STRING,
   --                                          Filter_Expression         => NULL_STRING,
   --                                          Expression_Parameters     => String_Seq.DEFAULT_SEQUENCE);

   --  ----------------------------------------------------------
   --                  ENTITY_NAME (eXtension QoS)
   --  ----------------------------------------------------------

   ENTITYNAME_QOS_POLICY_NAME : constant DDS.String := To_DDS_String ("EntityName");
   --  <defgroup>EntityNameQosGroupDocs</defgroup>
   --  <dref>ENTITYNAME_QOS_POLICY_NAME</dref>

   type EntityNameQosPolicy is record
      Name      : aliased DDS.String;
      Role_Name : aliased DDS.String;
   end record with Convention => C;
   --  <dref>EntityNameQosPolicy</dref>
   --  <dref name="Name">EntityNameQosPolicy_name</dref>
   --  <dref name="Role_Name">EntityNameQosPolicy_role_name</dref>

   ENTITY_NAME_QOS_POLICY_DEFAULT : constant EntityNameQosPolicy :=
                                      (Name      => (Data => DDS.NULL_STRING.Data),
                                       Role_Name => (Data => DDS.NULL_STRING.Data));
   --  <dref internal="true"></dref>

   --  ----------------------------------------------------------
   --                  LoggingQosPolicy
   --  ----------------------------------------------------------

   LOGGING_QOS_POLICY_NAME        : constant DDS.String := To_DDS_String ("Logging");
   --  <defgroup>LoggingQosGroupDocs</defgroup>
   --  <dref>LOGGING_QOS_POLICY_NAME</dref>

   --  ----------------------------------------------------------
   --                  PROFILE (eXtension QoS)
   --  ----------------------------------------------------------

   PROFILE_QOS_POLICY_NAME  : constant DDS.String := To_DDS_String ("Profile");
   --  <defgroup>ProfileQosGroupDocs</defgroup>
   --  <dref>PROFILE_QOS_POLICY_NAME</dref>

   type ProfileQosPolicy is record
      String_Profile                  : aliased String_Seq.Sequence;
      Url_Profile                     : aliased String_Seq.Sequence;
      Ignore_User_Profile             : aliased Boolean := False;
      Ignore_Environment_Profile      : aliased Boolean := False;
      Ignore_Resource_Profile         : aliased Boolean := False;
      String_Profile_Dtd              : aliased String_Seq.Sequence;
      Ignore_Is_Default_Qos_Attribute :  aliased Boolean := False;
   end record with Convention => C;
   --  <dref>ProfileQosPolicy</dref>
   --  <dref name="String_Profile">ProfileQosPolicy_string_profile</dref>
   --  <dref name="Url_Profile">ProfileQosPolicy_url_profile</dref>
   --  <dref name="Ignore_User_Profile">ProfileQosPolicy_ignore_user_profile</dref>
   --  <dref name="Ignore_Envionrment_Profile">ProfileQosPolicy_ignore_environment_profile</dref>
   --  <dref name="Ignore_Resource_Profile">ProfileQosPolicy_ignore_resource_profile</dref>
   --  <dref internal="true" name="String_Profile_Dtd">ProfileQosPolicy_string_profile_dtd</dref>


   --  ----------------------------------------------------------
   --                  SAMPLEIDENTITY
   --  ----------------------------------------------------------

   type SampleIdentity_T is record
      Writer_Guid     : aliased Guid_T;
      Sequence_Number : aliased DDS.SequenceNumber_T;
   end record with
     Convention => C;
   --  <defgroup>WriteParamsGroupDocs</defgroup>
   --  <dref>SampleIdentity_t</dref>
   --  <dref name="Writer_Guid">SampleIdentity_t_writer_guid</dref>
   --  <dref name="Sequence_Number">SampleIdentity_t_sequence_number</dref>

   AUTO_SAMPLE_IDENTITY           : constant SampleIdentity_T :=
                                      (Writer_Guid     => GUID_AUTO,
                                       Sequence_Number => SEQUENCE_NUMBER_UNKNOWN);
   --  <dref>SampleIdentity_t_AUTO_SAMPLE_IDENTITY</dref>


   UNKNOWN_SAMPLE_IDENTITY        : constant SampleIdentity_T :=
                                      (Writer_Guid     => GUID_AUTO,
                                       Sequence_Number => SEQUENCE_NUMBER_UNKNOWN);
   --  <dref>SampleIdentity_t_UNKNOWN_SAMPLE_IDENTITY</dref>

   --  ----------------------------------------------------------
   --                  Cookie_t
   --  ----------------------------------------------------------

   type Cookie_T is record
      Value : aliased Octet_Seq.Sequence;
   end record with Convention => C;

   --  <defgroup>CookieGroupDocs</defgroup>
   --  <dref>Cookie_t</dref>
   --  <dref name="Value">Cookie_t_value</dref>

   function "=" (Left, Right : Cookie_T) return Standard.Boolean;

   COOKIE_DEFAULT : constant Cookie_T := (Value => Octet_Seq.DEFAULT_SEQUENCE);

   type Cookie_T_Access is access all Cookie_T;
   type Cookie_T_Array is array (Natural range <>) of aliased Cookie_T;

   procedure Initialize (Self  : in out Cookie_T);
   procedure Finalize (Self  : in out Cookie_T);
   procedure Copy (Dst : in out Cookie_T; Src : in Cookie_T);


   package Cookie_T_Seq is new DDS_Support.Sequences_Generic
     (Cookie_T,
      Cookie_T_Access,
      DDS.Natural,
      1,
      Cookie_T_Array);


   --  ----------------------------------------------------------
   --                  AckResponseData
   --  ----------------------------------------------------------

   type AckResponseData_T is record
      Value     : aliased Octet_Seq.Sequence;
   end record with
     Convention => C;
   --  <dref>AckResponseData_t</dref>
   --  <dref name="Value">AckResponseData_t_value</dref>

   --  ----------------------------------------------------------
   --                  SampleFlag
   --  ----------------------------------------------------------
   type SampleFlagBits is new Unsigned_Long;
   --  <dref>SampleFlagBits</dref>

   REDELIVERED_SAMPLE : constant SampleFlagBits := 0;
   --  <dref>SampleFlagBits_REDELIVERED_SAMPLE</dref>

   INTERMEDIATE_REPLY_SEQUENCE_SAMPLE : constant SampleFlagBits := 1;
   --  <dref>SampleFlagBits_INTERMEDIATE_REPLY_SEQUENCE_SAMPLE</dref>

   REPLICATE_SAMPLE : constant SampleFlagBits := 2;
   --  <dref>SampleFlagBits_REPLICATE_SAMPLE</dref>

   LAST_SHARED_READER_QUEUE_SAMPLE : constant SampleFlagBits := 3;
   --  <dref>SampleFlagBits_LAST_SHARED_READER_QUEUE_SAMPLE</dref>

   type SampleFlag is new DDS.Long;


   --  ----------------------------------------------------------
   --                  WriteParams_t
   --  ----------------------------------------------------------

   type WriteParams_T is record
      Replace_Auto            : aliased DDS.Boolean  := False;
      Identity                : aliased SampleIdentity_T := AUTO_SAMPLE_IDENTITY;
      Related_Sample_Identity : aliased SampleIdentity_T := UNKNOWN_SAMPLE_IDENTITY;
      Source_Timestamp        : aliased DDS.Time_T := (-1, 0);
      Cookie                  : aliased DDS.Cookie_T := COOKIE_DEFAULT;
      Handle                  : aliased DDS.InstanceHandle_T := Null_InstanceHandle_T;
      Priority                : aliased Long := 0;
      Flush_On_Write          : aliased DDS.Boolean := False;
      Flag                    : aliased SampleFlag := 0;
      Source_Guid             : aliased Guid_T := GUID_AUTO;
      Related_Source_Guid     : aliased Guid_T := GUID_UNKNOWN;
      Related_Reader_Guid     : aliased Guid_T := GUID_UNKNOWN;
      Topic_Query_Guid        : aliased Guid_T := GUID_UNKNOWN;
      Related_Epoch           : aliased DDS.SequenceNumber_T := SEQUENCE_NUMBER_ZERO;
   end record with
     Convention => C;
   --  <dref>WriteParams</dref>
   --  <dref>Shared_replace_auto</dref>
   --  <dref name="Replace_Auto">WriteParams_replace_auto</dref>
   --  <dref name="Identity">WriteParams_identity</dref>
   --  <dref name="Related_Sample_Identity">WriteParams_related_sample_identity</dref>
   --  <dref name="Source_Timestamp">WriteParams_source_timestamp</dref>
   --  <dref name="Cookie">WriteParams_cookie</dref>
   --  <dref name="Handle">WriteParams_handle</dref>
   --  <dref name="Priority">WriteParams_priority</dref>
   --  <dref internal="true" name="Flush_On_Write">WriteParams_flush_on_write</dref>
   --  <dref name="Source_Guid">WriteParams_source_guid</dref>
   --  <dref name="Related_Source_Guid">WriteParams_related_source_guid</dref>
   --  <dref name="Related_Reader_Guid">WriteParams_related_reader_guid</dref>
   --  <dref internal="true" name="Topic_Query_Guid">WriteParams_topic_query_guid</dref>
   --  <dref internal="true" name="Related_Epoch">WriteParams_related_epoch</dref>

   WRITEPARAMS_DEFAULT : constant WriteParams_T
     := (Replace_Auto            => False,
         Identity                => AUTO_SAMPLE_IDENTITY,
         Related_Sample_Identity => UNKNOWN_SAMPLE_IDENTITY,
         Source_Timestamp        => (Sec => -1, Nanosec =>  0),
         Cookie                  => COOKIE_DEFAULT,
         Handle                  => Null_InstanceHandle_T,
         Priority                => 0,
         Flush_On_Write          => False,
         Flag                    => 0,
         Source_Guid             => GUID_AUTO,
         Related_Source_Guid     => GUID_UNKNOWN,
         Related_Reader_Guid     => GUID_UNKNOWN,
         Topic_Query_Guid        => GUID_UNKNOWN,
         Related_Epoch           => SEQUENCE_NUMBER_ZERO
        );
   --  <dref>WRITEPARAMS_DEFAULT</dref>

   type WriteParams_T_Access is access all WriteParams_T;

   procedure Initialize (Self : in out WriteParams_T);
   procedure Finalize   (Self : in out WriteParams_T);
   procedure Copy       (Dst  : in out WriteParams_T; Src : in WriteParams_T);

   function WriteParams_Equals (Self : in WriteParams_T_Access; Other : in WriteParams_T_Access)
                                return DDS.Boolean;
   pragma Warnings (Off, WriteParams_Equals);
   pragma Import (C, WriteParams_Equals, "DDS_WriteParams_equals");
   --  <dref internal="true">WriteParams_equals</dref>

   --
   --  From dds_c_typecode.h
   --

   --  !!! Change name back to TypeCode when typecode object removed

   type TypeCode is new RTIDDS.Low_Level.ndds_dds_c_dds_c_typecode_h.DDS_TypeCode;

   type TypeCode_Access is access all TypeCode;

   --  From dds_c_typeobject.h
   --

   subtype TypeObject is RTIDDS.Low_Level.ndds_dds_c_dds_c_typeobject_h.DDS_Type;

   type TypeObject_Access is access all TypeObject;

   --
   --  From dds_c_builtin.h
   --

   BUILTIN_TOPIC_MAX_STRING_LENGTH : constant := 256;
   --  <dref internal="true"></dref>

   type Transport_ClassId_T is new Long;
   type TransportInfo_T is record
      Class_Id         : aliased Transport_ClassId_T := 0;  -- ndds/dds_c/dds_c_infrastructure.h:3672
      Message_Size_Max : aliased Long := 1024;  -- ndds/dds_c/dds_c_infrastructure.h:3676
   end record with Convention => C;
   --  <dref>TransportInfo_t</dref>
   --  <dref name="class_id">TransportInfo_t_class_id</dref>
   --  <dref name="message_size_max">TransportInfo_t_message_size_max</dref>

   type TransportInfo_Access is access all TransportInfo_T;
   type TransportInfo_Array is array (Natural range <>) of aliased TransportInfo_T with Convention => C;


   procedure Initialize (This : in out TransportInfo_T);
   procedure Finalize (This : in out TransportInfo_T);
   procedure Copy (Dst : in out TransportInfo_T;
                   Src : in TransportInfo_T);

   package TransportInfo_Seq is new DDS_Support.Sequences_Generic
     (Element        => DDS.TransportInfo_T,
      Element_Access => DDS.TransportInfo_Access,
      Index_Type     => Natural,
      First_Element  => 1,
      Element_Array  => DDS.TransportInfo_Array);
   --  <dref>TransportInfoSeq</dref>


   --  ----------------------------------------------------------
   --                  ParticipantBuiltinTopicData
   --  ----------------------------------------------------------

   PARTICIPANT_TOPIC_NAME : constant DDS.String := To_DDS_String ("DCPSParticipant");
   --  <dref>PARTICIPANT_TOPIC_NAME</dref>

   PARTICIPANT_TRUSTED_TOPIC_NAME : constant DDS.String := To_DDS_String ("DCPSParticipantSecure");
   --  <dref internal="true">PARTICIPANT_TRUSTED_TOPIC_NAME</dref>

   PARTICIPANT_MESSAGE_TOPIC_NAME : constant DDS.String := To_DDS_String ("DCPSParticipantMessage");
   --  <dref internal="true">PARTICIPANT_MESSAGE_TOPIC_NAME</dref>

   PARTICIPANT_MESSAGE_TRUSTED_TOPIC_NAME : constant DDS.String := To_DDS_String ("DCPSParticipantMessageSecure");
   --  <dref internal="true">PARTICIPANT_MESSAGE_TRUSTED_TOPIC_NAME</dref>

   PARTICIPANT_PROXY_TOPIC_NAME : constant DDS.String := To_DDS_String ("DDSParticipantProxy");
   --  <dref internal="true">PARTICIPANT_PROXY_TOPIC_NAME</dref>

   PARTICIPANT_STATE_TOPIC_NAME : constant DDS.String := To_DDS_String ("DDSParticipantState");
   --  <dref internal="true">PARTICIPANT_STATE_TOPIC_NAME</dref>

   ParticipantBuiltinTopicData_TypeName : DDS.String := (Data => RTIDDS.Low_Level.ndds_dds_c_dds_c_builtin_impl_h.DDS_PARTICIPANT_TYPE_NAME);

   type ParticipantBuiltinTopicData is record
      Key                            : aliased BuiltinTopicKey_T;
      User_Data                      : aliased UserDataQosPolicy;
      --  --- Extensions: ----------------------------------------------------
      Property                       : aliased PropertyQosPolicy;
      Rtps_Protocol_Version          : aliased ProtocolVersion_T;
      Rtps_Vendor_Id                 : aliased VendorId_T;
      Dds_Builtin_Endpoints          : aliased Unsigned_Long := 0;
      Metatraffic_Unicast_Locators   : aliased Locator_Seq.Sequence;
      Metatraffic_Multicast_Locators : aliased Locator_Seq.Sequence;
      Default_Unicast_Locators       : aliased Locator_Seq.Sequence;
      Lease_Duration                 : aliased Duration_T;
      Product_Version                : aliased ProductVersion_T;
      Plugin_Promiscuity_Kind        : aliased DiscoveryPluginPromiscuityKind := DISCOVERYPLUGIN_DISCOVER_MATCHING_REMOTE_ENTITIES_PROMISCUITY;
      Participant_Name               : aliased EntityNameQosPolicy;
      Domain_Id                      : aliased DomainId_T := 0;  -- ndds/dds_c/dds_c_builtin.h:105
      Transport_Info                 : aliased RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_TransportInfoSeq;  -- ndds/dds_c/dds_c_builtin.h:109
      Reachability_Lease_Duration    : aliased Duration_T;
      Vendor_Builtin_Endpoints       : aliased Unsigned_Long := 0;
      Service                        : aliased ServiceQosPolicy;

   end record with
     Convention => C;
   --  <module name="DDSBuiltInTopicModule" actualName="Built-in Topics">builtin</module>
   --  <defgroup>ParticipantBuiltInTopicGroupDocs</defgroup>
   --  <dref>ParticipantBuiltinTopicData</dref>
   --  <dref name="Key">ParticipantBuiltinTopicData_key</dref>
   --  <dref name="User_Data">ParticipantBuiltinTopicData_user_data</dref>
   --  <dref name="Property">ParticipantBuiltinTopicData_property</dref>
   --  <dref name="Rtps_Protocol_Version">ParticipantBuiltinTopicData_rtps_protocol_version</dref>
   --  <dref name="Rtps_Vendor_Id">ParticipantBuiltinTopicData_rtps_vendor_id</dref>
   --  <dref name="Dds_Builtin_Endpoints">ParticipantBuiltinTopicData_dds_builtin_endpoints</dref>
   --  <dref internal="true" name="metatraffic_unicast_locators">ParticipantBuiltinTopicData_metatrafic_unicast_locators</dref>
   --  <dref internal="true" name="metatraffic_multicast_locators">ParticipantBuiltinTopicData_metatrafic_multicast_locators</dref>
   --  <dref name="Default_Unicast_Locators">ParticipantBuiltinTopicData_default_unicast_locators</dref>
   --  <dref internal="true" name="lease_duration">ParticipantBuiltinTopicData_lease_duration</dref>
   --  <dref name="Product_Version">ParticipantBuiltinTopicData_product_version</dref>
   --  <dref internal="true" name="Plugin_Promiscuity_Kind">ParticipantBuiltinTopicData_plugin_promiscuity_kind</dref>
   --  <dref name="Participant_Name">ParticipantBuiltinTopicData_participant_name</dref>
   --  <dref name="domain_id">ParticipantBuiltinTopicData_domain_id</dref>
   --  <dref name="transport_info">ParticipantBuiltinTopicData_transport_info</dref>
   --  <dref name="Reachability_Lease_Duration">ParticipantBuiltinTopicData_reachability_lease_duration</dref>
   --  <dref internal="true" name="Vendor_Builtin_Endpoints">ParticipantBuiltinTopicData_vendor_builtin_endpoints</dref>
   --  <dref internal="true" name="Service">ParticipantBuiltinTopicData_service</dref>


   type ParticipantBuiltinTopicData_Access is access all ParticipantBuiltinTopicData;

   --     ParticipantBuiltinTopicData_INITIALIZER : constant ParticipantBuiltinTopicData :=
   --                                                 (Key                      => BuiltinTopicKey_T_INITIALIZER,
   --                                                  User_Data                => USER_DATA_QOS_POLICY_DEFAULT,
   --                                                  --  --- Extensions: ----------------------------------------------------
   --                                                  Property                 => PROPERTY_QOS_POLICY_DEFAULT,
   --                                                  Rtps_Protocol_Version    => PROTOCOL_VERSION_DEFAULT,
   --                                                  Rtps_Vendor_Id           => VENDOR_ID_DEFAULT,
   --                                                  Dds_Builtin_Endpoints    => 0,
   --                                                  metatraffic_unicast_locators => LocatorSeq.DEFAULT_SEQUENCE,
   --                                                  metatraffic_multicast_locators => LocatorSeq.DEFAULT_SEQUENCE,
   --                                                  Default_Unicast_Locators => LocatorSeq.DEFAULT_SEQUENCE,
   --                                                  lease_duration           => (16#7FFFFFFF#, 16#7FFFFFFF#),
   --                                                  Product_Version          => PRODUCTVERSION_UNKNOWN,
   --                                                  Plugin_Promiscuity_Kind  => DISCOVERYPLUGIN_DISCOVER_MATCHING_REMOTE_ENTITIES_PROMISCUITY,
   --                                                  Participant_Name         => ENTITY_NAME_QOS_POLICY_DEFAULT,
   --                                                  Multicast_Mapping        => TRANSPORT_MULTICAST_MAPPING_QOS_POLICY_DEFAULT,
   --                                                  User_Object              => ,
   --                                                  Protocol                 => ,
   --                                                  Type_Support             => );

   procedure Print (UserData : ParticipantBuiltinTopicData_Access;
                    Desc     : DDS.String;
                    Indent   : Long) with
     Convention => C,
     Import => True,
     Link_Name => "DDS_ParticipantBuiltinTopicDataPlugin_print";

   type ParticipantBuiltinTopicData_Array is array (Natural range <>) of aliased ParticipantBuiltinTopicData;
   pragma Convention (C, ParticipantBuiltinTopicData_Array);

   function ParticipantBuiltinTopicData_Get_TypeCode return Standard.DDS.TypeCode_Access;
   pragma Import (C, ParticipantBuiltinTopicData_Get_TypeCode, "DDS_ParticipantBuiltinTopicData_get_typecode");

   procedure Initialize (This : in out ParticipantBuiltinTopicData);
   procedure Finalize (This : in out ParticipantBuiltinTopicData);
   procedure Copy (Dst : in out ParticipantBuiltinTopicData;
                   Src : in ParticipantBuiltinTopicData);

   package ParticipantBuiltinTopicData_Seq is new DDS_Support.Sequences_Generic
     (Element        => DDS.ParticipantBuiltinTopicData,
      Element_Access => DDS.ParticipantBuiltinTopicData_Access,
      Index_Type     => Natural,
      First_Element  => 1,
      Element_Array  => DDS.ParticipantBuiltinTopicData_Array);
   --  <dref>ParticipantBuiltinTopicDataSeq</dref>

   --  ----------------------------------------------------------
   --                  TopicBuiltinTopicData
   --  ----------------------------------------------------------

   TOPIC_TOPIC_NAME : constant DDS.String := To_DDS_String ("DCPSTopic");
   --  <dref>TOPIC_TOPIC_NAME</dref>

   TopicBuiltinTopicData_TypeName : DDS.String := (Data => RTIDDS.Low_Level.ndds_dds_c_dds_c_builtin_impl_h.DDS_TOPIC_TYPE_NAME);

   type TopicBuiltinTopicData is record
      Key                       : aliased BuiltinTopicKey_T;
      Name                      : aliased DDS.String;
      Type_Name                 : aliased DDS.String;
      Durability                : aliased DurabilityQosPolicy;
      Durability_Service        : aliased DurabilityServiceQosPolicy;
      Deadline                  : aliased DeadlineQosPolicy;
      Latency_Budget            : aliased LatencyBudgetQosPolicy;
      Liveliness                : aliased LivelinessQosPolicy;
      Reliability               : aliased ReliabilityQosPolicy;
      Transport_Priority        : aliased TransportPriorityQosPolicy;
      Lifespan                  : aliased LifespanQosPolicy;
      Destination_Order         : aliased DestinationOrderQosPolicy;
      History                   : aliased HistoryQosPolicy;
      Resource_Limits           : aliased ResourceLimitsQosPolicy;
      Ownership                 : aliased OwnershipQosPolicy;
      Topic_Data                : aliased TopicDataQosPolicy;
      Representation            : aliased DataRepresentationQosPolicy;
   end record with
     Convention => C;
   --  <defgroup>TopicBuiltInTopicGroupDocs</defgroup>
   --  <dref>TopicBuiltinTopicData</dref>
   --  <dref>Shared_topic_builtin_topic_data_description</dref>
   --  <dref name="Key">TopicBuiltinTopicData_key</dref>
   --  <dref name="Name">TopicBuiltinTopicData_name</dref>
   --  <dref name="Type_Name">TopicBuiltinTopicData_type_name</dref>
   --  <dref name="Durability">TopicBuiltinTopicData_durability</dref>
   --  <dref name="Durability_Service">TopicBuiltinTopicData_durability_service</dref>
   --  <dref name="Deadline">TopicBuiltinTopicData_deadline</dref>
   --  <dref name="Latency_Budget">TopicBuiltinTopicData_latency_budget</dref>
   --  <dref name="Liveliness">TopicBuiltinTopicData_liveliness</dref>
   --  <dref name="Reliability">TopicBuiltinTopicData_reliability</dref>
   --  <dref name="Transport_Priority">TopicBuiltinTopicData_transport_priority</dref>
   --  <dref name="Lifespan">TopicBuiltinTopicData_lifespan</dref>
   --  <dref name="Destination_Order">TopicBuiltinTopicData_destination_order</dref>
   --  <dref name="History">TopicBuiltinTopicData_history</dref>
   --  <dref name="Resource_Limits">TopicBuiltinTopicData_resource_limits</dref>
   --  <dref name="Ownership">TopicBuiltinTopicData_ownership</dref>
   --  <dref name="Topic_Data">TopicBuiltinTopicData_topic_data</dref>
   --  <dref name="Representation">TopicBuiltinTopicData_representation</dref>


   type TopicBuiltinTopicData_Access is access all TopicBuiltinTopicData;

   --     TopicBuiltinTopicData_INITIALIZER : constant TopicBuiltinTopicData :=
   --                                           (Key                        => BuiltinTopicKey_T_INITIALIZER,
   --                                            Name                       => NULL_STRING,
   --                                            Type_Name                  => NULL_STRING,
   --                                            Durability                 => DURABILITY_QOS_POLICY_DEFAULT,
   --                                            Durability_Service         => DURABILITY_SERVICE_QOS_POLICY_DEFAULT,
   --                                            Deadline                   => DEADLINE_QOS_POLICY_DEFAULT,
   --                                            Latency_Budget             => LATENCY_BUDGET_QOS_POLICY_DEFAULT,
   --                                            Liveliness                 => LIVELINESS_QOS_POLICY_DEFAULT,
   --                                            Reliability                => RELIABILITY_QOS_POLICY_DEFAULT,
   --                                            Transport_Priority         => TRANSPORT_PRIORITY_QOS_POLICY_DEFAULT,
   --                                            Lifespan                   => LIFESPAN_QOS_POLICY_DEFAULT,
   --                                            Destination_Order          => DESTINATION_ORDER_QOS_POLICY_DEFAULT,
   --                                            History                    => HISTORY_QOS_POLICY_DEFAULT,
   --                                            Resource_Limits            => RESOURCE_LIMITS_QOS_POLICY_DEFAULT,
   --                                            Ownership                  => OWNERSHIP_QOS_POLICY_DEFAULT,
   --                                            Topic_Data                 => TOPIC_DATA_QOS_POLICY_DEFAULT,
   --                                            Representation             => DataRepresentationQosPolicy_INITIALIZER);

   type TopicBuiltinTopicData_Array is array (Natural range <>) of aliased TopicBuiltinTopicData;
   pragma Convention (C, TopicBuiltinTopicData_Array);

   function TopicBuiltinTopicData_Get_TypeCode return Standard.DDS.TypeCode_Access;
   pragma Import (C, TopicBuiltinTopicData_Get_TypeCode, "DDS_TopicBuiltinTopicData_get_typecode");

   procedure Initialize (This : in out TopicBuiltinTopicData);
   procedure Finalize (This : in out TopicBuiltinTopicData);
   procedure Copy (Dst : in out TopicBuiltinTopicData;
                   Src : in TopicBuiltinTopicData);

   package TopicBuiltinTopicData_Seq is new DDS_Support.Sequences_Generic
     (Element        => DDS.TopicBuiltinTopicData,
      Element_Access => DDS.TopicBuiltinTopicData_Access,
      Index_Type     => Natural,
      First_Element  => 1,
      Element_Array  => DDS.TopicBuiltinTopicData_Array);
   --  <dref>TopicBuiltinTopicDataSeq</dref>

   --  ----------------------------------------------------------
   --                  Service Request Topic Data
   --  ----------------------------------------------------------

   --  <defgroup>ServiceRequestBuiltInTopicGroupDocs</defgroup>
   type ServiceRequestInternalTopicData is record
      Service_Id                : aliased Long := 0;
      Instance_Id               : aliased Guid_T;
      Request_Body              : aliased RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_OctetSeq;
   end record with Convention => C;
   --  <dref>ServiceRequest</dref>

   type ServiceRequestInternalTopicData_Access is access all ServiceRequestInternalTopicData;

   --  ----------------------------------------------------------
   --                  PublicationBuiltinTopicData
   --  ----------------------------------------------------------

   PUBLICATION_TOPIC_NAME : constant DDS.String := To_DDS_String ("DCPSPublication");
   --  <dref>PUBLICATION_TOPIC_NAME</dref>

   PUBLICATION_TRUSTED_TOPIC_NAME : constant DDS.String := To_DDS_String ("DCPSPublicationSecure");
   --  <dref internal="true">PUBLICATION_TRUSTED_TOPIC_NAME</dref>

   PublicationBuiltinTopicData_TypeName : DDS.String := (Data => RTIDDS.Low_Level.ndds_dds_c_dds_c_builtin_impl_h.DDS_PUBLICATION_TYPE_NAME);

   type PublicationBuiltinTopicData is record
      Key                       : aliased BuiltinTopicKey_T;
      Participant_Key           : aliased BuiltinTopicKey_T;
      Topic_Name                : aliased DDS.String;
      Type_Name                 : aliased DDS.String;
      Max_Sample_Serialize_Size : aliased Long := 0;
      Durability                : aliased DurabilityQosPolicy;
      Durability_Service        : aliased DurabilityServiceQosPolicy;
      Deadline                  : aliased DeadlineQosPolicy;
      Latency_Budget            : aliased LatencyBudgetQosPolicy;
      Liveliness                : aliased LivelinessQosPolicy;
      Reliability               : aliased ReliabilityQosPolicy;
      Lifespan                  : aliased LifespanQosPolicy;
      User_Data                 : aliased UserDataQosPolicy;
      Ownership                 : aliased OwnershipQosPolicy;
      Ownership_Strength        : aliased OwnershipStrengthQosPolicy;
      Destination_Order         : aliased DestinationOrderQosPolicy;
      Presentation              : aliased PresentationQosPolicy;
      Partition                 : aliased PartitionQosPolicy;
      Topic_Data                : aliased TopicDataQosPolicy;
      Group_Data                : aliased GroupDataQosPolicy;
      Type_Object               : aliased TypeObject_Access;
      Representation            : aliased DataRepresentationQosPolicy;
      Data_Tags                 : aliased DataTagQosPolicy;
      --  extensions
      Type_Code                 : aliased TypeCode_Access;
      Publisher_Key             : aliased BuiltinTopicKey_T;
      Property                  : aliased PropertyQosPolicy;
      Unicast_Locators          : aliased Locator_Seq.Sequence;
      Virtual_Guid              : aliased Guid_T;
      Service                   : aliased ServiceQosPolicy;
      Rtps_Protocol_Version     : aliased ProtocolVersion_T;
      Rtps_Vendor_Id            : aliased VendorId_T;
      Product_Version           : aliased ProductVersion_T;
      Locator_Filter            : aliased LocatorFilterQosPolicy;
      Disable_Positive_Acks     : aliased Boolean := False;
      Send_Queue_Size           : aliased Long := 0;
      Is_Incompatible           : aliased Boolean := False;
      Publication_Name          : aliased EntityNameQosPolicy;
   end record with
     Convention => C;
   --  <defgroup>PublicationBuiltInTopicGroupDocs</defgroup>
   --  <dref>PublicationBuiltinTopicData</dref>
   --  <dref>Shared_publication_builtin_topic_data_description</dref>
   --  <dref name="Key">PublicationBuiltinTopicData_key</dref>
   --  <dref name="Participant_Key">PublicationBuiltinTopicData_participant_key</dref>
   --  <dref name="Topic_Name">PublicationBuiltinTopicData_topic_name</dref>
   --  <dref name="Type_Name">PublicationBuiltinTopicData_type_name</dref>
   --  <dref internal="true" name="Max_Sample_Serialize_Size">PublicationBuiltinTopicData_max_sample_serialized_size</dref>
   --  <dref name="Durability">PublicationBuiltinTopicData_durability</dref>
   --  <dref name="Durability_Service">PublicationBuiltinTopicData_durability_service</dref>
   --  <dref name="Deadline">PublicationBuiltinTopicData_deadline</dref>
   --  <dref name="Latency_Budget">PublicationBuiltinTopicData_latency_budget</dref>
   --  <dref name="Liveliness">PublicationBuiltinTopicData_liveliness</dref>
   --  <dref name="Reliability">PublicationBuiltinTopicData_reliability</dref>
   --  <dref name="Lifespan">PublicationBuiltinTopicData_lifespan</dref>
   --  <dref name="User_Data">PublicationBuiltinTopicData_user_data</dref>
   --  <dref name="Ownership">PublicationBuiltinTopicData_ownership</dref>
   --  <dref name="Ownership_Strength">PublicationBuiltinTopicData_ownership_strength</dref>
   --  <dref name="Destination_Order">PublicationBuiltinTopicData_destination_order</dref>
   --  <dref name="Presentation">PublicationBuiltinTopicData_presentation</dref>
   --  <dref name="Partition">PublicationBuiltinTopicData_partition</dref>
   --  <dref name="Topic_Data">PublicationBuiltinTopicData_topic_data</dref>
   --  <dref name="Group_Data">PublicationBuiltinTopicData_group_data</dref>
   --  <dref internal="true" name="Type_Object">PublicationBuiltinTopicData_type_object</dref>
   --  <dref name="Representation">PublicationBuiltinTopicData_representation</dref>
   --  <dref name="Data_Tags">PublicationBuiltinTopicData_data_tags</dref>
   --  <dref name="Type_Code">PublicationBuiltinTopicData_type_code</dref>
   --  <dref name="Publisher_Key">PublicationBuiltinTopicData_publisher_key</dref>
   --  <dref name="Property">PublicationBuiltinTopicData_property</dref>
   --  <dref name="Unicast_Locators">PublicationBuiltinTopicData_unicast_locators</dref>
   --  <dref name="Virtual_Guid">PublicationBuiltinTopicData_virtual_guid</dref>
   --  <dref name="Service">PublicationBuiltinTopicData_service</dref>
   --  <dref name="Rtps_Protocol_Version">PublicationBuiltinTopicData_rtps_protocol_version</dref>
   --  <dref name="Rtps_Vendor_Id">PublicationBuiltinTopicData_rtps_vendor_id</dref>
   --  <dref name="Product_Version">PublicationBuiltinTopicData_product_version</dref>
   --  <dref name="locator_filter">PublicationBuiltinTopicData_locator_filter</dref>
   --  <dref name="disable_positive_acks">PublicationBuiltinTopicData_disable_positive_acks</dref>
   --  <dref internal="true" name="send_queue_zize">PublicationBuiltinTopicData_send_queue_size</dref>
   --  <dref internal="true" name="is_compatible">PublicationBuiltinTopicData_is_compatible</dref>
   --  <dref name="publication_name">PublicationBuiltinTopicData_publication_name</dref>


   type PublicationBuiltinTopicData_Access is access all PublicationBuiltinTopicData;

   --     PublicationBuiltinTopicData_INITIALIZER : constant PublicationBuiltinTopicData :=
   --                                                 (Key                        => BuiltinTopicKey_T_INITIALIZER,
   --                                                  Participant_Key            => BuiltinTopicKey_T_INITIALIZER,
   --                                                  Topic_Name                 => NULL_STRING,
   --                                                  Type_Name                  => NULL_STRING,
   --                                                  Max_Sample_Serialize_Size  => 0,
   --                                                  Durability                 => DURABILITY_QOS_POLICY_DEFAULT,
   --                                                  Durability_Service         => DURABILITY_SERVICE_QOS_POLICY_DEFAULT,
   --                                                  Deadline                   => DEADLINE_QOS_POLICY_DEFAULT,
   --                                                  Latency_Budget             => LATENCY_BUDGET_QOS_POLICY_DEFAULT,
   --                                                  Liveliness                 => LIVELINESS_QOS_POLICY_DEFAULT,
   --                                                  Reliability                => RELIABILITY_QOS_POLICY_DEFAULT,
   --                                                  Lifespan                   => LIFESPAN_QOS_POLICY_DEFAULT,
   --                                                  User_Data                  => USER_DATA_QOS_POLICY_DEFAULT,
   --                                                  Ownership                  => OWNERSHIP_QOS_POLICY_DEFAULT,
   --                                                  Ownership_Strength         => OWNERSHIP_STRENGTH_QOS_POLICY_DEFAULT,
   --                                                  Destination_Order          => DESTINATION_ORDER_QOS_POLICY_DEFAULT,
   --                                                  Presentation               => PRESENTATION_QOS_POLICY_DEFAULT,
   --                                                  Partition                  => PARTITION_QOS_POLICY_DEFAULT,
   --                                                  Topic_Data                 => TOPIC_DATA_QOS_POLICY_DEFAULT,
   --                                                  Group_Data                 => GROUP_DATA_QOS_POLICY_DEFAULT,
   --                                                  Representation             => DataRepresentationQosPolicy_INITIALIZER,
   --                                                  Data_Tags                  => DataTagQosPolicy_INITIALIZER,
   --                                                  Type_Code                  => null,
   --                                                  Publisher_Key              => BuiltinTopicKey_T_INITIALIZER,
   --                                                  Property                   => PROPERTY_QOS_POLICY_DEFAULT,
   --                                                  Unicast_Locators           => LocatorSeq.DEFAULT_SEQUENCE,
   --                                                  Virtual_Guid               => (Value => (others => 0)),
   --                                                  Service                    => SERVICE_QOS_POLICY_DEFAULT,
   --                                                  Rtps_Protocol_Version      => PROTOCOL_VERSION_DEFAULT,
   --                                                  Rtps_Vendor_Id             => VENDOR_ID_DEFAULT,
   --                                                  Product_Version            => PRODUCTVERSION_UNKNOWN);

   type PublicationBuiltinTopicData_Array is array (Natural range <>) of aliased PublicationBuiltinTopicData;
   pragma Convention (C, PublicationBuiltinTopicData_Array);

   function PublicationBuiltinTopicData_Get_TypeCode return Standard.DDS.TypeCode_Access;
   pragma Import (C, PublicationBuiltinTopicData_Get_TypeCode, "DDS_PublicationBuiltinTopicData_get_typecode");

   procedure Initialize (This : in out PublicationBuiltinTopicData);
   procedure Finalize (This : in out PublicationBuiltinTopicData);
   procedure Copy (Dst : in out PublicationBuiltinTopicData;
                   Src : in PublicationBuiltinTopicData);

   package PublicationBuiltinTopicData_Seq is new DDS_Support.Sequences_Generic
     (Element        => DDS.PublicationBuiltinTopicData,
      Element_Access => DDS.PublicationBuiltinTopicData_Access,
      Index_Type     => Natural,
      First_Element  => 1,
      Element_Array  => DDS.PublicationBuiltinTopicData_Array);
   --  <dref>PublicationBuiltinTopicDataSeq</dref>

   --  ----------------------------------------------------------
   --                  SubscriptionBuiltinTopicData
   --  ----------------------------------------------------------

   SUBSCRIPTION_TOPIC_NAME : constant DDS.String := To_DDS_String ("DCPSSubscription");
   --  <dref>SUBSCRIPTION_TOPIC_NAME</dref>

   SUBSCRIPTION_TRUSTED_TOPIC_NAME : constant DDS.String := To_DDS_String ("DCPSSubscriptionSecure");
   --  <dref internal="true">SUBSCRIPTION_TRUSTED_TOPIC_NAME</dref>

   SubscriptionBuiltinTopicData_TypeName : DDS.String := (Data => RTIDDS.Low_Level.ndds_dds_c_dds_c_builtin_impl_h.DDS_SUBSCRIPTION_TYPE_NAME);

   type SubscriptionBuiltinTopicData is record
      Key                     : aliased BuiltinTopicKey_T;
      Participant_Key         : aliased BuiltinTopicKey_T;
      Topic_Name              : aliased DDS.String;
      Type_Name               : aliased DDS.String;
      Durability              : aliased DurabilityQosPolicy;
      Deadline                : aliased DeadlineQosPolicy;
      Latency_Budget          : aliased LatencyBudgetQosPolicy;
      Liveliness              : aliased LivelinessQosPolicy;
      Reliability             : aliased ReliabilityQosPolicy;
      Ownership               : aliased OwnershipQosPolicy;
      Destination_Order       : aliased DestinationOrderQosPolicy;
      User_Data               : aliased UserDataQosPolicy;
      Time_Based_Filter       : aliased TimeBasedFilterQosPolicy;
      Presentation            : aliased PresentationQosPolicy;
      Partition               : aliased PartitionQosPolicy;
      Topic_Data              : aliased TopicDataQosPolicy;
      Group_Data              : aliased GroupDataQosPolicy;
      Type_Consistency        : aliased TypeConsistencyEnforcementQosPolicy;
      Type_Object             : aliased TypeObject_Access;
      Representation          : aliased DataRepresentationQosPolicy;
      Data_Tags               : aliased DataTagQosPolicy;
      --  extensions
      Type_Code               : aliased TypeCode_Access;
      Subscriber_Key          : aliased BuiltinTopicKey_T;
      Property                : aliased PropertyQosPolicy;
      Unicast_Locators        : aliased Locator_Seq.Sequence;
      Multicast_Locators      : aliased Locator_Seq.Sequence;
      Content_Filter_Property : aliased ContentFilterProperty_T;
      Virtual_Guid            : aliased Guid_T;
      Service                 : aliased ServiceQosPolicy;
      Rtps_Protocol_Version   : aliased ProtocolVersion_T;
      Rtps_Vendor_Id          : aliased VendorId_T;
      Product_Version         : aliased ProductVersion_T;
      Disable_Positive_Acks   : aliased Boolean := False;
      Expects_Inline_Qos      : aliased Boolean := False;
      Receive_Queue_Size      : aliased Long := 0;
      Is_Incompatible         : aliased Boolean := False;
      Subscription_Name       : aliased EntityNameQosPolicy;
   end record with
     Convention => C;
   --  <defgroup>SubscriptionBuiltInTopicGroupDocs</defgroup>
   --  <dref>SubscriptionBuiltinTopicData</dref>
   --  <dref>Shared_subscription_builtin_topic_data_description</dref>
   --  <dref name="Key">SubscriptionBuiltinTopicData_key</dref>
   --  <dref name="Participant_Key">SubscriptionBuiltinTopicData_participant_key</dref>
   --  <dref name="Topic_Name">SubscriptionBuiltinTopicData_topic_name</dref>
   --  <dref name="Type_Name">SubscriptionBuiltinTopicData_type_name</dref>
   --  <dref name="Durability">SubscriptionBuiltinTopicData_durability</dref>
   --  <dref name="Deadline">SubscriptionBuiltinTopicData_deadline</dref>
   --  <dref name="Latency_Budget">SubscriptionBuiltinTopicData_latency_budget</dref>
   --  <dref name="Liveliness">SubscriptionBuiltinTopicData_liveliness</dref>
   --  <dref name="Reliability">SubscriptionBuiltinTopicData_reliability</dref>
   --  <dref name="Ownership">SubscriptionBuiltinTopicData_ownership</dref>
   --  <dref name="Destination_Order">SubscriptionBuiltinTopicData_destination_order</dref>
   --  <dref name="User_Data">SubscriptionBuiltinTopicData_user_data</dref>
   --  <dref name="Time_Based_Filter">SubscriptionBuiltinTopicData_time_based_filter</dref>
   --  <dref name="Presentation">SubscriptionBuiltinTopicData_presentation</dref>
   --  <dref name="Partition">SubscriptionBuiltinTopicData_partition</dref>
   --  <dref name="Topic_Data">SubscriptionBuiltinTopicData_topic_data</dref>
   --  <dref name="Group_Data">SubscriptionBuiltinTopicData_group_data</dref>
   --  <dref name="Type_Consistency">SubscriptionBuiltinTopicData_type_consistency</dref>
   --  <dref internal="true" name="Type_Object">SubscriptionBuiltinTopicData_type</dref>
   --  <dref name="Representation">SubscriptionBuiltinTopicData_representation</dref>
   --  <dref name="Data_Tags">SubscriptionBuiltinTopicData_data_tags</dref>
   --  <dref name="Type_Code">SubscriptionBuiltinTopicData_type_code</dref>
   --  <dref name="Subscriber_Key">SubscriptionBuiltinTopicData_subscriber_key</dref>
   --  <dref name="Property">SubscriptionBuiltinTopicData_property</dref>
   --  <dref name="Unicast_Locators">SubscriptionBuiltinTopicData_unicast_locators</dref>
   --  <dref name="Multicast_Locators">SubscriptionBuiltinTopicData_multicast_locators</dref>
   --  <dref name="Content_Filter_Property">SubscriptionBuiltinTopicData_content_filter_property</dref>
   --  <dref name="Virtual_Guid">SubscriptionBuiltinTopicData_virtual_guid</dref>
   --  <dref name="Service">SubscriptionBuiltinTopicData_service</dref>
   --  <dref name="Rtps_Protocol_Version">SubscriptionBuiltinTopicData_rtps_protocol_version</dref>
   --  <dref name="Rtps_Vendor_Id">SubscriptionBuiltinTopicData_rtps_vendor_id</dref>
   --  <dref name="Product_Version">SubscriptionBuiltinTopicData_product_version</dref>
   --  <dref name="disable_positive_acks">SubscriptionBuiltinTopicData_disable_positive_acks</dref>
   --  <dref internal="true" name="expects_inline_qos">SubscriptionBuiltinTopicData_expects_inline_qos</dref>
   --  <dref internal="true" name="receive_queue_size">SubscriptionBuiltinTopicData_receive_queue_size</dref>
   --  <dref internal="true" name="is_compatible">SubscriptionBuiltinTopicData_is_compatible</dref>
   --  <dref name="subscription_name">SubscriptionBuiltinTopicData_subscription_name</dref>

   type SubscriptionBuiltinTopicData_Access is access all SubscriptionBuiltinTopicData;

   --     SubscriptionBuiltinTopicData_INITIALIZER : constant SubscriptionBuiltinTopicData :=
   --                                                  (Key                     => BuiltinTopicKey_T_INITIALIZER,
   --                                                   Participant_Key         => BuiltinTopicKey_T_INITIALIZER,
   --                                                   Topic_Name              => NULL_STRING,
   --                                                   Type_Name               => NULL_STRING,
   --                                                   Durability              => DURABILITY_QOS_POLICY_DEFAULT,
   --                                                   Deadline                => DEADLINE_QOS_POLICY_DEFAULT,
   --                                                   Latency_Budget          => LATENCY_BUDGET_QOS_POLICY_DEFAULT,
   --                                                   Liveliness              => LIVELINESS_QOS_POLICY_DEFAULT,
   --                                                   Reliability             => RELIABILITY_QOS_POLICY_DEFAULT,
   --                                                   Ownership               => OWNERSHIP_QOS_POLICY_DEFAULT,
   --                                                   Destination_Order       => DESTINATION_ORDER_QOS_POLICY_DEFAULT,
   --                                                   User_Data               => USER_DATA_QOS_POLICY_DEFAULT,
   --                                                   Time_Based_Filter       => TIME_BASED_FILTER_QOS_POLICY_DEFAULT,
   --                                                   Presentation            => PRESENTATION_QOS_POLICY_DEFAULT,
   --                                                   Partition               => PARTITION_QOS_POLICY_DEFAULT,
   --                                                   Topic_Data              => TOPIC_DATA_QOS_POLICY_DEFAULT,
   --                                                   Group_Data              => GROUP_DATA_QOS_POLICY_DEFAULT,
   --                                                   Type_Consistency        => TYPE_CONSISTENCY_ENFORCEMENT_QOS_POLICY_DEFAULT,
   --                                                   Representation          => DataRepresentationQosPolicy_INITIALIZER,
   --                                                   Data_Tags               => DataTagQosPolicy_INITIALIZER,
   --                                                   --  extensions
   --                                                   Type_Code               => null,
   --                                                   Subscriber_Key          => BuiltinTopicKey_T_INITIALIZER,
   --                                                   Property                => PROPERTY_QOS_POLICY_DEFAULT,
   --                                                   Unicast_Locators        => LocatorSeq.DEFAULT_SEQUENCE,
   --                                                   Multicast_Locators      => LocatorSeq.DEFAULT_SEQUENCE,
   --                                                   Content_Filter_Property => CONTENT_FILTER_PROPERTY_DEFAULT,
   --                                                   Virtual_Guid            =>  (Value => (others => 0)),
   --                                                   Service                 => SERVICE_QOS_POLICY_DEFAULT,
   --                                                   Rtps_Protocol_Version   => PROTOCOL_VERSION_DEFAULT,
   --                                                   Rtps_Vendor_Id          => VENDOR_ID_DEFAULT,
   --                                                   Product_Version         => PRODUCTVERSION_UNKNOWN,
   --                                                   disable_positive_acks   => False,
   --                                                   expects_inline_qos      => False,
   --                                                   receive_queue_size      => 0,
   --                                                   is_incompatible         => False);

   type SubscriptionBuiltinTopicData_Array is array (Natural range <>) of aliased SubscriptionBuiltinTopicData;
   pragma Convention (C, SubscriptionBuiltinTopicData_Array);

   function SubscriptionBuiltinTopicData_Get_TypeCode return Standard.DDS.TypeCode_Access;
   pragma Import (C, SubscriptionBuiltinTopicData_Get_TypeCode, "DDS_SubscriptionBuiltinTopicData_get_typecode");

   procedure Initialize (This : in out SubscriptionBuiltinTopicData);
   procedure Finalize (This : in out SubscriptionBuiltinTopicData);
   procedure Copy (Dst : in out SubscriptionBuiltinTopicData;
                   Src : in SubscriptionBuiltinTopicData);

   package SubscriptionBuiltinTopicData_Seq is new DDS_Support.Sequences_Generic
     (Element        => DDS.SubscriptionBuiltinTopicData,
      Element_Access => DDS.SubscriptionBuiltinTopicData_Access,
      Index_Type     => Natural,
      First_Element  => 1,
      Element_Array  => DDS.SubscriptionBuiltinTopicData_Array);
   --  <dref>SubscriptionBuiltinTopicDataSeq</dref>

   --
   --  dds/dds_c_topic.h
   --

   type KeyHash_Value_Array is array (0 .. 15) of aliased DDS.Octet;

   type KeyHash_T is record
      Value  : aliased KeyHash_Value_Array := (others => 0);
      Length : aliased DDS.Unsigned_Long := 0;
   end record with
     Convention => C;

   --  ----------------------------------------------------------
   --                  InconsistentTopicStatus
   --  ----------------------------------------------------------

   type InconsistentTopicStatus is record
      Total_Count        : aliased Long := 0;
      Total_Count_Change : aliased Long := 0;
   end record with
     Convention => C;
   --  <dref>InconsistentTopicStatus</dref>
   --  <dref name="Total_Count">InconsistentTopicStatus_total_count</dref>
   --  <dref name="Total_Count_Change">InconsistentTopicStatus_total_count_change</dref>

   InconsistentTopicStatus_INITIALIZER : constant InconsistentTopicStatus :=
                                           (Total_Count        => 0,
                                            Total_Count_Change => 0);

   --  ----------------------------------------------------------
   --                  TopicQos
   --  ----------------------------------------------------------

   type TopicQos is new Ada.Finalization.Limited_Controlled with record
      Topic_Data         : aliased TopicDataQosPolicy;
      Durability         : aliased DurabilityQosPolicy;
      Durability_Service : aliased DurabilityServiceQosPolicy;
      Deadline           : aliased DeadlineQosPolicy;
      Latency_Budget     : aliased LatencyBudgetQosPolicy;
      Liveliness         : aliased LivelinessQosPolicy;
      Reliability        : aliased ReliabilityQosPolicy;
      Destination_Order  : aliased DestinationOrderQosPolicy;
      History            : aliased HistoryQosPolicy;
      Resource_Limits    : aliased ResourceLimitsQosPolicy;
      Transport_Priority : aliased TransportPriorityQosPolicy;
      Lifespan           : aliased LifespanQosPolicy;
      Ownership          : aliased OwnershipQosPolicy;
      Representation     : aliased DataRepresentationQosPolicy;
      -- --- Extensions: ----------------------------------------------------
      Protocol           : aliased TopicProtocolQosPolicy;
   end record with
     Convention => C;
   --  <dref>TopicQos</dref>
   --  <dref name="Topic_Data">TopicQos_topic_data</dref>
   --  <dref name="Durability">TopicQos_durability</dref>
   --  <dref name="Durability_Service">TopicQos_durability_service</dref>
   --  <dref name="Deadline">TopicQos_deadline</dref>
   --  <dref name="Latency_Budget">TopicQos_latency_budget</dref>
   --  <dref name="Liveliness">TopicQos_liveliness</dref>
   --  <dref name="Reliability">TopicQos_reliability</dref>
   --  <dref name="Destination_Order">TopicQos_destination_order</dref>
   --  <dref name="History">TopicQos_history</dref>
   --  <dref name="Resource_Limits">TopicQos_resource_limits</dref>
   --  <dref name="Transport_Priority">TopicQos_transport_priority</dref>
   --  <dref name="Lifespan">TopicQos_lifespan</dref>
   --  <dref name="Ownership">TopicQos_ownership</dref>
   --  <dref name="Representation">TopicQos_representation</dref>
   --  <dref internal="true" name="Protocol">TopicQos_protocol</dref>

   type TopicQos_Access is access TopicQos;

   --  <dref>TopicQos_initialize</dref>
   procedure Initialize
     (Self : in out TopicQos);

   --  <dref>TopicQos_finalize</dref>
   procedure Finalize
     (Self : in out TopicQos);

   --  <dref>TopicQos_copy</dref>
   procedure Copy
     (Target : in out TopicQos;
      Source : in TopicQos);

   --
   --  dds/dds_c_publication.h
   --

   --  ----------------------------------------------------------
   --                  OfferedDeadlineMissedStatus
   --  ----------------------------------------------------------

   type OfferedDeadlineMissedStatus is record
      Total_Count          : aliased Long := 0;
      Total_Count_Change   : aliased Long := 0;
      Last_Instance_Handle : aliased InstanceHandle_T := Null_InstanceHandle_T;
   end record with
     Convention => C;
   --  <dref>OfferedDeadlineMissedStatus</dref>
   --  <dref name="Total_Count">OfferedDeadlineMissedStatus_total_count</dref>
   --  <dref name="Total_Count_Change">OfferedDeadlineMissedStatus_total_count_change</dref>
   --  <dref name="Last_Instance_Handle">OfferedDeadlineMissedStatus_last_instance_handle</dref>


   OfferedDeadlineMissedStatus_INITIALIZER : constant OfferedDeadlineMissedStatus :=
                                               (Total_Count          => 0,
                                                Total_Count_Change   => 0,
                                                Last_Instance_Handle => Null_InstanceHandle_T);

   --  ----------------------------------------------------------
   --                  LivelinessLostStatus
   --  ----------------------------------------------------------

   type LivelinessLostStatus is record
      Total_Count        : aliased Long := 0;
      Total_Count_Change : aliased Long := 0;
   end record with
     Convention => C;
   --  <dref>LivelinessLostStatus</dref>
   --  <dref name="Total_Count">LivelinessLostStatus_total_count</dref>
   --  <dref name="Total_Count_Change">LivelinessLostStatus_total_count_change</dref>

   LivelinessLostStatus_INITIALIZER : constant LivelinessLostStatus :=
                                        (Total_Count        => 0,
                                         Total_Count_Change => 0);

   --  ----------------------------------------------------------
   --                  OfferedIncompatibleQosStatus
   --  ----------------------------------------------------------

   type OfferedIncompatibleQosStatus is record
      Total_Count        : aliased Long := 0;
      Total_Count_Change : aliased Long := 0;
      Last_Policy_Id     : aliased QosPolicyId_T := INVALID_QOS_POLICY_ID;
      Policies           : aliased QosPolicyCount_Seq.Sequence;
   end record with
     Convention => C;
   --  <dref>OfferedIncompatibleQosStatus</dref>
   --  <dref name="Total_Count">OfferedIncompatibleQosStatus_total_count</dref>
   --  <dref name="Total_Count_Change">OfferedIncompatibleQosStatus_total_count_change</dref>
   --  <dref name="Last_Policy_Id">OfferedIncompatibleQosStatus_last_policy_id</dref>
   --  <dref name="Policies">OfferedIncompatibleQosStatus_policies</dref>


   type OfferedIncompatibleQosStatus_Access is access all OfferedIncompatibleQosStatus;

   --     OfferedIncompatibleQosStatus_INITIALIZER : constant OfferedIncompatibleQosStatus :=
   --                                                  (Total_Count        => 0,
   --                                                   Total_Count_Change => 0,
   --                                                   Last_Policy_Id     => INVALID_QOS_POLICY_ID,
   --                                                   Policies           => QosPolicyCount_Seq.DEFAULT_SEQUENCE);

   --  ----------------------------------------------------------
   --                  PublicationMatchedStatus
   --  ----------------------------------------------------------

   type PublicationMatchedStatus is record
      Total_Count              : aliased Long := 0;
      Total_Count_Change       : aliased Long := 0;
      Current_Count            : aliased Long := 0;
      Current_Count_Peak       : aliased Long := 0;
      Current_Count_Change     : aliased Long := 0;
      Last_Subscription_Handle : aliased InstanceHandle_T := Null_InstanceHandle_T;
   end record with
     Convention => C;
   --  <dref>PublicationMatchedStatus</dref>
   --  <dref name="Total_Count">PublicationMatchedStatus_total_count</dref>
   --  <dref name="Total_Count_Change">PublicationMatchedStatus_total_count_change</dref>
   --  <dref name="Current_Count">PublicationMatchedStatus_current_count</dref>
   --  <dref name="Current_Count_Peak">PublicationMatchedStatus_current_count_peak</dref>
   --  <dref name="Current_Count_Change">PublicationMatchedStatus_current_count_change</dref>
   --  <dref name="Last_Subscription_Handle">PublicationMatchedStatus_last_subscription_handle</dref>


   PublicationMatchedStatus_INITIALIZER : constant PublicationMatchedStatus :=
                                            (Total_Count              => 0,
                                             Total_Count_Change       => 0,
                                             Current_Count            => 0,
                                             Current_Count_Peak       => 0,
                                             Current_Count_Change     => 0,
                                             Last_Subscription_Handle => Null_InstanceHandle_T);

   --  ----------------------------------------------------------
   --                  ReliableWriterCacheEventCount
   --  ----------------------------------------------------------

   type ReliableWriterCacheEventCount is record
      Total_Count        : aliased Long := 0;
      Total_Count_Change : aliased Long := 0;
   end record;
   --  <dref>ReliableWriterCacheEventCount</dref>
   --  <dref name="Total_Count">ReliableWriterCacheEventCount_total_count</dref>
   --  <dref name="Total_Count_Change">ReliableWriterCacheEventCount_total_count_change</dref>

   pragma Convention (C, ReliableWriterCacheEventCount);

   ReliableWriterCacheEventCount_INITIALIZER : constant ReliableWriterCacheEventCount :=
                                                 (Total_Count        => 0,
                                                  Total_Count_Change => 0);

   --  ----------------------------------------------------------
   --                  ReliableWriterCacheChangedStatus
   --  ----------------------------------------------------------

   type ReliableWriterCacheChangedStatus is record
      Empty_Reliable_Writer_Cache          : aliased ReliableWriterCacheEventCount;
      Full_Reliable_Writer_Cache           : aliased ReliableWriterCacheEventCount;
      Low_Watermark_Reliable_Writer_Cache  : aliased ReliableWriterCacheEventCount;
      High_Watermark_Reliable_Writer_Cache : aliased ReliableWriterCacheEventCount;
      Unacknowledged_Sample_Count          : aliased Long := 0;
      Unacknowledged_Sample_Count_Peak     : aliased Long := 0;
   end record;
   --  <dref>ReliableWriterCacheChangedStatus</dref>
   --  <dref name="Empty_Reliable_Writer_Cache">ReliableWriterCacheChangedStatus_empty_reliable_writer_cache</dref>
   --  <dref name="Full_Reliable_Writer_Cache">ReliableWriterCacheChangedStatus_full_reliable_writer_cache</dref>
   --  <dref name="Low_Watermark_Reliable_Writer_Cache">ReliableWriterCacheChangedStatus_low_watermark_reliable_writer_cache</dref>
   --  <dref name="High_Watermark_Reliable_Writer_Cache">ReliableWriterCacheChangedStatus_high_watermark_reliable_writer_cache</dref>
   --  <dref name="Unacknowledged_Sample_Count">ReliableWriterCacheChangedStatus_unacknowledged_sample_count</dref>
   --  <dref name="Unacknowledged_Sample_Count_peak">ReliableWriterCacheChangedStatus_unacknowledged_sample_count_peak</dref>

   pragma Convention (C, ReliableWriterCacheChangedStatus);

   ReliableWriterCacheChangedStatus_INITIALIZER : constant ReliableWriterCacheChangedStatus :=
                                                    (Empty_Reliable_Writer_Cache          => ReliableWriterCacheEventCount_INITIALIZER,
                                                     Full_Reliable_Writer_Cache           => ReliableWriterCacheEventCount_INITIALIZER,
                                                     Low_Watermark_Reliable_Writer_Cache  => ReliableWriterCacheEventCount_INITIALIZER,
                                                     High_Watermark_Reliable_Writer_Cache => ReliableWriterCacheEventCount_INITIALIZER,
                                                     Unacknowledged_Sample_Count          => 0,
                                                     Unacknowledged_Sample_Count_Peak     => 0);

   --  ----------------------------------------------------------
   --                  ReliableReaderActivityChangedStatus
   --  ----------------------------------------------------------

   type ReliableReaderActivityChangedStatus is record
      Active_Count          : aliased Long := 0;
      Inactive_Count        : aliased Long := 0;
      Active_Count_Change   : aliased Long := 0;
      Inactive_Count_Change : aliased Long := 0;
      Last_Instance_Handle  : aliased InstanceHandle_T := Null_InstanceHandle_T;
   end record;
   --  <dref>ReliableReaderActivityChangedStatus</dref>
   --  <dref name="Acitve_Count">ReliableReaderActivityChangedStatus_active_count</dref>
   --  <dref name="Inacitve_Count">ReliableReaderActivityChangedStatus_inactive_count</dref>
   --  <dref name="Active_Count_change">ReliableReaderActivityChangedStatus_active_count_change</dref>
   --  <dref name="Inactive_Count_change">ReliableReaderActivityChangedStatus_inactive_count_change</dref>
   --  <dref name="Last_Instance_Handle">ReliableReaderActivityChangedStatus_last_instance_handle</dref>

   pragma Convention (C, ReliableReaderActivityChangedStatus);

   ReliableReaderActivityChangedStatus_INITIALIZER : constant  ReliableReaderActivityChangedStatus :=
                                                       (Active_Count          => 0,
                                                        Inactive_Count        => 0,
                                                        Active_Count_Change   => 0,
                                                        Inactive_Count_Change => 0,
                                                        Last_Instance_Handle  => Null_InstanceHandle_T);

   --  ----------------------------------------------------------
   --                  AcknowledgmentInfo
   --  ----------------------------------------------------------

   type AcknowledgmentInfo is record
      Subscription_Handle : aliased InstanceHandle_T := Null_InstanceHandle_T;
      Sample_Identity     : aliased SampleIdentity_T;
      Cookie              : aliased Cookie_T;
      Valid_Response_Data : aliased Boolean := False;
      Response_Data       : aliased AckResponseData_T;
   end record;
   --  <dref>AcknowledgmentInfo</dref>
   --  <dref name="Subscription_Handle">AcknowledgmentInfo_subscription_handle</dref>
   --  <dref name="Sample_Identity">AcknowledgmentInfo_sample_identity</dref>
   --  <dref name="Cookie">AcknowledgmentInfo_cookie</dref>
   --  <dref name="Valid_Response_Data">AcknowledgmentInfo_valid_response_data</dref>
   --  <dref name="Response_Data">AcknowledgmentInfo_response_data</dref>

   pragma Convention (C, AcknowledgmentInfo);
   type AcknowledgmentInfo_Access is access all AcknowledgmentInfo;

   type ServiceRequestAcceptedStatus is new RTIDDS.Low_Level.ndds_dds_c_dds_c_publication_h.DDS_ServiceRequestAcceptedStatus;
   type ServiceRequestAcceptedStatus_Access is access all  ServiceRequestAcceptedStatus with Storage_Size => 0;
   --  ----------------------------------------------------------
   --                  DataWriterQos
   --  ----------------------------------------------------------

   type DataWriterQos is new Ada.Finalization.Limited_Controlled with record
   ---
      Durability             : aliased DurabilityQosPolicy;
      Durability_Service     : aliased DurabilityServiceQosPolicy;
      Deadline               : aliased DeadlineQosPolicy;
      Latency_Budget         : aliased LatencyBudgetQosPolicy;
      Liveliness             : aliased LivelinessQosPolicy;
      Reliability            : aliased ReliabilityQosPolicy;
      Destination_Order      : aliased DestinationOrderQosPolicy;
      History                : aliased HistoryQosPolicy;
      Resource_Limits        : aliased ResourceLimitsQosPolicy;
      Transport_Priority     : aliased TransportPriorityQosPolicy;
      Lifespan               : aliased LifespanQosPolicy;
      User_Data              : aliased UserDataQosPolicy;
      Ownership              : aliased OwnershipQosPolicy;
      Ownership_Strength     : aliased OwnershipStrengthQosPolicy;
      Writer_Data_Lifecycle  : aliased WriterDataLifecycleQosPolicy;
      Representation         : aliased DataRepresentationQosPolicy;
      Data_Tags              : aliased DataTagQosPolicy;
      -- --- Extensions: ----------------------------------------------------
      Writer_Resource_Limits : aliased DataWriterResourceLimitsQosPolicy;
      Protocol               : aliased DataWriterProtocolQosPolicy;
      Transport_Selection    : aliased TransportSelectionQosPolicy;
      Unicast                : aliased TransportUnicastQosPolicy;
      Encapsulation          : aliased TransportEncapsulationQosPolicy;
      Publish_Mode           : aliased PublishModeQosPolicy;
      Property               : aliased PropertyQosPolicy;
      Service                : aliased ServiceQosPolicy;
      Batch                  : aliased BatchQosPolicy;
      Multi_Channel          : aliased MultiChannelQosPolicy;
      Availability           : aliased AvailabilityQosPolicy;
      Publication_Name       : aliased EntityNameQosPolicy;
      Topic_Query_Dispatch   : aliased TopicQueryDispatchQosPolicy;
      Transfer_Mode          : aliased DataWriterTransferModeQosPolicy;
      Type_Support           : aliased TypeSupportQosPolicy;
   end record;
   --  <dref>DataWriterQos</dref>
   --  <dref name="Durability">DataWriterQos_durability</dref>
   --  <dref name="Durability_Service">DataWriterQos_durability_service</dref>
   --  <dref name="Deadline">DataWriterQos_deadline</dref>
   --  <dref name="Latency_Budget">DataWriterQos_latency_budget</dref>
   --  <dref name="Liveliness">DataWriterQos_liveliness</dref>
   --  <dref name="Reliability">DataWriterQos_reliability</dref>
   --  <dref name="Destination_Order">DataWriterQos_destination_order</dref>
   --  <dref name="History">DataWriterQos_history</dref>
   --  <dref name="Resource_Limits">DataWriterQos_resource_limits</dref>
   --  <dref name="Transport_Priority">DataWriterQos_transport_priority</dref>
   --  <dref name="Lifespan">DataWriterQos_lifespan</dref>
   --  <dref name="User_Data">DataWriterQos_user_data</dref>
   --  <dref name="Ownership">DataWriterQos_ownership</dref>
   --  <dref name="Ownership_Strength">DataWriterQos_ownership_strength</dref>
   --  <dref name="Writer_Data_Lifecycle">DataWriterQos_writer_data_lifecycle</dref>
   --  <dref name="Representation">DataWriterQos_representation</dref>
   --  <dref name="Data_Tags">DataWriterQos_data_tags</dref>
   --  <dref name="Writer_Resource_Limits">DataWriterQos_writer_resource_limits</dref>
   --  <dref name="Protocol">DataWriterQos_protocol</dref>
   --  <dref name="Transport_Selection">DataWriterQos_transport_selection</dref>
   --  <dref name="Unicast">DataWriterQos_unicast</dref>
   --  <dref name="Encapsulation">DataWriterQos_encapsulation</dref>
   --  <dref name="Publish_Mode">DataWriterQos_publish_mode</dref>
   --  <dref name="Property">DataWriterQos_property</dref>
   --  <dref name="Service">DataWriterQos_service</dref>
   --  <dref name="batch">DataWriterQos_batch</dref>
   --  <dref name="multi_channel">DataWriterQos_multi_channel</dref>
   --  <dref name="Availability">DataWriterQos_availability</dref>
   --  <dref name="publication_name">DataWriterQos_publication_name</dref>
   --  <dref name="Topic_Query_Dispatch">DataWriterQos_topic_query_dispatch</dref>
   --  <dref name="Transfer_Mode">DataWriterQos_transfer_mode</dref>
   --  <dref name="Type_Support">DataWriterQos_type_support</dref>

   pragma Convention (C, DataWriterQos);

   --  <dref>DataWriterQos_initialize</dref>
   procedure Initialize
     (Self : in out DataWriterQos);

   --  <dref>DataWriterQos_finalize</dref>
   procedure Finalize
     (Self : in out DataWriterQos);

   --  <dref>DataWriterQos_copy</dref>
   procedure Copy
     (Target : out DataWriterQos;
      Source : in DataWriterQos);

   --  ----------------------------------------------------------
   --                  PublisherQos
   --  ----------------------------------------------------------

   type PublisherQos is  new Ada.Finalization.Limited_Controlled with record
      Presentation           : PresentationQosPolicy;
      Partition              : PartitionQosPolicy;
      Group_Data             : GroupDataQosPolicy;
      Entity_Factory         : EntityFactoryQosPolicy;
      -- --- Extensions: ----------------------------------------------------
      Asynchronous_Publisher : aliased AsynchronousPublisherQosPolicy;
      Exclusive_Area         : aliased ExclusiveAreaQosPolicy;
      Protocol               : aliased PublisherProtocolQosPolicy;
      Publisher_Name         : aliased EntityNameQosPolicy;
   end record;
   --  <dref>PublisherQos</dref>
   --  <dref name="Presentation">PublisherQos_presentation</dref>
   --  <dref name="Partition">PublisherQos_partition</dref>
   --  <dref name="Group_Data">PublisherQos_group_data</dref>
   --  <dref name="Entity_Factory">PublisherQos_entity_factory</dref>
   --  <dref name="Asynchronous_Publisher">PublisherQos_asynchronous_publisher</dref>
   --  <dref name="Exclusive_Area">PublisherQos_exclusive_area</dref>
   --  <dref internal="True" name="Protocol">PublisherQos_protocol</dref>
   --  <dref name="publisher_name">PublisherQos_publisher_name</dref>

   pragma Convention (C, PublisherQos);
   type PublisherQos_Access is access PublisherQos;

   --  <dref>PublisherQos_initialize</dref>
   procedure Initialize
     (Self : in out PublisherQos);

   --  <dref>PublisherQos_finalize</dref>
   procedure Finalize
     (Self : in out PublisherQos);

   --  <dref>PublisherQos_copy</dref>
   procedure Copy
     (Target : out PublisherQos;
      Source : in  PublisherQos);

   --  ----------------------------------------------------------
   --                  DataWriterCacheStatus
   --  ----------------------------------------------------------

   type DataWriterCacheStatus is record
      Sample_Count_Peak : aliased Long_Long;
      Sample_Count      : aliased Long_Long;
   end record;
   --  <dref>DataWriterCacheStatus</dref>
   --  <dref name="sample_count_peak">DataWriterCacheStatus_sample_count_peak</dref>
   --  <dref name="sample_count">DataWriterCacheStatus_sample_count</dref>

   pragma Convention (C, DataWriterCacheStatus);

   --  NOTE: filtered_sample_* fields have been removed from the documentation (see CORE-5977)
   --  and may eventually be removed from this structure (CORE-5953)
   type DataWriterProtocolStatus is record
      Pushed_Sample_Count                                  : aliased DDS.Long_Long := 0;
      Pushed_Sample_Count_Change                           : aliased DDS.Long_Long := 0;
      Pushed_Sample_Bytes                                  : aliased DDS.Long_Long := 0;
      Pushed_Sample_Bytes_Change                           : aliased DDS.Long_Long := 0;
      Filtered_Sample_Count                                : aliased DDS.Long_Long := 0;
      Filtered_Sample_Count_Change                         : aliased DDS.Long_Long := 0;
      Filtered_Sample_Bytes                                : aliased DDS.Long_Long := 0;
      Filtered_Sample_Bytes_Change                         : aliased DDS.Long_Long := 0;
      Sent_Heartbeat_Count                                 : aliased DDS.Long_Long := 0;
      Sent_Heartbeat_Count_Change                          : aliased DDS.Long_Long := 0;
      Sent_Heartbeat_Bytes                                 : aliased DDS.Long_Long := 0;
      Sent_Heartbeat_Bytes_Change                          : aliased DDS.Long_Long := 0;
      Pulled_Sample_Count                                  : aliased DDS.Long_Long := 0;
      Pulled_Sample_Count_Change                           : aliased DDS.Long_Long := 0;
      Pulled_Sample_Bytes                                  : aliased DDS.Long_Long := 0;
      Pulled_Sample_Bytes_Change                           : aliased DDS.Long_Long := 0;
      Received_Ack_Count                                   : aliased DDS.Long_Long := 0;
      Received_Ack_Count_Change                            : aliased DDS.Long_Long := 0;
      Received_Ack_Bytes                                   : aliased DDS.Long_Long := 0;
      Received_Ack_Bytes_Change                            : aliased DDS.Long_Long := 0;
      Received_Nack_Count                                  : aliased DDS.Long_Long := 0;
      Received_Nack_Count_Change                           : aliased DDS.Long_Long := 0;
      Received_Nack_Bytes                                  : aliased DDS.Long_Long := 0;
      Received_Nack_Bytes_Change                           : aliased DDS.Long_Long := 0;
      Sent_Gap_Count                                       : aliased DDS.Long_Long := 0;
      Sent_Gap_Count_Change                                : aliased DDS.Long_Long := 0;
      Sent_Gap_Bytes                                       : aliased DDS.Long_Long := 0;
      Sent_Gap_Bytes_Change                                : aliased DDS.Long_Long := 0;
      Rejected_Sample_Count                                : aliased DDS.Long_Long := 0;
      Rejected_Sample_Count_Change                         : aliased DDS.Long_Long := 0;
      Send_Window_Size                                     : aliased DDS.Long := 0;
      First_Available_Sample_Sequence_Number               : aliased DDS.SequenceNumber_T;
      Last_Available_Sample_Sequence_Number                : aliased DDS.SequenceNumber_T;
      First_Unacknowledged_Sample_Sequence_Number          : aliased DDS.SequenceNumber_T;
      First_Available_Sample_Virtual_Sequence_Number       : aliased DDS.SequenceNumber_T;
      Last_Available_Sample_Virtual_Sequence_Number        : aliased DDS.SequenceNumber_T;
      First_Unacknowledged_Sample_Virtual_Sequence_Number  : aliased DDS.SequenceNumber_T;
      First_Unacknowledged_Sample_Subscription_Handle      : aliased DDS.InstanceHandle_T;
      First_Unelapsed_Keep_Duration_Sample_Sequence_Number : aliased DDS.SequenceNumber_T;
   end record;
   --  <dref>DataWriterProtocolStatus</dref>
   --  <dref name="pushed_sample_count">DataWriterProtocolStatus_pushed_sample_count</dref>
   --  <dref name="pushed_sample_count_change">DataWriterProtocolStatus_pushed_sample_count_change</dref>
   --  <dref name="pushed_sample_bytes">DataWriterProtocolStatus_pushed_sample_bytes</dref>
   --  <dref name="pushed_sample_bytes_change">DataWriterProtocolStatus_pushed_sample_bytes_change</dref>
   --  <dref name="sent_heartbeat_count">DataWriterProtocolStatus_sent_heartbeat_count</dref>
   --  <dref name="sent_heartbeat_count_change">DataWriterProtocolStatus_sent_heartbeat_count_change</dref>
   --  <dref name="sent_heartbeat_bytes">DataWriterProtocolStatus_sent_heartbeat_bytes</dref>
   --  <dref name="sent_heartbeat_bytes_change">DataWriterProtocolStatus_sent_heartbeat_bytes_change</dref>
   --  <dref name="pulled_sample_count">DataWriterProtocolStatus_pulled_sample_count</dref>
   --  <dref name="pulled_sample_count_change">DataWriterProtocolStatus_pulled_sample_count_change</dref>
   --  <dref name="pulled_sample_bytes">DataWriterProtocolStatus_pulled_sample_bytes</dref>
   --  <dref name="pulled_sample_bytes_change">DataWriterProtocolStatus_pulled_sample_bytes_change</dref>
   --  <dref name="received_ack_count">DataWriterProtocolStatus_received_ack_count</dref>
   --  <dref name="received_ack_count_change">DataWriterProtocolStatus_received_ack_count_change</dref>
   --  <dref name="received_ack_bytes">DataWriterProtocolStatus_received_ack_bytes</dref>
   --  <dref name="received_ack_bytes_change">DataWriterProtocolStatus_received_ack_bytes_change</dref>
   --  <dref name="received_nack_count">DataWriterProtocolStatus_received_nack_count</dref>
   --  <dref name="received_nack_count_change">DataWriterProtocolStatus_received_nack_count_change</dref>
   --  <dref name="received_nack_bytes">DataWriterProtocolStatus_received_nack_bytes</dref>
   --  <dref name="received_nack_bytes_change">DataWriterProtocolStatus_received_nack_bytes_change</dref>
   --  <dref name="sent_gap_count">DataWriterProtocolStatus_sent_gap_count</dref>
   --  <dref name="sent_gap_count_change">DataWriterProtocolStatus_sent_gap_count_change</dref>
   --  <dref name="sent_gap_bytes">DataWriterProtocolStatus_sent_gap_bytes</dref>
   --  <dref name="sent_gap_bytes_change">DataWriterProtocolStatus_sent_gap_bytes_change</dref>
   --  <dref name="rejected_sample_count">DataWriterProtocolStatus_rejected_sample_count</dref>
   --  <dref name="rejected_sample_count_change">DataWriterProtocolStatus_rejected_sample_count_change</dref>
   --  <dref name="send_window_size">DataWriterProtocolStatus_send_window_size</dref>
   --  <dref name="first_available_sample_sequence_number">DataWriterProtocolStatus_first_available_sample_sequence_number</dref>
   --  <dref name="last_available_sample_sequence_number">DataWriterProtocolStatus_last_available_sample_sequence_number</dref>
   --  <dref name="first_unacknowledged_sample_sequence_number">DataWriterProtocolStatus_first_unacknowledged_sample_sequence_number</dref>
   --  <dref name="first_available_sample_virtual_sequence_number">DataWriterProtocolStatus_first_available_sample_virtual_sequence_number</dref>
   --  <dref name="last_available_sample_virtual_sequence_number">DataWriterProtocolStatus_last_available_sample_virtual_sequence_number</dref>
   --  <dref name="first_unacknowledged_sample_virtual_sequence_number">DataWriterProtocolStatus_first_unacknowledged_sample_virtual_sequence_number</dref>
   --  <dref name="first_unacknowledged_sample_subscription_handle">DataWriterProtocolStatus_first_unacknowledged_sample_subscription_handle</dref>
   --  <dref name="first_unelapsed_keep_duration_sample_sequence_number">DataWriterProtocolStatus_first_unelapsed_keep_duration_sample_sequence_number</dref>

   pragma Convention (C_Pass_By_Copy, DataWriterProtocolStatus);  -- ndds/dds_c/dds_c_publication.h:281

   --
   --  dds/dds_c_subscription.h
   --

   --  ----------------------------------------------------------
   --                  RequestedDeadlineMissedStatus
   --  ----------------------------------------------------------

   type RequestedDeadlineMissedStatus is record
      Total_Count          : aliased Long := 0;
      Total_Count_Change   : aliased Long := 0;
      Last_Instance_Handle : aliased InstanceHandle_T := Null_InstanceHandle_T;
   end record;
   --  <dref>RequestedDeadlineMissedStatus</dref>
   --  <dref name="Total_Count">RequestedDeadlineMissedStatus_total_count</dref>
   --  <dref name="Total_Count_Change">RequestedDeadlineMissedStatus_total_count_change</dref>
   --  <dref name="Last_Instance_Handle">RequestedDeadlineMissedStatus_last_instance_handle</dref>

   pragma Convention (C, RequestedDeadlineMissedStatus);

   RequestedDeadlineMissedStatus_INITIALIZER : constant RequestedDeadlineMissedStatus :=
                                                 (Total_Count              => 0,
                                                  Total_Count_Change       => 0,
                                                  Last_Instance_Handle     => Null_InstanceHandle_T);


   --  ----------------------------------------------------------
   --                  LivelinessChangedStatus
   --  ----------------------------------------------------------

   type LivelinessChangedStatus is record
      Alive_Count             : aliased Long := 0;
      Not_Alive_Count         : aliased Long := 0;
      Alive_Count_Change      : aliased Long := 0;
      Not_Alive_Count_Change  : aliased Long := 0;
      Last_Publication_Handle : aliased InstanceHandle_T := Null_InstanceHandle_T;
   end record;
   --  <dref>LivelinessChangedStatus</dref>
   --  <dref name="Alive_Count">LivelinessChangedStatus_alive_count</dref>
   --  <dref name="Not_Alive_Count">LivelinessChangedStatus_not_alive_count</dref>
   --  <dref name="Alive_Count_Change">LivelinessChangedStatus_alive_count_change</dref>
   --  <dref name="Not_Alive_Count_Change">LivelinessChangedStatus_not_alive_count_change</dref>
   --  <dref name="Last_Publication_Handle">LivelinessChangedStatus_last_publication_handle</dref>

   pragma Convention (C, LivelinessChangedStatus);

   LivelinessChangedStatus_INITIALIZER : constant LivelinessChangedStatus :=
                                           (Alive_Count             => 0,
                                            Not_Alive_Count         => 0,
                                            Alive_Count_Change      => 0,
                                            Not_Alive_Count_Change  => 0,
                                            Last_Publication_Handle => Null_InstanceHandle_T);

   --  ----------------------------------------------------------
   --                  RequestedIncompatibleQosStatus
   --  ----------------------------------------------------------

   type RequestedIncompatibleQosStatus is record
      Total_Count        : aliased Long := 0;
      Total_Count_Change : aliased Long := 0;
      Last_Policy_Id     : aliased QosPolicyId_T := INVALID_QOS_POLICY_ID;
      Policies           : aliased QosPolicyCount_Seq.Sequence;
   end record;
   --  <dref>RequestedIncompatibleQosStatus</dref>
   --  <dref name="Total_Count">RequestedIncompatibleQosStatus_total_count</dref>
   --  <dref name="Total_Count_Change">RequestedIncompatibleQosStatus_total_count_change</dref>
   --  <dref name="Last_Policy_Id">RequestedIncompatibleQosStatus_last_policy_id</dref>
   --  <dref name="Policies">RequestedIncompatibleQosStatus_policies</dref>

   pragma Convention (C, RequestedIncompatibleQosStatus);
   type RequestedIncompatibleQosStatus_Access is access all RequestedIncompatibleQosStatus;

   --     RequestedIncompatibleQosStatus_INITIALIZER : constant RequestedIncompatibleQosStatus :=
   --                                                    (Total_Count        => 0,
   --                                                     Total_Count_Change => 0,
   --                                                     Last_Policy_Id     => INVALID_QOS_POLICY_ID,
   --                                                     Policies           => QosPolicyCount_Seq.DEFAULT_SEQUENCE);

   --  ----------------------------------------------------------
   --                  SampleLostStatusKind
   --  ----------------------------------------------------------

   type SampleLostStatusKind is new Unsigned_Long;
   --  <dref>SampleLostStatusKind</dref>

   NOT_LOST : constant SampleLostStatusKind := 0;
   --  <dref>SampleLostStatusKind_NOT_LOST</dref>

   LOST_BY_WRITER : constant SampleLostStatusKind := 1;
   --  <dref>SampleLostStatusKind_LOST_BY_WRITER</dref>

   LOST_BY_INSTANCES_LIMIT : constant SampleLostStatusKind := 2;
   --  <dref>SampleLostStatusKind_LOST_BY_INSTANCES_LIMIT</dref>

   LOST_BY_REMOTE_WRITERS_PER_INSTANCE_LIMIT : constant SampleLostStatusKind := 3;
   --  <dref>SampleLostStatusKind_LOST_BY_REMOTE_WRITERS_PER_INSTANCE_LIMIT</dref>

   LOST_BY_INCOMPLETE_COHERENT_SET : constant SampleLostStatusKind := 4;
   --  <dref>SampleLostStatusKind_LOST_BY_LARGE_COHERENT_SET</dref>

   LOST_BY_LARGE_COHERENT_SET : constant SampleLostStatusKind := 5;
   --  <dref>SampleLostStatusKind_LOST_BY_LARGE_COHERENT_SET</dref>

   LOST_BY_SAMPLES_PER_REMOTE_WRITER_LIMIT : constant SampleLostStatusKind := 6;
   --  <dref>SampleLostStatusKind_LOST_BY_SAMPLES_PER_REMOTE_WRITER_LIMIT</dref>

   LOST_BY_VIRTUAL_WRITERS_LIMIT : constant SampleLostStatusKind := 7;
   --  <dref name="LOST_BY_VIRTUAL_WRITERS_LIMIT">SampleLostStatusKind_LOST_BY_VIRTUAL_WRITERS_LIMIT</dref>

   LOST_BY_REMOTE_WRITERS_PER_SAMPLE_LIMIT : constant SampleLostStatusKind := 8;
   --  <dref name="LOST_BY_REMOTE_WRITERS_PER_SAMPLE_LIMIT">SampleLostStatusKind_LOST_BY_REMOTE_WRITERS_PER_SAMPLE_LIMIT</dref>

   LOST_BY_AVAILABILITY_WAITING_TIME : constant SampleLostStatusKind := 9;
   --  <dref name="LOST_BY_AVAILABILITY_WAITING_TIME">SampleLostStatusKind_LOST_BY_AVAILABILITY_WAITING_TIME</dref>

   LOST_BY_REMOTE_WRITER_SAMPLES_PER_VIRTUAL_QUEUE_LIMIT : constant SampleLostStatusKind := 10;
   --  <dref name="LOST_BY_REMOTE_WRITER_SAMPLES_PER_VIRTUAL_QUEUE_LIMIT">SampleLostStatusKind_LOST_BY_REMOTE_WRITER_SAMPLES_PER_VIRTUAL_QUEUE_LIMIT</dref>

   LOST_BY_OUT_OF_MEMORY : constant SampleLostStatusKind := 11;
   --  <dref name="LOST_BY_OUT_OF_MEMORY">SampleLostStatusKind_LOST_BY_OUT_OF_MEMORY</dref>

   LOST_BY_UNKNOWN_INSTANCE : constant SampleLostStatusKind := 12;
   --  <dref name="LOST_BY_UNKNOWN_INSTANCE">SampleLostStatusKind_LOST_BY_UNKNOWN_INSTANCE</dref>

   --  type SampleLostStatusKind_Access is access constant SampleLostStatusKind;

   --  ----------------------------------------------------------
   --                  SampleLostStatus
   --  ----------------------------------------------------------

   type SampleLostStatus is record
      Total_Count        : aliased Long := 0;
      Total_Count_Change : aliased Long := 0;
      Last_Reason        : aliased SampleLostStatusKind := NOT_LOST;
   end record;
   --  <dref>SampleLostStatus</dref>
   --  <dref name="Total_Count">SampleLostStatus_total_count</dref>
   --  <dref name="Total_Count_Change">SampleLostStatus_total_count_change</dref>
   --  <dref name="Last_Reason">SampleLostStatus_last_reason</dref>

   pragma Convention (C, SampleLostStatus);

   SampleLostStatus_INITIALIZER : constant SampleLostStatus :=
                                    (Total_Count        => 0,
                                     Total_Count_Change => 0,
                                     Last_Reason        => NOT_LOST);

   --  ----------------------------------------------------------
   --                  SampleRejectedStatus
   --  ----------------------------------------------------------

   type SampleRejectedStatusKind is
     (NOT_REJECTED,
      REJECTED_BY_INSTANCES_LIMIT,
      REJECTED_BY_SAMPLES_LIMIT,
      REJECTED_BY_SAMPLES_PER_INSTANCE_LIMIT,
      REJECTED_BY_REMOTE_WRITERS_LIMIT,
      REJECTED_BY_REMOTE_WRITERS_PER_INSTANCE_LIMIT,
      REJECTED_BY_SAMPLES_PER_REMOTE_WRITER_LIMIT,
      REJECTED_BY_VIRTUAL_WRITERS_LIMIT,
      REJECTED_BY_REMOTE_WRITERS_PER_SAMPLE_LIMIT,
      REJECTED_BY_REMOTE_WRITER_SAMPLES_PER_VIRTUAL_QUEUE_LIMIT,
      REJECTED_BY_UNKNOWN_INSTANCE);
   --  <dref>SampleRejectedStatusKind</dref>
   --  <dref name="NOT_REJECTED">SampleRejectedStatusKind_NOT_REJECTED</dref>
   --  <dref name="REJECTED_BY_INSTANCES_LIMIT">SampleRejectedStatusKind_REJECTED_BY_INSTANCES_LIMIT</dref>
   --  <dref name="REJECTED_BY_SAMPLES_LIMIT">SampleRejectedStatusKind_REJECTED_BY_SAMPLES_LIMIT</dref>
   --  <dref name="REJECTED_BY_SAMPLES_PER_INSTANCE_LIMIT">SampleRejectedStatusKind_REJECTED_BY_SAMPLES_PER_INSTANCE_LIMIT</dref>
   --  <dref name="REJECTED_BY_REMOTE_WRITERS_LIMIT">SampleRejectedStatusKind_REJECTED_BY_REMOTE_WRITERS_LIMIT</dref>
   --  <dref name="REJECTED_BY_REMOTE_WRITERS_PER_INSTANCE_LIMIT">SampleRejectedStatusKind_REJECTED_BY_REMOTE_WRITERS_PER_INSTANCE_LIMIT</dref>
   --  <dref name="REJECTED_BY_SAMPLES_PER_REMOTE_WRITER_LIMIT">SampleRejectedStatusKind_REJECTED_BY_SAMPLES_PER_REMOTE_WRITER_LIMIT</dref>
   --  <dref name="REJECTED_BY_VIRTUAL_WRITERS_LIMIT">SampleRejectedStatusKind_REJECTED_BY_VIRTUAL_WRITERS_LIMIT</dref>
   --  <dref name="REJECTED_BY_REMOTE_WRITERS_PER_SAMPLE_LIMIT">SampleRejectedStatusKind_REJECTED_BY_REMOTE_WRITERS_PER_SAMPLE_LIMIT</dref>
   --  <dref name="REJECTED_BY_REMOTE_WRITER_SAMPLES_PER_VIRTUAL_QUEUE_LIMIT>SampleRejectedStatusKind_REJECTED_BY_REMOTE_WRITER_SAMPLES_PER_VIRTUAL_QUEUE_LIMIT</dref>
   --  <dref name="REJECTED_BY_UNKNOWN_INSTANCE>SampleRejectedStatusKind_REJECTED_BY_UNKNOWN_INSTANCE</dref>


   pragma Convention (C, SampleRejectedStatusKind);

   for SampleRejectedStatusKind use
     (NOT_REJECTED                                              => 0,
      REJECTED_BY_INSTANCES_LIMIT                               => 1,
      REJECTED_BY_SAMPLES_LIMIT                                 => 2,
      REJECTED_BY_SAMPLES_PER_INSTANCE_LIMIT                    => 3,
      REJECTED_BY_REMOTE_WRITERS_LIMIT                          => 4,
      REJECTED_BY_REMOTE_WRITERS_PER_INSTANCE_LIMIT             => 5,
      REJECTED_BY_SAMPLES_PER_REMOTE_WRITER_LIMIT               => 6,
      REJECTED_BY_VIRTUAL_WRITERS_LIMIT                         => 7,
      REJECTED_BY_REMOTE_WRITERS_PER_SAMPLE_LIMIT               => 8,
      REJECTED_BY_REMOTE_WRITER_SAMPLES_PER_VIRTUAL_QUEUE_LIMIT => 9,
      REJECTED_BY_UNKNOWN_INSTANCE                              => 10);

   type SampleRejectedStatus is record
      Total_Count          : aliased Long := 0;
      Total_Count_Change   : aliased Long := 0;
      Last_Reason          : aliased SampleRejectedStatusKind := NOT_REJECTED;
      Last_Instance_Handle : aliased InstanceHandle_T := Null_InstanceHandle_T;
   end record;
   --  <dref>SampleRejectedStatus</dref>
   --  <dref name="Total_Count">SampleRejectedStatus_total_count</dref>
   --  <dref name="Total_Count_Change">SampleRejectedStatus_total_count_change</dref>
   --  <dref name="Last_Reason">SampleRejectedStatus_last_reason</dref>
   --  <dref name="Last_Instance_Handle">SampleRejectedStatus_last_instance_handle</dref>

   SampleRejectedStatus_INITIALIZER : constant SampleRejectedStatus :=
                                        (Total_Count          => 0,
                                         Total_Count_Change   => 0,
                                         Last_Reason          => NOT_REJECTED,
                                         Last_Instance_Handle => Null_InstanceHandle_T);

   --  ----------------------------------------------------------
   --                  SubscriptionMatchedStatus
   --  ----------------------------------------------------------

   type SubscriptionMatchedStatus is limited record
      Total_Count             : aliased Long := 0;
      Total_Count_Change      : aliased Long := 0;
      Current_Count           : aliased Long := 0;
      Current_Count_Peak      : aliased Long := 0;
      Current_Count_Change    : aliased Long := 0;
      Last_Publication_Handle : aliased InstanceHandle_T := Null_InstanceHandle_T;
   end record;
   --  <dref>SubscriptionMatchedStatus</dref>
   --  <dref name="Total_Count">SubscriptionMatchedStatus_total_count</dref>
   --  <dref name="Total_Count_Change">SubscriptionMatchedStatus_total_count_change</dref>
   --  <dref name="Current_Count">SubscriptionMatchedStatus_current_count</dref>
   --  <dref name="Current_Count_Peak">SubscriptionMatchedStatus_current_count_peak</dref>
   --  <dref name="Current_Count_Change">SubscriptionMatchedStatus_current_count_change</dref>
   --  <dref name="Last_Publication_Handle">SubscriptionMatchedStatus_last_publication_handle</dref>

   pragma Convention (C, SubscriptionMatchedStatus);

   SubscriptionMatchedStatus_INITIALIZER : constant SubscriptionMatchedStatus :=
                                             (Total_Count              => 0,
                                              Total_Count_Change       => 0,
                                              Current_Count            => 0,
                                              Current_Count_Peak       => 0,
                                              Current_Count_Change     => 0,
                                              Last_Publication_Handle  => Null_InstanceHandle_T);

   --  ----------------------------------------------------------
   --                  DataReaderCacheStatus
   --  ----------------------------------------------------------

   type DataReaderCacheStatus is record
      Sample_Count_Peak   : aliased Long_Long := 0;
      Sample_Count        : aliased Long_Long := 0;
      Instance_Count      : aliased Long_Long := 0;
      Instance_Count_Peak : aliased Long_Long := 0;
   end record;
   --  <dref>DataReaderCacheStatus</dref>
   --  <dref name="Sample_Count_Peak">DataReaderCacheStatus_sample_count_peak</dref>
   --  <dref name="Sample_Count">DataReaderCacheStatus_sample_count</dref>
   --  <dref internal="true" name="Instance_Count">DataReaderCacheStatus_instance_count</dref>
   --  <dref internal="true" name="Instance_Count_Peak">DataReaderCacheStatus_instance_count_peak</dref>

   pragma Convention (C, DataReaderCacheStatus);

   DataReaderCacheStatus_INITIALIZER : constant DataReaderCacheStatus :=
                                         (Sample_Count_Peak   => 0,
                                          Sample_Count        => 0,
                                          Instance_Count      => 0,
                                          Instance_Count_Peak => 0);

   --  ----------------------------------------------------------
   --                  DataReaderProtocolStatus
   --  ----------------------------------------------------------

   type DataReaderProtocolStatus is record
      Received_Sample_Count                  : aliased Long_Long := 0;
      Received_Sample_Count_Change           : aliased Long_Long := 0;
      Received_Sample_Bytes                  : aliased Long_Long := 0;
      Received_Sample_Bytes_Change           : aliased Long_Long := 0;
      Duplicate_Sample_Count                 : aliased Long_Long := 0;
      Duplicate_Sample_Count_Change          : aliased Long_Long := 0;
      Duplicate_Sample_Bytes                 : aliased Long_Long := 0;
      Duplicate_Sample_Bytes_Change          : aliased Long_Long := 0;
      Filtered_Sample_Count                  : aliased Long_Long := 0;
      Filtered_Sample_Count_Change           : aliased Long_Long := 0;
      Filtered_Sample_Bytes                  : aliased Long_Long := 0;
      Filtered_Sample_Bytes_Change           : aliased Long_Long := 0;
      Received_Heartbeat_Count               : aliased Long_Long := 0;
      Received_Heartbeat_Count_Change        : aliased Long_Long := 0;
      Received_Heartbeat_Bytes               : aliased Long_Long := 0;
      Received_Heartbeat_Bytes_Change        : aliased Long_Long := 0;
      Sent_Ack_Count                         : aliased Long_Long := 0;
      Sent_Ack_Count_Change                  : aliased Long_Long := 0;
      Sent_Ack_Bytes                         : aliased Long_Long := 0;
      Sent_Ack_Bytes_Change                  : aliased Long_Long := 0;
      Sent_Nack_Count                        : aliased Long_Long := 0;
      Sent_Nack_Count_Change                 : aliased Long_Long := 0;
      Sent_Nack_Bytes                        : aliased Long_Long := 0;
      Sent_Nack_Bytes_Change                 : aliased Long_Long := 0;
      Received_Gap_Count                     : aliased Long_Long := 0;
      Received_Gap_Count_Change              : aliased Long_Long := 0;
      Received_Gap_Bytes                     : aliased Long_Long := 0;
      Received_Gap_Bytes_Change              : aliased Long_Long := 0;
      Rejected_Sample_Count                  : aliased Long_Long := 0;
      Rejected_Sample_Count_Change           : aliased Long_Long := 0;
      First_Available_Sample_Sequence_Number : aliased SequenceNumber_T;
      Last_Available_Sample_Sequence_Number  : aliased SequenceNumber_T;
      Last_Committed_Sample_Sequence_Number  : aliased SequenceNumber_T;
      Uncommitted_Sample_Count               : aliased Long := 0;
   end record;
   --  <dref>DataReaderProtocolStatus</dref>
   --  <dref name="received_sample_count">DataReaderProtocolStatus_received_sample_count</dref>
   --  <dref name="received_sample_count_change">DataReaderProtocolStatus_received_sample_count_change</dref>
   --  <dref name="received_sample_bytes">DataReaderProtocolStatus_received_sample_bytes</dref>
   --  <dref name="received_sample_bytes_change">DataReaderProtocolStatus_received_sample_bytes_change</dref>
   --  <dref name="duplicate_sample_count">DataReaderProtocolStatus_duplicate_sample_count</dref>
   --  <dref name="duplicate_sample_count_change">DataReaderProtocolStatus_duplicate_sample_count_change</dref>
   --  <dref name="duplicate_sample_bytes">DataReaderProtocolStatus_duplicate_sample_bytes</dref>
   --  <dref name="duplicate_sample_bytes_change">DataReaderProtocolStatus_duplicate_sample_bytes_change</dref>
   --  <dref name="filtered_sample_count">DataReaderProtocolStatus_filtered_sample_count</dref>
   --  <dref name="filtered_sample_count_change">DataReaderProtocolStatus_filtered_sample_count_change</dref>
   --  <dref name="filtered_sample_bytes">DataReaderProtocolStatus_filtered_sample_bytes</dref>
   --  <dref name="filtered_sample_bytes_change">DataReaderProtocolStatus_filtered_sample_bytes_change</dref>
   --  <dref name="received_heartbeat_count">DataReaderProtocolStatus_received_heartbeat_count</dref>
   --  <dref name="received_heartbeat_count_change">DataReaderProtocolStatus_received_heartbeat_count_change</dref>
   --  <dref name="received_heartbeat_bytes">DataReaderProtocolStatus_received_heartbeat_bytes</dref>
   --  <dref name="received_heartbeat_bytes_change">DataReaderProtocolStatus_received_heartbeat_bytes_change</dref>
   --  <dref name="sent_ack_count">DataReaderProtocolStatus_sent_ack_count</dref>
   --  <dref name="sent_ack_count_change">DataReaderProtocolStatus_sent_ack_count_change</dref>
   --  <dref name="sent_ack_bytes">DataReaderProtocolStatus_sent_ack_bytes</dref>
   --  <dref name="sent_ack_bytes_change">DataReaderProtocolStatus_sent_ack_bytes_change</dref>
   --  <dref name="sent_nack_count">DataReaderProtocolStatus_sent_nack_count</dref>
   --  <dref name="sent_nack_count_change">DataReaderProtocolStatus_sent_nack_count_change</dref>
   --  <dref name="sent_nack_bytes">DataReaderProtocolStatus_sent_nack_bytes</dref>
   --  <dref name="sent_nack_bytes_change">DataReaderProtocolStatus_sent_nack_bytes_change</dref>
   --  <dref name="received_gap_count">DataReaderProtocolStatus_received_gap_count</dref>
   --  <dref name="received_gap_count_change">DataReaderProtocolStatus_received_gap_count_change</dref>
   --  <dref name="received_gap_bytes">DataReaderProtocolStatus_received_gap_bytes</dref>
   --  <dref name="received_gap_bytes_change">DataReaderProtocolStatus_received_gap_bytes_change</dref>
   --  <dref name="rejected_sample_count">DataReaderProtocolStatus_rejected_sample_count</dref>
   --  <dref name="rejected_sample_count_change">DataReaderProtocolStatus_rejected_sample_count_change</dref>
   --  <dref name="first_available_sample_sequence_number">DataReaderProtocolStatus_first_available_sample_sequence_number</dref>
   --  <dref name="last_available_sample_sequence_number">DataReaderProtocolStatus_last_available_sample_sequence_number</dref>
   --  <dref name="last_committed_sample_sequence_number">DataReaderProtocolStatus_last_committed_sample_sequence_number</dref>
   --  <dref name="uncommitted_sample_count">DataReaderProtocolStatus_uncommitted_sample_count</dref>

   pragma Convention (C_Pass_By_Copy, DataReaderProtocolStatus);

   DataReaderProtocolStatus_INITIALIZER : constant DataReaderProtocolStatus :=
                                            (Received_Sample_Count                  => 0,
                                             Received_Sample_Count_Change           => 0,
                                             Received_Sample_Bytes                  => 0,
                                             Received_Sample_Bytes_Change           => 0,
                                             Duplicate_Sample_Count                 => 0,
                                             Duplicate_Sample_Count_Change          => 0,
                                             Duplicate_Sample_Bytes                 => 0,
                                             Duplicate_Sample_Bytes_Change          => 0,
                                             Filtered_Sample_Count                  => 0,
                                             Filtered_Sample_Count_Change           => 0,
                                             Filtered_Sample_Bytes                  => 0,
                                             Filtered_Sample_Bytes_Change           => 0,
                                             Received_Heartbeat_Count               => 0,
                                             Received_Heartbeat_Count_Change        => 0,
                                             Received_Heartbeat_Bytes               => 0,
                                             Received_Heartbeat_Bytes_Change        => 0,
                                             Sent_Ack_Count                         => 0,
                                             Sent_Ack_Count_Change                  => 0,
                                             Sent_Ack_Bytes                         => 0,
                                             Sent_Ack_Bytes_Change                  => 0,
                                             Sent_Nack_Count                        => 0,
                                             Sent_Nack_Count_Change                 => 0,
                                             Sent_Nack_Bytes                        => 0,
                                             Sent_Nack_Bytes_Change                 => 0,
                                             Received_Gap_Count                     => 0,
                                             Received_Gap_Count_Change              => 0,
                                             Received_Gap_Bytes                     => 0,
                                             Received_Gap_Bytes_Change              => 0,
                                             Rejected_Sample_Count                  => 0,
                                             Rejected_Sample_Count_Change           => 0,
                                             First_Available_Sample_Sequence_Number => (-2147483648, 16#FFFF_FFFF#),
                                             Last_Available_Sample_Sequence_Number  => (-2147483648, 16#FFFF_FFFF#),
                                             Last_Committed_Sample_Sequence_Number  => (-2147483648, 16#FFFF_FFFF#),
                                             Uncommitted_Sample_Count               => 0);

   --  ----------------------------------------------------------
   --                  Sample States
   --  ----------------------------------------------------------

   type SampleStateKind is new Unsigned_Long;
   --  <dref>SampleStateKind</dref>

   READ_SAMPLE_STATE : constant SampleStateKind     := 1;
   --  <dref>SampleStateKind_READ_SAMPLE_STATE</dref>

   NOT_READ_SAMPLE_STATE : constant SampleStateKind := 2;
   --  <dref>SampleStateKind_NOT_READ_SAMPLE_STATE</dref>

   subtype SampleStateMask is SampleStateKind;
   --  <dref>SampleStateMask</dref>

   --     ANY_SAMPLE_STATE : constant SampleStateMask := 65535;

   ANY_SAMPLE_STATE  : constant SampleStateMask := 16#FFFF#;
   --  <dref>ANY_SAMPLE_STATE</dref>

   type SampleStateKind_Access is access constant SampleStateKind;

   --  ----------------------------------------------------------
   --                  View States
   --  ----------------------------------------------------------

   type ViewStateKind is new Unsigned_Long;
   --  <dref>ViewStateKind</dref>

   NEW_VIEW_STATE  : constant ViewStateKind     := 1;
   --  <dref>ViewStateKind_NEW_VIEW_STATE</dref>

   NOT_NEW_VIEW_STATE : constant ViewStateKind := 2;
   --  <dref>ViewStateKind_NOT_NEW_VIEW_STATE</dref>

   subtype ViewStateMask is ViewStateKind;
   --  <dref>ViewStateMask</dref>

   --     ANY_VIEW_STATE  : constant ViewStateMask      := 65535;

   ANY_VIEW_STATE  : constant ViewStateMask := 16#FFFF#;
   --  <dref>ANY_VIEW_STATE</dref>

   type ViewStateKind_Access is access constant ViewStateKind;

   --  ----------------------------------------------------------
   --                  Instance States
   --  ----------------------------------------------------------

   type InstanceStateKind is   new Unsigned_Long;
   --  <dref>InstanceStateKind</dref>

   ALIVE_INSTANCE_STATE : constant InstanceStateKind                := 1;
   --  <dref>InstanceStateKind_ALIVE_INSTANCE_STATE</dref>

   NOT_ALIVE_DISPOSED_INSTANCE_STATE : constant InstanceStateKind   := 2;
   --  <dref>InstanceStateKind_NOT_ALIVE_DISPOSED_INSTANCE_STATE</dref>

   NOT_ALIVE_NO_WRITERS_INSTANCE_STATE : constant InstanceStateKind := 4;
   --  <dref>InstanceStateKind_NOT_ALIVE_NO_WRITERS_INSTANCE_STATE</dref>

   subtype InstanceStateMask is InstanceStateKind;
   --  <dref>InstanceStateMask</dref>

   NOT_ALIVE_INSTANCE_STATE : constant InstanceStateMask := 6;
   --  <dref>NOT_ALIVE_INSTANCE_STATE</dref>

   --     ANY_INSTANCE_STATE : constant InstanceStateMask := 65535;

   ANY_INSTANCE_STATE  : constant InstanceStateMask := 16#FFFF#;
   --  <dref>ANY_INSTANCE_STATE</dref>

   type InstanceStateKind_Access is access constant InstanceStateKind;

   --  ----------------------------------------------------------
   --                  Sample Info
   --  ----------------------------------------------------------

   type SampleInfo is record
      Sample_State                                                : aliased SampleStateKind;
      View_State                                                  : aliased ViewStateKind;
      Instance_State                                              : aliased InstanceStateKind;
      Source_Timestamp                                            : aliased Time_T;
      Instance_Handle                                             : aliased InstanceHandle_T;
      Publication_Handle                                          : aliased InstanceHandle_T;
      Disposed_Generation_Count                                   : aliased Long := 0;
      No_Writers_Generation_Count                                 : aliased Long := 0;
      Sample_Rank                                                 : aliased Long := 0;
      Generation_Rank                                             : aliased Long := 0;
      Absolute_Generation_Rank                                    : aliased Long := 0;
      Valid_Data                                                  : aliased DDS.Boolean := False;
      Reception_Timestamp                                         : aliased Time_T;
      Publication_Sequence_Number                                 : aliased SequenceNumber_T;
      Reception_Sequence_Number                                   : aliased SequenceNumber_T;
      Publication_Virtual_Guid                                    : aliased Guid_T;
      Publication_Virtual_Sequence_Number                         : aliased SequenceNumber_T;
      Original_Publication_Virtual_Guid                           : aliased Guid_T;
      Original_Publication_Virtual_Sequence_Number                : aliased SequenceNumber_T;
      Related_Original_Publication_Virtual_Guid                   : aliased Guid_T;
      Related_Original_Publication_Virtual_Sequence_Number        : aliased SequenceNumber_T;
      Flag                                                        : aliased SampleFlag;
      Source_Guid                                                 : aliased Guid_T;
      Related_Source_Guid                                         : aliased Guid_T;
      Related_Subscription_Guid                                   : aliased Guid_T;
      Topic_Query_Guid                                            : aliased Guid_T;
      Sample_Info_Hash                                            : aliased RTIDDS.Low_Level.ndds_osapi_osapi_hash_h.RTIOsapiHash;
      Sample_Signature                                            : aliased access RTIDDS.Low_Level.ndds_pres_pres_common_impl_h.PRESSampleSignature;
      Encapsulation_Id                                            : aliased EncapsulationId_T;
      Related_Epoch                                               : aliased SequenceNumber_T;
   end record;
   --  <dref>SampleInfo</dref>
   --  <dref name="Sample_State">SampleInfo_sample_state</dref>
   --  <dref name="View_State">SampleInfo_view_state</dref>
   --  <dref name="Instance_State">SampleInfo_instance_state</dref>
   --  <dref name="Source_Timestamp">SampleInfo_source_timestamp</dref>
   --  <dref name="Instance_Handle">SampleInfo_instance_handle</dref>
   --  <dref name="Publication_Handle">SampleInfo_publication_handle</dref>
   --  <dref name="Disposed_Generation_Count">SampleInfo_disposed_generation_count</dref>
   --  <dref name="No_Writers_Generation_Count">SampleInfo_no_writers_generation_count</dref>
   --  <dref name="Sample_Rank">SampleInfo_sample_rank</dref>
   --  <dref name="Generation_Rank">SampleInfo_generation_rank</dref>
   --  <dref name="Absolute_Generation_Rank">SampleInfo_absolute_generation_rank</dref>
   --  <dref name="Valid_Data">SampleInfo_valid_data</dref>
   --  <dref name="Reception_Timestamp">SampleInfo_reception_timestamp</dref>
   --  <dref name="Publication_Sequence_Number">SampleInfo_publication_sequence_number</dref>
   --  <dref name="Reception_Sequence_Number">SampleInfo_reception_sequence_number</dref>
   --  <dref internal="true" name="Publication_Virtual_Guid">SampleInfo_publication_virtual_guid</dref>
   --  <dref internal="true" name="Publication_Virtual_Sequence_Number">SampleInfo_publication_virtual_sequence_number</dref>
   --  <dref name="Original_Publication_Virtual_Guid">SampleInfo_original_publication_virtual_guid</dref>
   --  <dref name="Original_Publication_Virtual_Sequence_Number">SampleInfo_original_publication_virtual_sequence_number</dref>
   --  <dref name="Related_Original_Publication_Virtual_Guid">SampleInfo_related_original_publication_virtual_guid</dref>
   --  <dref name="Related_Original_Publication_Virtual_Sequence_Number">SampleInfo_related_original_publication_virtual_sequence_number</dref>
   --  <dref name="Flag">SampleInfo_flag</dref>
   --  <dref name="Source_Guid">SampleInfo_source_guid</dref>
   --  <dref name="Related_Source_Guid">SampleInfo_related_source_guid</dref>
   --  <dref name="Related_Subscription_Guid">SampleInfo_related_subscription_guid</dref>
   --  <dref internal="true" name="Topic_Query_Guid">SampleInfo_topic_query_guid</dref>
   --  <dref internal="true" name="Sample_Info_Hash">SampleInfo_sample_info_hash</dref>
   --  <dref internal="true" name="Sample_Signature">SampleInfo_sample_signature</dref>
   --  <dref internal="true" name="Encapsulation_Id">SampleInfo_encapsulation_id</dref>
   --  <dref internal="true" name="Related_Epoch">SampleInfo_related_epoch</dref>
   pragma Convention (C, SampleInfo);



   type SampleInfo_Access is access all SampleInfo;
   type SampleInfo_Array is array (Natural range <>) of aliased SampleInfo;
   procedure Initialize (Self  : in out SampleInfo);
   procedure Finalize (Self  : in out SampleInfo);
   procedure Copy (Dst : in out SampleInfo; Src : in SampleInfo);

   procedure Get_Sample_Identity (From : SampleInfo; Id : out SampleIdentity_T);
   function Get_Sample_Identity (From : SampleInfo) return  SampleIdentity_T;

   procedure Get_Related_Sample_Identity (From : SampleInfo; Id : out SampleIdentity_T);
   function Get_Related_Sample_Identity (From : SampleInfo) return  SampleIdentity_T;

   package SampleInfo_Seq is new DDS_Support.Sequences_Generic
     (SampleInfo,
      SampleInfo_Access,
      DDS.Natural,
      1,
      SampleInfo_Array);
   --  <dref>SampleInfoSeq</dref>

   --  ----------------------------------------------------------
   --                  DataReaderOos
   --  ----------------------------------------------------------

   type DataReaderQoS is new Ada.Finalization.Limited_Controlled with record
   ---
      Durability             : aliased DurabilityQosPolicy;
      Deadline               : aliased DeadlineQosPolicy;
      Latency_Budget         : aliased LatencyBudgetQosPolicy;
      Liveliness             : aliased LivelinessQosPolicy;
      Reliability            : aliased ReliabilityQosPolicy;
      Destination_Order      : aliased DestinationOrderQosPolicy;
      History                : aliased HistoryQosPolicy;
      Resource_Limits        : aliased ResourceLimitsQosPolicy;
      User_Data              : aliased UserDataQosPolicy;
      Ownership              : aliased OwnershipQosPolicy;
      Time_Based_Filter      : aliased TimeBasedFilterQosPolicy;
      Reader_Data_Lifecycle  : aliased ReaderDataLifecycleQosPolicy;
      Representation         : aliased DataRepresentationQosPolicy;
      Type_Consistency       : aliased TypeConsistencyEnforcementQosPolicy;
      Data_Tags              : aliased DataTagQosPolicy;
      -- --- Extensions: ----------------------------------------------------
      Reader_Resource_Limits : aliased DataReaderResourceLimitsQosPolicy;
      Protocol               : aliased DataReaderProtocolQosPolicy;
      Transport_Selection    : aliased TransportSelectionQosPolicy;
      Unicast                : aliased TransportUnicastQosPolicy;
      Multicast              : aliased TransportMulticastQosPolicy;
      Encapsulation          : aliased TransportEncapsulationQosPolicy;
      Property               : aliased PropertyQosPolicy;
      Service                : aliased ServiceQosPolicy;
      Availability           : aliased AvailabilityQosPolicy;
      Subscription_Name      : aliased EntityNameQosPolicy;
      Transport_Priority     : aliased TransportPriorityQosPolicy;
      Type_Support           : aliased TypeSupportQosPolicy;
   end record;
   --  <dref>DataReaderQos</dref>
   --  <dref name="Durability">DataReaderQos_durability</dref>
   --  <dref name="Deadline">DataReaderQos_deadline</dref>
   --  <dref name="Latency_Budget">DataReaderQos_latency_budget</dref>
   --  <dref name="Liveliness">DataReaderQos_liveliness</dref>
   --  <dref name="Reliability">DataReaderQos_reliability</dref>
   --  <dref name="Destination_Order">DataReaderQos_destination_order</dref>
   --  <dref name="History">DataReaderQos_history</dref>
   --  <dref name="Resource_Limits">DataReaderQos_resource_limits</dref>
   --  <dref name="User_Data">DataReaderQos_user_data</dref>
   --  <dref name="Ownership">DataReaderQos_ownership</dref>
   --  <dref name="Time_Based_Filter">DataReaderQos_time_based_filter</dref>
   --  <dref name="Reader_Data_Lifecycle">DataReaderQos_reader_data_lifecycle</dref>
   --  <dref name="Representation">DataReaderQos_representation</dref>
   --  <dref name="Type_Consistency">DataReaderQos_type_consistency</dref>
   --  <dref name="Data_Tags">DataReaderQos_data_tags</dref>
   --  <dref name="Reader_Resource_Limits">DataReaderQos_reader_resource_limits</dref>
   --  <dref name="Protocol">DataReaderQos_protocol</dref>
   --  <dref name="Transport_Selection">DataReaderQos_transport_selection</dref>
   --  <dref name="Unicast">DataReaderQos_unicast</dref>
   --  <dref name="Multicast">DataReaderQos_multicast</dref>
   --  <dref internal="true" name="Encapsulation">DataReaderQos_encapsulation</dref>
   --  <dref name="Property">DataReaderQos_property</dref>
   --  <dref name="Service">DataReaderQos_service</dref>
   --  <dref name="Availability">DataReaderQos_availability</dref>
   --  <dref name="Subscription_Name">DataReaderQos_subscription_name</dref>
   --  <dref name="Transport_Priority">DataReaderQos_transport_priority</dref>
   --  <dref name="Type_Support">DataReaderQos_type_support</dref>

   pragma Convention (C, DataReaderQoS);

   --  <dref>DataReaderQos_initialize</dref>
   procedure Initialize
     (Self : in out DataReaderQoS);

   --  <dref>DataReaderQos_finalize</dref>
   procedure Finalize
     (Self : in out DataReaderQoS);

   --  <dref>DataReaderQos_copy</dref>
   procedure Copy
     (Target : out DataReaderQoS;
      Source : in DataReaderQoS);


   --  ----------------------------------------------------------
   --                  SubscriberOos
   --  ----------------------------------------------------------

   type SubscriberQos is new Ada.Finalization.Limited_Controlled with record
      Presentation    : PresentationQosPolicy;
      Partition       : PartitionQosPolicy;
      Group_Data      : GroupDataQosPolicy;
      Entity_Factory  : EntityFactoryQosPolicy;
      -- --- Extensions: ----------------------------------------------------
      Exclusive_Area  : ExclusiveAreaQosPolicy;
      Protocol        : aliased SubscriberProtocolQosPolicy;
      Subscriber_Name : aliased EntityNameQosPolicy;
   end record;
   --  <dref>SubscriberQos</dref>
   --  <dref name="Presentation">SubscriberQos_presentation</dref>
   --  <dref name="Partition">SubscriberQos_partition</dref>
   --  <dref name="Group_Data">SubscriberQos_group_data</dref>
   --  <dref name="Entity_Factory">SubscriberQos_entity_factory</dref>
   --  <dref name="Enclusive_Area">SubscriberQos_exclusive_area</dref>
   --  <dref internal="true" name="Protocol">SubscriberQos_protocol</dref>
   --  <dref name="subscriber_name">SubscriberQos_subscriber_name</dref>

   pragma Convention (C, SubscriberQos);
   type SubscriberQos_Access is access SubscriberQos;

   --  <dref>SubscriberQos_initialize</dref>
   procedure Initialize
     (Self : in out SubscriberQos);

   --  <dref>SubscriberQos_finalize</dref>
   procedure Finalize
     (Self : in out SubscriberQos);

   --  <dref>SubscriberQos_copy</dref>
   procedure Copy
     (Target : out SubscriberQos;
      Source : in SubscriberQos);

   --
   --  From dds_sqlfilter.h
   --

   SQLFILTER_NAME  : constant DDS.String := To_DDS_String ("DDSSQL");
   --  <dref>SQLFILTER_NAME</dref>


   STRINGMATCHFILTER_NAME : constant DDS.String := To_DDS_String ("DDSSTRINGMATCH");
   --  <dref>STRINGMATCHFILTER_NAME</dref>
   --  <dref>Shared_string_match_filter</dref>

   --
   --  From dds_c_domain.h
   --

   --  ----------------------------------------------------------
   --                  DomainParticipantQos
   --  ----------------------------------------------------------

   type DomainParticipantQos is new Ada.Finalization.Limited_Controlled with  record
      User_Data         : aliased UserDataQosPolicy;
      Entity_Factory    : aliased EntityFactoryQosPolicy;
      -- --------------- Extensions: ----------------------------------
      Wire_Protocol     : aliased WireProtocolQosPolicy;
      Transport_Builtin : aliased TransportBuiltinQosPolicy;
      Default_Unicast   : aliased TransportUnicastQosPolicy;
      Discovery         : aliased DiscoveryQosPolicy;
      Resource_Limits   : aliased DomainParticipantResourceLimitsQosPolicy;
      Event             : aliased EventQosPolicy;
      Receiver_Pool     : aliased ReceiverPoolQosPolicy;
      Database          : aliased DatabaseQosPolicy;
      Discovery_Config  : aliased DiscoveryConfigQosPolicy;
      Exclusive_Area    : aliased ExclusiveAreaQosPolicy;
      Property          : aliased PropertyQosPolicy;
      Participant_Name  : aliased EntityNameQosPolicy;
      Multicast_Mapping : aliased TransportMulticastMappingQosPolicy;
      Service           : aliased ServiceQosPolicy;
      User_Object       : aliased UserObjectQosPolicy;
      Protocol          : aliased DomainParticipantProtocolQosPolicy;
      Type_Support      : aliased TypeSupportQosPolicy;
   end record;
   --  <dref>DomainParticipantQos</dref>
   --  <dref name="User_Data">DomainParticipantQos_user_data</dref>
   --  <dref name="Entity_Factory">DomainParticipantQos_entity_factory</dref>
   --  <dref name="Wire_Protocol">DomainParticipantQos_wire_protocol</dref>
   --  <dref name="Transport_Builtin">DomainParticipantQos_transport_builtin</dref>
   --  <dref name="Default_Unicast">DomainParticipantQos_default_unicast</dref>
   --  <dref name="Discovery">DomainParticipantQos_discovery</dref>
   --  <dref name="Resource_Limits">DomainParticipantQos_resource_limits</dref>
   --  <dref name="Event">DomainParticipantQos_event</dref>
   --  <dref name="Receiver_Pool">DomainParticipantQos_receiver_pool</dref>
   --  <dref name="Database">DomainParticipantQos_database</dref>
   --  <dref name="Discovery_Config">DomainParticipantQos_discovery_config</dref>
   --  <dref name="Exclusive_Area">DomainParticipantQos_exclusive_area</dref>
   --  <dref name="Property">DomainParticipantQos_property</dref>
   --  <dref name="Participant_Name">DomainParticipantQos_participant_name</dref>
   --  <dref name="Multicast_Mapping">DomainParticipantQos_multicast_mapping</dref>
   --  <dref internal="true" name="Service">DomainParticipantQos_service</dref>
   --  <dref name="User_Object">DomainParticipantQos_user_object</dref>
   --  <dref internal="true" name="Protocol">DomainParticipantQos_protocol</dref>
   --  <dref name="Type_Support">DomainParticipantQos_type_support</dref>

   pragma Convention (C, DomainParticipantQos);
   --   <internal>
   --   for DomainParticipantQos'Alignment use 4;
   --   </internal>

   --  <dref>DomainParticipantQos_initialize</dref>
   procedure Initialize
     (Self : in out DomainParticipantQos);

   --  <dref>DomainParticipantQos_finalize</dref>
   procedure Finalize
     (Self : in out DomainParticipantQos);

   --  <dref>DomainParticipantQos_copy</dref>
   procedure Copy
     (Target : out  DomainParticipantQos;
      Source : in DomainParticipantQos);

   type LoggingQosPolicy is new DDS_LoggingQosPolicy;

   --  ----------------------------------------------------------
   --                  SqlFilterAlignmentQos
   --  ----------------------------------------------------------

   type SqlFilterAlignmentQos is record
      Char_Alignment       : aliased DDS.Unsigned_Short := 0;
      Short_Alignment      : aliased DDS.Unsigned_Short := 0;
      Long_Alignment       : aliased DDS.Unsigned_Short := 0;
      Float_Alignment      : aliased DDS.Unsigned_Short := 0;
      Double_Alignment     : aliased DDS.Unsigned_Short := 0;
      Longlong_Alignment   : aliased DDS.Unsigned_Short := 0;
      Longdouble_Alignment : aliased DDS.Unsigned_Short := 0;
      Pointer_Alignment    : aliased DDS.Unsigned_Short := 0;
   end record;
   pragma Convention (C_Pass_By_Copy, SqlFilterAlignmentQos);  -- ndds/dds_c/dds_c_sqlfilter.h:170

   type SqlFilterMemoryManagementQos is record
      Buffer_Min_Size : aliased DDS.Long;  -- ndds/dds_c/dds_c_sqlfilter.h:198
      Trim_Buffer     : aliased DDS.Boolean;  -- ndds/dds_c/dds_c_sqlfilter.h:199
   end record;

   pragma Convention (C_Pass_By_Copy, SqlFilterMemoryManagementQos);  -- ndds/dds_c/dds_c_sqlfilter.h:197
   type SqlFilterGeneratorQos is new RTIDDS.Low_Level.ndds_dds_c_dds_c_sqlfilter_h.DDS_SqlFilterGeneratorQos;

   --  ----------------------------------------------------------
   --                  DomainParticipantFactoryQos
   --  ----------------------------------------------------------

   type DomainParticipantFactoryQos is new Ada.Finalization.Limited_Controlled with  record
      Entity_Factory  : aliased EntityFactoryQosPolicy;
      -- --- Extensions: ----------------------------------------------------
      Resource_Limits : aliased SystemResourceLimitsQosPolicy;
      Profile         : aliased ProfileQosPolicy;
      Logging         : aliased DDS_LoggingQosPolicy := (0,
                                                         NDDS_CONFIG_LOG_CATEGORY_PLATFORM,
                                                         0,
                                                         Interfaces.C.Strings.Null_Ptr,
                                                         Interfaces.C.Strings.Null_Ptr,
                                                         Interfaces.C.int (-1),
                                                         Interfaces.C.int (-1));
   end record;
   --  <dref>DomainParticipantFactoryQos</dref>
   --  <dref name="Entity_Factory">DomainParticipantFactoryQos_entity_factory</dref>
   --  <dref name="Resource_Limits">DomainParticipantFactoryQos_resource_limits</dref>
   --  <dref name="Profile">DomainParticipantFactoryQos_profile</dref>
   --  <dref name="Logging">DomainParticipantFactoryQos_logging</dref>

   pragma Convention (C, DomainParticipantFactoryQos);

   type DomainParticipantFactoryQos_Access is access constant DomainParticipantFactoryQos;

   --  <dref>DomainParticipantFactoryQos_copy</dref>
   procedure Copy
     (Target : out DomainParticipantFactoryQos;
      Source : in DomainParticipantFactoryQos);

   --  <dref>DomainParticipantFactoryQos_initialize</dref>
   procedure Initialize
     (Self : in out DomainParticipantFactoryQos);

   --  <dref>DomainParticipantFactoryQos_finalize</dref>
   procedure Finalize
     (Self : in out DomainParticipantFactoryQos);

   --
   --  From dds_c_flowcontroller.h
   --

   --  ----------------------------------------------------------
   --                  Flow Confroller
   --  ----------------------------------------------------------

   DEFAULT_FLOW_CONTROLLER_NAME : constant DDS.String := To_DDS_String ("DDS_DEFAULT_FLOW_CONTROLLER_NAME");
   --  <dref>DEFAULT_FLOW_CONTROLLER_NAME</dref>
   --  <dref>Shared_default_flow_controller_name</dref>

   FIXED_RATE_FLOW_CONTROLLER_NAME : constant DDS.String := To_DDS_String ("DDS_FIXED_RATE_FLOW_CONTROLLER_NAME");
   --  <dref>FIXED_RATE_FLOW_CONTROLLER_NAME</dref>
   --  <dref>Shared_fixed_rate_flow_controller_name</dref>


   ON_DEMAND_FLOW_CONTROLLER_NAME : constant DDS.String := To_DDS_String ("DDS_ON_DEMAND_FLOW_CONTROLLER_NAME");
   --  <dref>ON_DEMAND_FLOW_CONTROLLER_NAME</dref>
   --  <dref>Shared_on_demand_flow_controller_name</dref>


   type FlowControllerSchedulingPolicy is new Unsigned_Long;
   --  <dref>FlowControllerSchedulingPolicy</dref>
   --  <dref>Shared_FlowControllerSchedulingPolicy</dref>

   RR_FLOW_CONTROLLER_SCHED_POLICY : constant FlowControllerSchedulingPolicy := 0;
   --  <dref>FlowControllerSchedulingPolicy_RR_FLOW_CONTROLLER_SCHED_POLICY</dref>
   --  <dref>Shared_RR_FLOW_CONTROLLER_SCHED_POLICY</dref>

   EDF_FLOW_CONTROLLER_SCHED_POLICY : constant FlowControllerSchedulingPolicy := 1;
   --  <dref>FlowControllerSchedulingPolicy_EDF_FLOW_CONTROLLER_SCHED_POLICY</dref>
   --  <dref>Shared_EDF_FLOW_CONTROLLER_SCHED_POLICY</dref>

   type FlowControllerTokenBucketProperty_T is record
      Max_Tokens               : aliased DDS.Long := 0;
      Tokens_Added_Per_Period  : aliased DDS.Long := 0;
      Tokens_Leaked_Per_Period : aliased DDS.Long := 0;
      Period                   : aliased Duration_T;
      Bytes_Per_Token          : aliased DDS.Long := 0;
   end record;
   --  <dref>FlowControllerTokenBucketProperty_t</dref>
   --  <dref>Shared_max_tokens</dref>
   --  <dref>Shared_tokens_added_per_period</dref>
   --  <dref>Shared_tokens_leaked_per_period</dref>
   --  <dref>Shared_flow_controller_property_period</dref>
   --  <dref>Shared_bytes_per_token</dref>
   --  <dref name="max_tokens">FlowControllerTokenBucketProperty_t_max_tokens</dref>
   --  <dref name="tokens_added_per_period">FlowControllerTokenBucketProperty_t_tokens_added_per_period</dref>
   --  <dref name="tokens_leaked_per_period">FlowControllerTokenBucketProperty_t_tokens_leaked_per_period</dref>
   --  <dref name="period">FlowControllerTokenBucketProperty_t_period</dref>
   --  <dref name="bytes_per_token">FlowControllerTokenBucketProperty_t_bytes_per_token</dref>

   pragma Convention (C, FlowControllerTokenBucketProperty_T);

   type FlowControllerProperty_T is record
      Scheduling_Policy  : aliased DDS.FlowControllerSchedulingPolicy := EDF_FLOW_CONTROLLER_SCHED_POLICY;
      Token_Bucket       : aliased DDS.FlowControllerTokenBucketProperty_T := (-1, -1, 0, (1, 0), -1);
      Is_Vendor_Specific : aliased DDS.Boolean := False;
   end record;
   --  <dref>FlowControllerProperty_t</dref>
   --  <dref>Shared_FlowControllerProperty_t</dref>
   --  <dref name="scheduling_policy">FlowControllerProperty_t_scheduling_policy</dref>
   --  <dref name="token_bucket">FlowControllerProperty_t_token_bucket</dref>
   --  <dref internal="true" name="is_vendor_specific">FlowControllerProperty_t_is_vendor_specific</dref>

   pragma Convention (C, FlowControllerProperty_T);

   FlowControllerProperty_T_INITIALIZER : constant FlowControllerProperty_T :=
                                            (Scheduling_Policy  => DDS.EDF_FLOW_CONTROLLER_SCHED_POLICY,
                                             Token_Bucket       => (-1, -1, 0, (1, 0), -1),
                                             Is_Vendor_Specific => False);
   --  <dref>FlowControllerProperty_t_INITIALIZER</dref>

   procedure Copy (C_Out : not null access FlowControllerProperty_T;
                   C_In  : not null access FlowControllerProperty_T);
   --  <dref internal="true">FlowControllerProperty_copy</dref>

   --
   --  DLRL stuff
   --


   type ReferenceScope is
     (SIMPLE_CONTENT_SCOPE,
      REFERENCED_CONTENTS_SCOPE);

   type ObjectScope is
     (SIMPLE_OBJECT_SCOPE,
      CONTAINED_OBJECTS_SCOPE,
      RELATED_OBJECTS_SCOPE);

   type DCPSState is
     (INITIAL,
      REGISTERED,
      ENABLED);

   type CacheUsage is
     (READ_ONLY,
      WRITE_ONLY,
      READ_WRITE);

   type ObjectSubState is new Interfaces.Unsigned_16;

   OBJECT_NEW       : constant ObjectSubState := 2#0000_0000_0000_0001#;
   OBJECT_MODIFIED  : constant ObjectSubState := 2#0000_0000_0000_0010#;
   OBJECT_READ      : constant ObjectSubState := 2#0000_0000_0000_0100#;
   OBJECT_DELETED   : constant ObjectSubState := 2#0000_0000_0000_1000#;
   OBJECT_CREATED   : constant ObjectSubState := 2#0000_0001_0000_0000#;
   OBJECT_CHANGED   : constant ObjectSubState := 2#0000_0010_0000_0000#;
   OBJECT_WRITTEN   : constant ObjectSubState := 2#0000_0100_0000_0000#;
   OBJECT_DESTROYED : constant ObjectSubState := 2#0000_1000_0000_0000#;

   type DLRLOid is record
      Creator_Id : aliased Unsigned_Long;
      Local_Id   : aliased Unsigned_Long;
   end record;

   type TimeOutDuration is    new Interfaces.Unsigned_32;

   INFINITE_TIME_OUT : constant TimeOutDuration  := -1;

   subtype ClassName is DDS.String;
   subtype CacheName is  DDS.String;
   subtype RelationName is DDS.String;

   BadParameter    : exception;

   NotFound        : exception;

   --  type ReadOnlyMode_Members is

   ReadOnlyMode    : exception;

   WriteOnlyMode   : exception;

   AlreadyClonedInWriteMode : exception;

   ExpiredTimeOut  : exception;


   type ObjectReference is record
      Oid        : DLRLOid;
      Home_Index : Unsigned_Long;
   end record;

   type RelationKind is
     (REF_RELATION,
      LIST_RELATION,
      INT_MAP_RELATION,
      STR_MAP_RELATION);


   type RelatedObjectDepth is   new Short_Integer;
   UNLIMITED_RELATED_OBJECTS : constant RelatedObjectDepth    := -1;

   type MembershipState is
     (UNDEFINED_MEMBERSHIP,
      ALREADY_MEMBER,
      NOT_MEMBER);

   --
   --  end DLRL stuff
   --


   Not_Implemented : exception;

   --  type Wide_String is access all Standard.Wide_Character;

   --  <internal>
   --  DDS_Octets support methods
   --  </internal>

   function Octets_New
     return Octets_Ptr;
   --  <dref>Octets_new</dref>

   function Octets_New_W_Size
     (Size : Integer)
      return Octets_Ptr;
   --  <dref>Octets_new_with_length</dref>

   procedure Octets_Delete
     (Self : Octets_Ptr);
   --  <dref>Octets_destroy</dref>

   --  <internal>
   --  DDS_KeyedString support methods
   --  </internal>

   function KeyedString_New
     return KeyedString_Ptr;
   --  <dref>KeyedString_new</dref>

   function KeyedString_New_W_Size
     (Key_Size : Integer;
      Size     : Integer)
      return KeyedString_Ptr;
   --  <dref>KeyedString_new_with_length</dref>

   procedure KeyedString_Delete
     (Self : KeyedString_Ptr);
   --  <dref>KeyedString_destroy</dref>

   --  <internal>
   --  DDS_KeyedOctets support methods
   --  </internal>

   function KeyedOctets_New
     return KeyedOctets_Ptr;
   --  <dref>KeyedOctets_new</dref>

   function KeyedOctets_New_W_Size
     (Key_Size : Integer;
      Size     : Integer)
      return KeyedOctets_Ptr;
   --  <dref>KeyedOctets_new_with_length</dref>

   procedure KeyedOctets_Delete
     (Self : KeyedOctets_Ptr);
   --  <dref>KeyedOctets_destroy</dref>

   function Convert (Code : RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_ReturnCode_t) return DDS.ReturnCode_T;

private
   use Interfaces.C.Strings;
   --  private routines to get address of c-comaptible Qos

   function GetInterface (P_Qos : TopicQos) return access RTIDDS.Low_Level.ndds_dds_c_dds_c_topic_h.DDS_TopicQos;
   function GetInterface (P_Qos : DataWriterQos) return access RTIDDS.Low_Level.ndds_dds_c_dds_c_publication_h.DDS_DataWriterQos;
   function GetInterface (P_Qos : PublisherQos) return access RTIDDS.Low_Level.ndds_dds_c_dds_c_publication_h.DDS_PublisherQos;
   function GetInterface (P_Qos : DataReaderQoS) return access RTIDDS.Low_Level.ndds_dds_c_dds_c_subscription_h.DDS_DataReaderQos;
   function GetInterface (P_Qos : SubscriberQos) return access RTIDDS.Low_Level.ndds_dds_c_dds_c_subscription_h.DDS_SubscriberQos;
   function GetInterface (P_Qos : DomainParticipantQos) return access RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h.DDS_DomainParticipantQos;
   function GetInterface (P_Qos : DomainParticipantFactoryQos) return access RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h.DDS_DomainParticipantFactoryQos;
   function GetInterface (FC_P : FlowControllerProperty_T) return access RTIDDS.Low_Level.ndds_dds_c_dds_c_flowcontroller_h.DDS_FlowControllerProperty_t;

   procedure Ret_Code_To_Exception (Code    : RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_ReturnCode_t;
                                    Message : Standard.String := "");

   procedure Ret_Code_To_Exception (Code    : RTIDDS.Low_Level.ndds_dds_c_dds_c_common_h.DDS_Boolean;
                                    Message : Standard.String := "");

   procedure Free is new Ada.Unchecked_Deallocation (PublisherQos, PublisherQos_Access);
   procedure Free is new Ada.Unchecked_Deallocation (SubscriberQos, SubscriberQos_Access);
   procedure Free is new Ada.Unchecked_Deallocation (TopicQos, TopicQos_Access);

   procedure Validate_Library;

   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_Time_t;
                        Source : DDS.Time_T);

   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_WriteParams_t;
                        Source : DDS.WriteParams_T);

   procedure Copy_Up (Dst    : out DDS.Time_T;
                      Source : RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_Time_t);

   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_pres_pres_participant_h.PRESInstanceHandle;
                        Source : DDS.InstanceHandle_T);

   procedure Copy_Up (Dst    : out DDS.InstanceHandle_T;
                      Source : RTIDDS.Low_Level.ndds_pres_pres_participant_h.PRESInstanceHandle);
   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_common_h.DDS_Boolean;
                        Source : DDS.Boolean);

   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_SampleIdentity_t;
                        Source : DDS.SampleIdentity_T);
   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_GUID_t;
                        Source : DDS.Guid_T);

   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_GUID_t_value_array;
                        Source : DDS.GUID_T_Value_Array);

   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_common_h.DDS_Long;
                        Source : DDS.Long);

   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_common_h.DDS_Long;
                        Source : DDS.SampleFlag);

   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_common_h.DDS_UnsignedLong;
                        Source : DDS.Unsigned_Long);

   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_SequenceNumber_t;
                        Source : DDS.SequenceNumber_T);
   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_OctetSeq;
                        Source : DDS.Octet_Seq.Sequence);
   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_Cookie_t;
                        Source : DDS.Cookie_T);



   Epoch  : constant Ada.Calendar.Time := Ada.Calendar.Time_Of (1970, 01, 01);
   type DDS_Wchar_Ptr is access all RTIDDS.Low_Level.ndds_dds_c_dds_c_common_h.DDS_Wchar
      with Convention => C;

   function GetInterface (Item : String) return access Interfaces.C.Strings.chars_ptr;
   function GetInterface (Item : String) return Interfaces.C.Strings.chars_ptr;
   procedure Copy (To : in out String; From : Interfaces.C.Strings.chars_ptr);

   procedure Debug_Trap;

end DDS;
