--  (c) Copyright, Real-Time Innovations, $Date: 2012-10-23 16:55:08 -0700 (Tue, 23 Oct 2012) $
--  All rights reserved.
--
--  No duplications, whole or partial, manual or electronic, may be made
--  without express written permission.  Any such copies, or
--  revisions thereof, must display this notice unaltered.
--  This code contains trade secrets of Real-Time Innovations, Inc.

with Ada.Exceptions; use Ada.Exceptions;
with Ada.Strings.Fixed;
with Ada.Strings.Wide_Fixed;
with Ada.Unchecked_Conversion;
with RTIDDS.Config;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_string_h;
with System.Storage_Elements;
with RTIDDS.Low_Level.Conversions.DDS_ParticipantBuiltinTopicData_Conv;
with RTIDDS.Low_Level.Conversions.DDS_TopicBuiltinTopicData_Conv;
with RTIDDS.Low_Level.Conversions.DDS_PublicationBuiltinTopicData_Conv;
with RTIDDS.Low_Level.Conversions.DDS_SubscriptionBuiltinTopicData_Conv;
with Calendar.Time_Zones;
with RTIDDS.Low_Level.ndds_dds_c_dds_c_builtin_h;

package body DDS is

   use RTIDDS.Low_Level.ndds_dds_c_dds_c_builtin_h;
   use RTIDDS.Low_Level.ndds_dds_c_dds_c_builtin_impl_h;
   use RTIDDS.Low_Level.Conversions;
   use RTIDDS.Low_Level.ndds_dds_c_dds_c_publication_h;
   use RTIDDS.Low_Level.ndds_dds_c_dds_c_subscription_h;
   use RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h;
   use RTIDDS.Low_Level.ndds_dds_c_dds_c_topic_h;
   use RTIDDS.Low_Level.ndds_dds_c_dds_c_string_h;
   use RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h;
   use Interfaces.C;
   use System;


   --  ====================================================================
   --  Suport routines for short

   procedure Initialize (Self  : in out Short) is
   begin
      Self := 0;
   end Initialize;

   procedure Finalize (Self  : in out Short) is
      pragma Unreferenced (Self);
   begin
      null;
   end Finalize;

   procedure Copy (Dst : in out Short; Src : in Short) is
   begin
      Dst := Src;
   end Copy;

   --  ====================================================================
   --  Suport routines for long

   procedure Initialize (Self  : in out Long) is
   begin
      Self := 0;
   end Initialize;

   procedure Finalize (Self  : in out Long) is
      pragma Unreferenced (Self);
   begin
      null;
   end Finalize;

   procedure Copy (Dst : in out Long; Src : in Long) is
   begin
      Dst := Src;
   end Copy;

   --  ====================================================================
   --  Suport routines for long_long

   procedure Initialize (Self  : in out Long_Long) is
   begin
      Self := 0;
   end Initialize;

   procedure Finalize (Self  : in out Long_Long) is
      pragma Unreferenced (Self);
   begin
      null;
   end Finalize;

   procedure Copy (Dst : in out Long_Long; Src : in Long_Long) is
   begin
      Dst := Src;
   end Copy;

   --  ====================================================================
   --  Suport routines for Unsigned_short

   procedure Initialize (Self  : in out Unsigned_Short) is
   begin
      Self := 0;
   end Initialize;

   procedure Finalize (Self  : in out Unsigned_Short) is
      pragma Unreferenced (Self);
   begin
      null;
   end Finalize;

   procedure Copy (Dst : in out Unsigned_Short; Src : in Unsigned_Short) is
   begin
      Dst := Src;
   end Copy;

   --  ====================================================================
   --  Suport routines for Unsigned_long

   procedure Initialize (Self  : in out Unsigned_Long) is
   begin
      Self := 0;
   end Initialize;

   procedure Finalize (Self  : in out Unsigned_Long) is
      pragma Unreferenced (Self);
   begin
      null;
   end Finalize;

   procedure Copy (Dst : in out Unsigned_Long; Src : in Unsigned_Long) is
   begin
      Dst := Src;
   end Copy;

   --  ====================================================================
   --  Suport routines for long_long

   procedure Initialize (Self  : in out Unsigned_Long_Long) is
   begin
      Self := 0;
   end Initialize;

   procedure Finalize (Self  : in out Unsigned_Long_Long) is
      pragma Unreferenced (Self);
   begin
      null;
   end Finalize;

   procedure Copy (Dst : in out Unsigned_Long_Long; Src : in Unsigned_Long_Long) is
   begin
      Dst := Src;
   end Copy;

   --  ====================================================================
   --  Suport routines for enum

   procedure Initialize (Self  : in out Enum) is
   begin
      Self := 0;
   end Initialize;

   procedure Finalize (Self  : in out Enum) is
   begin
      null;
   end Finalize;

   procedure Copy (Dst : in out Enum; Src : in Enum) is
   begin
      Dst := Src;
   end Copy;

   --  ====================================================================
   --  Suport routines for float

   procedure Initialize (Self  : in out Float) is
   begin
      Self := 0.0;
   end Initialize;

   procedure Finalize (Self  : in out Float) is
      pragma Unreferenced (Self);
   begin
      null;
   end Finalize;

   procedure Copy (Dst : in out Float; Src : in Float) is
   begin
      Dst := Src;
   end Copy;

   --  ====================================================================
   --  Suport routines for Double

   procedure Initialize (Self  : in out Double) is
      pragma Unreferenced (Self);
   begin
      Self := 0.0;
   end Initialize;

   procedure Finalize (Self  : in out Double) is
      pragma Unreferenced (Self);
   begin
      null;
   end Finalize;

   procedure Copy (Dst : in out Double; Src : in Double) is
   begin
      Dst := Src;
   end Copy;

   --  ====================================================================
   --  Suport routines for Long_Double

   procedure Initialize (Self  : in out Long_Double) is
      pragma Unreferenced (Self);
   begin
      Self := 0.0;
   end Initialize;

   procedure Finalize (Self  : in out Long_Double) is
      pragma Unreferenced (Self);
   begin
      null;
   end Finalize;

   procedure Copy (Dst : in out Long_Double; Src : in Long_Double) is
   begin
      Dst := Src;
   end Copy;

   --  ====================================================================
   --  Suport routines for Char

   procedure Initialize (Self  : in out Char) is
      pragma Unreferenced (Self);
   begin
      Self := ASCII.NUL;
   end Initialize;

   procedure Finalize (Self  : in out Char) is
      pragma Unreferenced (Self);
   begin
      null;
   end Finalize;

   procedure Copy (Dst : in out Char; Src : in Char) is
   begin
      Dst := Src;
   end Copy;

   --  ====================================================================
   --  Suport routines for Wchar

   procedure Initialize (Self  : in out Wchar) is
      pragma Unreferenced (Self);
   begin
      Self := Wchar'First;
   end Initialize;

   procedure Finalize (Self  : in out Wchar) is
      pragma Unreferenced (Self);
   begin
      null;
   end Finalize;

   procedure Copy (Dst : in out Wchar; Src : in Wchar) is
   begin
      Dst := Src;
   end Copy;

   --  ====================================================================
   --  Suport routines for Octet

   procedure Initialize (Self  : in out Octet) is
      pragma Unreferenced (Self);
   begin
      Self := 0;
   end Initialize;

   procedure Finalize (Self  : in out Octet) is
      pragma Unreferenced (Self);
   begin
      null;
   end Finalize;

   procedure Copy (Dst : in out Octet; Src : in Octet) is
   begin
      Dst := Src;
   end Copy;

   --  ====================================================================
   --  Suport routines for Octets

   procedure Initialize (Self  : in out Octets) is
   begin
      Self.Length := 0;
      Self.Value := System.Null_Address;
   end Initialize;

   procedure Finalize (Self  : in out Octets) is
   begin
      --  Since the value field points to a user's array it will not be deallocated
      Self.Length := 0;
      Self.Value := System.Null_Address;
   end Finalize;

   procedure Copy (Dst : in out Octets; Src : in Octets) is
   begin
      --  if we reallocate then we should also return the array to where dst will
      --  now be pointing
      Dst.Length := Src.Length;
      Dst.Value := Src.Value;
   end Copy;

   --  ====================================================================
   --  Suport routines for Boolean

   procedure Initialize (Self  : in out Boolean) is
      pragma Unreferenced (Self);
   begin
      Self := False;
   end Initialize;

   procedure Finalize (Self  : in out Boolean) is
      pragma Unreferenced (Self);
   begin
      null;
   end Finalize;

   procedure Copy (Dst : in out Boolean; Src : in Boolean) is
   begin
      Dst := Src;
   end Copy;

   --  ====================================================================
   --  Suport routines for KeyedOctets

   procedure Initialize (Self  : in out KeyedOctets) is
   begin
      Self.Key.Data := Interfaces.C.Strings.Null_Ptr;
      Self.Value := (0, System.Null_Address);
   end Initialize;

   procedure Finalize (Self  : in out KeyedOctets) is
   begin
      --  Since the value field points to a user's array it will not be deallocated
      Self.Key.Data := Interfaces.C.Strings.Null_Ptr;
      Self.Value := (0, System.Null_Address);
   end Finalize;

   procedure Copy (Dst : in out KeyedOctets; Src : in KeyedOctets) is
   begin
      --  if we reallocate then we should also return the array to where dst will
      --  now be pointing
      Copy (Dst.Key, Src.Key);
      Copy (Dst.Value, Src.Value);
   end Copy;

   --  ====================================================================
   --  Suport routines for String
   procedure Initialize (Self  : in out DDS.String) is
      pragma Unreferenced (Self);
   begin
      --      if Self.data /= Null_Ptr then
      --         DDS_String_free (Self.data);
      --      end if;

      Self.Data := Interfaces.C.Strings.Null_Ptr;
   end Initialize;

   procedure Finalize (Self  : in out DDS.String) is
   begin
      if Self.Data /= Null_Ptr then
         DDS_String_free (Self.Data);
         Self.Data := Null_Ptr;
      end if;
   end Finalize;

   procedure Copy (Dst : in out DDS.String; Src : in DDS.String) is
   begin
      Dst.Data :=  DDS_String_replace (Dst'Address, Src.Data);
   end Copy;

   procedure Copy (Dst : in out DDS.String; Src : in Standard.String) is
      Xsrc : DDS.String := To_DDS_String (Src);
   begin
      Copy (Dst, Xsrc);
      Finalize (Xsrc);
   end Copy;

   procedure Copy (Dst : in out Standard.String; Src : in DDS.String) is
      I_Src : constant Standard.String := Interfaces.C.Strings.Value (Src.Data);
   begin
      Ada.Strings.Fixed.Move (I_Src, Dst);
   end Copy;

   function "=" (L, R  : DDS.String) return Boolean is

   begin
      if L.Data /= Null_Ptr and R.Data /= Null_Ptr then
         return Standard.String'(Value (L.Data)) =  Standard.String'(Value (R.Data));
      elsif L.Data = Null_Ptr and R.Data = Null_Ptr then
         return True;
      else
         return False;
      end if;
   end "=";

   function To_Standard_String (Source : DDS.String) return Standard.String is
   begin
      return Interfaces.C.Strings.Value (Source.Data);
   end To_Standard_String;

   function Length (Item : String) return Natural is
   begin
      if Item = NULL_STRING then -- output of strlen for NULL string is undefined
         return 0;
      else
         return Natural (Interfaces.C.Strings.Strlen (Item.Data));
      end if;
   end Length;

   function "&" (L : DDS.String; R : Standard.String) return Standard.String is
   begin
      return To_Standard_String (L) & R;
   end "&";
   function "&" (L : Standard.String; R : DDS.String) return Standard.String is
   begin
      return  L & To_Standard_String (R);
   end"&";

   function "=" (L : DDS.String; R : Standard.String) return Standard.Boolean  is
   begin
      return  To_Standard_String (L) = R;
   end"=";

   function "=" (L : Standard.String; R : DDS.String) return Standard.Boolean is
   begin
      return  L = To_Standard_String (R);
   end"=";

   procedure Append (To : in out DDS.String; Data : DDS.String) is
      Temp : constant Standard.String := To_Standard_String (Data);
   begin
      Append (To, Temp);
   end;

   procedure Append (To : in out DDS.String; Data : Standard.String) is
      Temp : constant Standard.String := To_Standard_String (To);
   begin
      Copy (To, Temp & Data);
   end;

   procedure Prepend (To : in out DDS.String; Data : DDS.String) is
      Temp : constant Standard.String := To_Standard_String (Data);
   begin
      Prepend (To, Temp);
   end;

   procedure Prepend (To : in out DDS.String; Data : Standard.String) is
      Temp : constant Standard.String := To_Standard_String (To);
   begin
      Copy (To,  Data & Temp);
   end;


   function GetInterface (Item : String) return access Interfaces.C.Strings.chars_ptr is
   begin
      return Item.Data'Unrestricted_Access;
   end GetInterface;

   function GetInterface (Item : String) return Interfaces.C.Strings.chars_ptr is
   begin
      return Item.Data;
   end GetInterface;

   procedure Copy (To : in out String; From : Interfaces.C.Strings.chars_ptr) is
   begin
      Finalize (To);
      To.Data := From;
   end Copy;

   ----------------------------------------------------------------

   --  ====================================================================
   --  Suport routines for KeyedString
   procedure Initialize (Self  : in out DDS.KeyedString) is
   begin
      Self.Key.Data := Interfaces.C.Strings.Null_Ptr;
      Self.Value.Data := Interfaces.C.Strings.Null_Ptr;
   end Initialize;

   procedure Finalize (Self  : in out DDS.KeyedString) is
   begin
      if Self.Value.Data /= Null_Ptr then
         DDS_String_free (Self.Value.Data);
         Self.Value.Data := Null_Ptr;
      end if;
      if Self.Key.Data /= Null_Ptr then
         DDS_String_free (Self.Key.Data);
         Self.Key.Data := Null_Ptr;
      end if;
   end Finalize;

   procedure Copy (Dst : in out DDS.KeyedString; Src : in DDS.KeyedString) is
   begin
      Dst.Value.Data :=  DDS_String_replace (Dst.Value.Data'Address, Src.Value.Data);
      Dst.Key.Data :=  DDS_String_replace (Dst.Key.Data'Address, Src.Key.Data);
   end Copy;

   function "=" (L, R  : DDS.KeyedString) return Boolean is
      ValueResult : Boolean;
      KeyResult   : Boolean;
   begin
      if L.Value.Data /= Null_Ptr and R.Value.Data /= Null_Ptr then
         ValueResult := Standard.String'(Value (L.Value.Data)) =  Standard.String'(Value (R.Value.Data));
      elsif L.Value.Data = Null_Ptr and R.Value.Data = Null_Ptr then
         ValueResult := True;
      else
         ValueResult := False;
      end if;
      if L.Key.Data /= Null_Ptr and R.Key.Data /= Null_Ptr then
         KeyResult := Standard.String'(Value (L.Key.Data)) =  Standard.String'(Value (R.Key.Data));
      elsif L.Key.Data = Null_Ptr and R.Key.Data = Null_Ptr then
         KeyResult := True;
      else
         KeyResult := False;
      end if;
      return ValueResult and KeyResult;
   end "=";

   function To_DDS_KeyedString
     (Key    : Standard.String;
      Source : Standard.String)
      return DDS.KeyedString
   is
   begin
      return Ret : DDS.KeyedString do
         Ret.Value.Data := DDS_String_alloc (Source'Length);
         Interfaces.C.Strings.Update (Ret.Value.Data, 0, Source, False);
         Ret.Key.Data := DDS_String_alloc (Key'Length);
         Interfaces.C.Strings.Update (Ret.Key.Data, 0, Key, False);
      end return;
   end To_DDS_KeyedString;

   function To_Standard_String (Source : DDS.KeyedString) return Standard.String is
   begin
      return (if Source.Key /= NULL_STRING then  Value (Source.Key.Data) else "");
   end To_Standard_String;

   function Get_Key_From_KeyedString (Source : DDS.KeyedString) return Standard.String is
   begin
      return Interfaces.C.Strings.Value (Source.Key.Data);
   end Get_Key_From_KeyedString;

   ----------------------------------------------------------------

   --  ====================================================================
   --  Suport routines for Wide_String
   procedure Initialize (Self  : in out DDS.Wide_String) is
      pragma Unreferenced (Self);
   begin
      Self.Data := null;
   end Initialize;

   procedure Finalize (Self  : in out DDS.Wide_String) is
      function Convert is new Ada.Unchecked_Conversion (Wchars_Ptr, DDS_Wchar_Ptr);
   begin
      if Self.Data /= null then
         DDS_Wstring_free (Convert (Self.Data));
         Self.Data := null;
      end if;
   end Finalize;

   function To_Address is new Ada.Unchecked_Conversion (Wchars_Ptr, System.Address);

   function To_Wchars_Ptr is new Ada.Unchecked_Conversion (System.Address, Wchars_Ptr);

   function "+" (Left : Wchars_Ptr; Right : size_t)
                 return Wchars_Ptr
   is
      use System.Storage_Elements;
   begin
      return To_Wchars_Ptr (To_Address (Left) + Storage_Offset (Right));
   end "+";

   function Peek (From : Wchars_Ptr)
                  return Standard.Wide_Character is
   begin
      return From.all;
   end Peek;

   function WValue (Item : Wchars_Ptr) return char16_array is
      function Convert is new Ada.Unchecked_Conversion (Wchars_Ptr, DDS_Wchar_Ptr);
      ArraySize : constant size_t := size_t (DDS_Wstring_length (Convert (Item)));
      Result    : char16_array (0 .. ArraySize);
   begin
      if Item = null then
         raise Interfaces.C.Strings.Dereference_Error;
      end if;
      for J in Result'Range loop
         Result (J) := Interfaces.C.char16_t (Peek (Item + J));
      end loop;
      return Result;
   end WValue;

   procedure Copy (Dst : in out DDS.Wide_String; Src : in DDS.Wide_String) is
      function Convert is new Ada.Unchecked_Conversion (Wchars_Ptr, DDS_Wchar_Ptr);
      function ConvertBack is new Ada.Unchecked_Conversion (DDS_Wchar_Ptr, Wchars_Ptr);
   begin
      Dst.Data := ConvertBack (DDS_Wchar_Ptr (DDS_Wstring_replace (Dst.Data'Address, Convert (Src.Data))));
   end Copy;

   procedure Copy (Dst : in out DDS.Wide_String; Src : in Standard.Wide_String) is
      Xsrc : DDS.Wide_String := To_DDS_Wide_String (Src);
   begin
      Copy (Dst, Xsrc);
      Finalize (Xsrc);
   end Copy;

   procedure Copy (Dst : in out Standard.Wide_String; Src : in DDS.Wide_String) is
      I_Src : constant Standard.Wide_String := To_Standard_Wide_String (Src);
   begin
      Ada.Strings.Wide_Fixed.Move (I_Src, Dst);
   end Copy;

   function "=" (L, R  : DDS.Wide_String) return Boolean is
   begin
      if L.Data /= null and R.Data /= null then
         return L.Data.all =  R.Data.all;
      elsif L.Data = null and R.Data = null then
         return True;
      else
         return False;
      end if;
   end "=";

   function To_DDS_Wide_String (Source : Standard.Wide_String) return DDS.Wide_String is
      function Convert is new Ada.Unchecked_Conversion (DDS_Wchar_Ptr, Wchars_Ptr);

      --  We can use memcpy to copy the string contents because the internal
      --  representation of Standard.Wide_Character matches the size and
      --  representation of DDS_Wchar. Standard.Wide_String is also defined as
      --  an array of Standard.Wide_Characters. AdaCore confirmed array items
      --  are always stored in contiguous memory (without gaps) by GNAT Pro.
      function Blind_Copy (To : in Wchars_Ptr; From : in System.Address; N : in size_t) return System.Address;
      pragma Import (C, Blind_Copy, "memcpy");

      AllocatedString : DDS_Wchar_Ptr;
      Unused : System.Address;
   begin
      return Ret : DDS.Wide_String do
         AllocatedString := DDS_Wstring_alloc (RTIDDS.Low_Level.ndds_dds_c_dds_c_common_h.DDS_UnsignedLong (Source'Length)).all'Access;
         Ret.Data := Convert (AllocatedString);
         --  DDS_Wstring_alloc zeros-out memory so we don't need to append the
         --  null wide character after copying the string contents.
         Unused := Blind_Copy (Ret.Data, Source (Source'First)'Address, size_t (Source'Length * Standard.Wide_Character'Size / 8));
      end return;
   end To_DDS_Wide_String;

   function To_Standard_Wide_String (Source : DDS.Wide_String) return Standard.Wide_String is
      function Convert is new Ada.Unchecked_Conversion (Wchars_Ptr, DDS_Wchar_Ptr);

      --  See To_DDS_Wide_String for an explanation on how we can use memcpy.
      function Blind_Copy (To : in System.Address; From : in Wchars_Ptr; N : in size_t) return System.Address;
      pragma Import (C, Blind_Copy, "memcpy");

      StringLength : Standard.Integer;
      Unused : System.Address;
   begin
      StringLength := Standard.Integer (DDS_Wstring_length (Convert (Source.Data)));
      return Ret : Standard.Wide_String (1 .. StringLength) do
         Unused := Blind_Copy (Ret (1)'Address, Source.Data, size_t (StringLength * Standard.Wide_Character'Size / 8));
      end return;
   end To_Standard_Wide_String;

   ----------------------------------------------------------------

   function "<" (L : Time_T; R : Time_T) return Boolean is
   begin
      if L.Sec = R.Sec then
         return L.Nanosec < R.Nanosec;
      else
         return L.Sec < R.Sec;
      end if;
   end "<";

   function ">" (L : Time_T; R : Time_T) return Boolean is
   begin
      if L.Sec = R.Sec then
         return L.Nanosec > R.Nanosec;
      else
         return L.Sec > R.Sec;
      end if;
   end ">";

   function "<=" (L : Time_T; R : Time_T) return Boolean is
   begin
      if L.Sec < R.Sec then
         return True;
      elsif L.Sec > R.Sec then
         return False;
      else
         return L.Nanosec <= R.Nanosec;
      end if;
   end "<=";

   function ">=" (L : Time_T; R : Time_T) return Boolean is
   begin
      if L.Sec > R.Sec then
         return True;
      elsif L.Sec < R.Sec then
         return False;
      else
         return L.Nanosec >= R.Nanosec;
      end if;
   end ">=";


   function "+" (L : Time_T; R : Time_T) return Time_T is
      Sum : Time_T;
   begin

      Sum.Sec := L.Sec + R.Sec;
      Sum.Nanosec := L.Nanosec + R.Nanosec;
      if Sum.Nanosec > 1_000_000_000 then
         Sum.Sec := Sum.Sec + 1;
         Sum.Nanosec := Sum.Nanosec - 1_000_000_000;
      end if;

      return Sum;

   end "+";

   function Time_Is_Zero (T : Time_T) return Boolean is
   begin
      return (T = Time_Zero);
   end Time_Is_Zero;

   function Time_Is_Invalid (T : Time_T) return Boolean is
   begin
      return (T.Sec < 0);
   end Time_Is_Invalid;

   function To_Time (T : Time_T) return Ada.Calendar.Time is
      use type Ada.Calendar.Time;
   begin
      return Ret : Ada.Calendar.Time do
         Ret := Epoch;
         Ret := Ret + Duration (T.Sec) + Duration (T.Nanosec) * 0.000_000_001;
         Ret := Ret + Duration (Ada.Calendar.Time_Zones.UTC_Time_Offset) * 60.0;
      end return;
   end To_Time;

   function To_Time (T : DDS.Time_T) return Ada.Real_Time.Time is
      use Ada.Real_Time;
   begin
      return Time_Of (Seconds_Count (T.Sec), Nanoseconds (Standard.Integer (T.Nanosec)));
   end To_Time;

   function To_Time_T (T : Ada.Calendar.Time) return Time_T is
      use type Ada.Calendar.Time;
      pragma Unsuppress (Overflow_Check);
      Nano         : constant := 1_000_000_000;
      Temp         : constant Duration := T - Epoch;
      Secs      : Duration;
      Nano_Secs : Duration;
   begin
      return Ret : DDS.Time_T do
         Secs   := Temp - 0.5;
         Ret.Sec := Long (Secs);
         Nano_Secs := Temp - Duration (Ret.Sec);
         Ret.Nanosec := DDS.Unsigned_Long (Nano_Secs * Nano);
      end return;
   end To_Time_T;

   function To_Time_T (T : Ada.Real_Time.Time) return Time_T is
      use Ada.Real_Time;
      SC : Seconds_Count;
      TS : Time_Span;
   begin
      return Ret : DDS.Time_T do
         Split (T, SC, TS);
         Ret.Sec := DDS.Long  (SC);
         Ret.Nanosec := DDS.Unsigned_Long (To_Duration (TS) / 0.000_000_001);
      end return;
   end To_Time_T;


   function Duration_Is_Zero (D : Duration_T) return Boolean is
   begin
      return (D = DURATION_ZERO);
   end Duration_Is_Zero;

   function Duration_Is_Infinite (D : Duration_T) return Boolean is
   begin
      return (D = DURATION_INFINITE);
   end Duration_Is_Infinite;

   function Duration_Is_Auto (D : Duration_T) return Boolean is
   begin
      if D.Sec = DURATION_AUTO_SEC and D.Nanosec = DURATION_AUTO_NSEC then
         return True;
      else
         return False;
      end if;
   end Duration_Is_Auto;

   ---------------------------
   -- Ret_Code_To_Exception --
   ---------------------------

   procedure Ret_Code_To_Exception
     (Code    : DDS.ReturnCode_T;
      Message : Standard.String := "")
   is
   begin
      case Code is
         when  RETCODE_OK =>
            null;
         when RETCODE_ERROR =>
            Raise_Exception (ERROR'Identity, Message);
         when RETCODE_UNSUPPORTED =>
            Raise_Exception (UNSUPPORTED'Identity, Message);
         when RETCODE_BAD_PARAMETER =>
            Raise_Exception (BAD_PARAMETER'Identity, Message);
         when RETCODE_PRECONDITION_NOT_MET =>
            Raise_Exception (PRECONDITION_NOT_MET'Identity, Message);
         when RETCODE_OUT_OF_RESOURCES =>
            Raise_Exception (OUT_OF_RESOURCES'Identity, Message);
         when RETCODE_NOT_ENABLED =>
            Raise_Exception (NOT_ENABLED'Identity, Message);
         when RETCODE_IMMUTABLE_POLICY =>
            Raise_Exception (IMMUTABLE_POLICY'Identity, Message);
         when RETCODE_INCONSISTENT_POLICY =>
            Raise_Exception (INCONSISTENT_POLICY'Identity, Message);
         when RETCODE_ALREADY_DELETED =>
            Raise_Exception (ALREADY_DELETED'Identity, Message);
         when RETCODE_TIMEOUT =>
            Raise_Exception (TIMEOUT'Identity, Message);
         when RETCODE_NO_DATA =>
            Raise_Exception (NO_DATA'Identity, Message);
         when RETCODE_ILLEGAL_OPERATION =>
            Raise_Exception (ILLEGAL_OPERATION'Identity, Message);
         when RETCODE_NOT_ALLOWED_BY_SECURITY =>
            Raise_Exception (NOT_ALLOWED_BY_SECURITY'Identity, Message);
      end case;
   end Ret_Code_To_Exception;

   function Convert (Code : RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_ReturnCode_t) return DDS.ReturnCode_T is
   begin
      if --  Code >= DDS_RETCODE_OK and then
         Code <= DDS_RETCODE_ILLEGAL_OPERATION
      then
         return DDS.ReturnCode_T'Val (DDS_ReturnCode_t'Pos (Code));
      elsif Code = DDS_RETCODE_NOT_ALLOWED_BY_SECURITY
      then
         return RETCODE_NOT_ALLOWED_BY_SECURITY;
      else
         raise Program_Error with "Unknown DDS_ReturnCode_t value";
      end if;
   end Convert;

   procedure Ret_Code_To_Exception (Code    : RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_ReturnCode_t;
                                    Message : Standard.String := "") is
   begin
      Ret_Code_To_Exception (Convert (Code), Message);
   end Ret_Code_To_Exception;

   procedure Ret_Code_To_Exception (Code    : RTIDDS.Low_Level.ndds_dds_c_dds_c_common_h.DDS_Boolean;
                                    Message : Standard.String := "") is
   begin
      if Code = 0 then
         raise ERROR with Message;
      end if;
   end Ret_Code_To_Exception;

   --  ===================================================================
   --  Suport routines for InstanceHandle_T

   procedure Initialize (Self  : in out InstanceHandle_T) is
   begin
      Self := HANDLE_NIL;
   end Initialize;
   procedure Finalize (Self  : in out InstanceHandle_T) is
   begin
      Self := HANDLE_NIL;
   end Finalize;
   procedure Copy (Dst : in out InstanceHandle_T; Src : in InstanceHandle_T) is
   begin
      Dst := Src;
   end Copy;

   function InstanceHandle_Equals
     (Self  : not null access InstanceHandle_T;
      Other : not null access InstanceHandle_T)
      return Boolean
   is
   begin
      return DDS_InstanceHandle_equals
        (RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_InstanceHandle_t (Self.all)'Unrestricted_Access,
         RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_InstanceHandle_t (Other.all)'Unrestricted_Access) /= 0;
   end InstanceHandle_Equals;

   function InstanceHandle_Is_Nil
     (Self : not null access InstanceHandle_T)
      return Boolean
   is
   begin
      return Self.isValid = 0;
   end InstanceHandle_Is_Nil;

   --  ===================================================================
   --  Suport routines for Guid_T

   function Guid_Equals (Self  : not null Guid_T_Access;
                         Other : not null Guid_T_Access) return Boolean
   is
      type DDS_GUID_T_Access is access all DDS_GUID_t;
      function Convert is new Ada.Unchecked_Conversion (Guid_T_Access, DDS_GUID_T_Access);
   begin
      return DDS_GUID_equals (Convert (Self), Convert (Other)) /= 0;
   end Guid_Equals;

   function Guid_Compare (Self  : not null Guid_T_Access;
                          Other : not null Guid_T_Access) return Boolean
   is
      type DDS_GUID_T_Access is access all DDS_GUID_t;
      function Convert is new Ada.Unchecked_Conversion (Guid_T_Access, DDS_GUID_T_Access);
   begin
      return DDS_GUID_compare (Convert (Self), Convert (Other)) /= 0;
   end Guid_Compare;


   -----------
   -- Image --
   -----------

   function Image (Item : Guid_T) return DDS.String is
   begin
      return Ret : DDS.String do
         Copy (Ret, String'(Image (Item)));
      end return;
   end Image;
   subtype Octet_Image_String is Standard.String (1 .. 2);
   function Value (Item : Octet_Image_String) return Octet is
      Map : constant array (Character) of Octet := ('0'    => 0,
                                                    '1'    => 1,
                                                    '2'    => 2,
                                                    '3'    => 3,
                                                    '4'    => 4,
                                                    '5'    => 5,
                                                    '6'    => 6,
                                                    '7'    => 7,
                                                    '8'    => 8,
                                                    '9'    => 9,
                                                    'A'    => 10,
                                                    'B'    => 11,
                                                    'C'    => 12,
                                                    'D'    => 13,
                                                    'E'    => 14,
                                                    'F'    => 15,
                                                    others => 0);
      use type Interfaces.Unsigned_8;
   begin
      return (Map (item(Item'First)) * 16 + Map (Item(Item'First + 1)));
   end;
   -----------
   -- Value --
   -----------

   function Value (Item : Standard.String) return Guid_T is
      Cursor : Standard.Natural := Item'First;
   begin
      return ret : Guid_T do
         if Item'Length /= Ret.Value'Length * 2 then
            raise Constraint_Error with "invalid length";
         end if;
         for I in Ret.Value'First .. Ret.Value'Last loop
            Ret.Value (I) := Value (Item (Cursor .. Cursor + 1));
            Cursor := Cursor + 2;
         end loop;
      end return;
   end;

   -----------
   -- Image --
   -----------
   function Image (Item : Octet) return Standard.String is
      use Interfaces;
      Map : constant array (Unsigned_8'(0) .. Unsigned_8'(15)) of Character := "0123456789ABCDEF";
   begin
      return Map (Item / 16) & Map (Item mod 16);
   end;

   function Image (Item : Guid_T) return Standard.String is
      Cursor : Standard.Natural := 1;
   begin
      return Ret : Standard.String (1 .. (Item.Value'Length * 2)) do
         for V of Item.Value loop
            Ret (Cursor .. Cursor + 1) := Image (V);
            Cursor := Cursor + 2;
         end loop;
      end return;
   end Image;





   --  ===================================================================
   --  Suport routines for SequenceNumber_T

   --  #define DDS_SequenceNumber_plusplus(sn)
   --  ((++(sn)->low) == 0) ? ++(sn)->high : 0
   --  function SequenceNumber_Plusplus (Sn : SequenceNumber_T_Access)
   --                                  return Long is
   --  begin
   --     Sn.Low := +1;
   --     if Sn.Low = 0 then
   --        Sn.High := +1;
   --         return Sn.High
   --      else
   --        return 0
   --     end if;
   --  end SequenceNumber_Plusplus;

   --  #define DDS_SequenceNumber_minusminus(sn) \
   --  register RTI_UINT32 originalLow = (sn)->low; \
   --  --(sn)->low; \
   --  if (((sn)->low > originalLow)) { --(sn)->high; } \
   --  function SequenceNumber_Minusminus (Sn : SequenceNumber_T_Access)
   --                                      return Long is
   --  begin
   --     if Sn.Low > OriginalLow then

   --  end SequenceNumber_Minusminus;


   --  #define DDS_SequenceNumber_compare(sn1,sn2) \
   --    ((((sn1)->high) > ((sn2)->high)) ? 1 : \
   --     ((((sn1)->high) < ((sn2)->high)) ? -1 : \
   --      ((((sn1)->low) > ((sn2)->low)) ? 1 : \
   --       ((((sn1)->low) < ((sn2)->low)) ? -1 : 0))))


   --  ====================================================================
   --  Suport routines for ThreadSettings_t
   function ThreadSettings_T_Is_Equal
     (Self  : not null ThreadSettings_T_Access;
      Other : not null ThreadSettings_T_Access)
      return Boolean is
      pragma Unreferenced (Self, Other);
   begin
      --  TODO
      return True;
   end ThreadSettings_T_Is_Equal;

   --  ====================================================================
   --  Suport routines for QosPolicyCount

   procedure Initialize (Self  : in out QosPolicyCount) is
      pragma Unreferenced (Self);
   begin
      Self := (INVALID_QOS_POLICY_ID, 0);
   end Initialize;

   procedure Finalize (Self  : in out QosPolicyCount) is
   begin
      Self := (INVALID_QOS_POLICY_ID, 0);
   end Finalize;

   procedure Copy (Dst : in out QosPolicyCount; Src : in QosPolicyCount) is
   begin
      Dst := Src;
   end Copy;


   function "+" (Left, Right : aliased AllocationSettings_T) return AllocationSettings_T is
      procedure AllocationSettings_Add (Answer : AllocationSettings_T_Access;
                                        Left   : not null access constant AllocationSettings_T;
                                        Right  : not null access constant AllocationSettings_T);
      pragma Import (C, AllocationSettings_Add, "DDS_AllocationSettings_add");
   begin
      return Ret : AllocationSettings_T do
         AllocationSettings_Add (Ret'Unrestricted_Access,
                                 Left'Access,
                                 Right'Access);
      end return;
   end "+";
   function "=" (Left, Right : Cookie_T) return Standard.Boolean is
      function Cookie_Equals (Self : in Cookie_T_Access; Other : in Cookie_T_Access)
                              return DDS.Boolean;

      pragma Warnings (Off, Cookie_Equals);

      pragma Import (C, Cookie_Equals, "DDS_Cookie_equals");
   begin
      return Cookie_Equals (Left'Unrestricted_Access, Right'Unrestricted_Access);
   end "=";

   --  ====================================================================
   --  Suport routines for DataRepresentationId_T

   procedure Initialize (Self : in out DataRepresentationId_T) is
   begin
      Self := 0;
   end Initialize;

   procedure Finalize (Self : in out DataRepresentationId_T) is
   begin
      null;
   end Finalize;

   procedure Copy (Dst : in out DataRepresentationId_T;
                   Src : in DataRepresentationId_T) is
   begin
      Dst := Src;
   end Copy;

   function Contains
      (Policy : in DataRepresentationQosPolicy;
       Id     : in DataRepresentationId_T) return Standard.Boolean is

      function Internal
         (Policy : in System.Address;
          Id     : in DataRepresentationId_T) return DDS.Boolean;
      pragma Warnings (Off, Internal);
      pragma Import (C, Internal, "DDS_DataRepresentationQosPolicy_contains");
   begin
      return Internal (Policy'Address, Id);
   end Contains;

   function Equals
      (Left, Right : in DataRepresentationQosPolicy) return Standard.Boolean is

      function Internal (Left, Right : in System.Address) return DDS.Boolean;
      pragma Warnings (Off, Internal);
      pragma Import (C, Internal, "DDS_DataRepresentationQosPolicy_equals");
   begin
      return Internal (Left'Address, Right'Address);
   end Equals;

   --  ====================================================================
   --  Suport routines for Tags_T

   procedure Initialize (Self  : in out Tags_T) is
   begin
      DDS.Initialize (Self.Name);
      DDS.Initialize (Self.Value);
   end Initialize;

   procedure Finalize (Self  : in out Tags_T) is
   begin
      if Self.Name /= DDS.NULL_STRING then
         DDS.Finalize (Self.Name);
      end if;

      if Self.Value /= DDS.NULL_STRING then
         DDS.Finalize (Self.Value);
      end if;
   end Finalize;

   procedure Copy (Dst : in out Tags_T;
                   Src : in Tags_T) is
   begin
      Finalize (Dst);
      Copy (Dst.Name, Src.Name);
      Copy (Dst.Value, Src.Value);
   end Copy;

   --  ====================================================================
   --  Routines for DataTagQosPolicy

   function Lookup_Tag
      (Policy : in DataTagQosPolicy;
       Name   : in DDS.String) return Tags_T_Access is

      function Internal
         (Policy : in System.Address;
          Name   : in Interfaces.C.Strings.chars_ptr) return Tags_T_Access;
      pragma Import (C, Internal, "DDS_DataTagQosPolicyHelper_lookup_tag");
   begin
      return Internal (Policy'Address, Name.Data);
   end Lookup_Tag;

   procedure Assert_Tag
      (Policy : in DataTagQosPolicy;
       Name   : in DDS.String;
       Value  : in DDS.String) is

      function Internal
         (Policy : in System.Address;
          Name   : in Interfaces.C.Strings.chars_ptr;
          Value  : in Interfaces.C.Strings.chars_ptr) return ReturnCode_T;
      pragma Import (C, Internal, "DDS_DataTagQosPolicyHelper_assert_tag");
   begin
      Ret_Code_To_Exception
         (Internal (Policy'Address, Name.Data, Value.Data),
          "DDS_DataTagQosPolicyHelper_assert_tag");
   end Assert_Tag;

   procedure Add_Tag
      (Policy : in DataTagQosPolicy;
       Name   : in DDS.String;
       Value  : in DDS.String) is

      function Internal
         (Policy : in System.Address;
          Name   : in Interfaces.C.Strings.chars_ptr;
          Value  : in Interfaces.C.Strings.chars_ptr) return ReturnCode_T;
      pragma Import (C, Internal, "DDS_DataTagQosPolicyHelper_add_tag");
   begin
      Ret_Code_To_Exception
         (Internal (Policy'Address, Name.Data, Value.Data),
          "DDS_DataTagQosPolicyHelper_add_tag");
   end Add_Tag;

   procedure Remove_Tag
      (Policy : in DataTagQosPolicy;
       Name   : in DDS.String) is

      function Internal
         (Policy : in System.Address;
          Name   : in Interfaces.C.Strings.chars_ptr) return ReturnCode_T;
      pragma Import (C, Internal, "DDS_DataTagQosPolicyHelper_remove_tag");
   begin
      Ret_Code_To_Exception
         (Internal (Policy'Address, Name.Data),
          "DDS_DataTagQosPolicyHelper_remove_tag");
   end Remove_Tag;

   function Get_Number_Of_Tags
      (Policy : in DataTagQosPolicy) return DDS.Long is

      function Internal (Policy : in System.Address) return DDS.Long;
      pragma Import (C, Internal, "DDS_DataTagQosPolicyHelper_get_number_of_tags");
   begin
      return Internal (Policy'Address);
   end Get_Number_Of_Tags;

   --  ====================================================================
   --  Suport routines for SampleInfo

   procedure Initialize (Self  : in out SampleInfo) is
      pragma Unreferenced (Self);
   begin
      Self := (Sample_State                                         => 0,
               View_State                                           => 0,
               Instance_State                                       => 0,
               Source_Timestamp                                     => Time_Zero,
               Instance_Handle                                      => Null_InstanceHandle_T,
               Publication_Handle                                   => Null_InstanceHandle_T,
               Disposed_Generation_Count                            => 0,
               No_Writers_Generation_Count                          => 0,
               Sample_Rank                                          => 0,
               Generation_Rank                                      => 0,
               Absolute_Generation_Rank                             => 0,
               Valid_Data                                           => False,
               Reception_Timestamp                                  => Time_Zero,
               Publication_Sequence_Number                          => SEQUENCE_NUMBER_UNKNOWN,
               Reception_Sequence_Number                            => SEQUENCE_NUMBER_UNKNOWN,
               Publication_Virtual_Guid                             => (Value => (others => 0)),
               Publication_Virtual_Sequence_Number                  => SEQUENCE_NUMBER_UNKNOWN,
               Original_Publication_Virtual_Guid                    => (Value => (others => 0)),
               Original_Publication_Virtual_Sequence_Number         => SEQUENCE_NUMBER_UNKNOWN,
               Related_Original_Publication_Virtual_Guid            => (Value => (others => 0)),
               Related_Original_Publication_Virtual_Sequence_Number => SEQUENCE_NUMBER_UNKNOWN,
               Flag                                                 => 0,
               Source_Guid                                          => GUID_UNKNOWN,
               Related_Source_Guid                                  => GUID_UNKNOWN,
               Related_Subscription_Guid                            => GUID_UNKNOWN,
               Topic_Query_Guid                                     => GUID_UNKNOWN,
               Sample_Info_Hash                                     => ((others => 0), 0, 0),
               Sample_Signature                                     => null,
               Encapsulation_Id                                     => 0,
               Related_Epoch                                        => SEQUENCE_NUMBER_UNKNOWN
              );
   end Initialize;

   procedure Finalize (Self  : in out SampleInfo) is
      pragma Unreferenced (Self);
   begin
      null;
   end Finalize;

   procedure Copy (Dst : in out SampleInfo; Src : in SampleInfo) is
   begin
      Dst := Src;
   end Copy;

   procedure Get_Sample_Identity (From : SampleInfo; Id : out SampleIdentity_T) is
   begin
      Id := (Writer_Guid => From.Original_Publication_Virtual_Guid,
             Sequence_Number => From.Original_Publication_Virtual_Sequence_Number);
   end;

   function Get_Sample_Identity (From : SampleInfo) return  SampleIdentity_T  is
   begin
      return Ret : SampleIdentity_T do
         Get_Sample_Identity (From, Ret);
      end return;
   end;

   procedure Get_Related_Sample_Identity (From : SampleInfo; Id : out SampleIdentity_T) is
   begin
      Id := (Writer_Guid => From.Related_Original_Publication_Virtual_Guid,
             Sequence_Number => From.Related_Original_Publication_Virtual_Sequence_Number);
   end;

   function Get_Related_Sample_Identity (From : SampleInfo) return  SampleIdentity_T  is
   begin
      return Ret : SampleIdentity_T do
         Get_Related_Sample_Identity (From, Ret);
      end return;
   end;

   --  ====================================================================
   --  Suport routines for TransportUnicastSettings_T

   procedure Initialize (Self  : in out TransportUnicastSettings_T) is
   begin
      String_Seq.Initialize (Self.Transports'Unrestricted_Access);
      Self.Receive_Port := 0;
   end Initialize;

   procedure Finalize (Self  : in out TransportUnicastSettings_T) is
   begin
      String_Seq.Finalize (Self.Transports'Unrestricted_Access);
      Self.Receive_Port := 0;
   end Finalize;

   procedure Copy (Dst : in out TransportUnicastSettings_T; Src : in TransportUnicastSettings_T) is
   begin
      String_Seq.Copy (Dst.Transports'Unrestricted_Access,
                       Src.Transports'Unrestricted_Access);
      Dst.Receive_Port := Src.Receive_Port;
   end Copy;

   --  ====================================================================
   --  Suport routines for TransportMulticastSettings_T

   procedure Initialize (Self  : in out TransportMulticastSettings_T) is
   begin
      String_Seq.Copy (Self.Transports'Unrestricted_Access,
                       String_Seq.DEFAULT_SEQUENCE'Unrestricted_Access);
      Self.Receive_Address.Data := Interfaces.C.Strings.Null_Ptr;
      Self.Receive_Port := 0;
   end Initialize;

   procedure Finalize (Self  : in out TransportMulticastSettings_T) is
   begin
      String_Seq.Finalize (Self.Transports'Unrestricted_Access);
      Interfaces.C.Strings.Free (Self.Receive_Address.Data);
      Self.Receive_Port := 0;
   end Finalize;

   procedure Copy (Dst : in out TransportMulticastSettings_T; Src : in TransportMulticastSettings_T) is
   begin
      String_Seq.Copy (Dst.Transports'Unrestricted_Access,
                       Src.Transports'Unrestricted_Access);
      Dst.Receive_Address.Data := New_String (Value (Src.Receive_Address.Data));
      Dst.Receive_Port := Src.Receive_Port;

   end Copy;

   --  ====================================================================
   --  Suport routines for EncapsulationId_T

   procedure Initialize (Self  : in out EncapsulationId_T) is
   begin
      Self := 0;
   end Initialize;

   procedure Finalize (Self  : in out EncapsulationId_T) is
      pragma Unreferenced (Self);
   begin
      null;
   end Finalize;

   procedure Copy (Dst : in out EncapsulationId_T; Src : in EncapsulationId_T) is
   begin
      Dst := Src;
   end Copy;

   --  ====================================================================
   --  Suport routines for TransportMulticastMapping_T

   procedure Initialize (Self  : in out TransportMulticastMapping_T) is
   begin
      Initialize (Self.Addresses);
      Initialize (Self.Topic_Expression);
      --  Initialize (Self.mapping_function);
   end Initialize;

   procedure Finalize (Self  : in out TransportMulticastMapping_T) is
   begin
      Finalize (Self.Addresses);
      Finalize (Self.Topic_Expression);
      --  Finalize (Self.mapping_function);
   end Finalize;

   procedure Copy (Dst : in out TransportMulticastMapping_T; Src : in TransportMulticastMapping_T) is
   begin
      Copy (Dst.Addresses, Src.Addresses);
      Copy (Dst.Topic_Expression, Src.Topic_Expression);
      --  Copy (Dst.mapping_function, Src.mapping_function);
   end Copy;


   --  ====================================================================
   --  Suport routines for TransportEncapsulationSettings_T

   procedure Initialize (Self  : in out TransportEncapsulationSettings_T) is
   begin
      DDS.String_Seq.Initialize (Self.Transports'Unrestricted_Access);
      DDS.EncapsulationId_Seq.Initialize (Self.Encapsulations'Unrestricted_Access);
   end Initialize;

   procedure Finalize (Self  : in out TransportEncapsulationSettings_T) is
   begin
      DDS.String_Seq.Finalize (Self.Transports'Unrestricted_Access);
      DDS.EncapsulationId_Seq.Finalize (Self.Encapsulations'Unrestricted_Access);
   end Finalize;

   procedure Copy (Dst : in out TransportEncapsulationSettings_T; Src : in TransportEncapsulationSettings_T) is
   begin
      DDS.String_Seq.Copy (Dst.Transports'Unrestricted_Access, Src.Transports'Unrestricted_Access);
      DDS.EncapsulationId_Seq.Copy (Dst.Encapsulations'Unrestricted_Access, Src.Encapsulations'Unrestricted_Access);
   end Copy;

   --  ====================================================================
   --  Suport routines for LocatorFilter_T

   procedure Initialize (Self  : in out LocatorFilter_T) is
   begin
      DDS.Locator_Seq.Initialize (Self.Locators'Unrestricted_Access);
   end Initialize;

   procedure Finalize (Self  : in out LocatorFilter_T) is
   begin
      DDS.Locator_Seq.Finalize (Self.Locators'Unrestricted_Access);
   end Finalize;

   procedure Copy (Dst : in out LocatorFilter_T; Src : in LocatorFilter_T) is
   begin
      DDS.Locator_Seq.Copy (Dst.Locators'Unrestricted_Access, Src.Locators'Unrestricted_Access);
      DDS.Copy (Dst.Filter_Expression, Src.Filter_Expression);
   end Copy;

   --  ====================================================================
   --  Suport routines for ChannelSettings_T

   procedure Initialize (Self  : in out ChannelSettings_T) is
   begin
      TransportMulticastSettings_Seq.Copy (Self.Multicast_Settings'Unrestricted_Access,
                                           TransportMulticastSettings_Seq.DEFAULT_SEQUENCE'Unrestricted_Access);
      Self.Filter_Expression.Data := Interfaces.C.Strings.Null_Ptr;
   end Initialize;

   procedure Finalize (Self  : in out ChannelSettings_T) is
   begin
      TransportMulticastSettings_Seq.Finalize (Self.Multicast_Settings'Unrestricted_Access);
      Interfaces.C.Strings.Free (Self.Filter_Expression.Data);
   end Finalize;

   procedure Copy (Dst : in out ChannelSettings_T; Src : in ChannelSettings_T) is
   begin
      TransportMulticastSettings_Seq.Copy (Dst.Multicast_Settings'Unrestricted_Access,
                                           Src.Multicast_Settings'Unrestricted_Access);
      Dst.Filter_Expression.Data := New_String (Value (Src.Filter_Expression.Data));

   end Copy;

   --  ====================================================================
   --  Suport routines for Discovery_ParticipantInformation

   procedure Initialize (Self : in out Discovery_ParticipantInformation) is
   begin
      Self.Participant_Discovery_Id := 0;
      Self.Participant_Discovery_Version := 0;
      Self.Participant_Discovery_Vendor_Id := 0;
      Octet_Seq.Initialize (Self.Participant_Discovery_Parameters'Unrestricted_Access);
   end Initialize;

   procedure Finalize (Self : in out Discovery_ParticipantInformation) is
   begin
      Self.Participant_Discovery_Id := 0;
      Self.Participant_Discovery_Version := 0;
      Self.Participant_Discovery_Vendor_Id := 0;
      Octet_Seq.Finalize (Self.Participant_Discovery_Parameters'Unrestricted_Access);
   end  Finalize;

   procedure Copy (Dst : in out Discovery_ParticipantInformation;
                   Src : in Discovery_ParticipantInformation) is
   begin
      Dst.Participant_Discovery_Id := Src.Participant_Discovery_Id;
      Dst.Participant_Discovery_Version := Src.Participant_Discovery_Version;
      Dst.Participant_Discovery_Vendor_Id := Src.Participant_Discovery_Vendor_Id;
      Octet_Seq.Copy (Dst.Participant_Discovery_Parameters'Unrestricted_Access,
                      Src.Participant_Discovery_Parameters'Unrestricted_Access);
   end Copy;

   --  ====================================================================
   --  Suport routines for Discovery_EndpointInformation

   procedure Initialize (Self : in out Discovery_EndpointInformation) is
   begin
      Self.Endpoint_Discovery_Id := 0;
      Self.Endpoint_Discovery_Version := 0;
      Self.Endpoint_Discovery_Vendor_Id := 0;
      Octet_Seq.Initialize (Self.Endpoint_Discovery_Parameters'Unrestricted_Access);
   end Initialize;

   procedure Finalize (Self : in out Discovery_EndpointInformation) is
   begin
      Self.Endpoint_Discovery_Id := 0;
      Self.Endpoint_Discovery_Version := 0;
      Self.Endpoint_Discovery_Vendor_Id := 0;
      Octet_Seq.Finalize (Self.Endpoint_Discovery_Parameters'Unrestricted_Access);
   end Finalize;

   procedure Copy (Dst : in out Discovery_EndpointInformation;
                   Src : in Discovery_EndpointInformation) is
   begin
      Dst.Endpoint_Discovery_Id := Src.Endpoint_Discovery_Id;
      Dst.Endpoint_Discovery_Version := Src.Endpoint_Discovery_Version;
      Dst.Endpoint_Discovery_Vendor_Id := Src.Endpoint_Discovery_Vendor_Id;
      Octet_Seq.Copy (Dst.Endpoint_Discovery_Parameters'Unrestricted_Access,
                      Src.Endpoint_Discovery_Parameters'Unrestricted_Access);
   end Copy;

   --  ====================================================================
   --  Suport routines for Locator_T
   procedure Initialize (Self  : in out Locator_T) is
   begin
      Self.Kind := 0;
      Self.Port := 0;
      EncapsulationId_Seq.Initialize (Self.Encapsulations'Unrestricted_Access);
   end Initialize;
   procedure Finalize (Self  : in out Locator_T) is
   begin
      Self.Kind := 0;
      Self.Port := 0;
      EncapsulationId_Seq.Finalize (Self.Encapsulations'Unrestricted_Access);
   end Finalize;
   procedure Copy (Dst : in out Locator_T; Src : in Locator_T) is
   begin
      Dst.Kind := Src.Kind;
      Dst.Port := Src.Port;
      Dst.Address := Src.Address;
      EncapsulationId_Seq.Copy (Dst.Encapsulations'Unrestricted_Access,
                                Src.Encapsulations'Unrestricted_Access);
   end Copy;


   --  ====================================================================
   --  Suport routines for Property_T

   procedure Initialize (Self  : in out Property_T) is
   begin
      Self.Name.Data := Null_Ptr;
      Self.Value.Data := Null_Ptr;
   end Initialize;

   procedure Finalize (Self  : in out Property_T) is
   begin
      Interfaces.C.Strings.Free (Self.Name.Data);
      Interfaces.C.Strings.Free (Self.Value.Data);
   end Finalize;

   procedure Copy (Dst : in out Property_T; Src : in Property_T) is
   begin
      if Src.Name.Data = Null_Ptr then
         Dst.Name.Data := Null_Ptr;
      else
         Dst.Name.Data := New_String (Value (Src.Name.Data));
      end if;
      if Src.Value.Data = Null_Ptr then
         Dst.Value.Data := Null_Ptr;
      else
         Dst.Value.Data := New_String (Value (Src.Value.Data));
      end if;
   end Copy;

   --  ====================================================================
   --  Suport routines for EndpointGroup_T

   procedure Initialize (Self  : in out EndpointGroup_T) is
   begin
      Self.Role_Name.Data := Null_Ptr;
      Self.Quorum_Count := 0;
   end Initialize;

   procedure Finalize (Self  : in out EndpointGroup_T) is
   begin
      Interfaces.C.Strings.Free (Self.Role_Name.Data);
   end Finalize;

   procedure Copy (Dst : in out EndpointGroup_T; Src : in EndpointGroup_T) is
   begin
      if Src.Role_Name.Data = Null_Ptr then
         Dst.Role_Name.Data := Null_Ptr;
      else
         Dst.Role_Name.Data := New_String (Value (Src.Role_Name.Data));
      end if;
      Dst.Quorum_Count := Src.Quorum_Count;
   end Copy;


   function BuiltinTopicKey_Equals (A : in BuiltinTopicKey_T_Access;
                                    B : in BuiltinTopicKey_T_Access)
                                    return DDS.Boolean is
   begin
      if (A.Value (0) = B.Value (0))  and
        (A.Value (1) = B.Value (1))  and
        (A.Value (2) = B.Value (2))  and
        (A.Value (3) = B.Value (3))
      then
         return True;
      else
         return False;
      end if;
   end BuiltinTopicKey_Equals;


   --  Qos Subprograms

   procedure Initialize (Self : in out TopicQos) is
   begin
      Ret_Code_To_Exception (RTIDDS.Low_Level.ndds_dds_c_dds_c_topic_h.DDS_TopicQos_initialize (GetInterface (Self)));
   end Initialize;

   procedure Finalize (Self : in out TopicQos) is
   begin
      Ret_Code_To_Exception (DDS_TopicQos_finalize (GetInterface (Self)));
   end Finalize;

   procedure Copy (Target : in out TopicQos;
                   Source : in TopicQos) is
   begin
      Ret_Code_To_Exception (DDS_TopicQos_copy (GetInterface (Target), GetInterface (Source)));
   end Copy;

   procedure Initialize (Self : in out DataWriterQos) is
   begin
      Ret_Code_To_Exception (RTIDDS.Low_Level.ndds_dds_c_dds_c_publication_h.DDS_DataWriterQos_initialize (GetInterface (Self)));
   end Initialize;

   procedure Finalize (Self : in out DataWriterQos) is
   begin
      Ret_Code_To_Exception (RTIDDS.Low_Level.ndds_dds_c_dds_c_publication_h.DDS_DataWriterQos_finalize (GetInterface (Self)));
   end Finalize;

   procedure Copy (Target : out DataWriterQos;
                   Source : in DataWriterQos) is
      pragma Warnings (Off, Target);
   begin
      Ret_Code_To_Exception (RTIDDS.Low_Level.ndds_dds_c_dds_c_publication_h.DDS_DataWriterQos_copy (GetInterface (Target), GetInterface (Source)));
   end Copy;

   procedure Initialize (Self : in out PublisherQos) is
   begin
      Ret_Code_To_Exception (DDS_PublisherQos_initialize (GetInterface (Self)));
   end Initialize;

   procedure Finalize (Self : in out PublisherQos) is
   begin
      Ret_Code_To_Exception (DDS_PublisherQos_finalize (GetInterface (Self)));
   end Finalize;

   procedure Copy (Target : out PublisherQos;
                   Source : in  PublisherQos) is
      pragma Warnings (Off, Target);
   begin
      Ret_Code_To_Exception (DDS_PublisherQos_copy (GetInterface (Target), GetInterface (Source)));
   end Copy;


   procedure Initialize (Self : in out DataReaderQoS) is
   begin
      Ret_Code_To_Exception  (RTIDDS.Low_Level.ndds_dds_c_dds_c_subscription_h.DDS_DataReaderQos_initialize (GetInterface (Self)));
   end Initialize;

   ----------------------------------------------------
   --  DataReaderQoS routines
   ----------------------------------------------------
   procedure Finalize (Self : in out DataReaderQoS) is
   begin
      Ret_Code_To_Exception  (RTIDDS.Low_Level.ndds_dds_c_dds_c_subscription_h.DDS_DataReaderQos_finalize (GetInterface (Self)));
   end Finalize;

   procedure Copy (Target : out DataReaderQoS;
                   Source : in DataReaderQoS) is
      pragma Warnings (Off, Target);
   begin
      Ret_Code_To_Exception  (RTIDDS.Low_Level.ndds_dds_c_dds_c_subscription_h.DDS_DataReaderQos_copy
                              (GetInterface (Target), GetInterface (Source)));
   end Copy;

   function GetInterface (P_Qos : DataReaderQoS) return access RTIDDS.Low_Level.ndds_dds_c_dds_c_subscription_h.DDS_DataReaderQos is
      type Temp_Ref_Type is access RTIDDS.Low_Level.ndds_dds_c_dds_c_subscription_h.DDS_DataReaderQos;
      function Convert is new Ada.Unchecked_Conversion (System.Address, Temp_Ref_Type);
   begin
      return Convert (P_Qos.Durability'Address).all'Unrestricted_Access;
   end GetInterface;


   ----------------------------------------------------
   --  SubscriberQos routines
   ----------------------------------------------------

   procedure Initialize (Self : in out SubscriberQos) is
   begin
      Ret_Code_To_Exception (DDS_SubscriberQos_initialize (GetInterface (Self)));
   end Initialize;

   procedure Finalize (Self : in out SubscriberQos) is
   begin
      Ret_Code_To_Exception (DDS_SubscriberQos_finalize (GetInterface (Self)));
   end Finalize;

   procedure Copy (Target : out SubscriberQos;
                   Source : in SubscriberQos) is
      pragma Warnings (Off, Target);
   begin
      Ret_Code_To_Exception (DDS_SubscriberQos_copy (GetInterface (Target), GetInterface (Source)));
   end Copy;

   function GetInterface (P_Qos : SubscriberQos) return access RTIDDS.Low_Level.ndds_dds_c_dds_c_subscription_h.DDS_SubscriberQos is
      type Temp_Ref_Type is access RTIDDS.Low_Level.ndds_dds_c_dds_c_subscription_h.DDS_SubscriberQos;
      function Convert is new Ada.Unchecked_Conversion (System.Address, Temp_Ref_Type);
   begin
      return Convert (P_Qos.Presentation'Address).all'Unrestricted_Access;
   end GetInterface;

   ----------------------------------------------------
   --  DomainParticipantQos Routines
   ----------------------------------------------------
   procedure Initialize (Self : in out DomainParticipantQos) is
   begin
      Ret_Code_To_Exception (DDS_DomainParticipantQos_initialize (GetInterface (Self)));
   end Initialize;

   procedure Finalize (Self : in out DomainParticipantQos) is
   begin
      Ret_Code_To_Exception (DDS_DomainParticipantQos_finalize (GetInterface (Self)));
   end Finalize;

   procedure Copy (Target : out  DomainParticipantQos;
                   Source : in DomainParticipantQos) is
      pragma Warnings (Off, Target);
   begin
      Ret_Code_To_Exception
        (DDS_DomainParticipantQos_copy
           (GetInterface (Target),
            GetInterface (Source)));
   end Copy;

   function GetInterface (P_Qos : in DomainParticipantQos) return access RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h.DDS_DomainParticipantQos is
      type Temp_Ref_Type is access RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h.DDS_DomainParticipantQos;
      function Convert is new Ada.Unchecked_Conversion (System.Address, Temp_Ref_Type);
   begin
      return Convert (P_Qos.User_Data'Address).all'Unrestricted_Access;

   end GetInterface;
   -----------------------------------------------
   --
   -----------------------------------------------

   --  Participant Qos Private Subprograms
   function GetInterface (P_Qos : TopicQos) return access RTIDDS.Low_Level.ndds_dds_c_dds_c_topic_h.DDS_TopicQos is
      type Temp_Ref_Type is access RTIDDS.Low_Level.ndds_dds_c_dds_c_topic_h.DDS_TopicQos;
      function Convert is new Ada.Unchecked_Conversion (System.Address, Temp_Ref_Type);
   begin
      return Convert (P_Qos.Topic_Data'Address).all'Unrestricted_Access;
   end GetInterface;

   function GetInterface (P_Qos : DataWriterQos) return access RTIDDS.Low_Level.ndds_dds_c_dds_c_publication_h.DDS_DataWriterQos is
      type Temp_Ref_Type is access RTIDDS.Low_Level.ndds_dds_c_dds_c_publication_h.DDS_DataWriterQos;
      function Convert is new Ada.Unchecked_Conversion (System.Address, Temp_Ref_Type);
   begin
      return Convert (P_Qos.Durability'Address).all'Unrestricted_Access;
   end GetInterface;

   function GetInterface (P_Qos : PublisherQos) return access RTIDDS.Low_Level.ndds_dds_c_dds_c_publication_h.DDS_PublisherQos is
      type Temp_Ref_Type is access RTIDDS.Low_Level.ndds_dds_c_dds_c_publication_h.DDS_PublisherQos;
      function Convert is new Ada.Unchecked_Conversion (System.Address, Temp_Ref_Type);
   begin
      return Convert (P_Qos.Presentation'Address).all'Unrestricted_Access;
   end GetInterface;

   function GetInterface (FC_P : FlowControllerProperty_T) return access RTIDDS.Low_Level.ndds_dds_c_dds_c_flowcontroller_h.DDS_FlowControllerProperty_t is
      type Temp_Ref_Type is access RTIDDS.Low_Level.ndds_dds_c_dds_c_flowcontroller_h.DDS_FlowControllerProperty_t;
      function Convert is new Ada.Unchecked_Conversion (System.Address, Temp_Ref_Type);
   begin
      return Convert (FC_P'Address).all'Unrestricted_Access;
   end GetInterface;


   procedure Validate_Library is
      Actual_Version : constant Standard.String := RTIDDS.Config.get_product_version;
   begin
      if Actual_Version /= Binding_Version then
         raise Program_Error with "Only NDDS '" & Binding_Version & "' suported, found :'"  & Actual_Version & "'.";
      end if;
   end Validate_Library;

   function GetInterface (P_Qos : DomainParticipantFactoryQos) return access RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h.DDS_DomainParticipantFactoryQos is
      type Temp_Ref_Type is access RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h.DDS_DomainParticipantFactoryQos;
      function Convert is new Ada.Unchecked_Conversion (System.Address, Temp_Ref_Type);
   begin
      return Convert (P_Qos.Entity_Factory'Address).all'Unrestricted_Access;
   end GetInterface;


   procedure Finalize (Self : in out DomainParticipantFactoryQos) is
   begin
      Ret_Code_To_Exception (RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h.DDS_DomainParticipantFactoryQos_finalize (GetInterface (Self)));
   end Finalize;

   procedure Initialize (Self : in out DomainParticipantFactoryQos) is
   begin
      Ret_Code_To_Exception (RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h.DDS_DomainParticipantFactoryQos_initialize (GetInterface (Self)));
   end Initialize;

   procedure Copy (C_Out : not null access FlowControllerProperty_T;
                   C_In  : not null access FlowControllerProperty_T) is
   begin
      C_Out.all :=  C_In.all;
   end Copy;

   procedure Copy (Target : out DomainParticipantFactoryQos;
                   Source : in DomainParticipantFactoryQos) is
      pragma Warnings (Off, Target);
   begin
      Ret_Code_To_Exception
        (RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h.DDS_DomainParticipantFactoryQos_copy
           (GetInterface (Target),
            GetInterface (Source)));
   end Copy;

   function To_Duration (D : Duration_T) return Standard.Duration is
   begin
      return Duration (Long_Float (D.Sec) * 1.0 +
                         Long_Float (D.Nanosec) * 0.000_000_001);
   end To_Duration;

   function To_Duration_T (D : Standard.Duration) return Duration_T is
      Temp : constant Long_Float := Long_Float'Truncation (Long_Float (D));
   begin
      return Ret : Duration_T do
         if D = Duration'Last then
            Ret := DURATION_INFINITE;
         else
            Ret.Sec := Long (Temp);
            Ret.Nanosec := Unsigned_Long ((Long_Float (D) - Temp) * 1_000_000_000.0);
         end if;
      end return;
   end To_Duration_T;

   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_common_h.DDS_UnsignedLong;
                        Source : DDS.Unsigned_Long) is
   begin
      Dst := RTIDDS.Low_Level.ndds_dds_c_dds_c_common_h.DDS_UnsignedLong (Source);
   end Copy_Down;

   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_Time_t;
                        Source : DDS.Time_T) is
   begin
      Dst.sec     := Interfaces.C.int (Source.Sec);
      Dst.nanosec := Interfaces.C.unsigned (Source.Nanosec);
   end Copy_Down;

   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_common_h.DDS_Boolean;
                        Source : DDS.Boolean) is
   begin
      Dst := (if Source then 1 else 0);
   end Copy_Down;


   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_GUID_t_value_array;
                        Source : DDS.GUID_T_Value_Array) is
      function Convert is new Ada.Unchecked_Conversion (Source => DDS.GUID_T_Value_Array, Target => RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_GUID_t_value_array);
   begin
      Dst := Convert (Source);
   end Copy_Down;

   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_GUID_t;
                        Source : DDS.Guid_T) is
   begin
      Copy_Down (Dst => Dst.value, Source => Source.Value);
   end Copy_Down;

   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_common_h.DDS_Long;
                        Source : DDS.Long) is
   begin
      Dst := RTIDDS.Low_Level.ndds_dds_c_dds_c_common_h.DDS_Long (Source);
   end Copy_Down;

   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_SequenceNumber_t;
                        Source : DDS.SequenceNumber_T) is
   begin
      Copy_Down (Dst.high, Source.High);
      Copy_Down (Dst.low, Source.Low);
   end Copy_Down;


   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_SampleIdentity_t;
                        Source : DDS.SampleIdentity_T) is
   begin
      Copy_Down (Dst => Dst.writer_guid, Source => Source.Writer_Guid);
      Copy_Down (Dst => Dst.sequence_number, Source => Source.Sequence_Number);
   end Copy_Down;

   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_OctetSeq;
                        Source : DDS.Octet_Seq.Sequence) is
      function Convert is new Ada.Unchecked_Conversion
        (Source => DDS.Octet_Seq.Sequence,
         Target => RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_OctetSeq);
   begin
      Dst := Convert (Source);
   end Copy_Down;

   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_Cookie_t;
                        Source : DDS.Cookie_T) is
   begin
      Copy_Down (Dst => Dst.value, Source => Source.Value);
   end Copy_Down;

   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_common_h.DDS_Long;
                        Source : DDS.SampleFlag) is
   begin
      Dst := RTIDDS.Low_Level.ndds_dds_c_dds_c_common_h.DDS_Long (Source);
   end Copy_Down;

   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_WriteParams_t;
                        Source : DDS.WriteParams_T) is

   begin
      Copy_Down (Dst => Dst.related_sample_identity, Source => Source.Related_Sample_Identity);
      Copy_Down (Dst => Dst.source_timestamp, Source => Source.Source_Timestamp);
      Copy_Down (Dst => Dst.cookie, Source => Source.Cookie);
      Copy_Down (Dst => Dst.handle, Source => Source.Handle);
      Copy_Down (Dst => Dst.priority, Source => Source.Priority);
      Copy_Down (Dst => Dst.flush_on_write, Source => Source.Flush_On_Write);
      Copy_Down (Dst => Dst.flag, Source => Source.Flag);
      Copy_Down (Dst => Dst.source_guid, Source => Source.Source_Guid);
      Copy_Down (Dst => Dst.related_source_guid, Source => Source.Related_Source_Guid);
      Copy_Down (Dst => Dst.related_reader_guid, Source => Source.Related_Reader_Guid);
   end Copy_Down;


   procedure Copy_Up (Dst    : out DDS.Time_T;
                      Source : RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_Time_t) is
   begin
      Dst.Sec     := Long (Source.sec);
      Dst.Nanosec := Unsigned_Long (Source.nanosec);
   end Copy_Up;

   procedure Copy_Down (Dst    : out RTIDDS.Low_Level.ndds_pres_pres_participant_h.PRESInstanceHandle;
                        Source : DDS.InstanceHandle_T) is
   begin
      Dst.keyHash :=  Source.keyHash;
      Dst.isValid := Source.isValid;
   end Copy_Down;

   procedure Copy_Up (Dst    : out DDS.InstanceHandle_T;
                      Source : RTIDDS.Low_Level.ndds_pres_pres_participant_h.PRESInstanceHandle) is
   begin
      Dst.keyHash :=  Source.keyHash;
      Dst.isValid := Source.isValid;
   end Copy_Up;

   --  ====================================================================
   --  Suport routines for WriteParams_T
   procedure Initialize (Self : in out WriteParams_T) is
   begin
      DDS_WriteParams_t_initialize (Self'Address);
   end Initialize;

   procedure Finalize (Self : in out WriteParams_T) is
   begin
      DDS_WriteParams_t_finalize (Self'Address);
   end Finalize;

   procedure Copy (Dst  : in out WriteParams_T; Src : in WriteParams_T) is
      Unused : System.Address;
      pragma Warnings (Off, Unused);
   begin
      Unused := DDS_WriteParams_t_copy (Dst'Address, Src'Address);
   end Copy;

   --  ====================================================================
   --  Suport routines for TransportInfo_t
   procedure Initialize (This : in out TransportInfo_T) is
   begin
      This := (0, 0);
   end Initialize;
   procedure Finalize (This : in out TransportInfo_T) is
   begin
      null;
   end Finalize;
   procedure Copy (Dst : in out TransportInfo_T;
                   Src : in TransportInfo_T) is
   begin
      Dst := Src;
   end Copy;

   --  ====================================================================
   --  Suport routines for ParticipantBuiltinTopicData

   procedure Initialize
     (This : in out ParticipantBuiltinTopicData)
   is
   begin
      if DDS_ParticipantBuiltinTopicData_initialize_ex (DDS_ParticipantBuiltinTopicData_Conv.To_Pointer (This'Address).all'Access, 1, 1) = 0 then
         raise Standard.DDS.ERROR with "unable to initialize";
      end if;
   end Initialize;

   procedure Finalize
     (This            : in out ParticipantBuiltinTopicData) is
      procedure Internal
        (This : access ParticipantBuiltinTopicData);
      pragma Warnings (Off, Internal);
      pragma Import (C, Internal, "DDS_ParticipantBuiltinTopicData_finalize_ex");
   begin
      Internal (This'Unrestricted_Access);
   end Finalize;

   procedure Copy
     (Dst : in out ParticipantBuiltinTopicData;
      Src : in ParticipantBuiltinTopicData) is
   begin
      if DDS_ParticipantBuiltinTopicData_copy
        (Dst'Address, Src'Address) = 0
      then
         raise Standard.DDS.ERROR with "unable to copy";
      end if;
   end Copy;

   --  ====================================================================
   --  Suport routines for TopicBuiltinTopicData

   procedure Initialize
     (This              : in out TopicBuiltinTopicData) is
   begin
      if DDS_TopicBuiltinTopicData_initialize_ex (DDS_TopicBuiltinTopicData_Conv.To_Pointer (This'Address), 1, 1) = 0 then
         raise Standard.DDS.ERROR with "unable to initialize";
      end if;
   end Initialize;

   procedure Finalize
     (This            : in out TopicBuiltinTopicData) is
      procedure Internal
        (This : access TopicBuiltinTopicData);
      pragma Warnings (Off, Internal);
      pragma Import (C, Internal, "DDS_TopicBuiltinTopicData_finalize_ex");
   begin
      Internal (This'Unrestricted_Access);
   end Finalize;

   procedure Copy
     (Dst : in out TopicBuiltinTopicData;
      Src : in TopicBuiltinTopicData) is
   begin
      if  DDS_TopicBuiltinTopicData_copy (Dst'Address, Src'Address) = 0 then
         raise Standard.DDS.ERROR with "unable to copy";
      end if;
   end Copy;

   --  ====================================================================
   --  Suport routines for PublicationBuiltinTopicData

   procedure Initialize
     (This              : in out PublicationBuiltinTopicData) is
   begin
      if DDS_PublicationBuiltinTopicData_initialize_ex (DDS_PublicationBuiltinTopicData_Conv.To_Pointer (This'Address), 1, 1) = 0 then
         raise Standard.DDS.ERROR with "unable to initialize";
      end if;
   end Initialize;

   procedure Finalize
     (This            : in out PublicationBuiltinTopicData) is
      procedure Internal
        (This : access PublicationBuiltinTopicData);
      pragma Warnings (Off, Internal);
      pragma Import (C, Internal, "DDS_PublicationBuiltinTopicData_finalize_ex");
   begin
      DDS_PublicationBuiltinTopicData_finalize_ex (DDS_PublicationBuiltinTopicData_Conv.To_Pointer (This'Address), 1);
   end Finalize;

   procedure Copy
     (Dst : in out PublicationBuiltinTopicData;
      Src : in PublicationBuiltinTopicData) is
   begin
      if  DDS_PublicationBuiltinTopicData_copy (Dst'Address, Src'Address) = 0 then
         raise Standard.DDS.ERROR with "unable to copy";
      end if;
   end Copy;

   --  ====================================================================
   --  Suport routines for SubscriptionBuiltinTopicData

   procedure Initialize
     (This              : in out SubscriptionBuiltinTopicData) is
   begin
      if DDS_SubscriptionBuiltinTopicData_initialize_ex (DDS_SubscriptionBuiltinTopicData_Conv.To_Pointer (This'Address), 1, 1) = 0 then
         raise Standard.DDS.ERROR with "unable to initialize";
      end if;
   end Initialize;

   procedure Finalize
     (This            : in out SubscriptionBuiltinTopicData) is
      procedure Internal
        (This : access SubscriptionBuiltinTopicData);
      pragma Warnings (Off, Internal);
      pragma Import (C, Internal, "DDS_SubscriptionBuiltinTopicData_finalize_ex");
   begin
      DDS_SubscriptionBuiltinTopicData_finalize_ex (DDS_SubscriptionBuiltinTopicData_Conv.To_Pointer (This'Address), 1);
   end Finalize;

   procedure Copy
     (Dst : in out SubscriptionBuiltinTopicData;
      Src : in SubscriptionBuiltinTopicData) is
   begin
      if  DDS_SubscriptionBuiltinTopicData_copy (Dst'Address, Src'Address) = 0 then
         raise Standard.DDS.ERROR with "unable to copy";
      end if;
   end Copy;

   --  ====================================================================
   --  Suport routines for DDS_Octets

   function Octets_New
     return Octets_Ptr
   is
      function Internal
        return Octets_Ptr;
      pragma Import (C, Internal, "DDS_Octets_new");
   begin
      return Internal;
   end Octets_New;

   function Octets_New_W_Size
     (Size : Integer)
      return Octets_Ptr
   is
      function Internal
        (Size : Integer)
         return Octets_Ptr;
      pragma Import (C, Internal, "DDS_Octets_new_w_size");
   begin
      return Internal (Size);
   end Octets_New_W_Size;

   procedure Octets_Delete
     (Self : Octets_Ptr)
   is
      procedure Internal
        (Self : Octets_Ptr);
      pragma Import (C, Internal, "DDS_Octets_delete");
   begin
      Internal (Self);
   end Octets_Delete;

   --  ====================================================================
   --  Suport routines for DDS_KeyedString

   function KeyedString_New
     return KeyedString_Ptr
   is
      function Internal
        return KeyedString_Ptr;
      pragma Import (C, Internal, "DDS_KeyedString_new");
   begin
      return Internal;
   end KeyedString_New;

   function KeyedString_New_W_Size
     (Key_Size : Integer;
      Size     : Integer)
      return KeyedString_Ptr
   is
      function Internal
        (Key_Size : Integer;
         Size     : Integer)
         return KeyedString_Ptr;
      pragma Import (C, Internal, "DDS_KeyedString_new_w_size");
   begin
      return Internal (Key_Size, Size);
   end KeyedString_New_W_Size;

   procedure KeyedString_Delete
     (Self : KeyedString_Ptr)
   is
      procedure Internal
        (Self : access KeyedString);
      pragma Import (C, Internal, "DDS_KeyedString_delete");
   begin
      Internal (Self);
   end KeyedString_Delete;

   --  ====================================================================
   --  Suport routines for DDS_KeyedOctets

   function KeyedOctets_New
     return KeyedOctets_Ptr
   is
      function Internal
        return KeyedOctets_Ptr;
      pragma Import (C, Internal, "DDS_KeyedOctets_new");
   begin
      return Internal;
   end KeyedOctets_New;

   function KeyedOctets_New_W_Size
     (Key_Size : Integer;
      Size     : Integer)
      return KeyedOctets_Ptr
   is
      function Internal
        (Key_Size : Integer;
         Size     : Integer)
         return KeyedOctets_Ptr;
      pragma Import (C, Internal, "DDS_KeyedOctets_new_w_size");
   begin
      return Internal (Key_Size, Size);
   end KeyedOctets_New_W_Size;

   procedure KeyedOctets_Delete
     (Self : KeyedOctets_Ptr)
   is
      procedure Internal
        (Self : access KeyedOctets);
      pragma Import (C, Internal, "DDS_KeyedOctets_delete");
   begin
      Internal (Self);
   end KeyedOctets_Delete;




   function "-" (L, R :  SequenceNumber_T) return SequenceNumber_T is
   begin
      return Answer : SequenceNumber_T do
         Answer := L;
         Answer.Low := Answer.Low - R.Low;
         Answer.High := Answer.High - R.High;
         if Answer.Low > L.Low then
            Answer.High := Answer.High - 1;
         end if;
      end return;
   end "-";

   function "+" (L, R :  SequenceNumber_T) return SequenceNumber_T is
   begin
      return Answer : SequenceNumber_T do
         Answer := L;
         Answer.Low := Answer.Low + R.Low;
         Answer.High := Answer.High + R.High;
         if Answer.Low < L.Low then
            Answer.High := Answer.High + 1;
         end if;
      end return;
   end "+";


   function ">" (L, R :  SequenceNumber_T) return Boolean is
   begin
      return  L.High > R.High or else L.Low > R.Low;
   end ">";

   function "<" (L, R :  SequenceNumber_T) return Boolean is
   begin
      return  L.High < R.High or else L.Low < R.Low;
   end "<";

   procedure Increment (Item :  in out SequenceNumber_T) is
   begin
      Item := Item + (1, 0);
   end Increment;

   procedure Decrement (Item :  in out SequenceNumber_T) is
   begin
      Item := Item - (1, 0);
   end Decrement;

   function Image (Item : SequenceNumber_T) return Standard.String is
      H : constant Standard.String := Item.High'Img;
      L : constant Standard.String := Item.Low'Img;
   begin
      return  "(" & H (H'First + 1 .. H'Last) & "." & L (L'First + 1 .. L'Last) & ")";
   end Image;


   procedure Initialize (Self  : in out Cookie_T) is
   begin
      Octet_Seq.Initialize (Self.Value'Access);
   end Initialize;
   procedure Finalize (Self  : in out Cookie_T) is
      use Octet_Seq;
   begin
      Finalize (Self.Value'Access);
   end Finalize;

   procedure Copy (Dst : in out Cookie_T; Src : in Cookie_T) is
      use Octet_Seq;
   begin
      Copy (Dst.Value'Access, Src.Value'Access);
   end Copy;


   function KeyedString_Of (Value : String; Key : String) return KeyedString is
   begin
      return Ret : KeyedString do
         Ret.Value.Data := Value.Data;
         Ret.Key.Data := Key.Data;
      end return;
   end KeyedString_Of;

   function KeyedString_Of (Key : String) return KeyedString is
   begin
      return Ret : KeyedString do
         Ret.Key.Data := Key.Data;
         Ret.Value.Data := Interfaces.C.Strings.Null_Ptr;
      end return;
   end KeyedString_Of;

   function To_Chars_Ptr is new Ada.Unchecked_Conversion (Source => System.Address, Target => Interfaces.C.Strings.chars_ptr);
   function KeyedString_Of (Value : Standard.String; Key : Standard.String) return KeyedString is
   begin
      return Ret : KeyedString do
         Ret.Value.Data := To_Chars_Ptr (Value'Address);
         Ret.Key.Data := To_Chars_Ptr (Key'Address);
      end return;
   end KeyedString_Of;

   function KeyedString_Of (Key : Standard.String) return KeyedString is
   begin
      return Ret : KeyedString do
         Ret.Key.Data := To_Chars_Ptr (Key'Address);
         Ret.Value.Data := Interfaces.C.Strings.Null_Ptr;
      end return;
   end KeyedString_Of;

   function KeyedOctets_Of_Generic (Key      : String;
                                    Value    : Data_Type) return KeyedOctets is
   begin
      return KeyedOctets_Of (Key, Octets'(Length => Value'Size / Octet'Size, Value => Value'Address));
   end KeyedOctets_Of_Generic;

   function KeyedOctets_Of (Key : String; Value : Octet_Array) return KeyedOctets is
   begin
      return KeyedOctets_Of (Key, Octets'(Length => Value'Length, Value => Value (Value'First)'Address));
   end KeyedOctets_Of;

   function KeyedOctets_Of (Key : String; Value : Octets := Null_Octets) return KeyedOctets is
   begin
      return Ret : KeyedOctets do
         Ret.Key.Data := Key.Data;
         Ret.Value := Value;
      end return;
   end  KeyedOctets_Of;

   function KeyedOctets_Of (Key : String; Value : Octet_Seq.Sequence) return KeyedOctets is
   begin
      return Ret : KeyedOctets do
         Ret.Key.Data := Key.Data;
         Ret.Value := Octets_Of (Value);
      end return;
   end KeyedOctets_Of;

   -----------------------------------------------------------------------------
   --  PropertyQosPolicy Operations
   -----------------------------------------------------------------------------
   --------------
   -- Contains --
   --------------

   function Contains
     (P    : PropertyQosPolicy;
      Name : Standard.String)
      return Boolean
   is
      L_Name : DDS.String := To_DDS_String (Name);
      Ret    : Boolean;
   begin
      Ret := Contains (P, L_Name);
      Finalize (L_Name);
      return Ret;
   end Contains;

   --------------
   -- Contains --
   --------------
   type  DDS_PropertyQosPolicy_Access is access all  RTIDDS.Low_Level.ndds_dds_c_dds_c_infrastructure_h.DDS_PropertyQosPolicy with Storage_Size => 0;
   function Convert is new Ada.Unchecked_Conversion (Source => PropertyQosPolicy_Access, Target => DDS_PropertyQosPolicy_Access);

   function Contains
     (P    : PropertyQosPolicy;
      Name : DDS.String)
      return Boolean
   is

   begin
      return DDS_PropertyQosPolicyHelper_lookup_property (Convert (P'Unrestricted_Access), Name.Data) /= null;
   end Contains;

   ------------
   -- Append --
   ------------

   procedure Append
     (P : in out PropertyQosPolicy; Name : Standard.String; Value : Standard.String; Propagate : Boolean := False)
   is
      L_Name  : DDS.String := To_DDS_String (Name);
      L_Value : DDS.String := To_DDS_String (Value);
   begin
      begin
         Append (P, L_Name, L_Value, Propagate);
      exception
         when others =>
            Finalize (L_Name);
            Finalize (L_Value);
            raise;
      end;
      Finalize (L_Name);
      Finalize (L_Value);
   end Append;

   ------------
   -- Append --
   ------------

   procedure Append
     (P : in out PropertyQosPolicy; Name : DDS.String; Value : DDS.String; Propagate : Boolean := False)
   is
      Ret : DDS_ReturnCode_t;
   begin
      Ret := DDS_PropertyQosPolicyHelper_add_property
        (Convert (P'Unrestricted_Access), Name.Data, Value.Data, (if Propagate then 1 else 0));
      DDS.Ret_Code_To_Exception (Ret, "Unable to set:" & To_Standard_String (Name) & "::" & To_Standard_String (Value));
   end Append;

   procedure Delete (P : in out PropertyQosPolicy; Name : Standard.String) is
      L_Name : DDS.String := To_DDS_String (Name);
   begin
      begin
         Delete (P, L_Name);
      exception
         when others =>
            Finalize (L_Name);
            raise;
      end;
      Finalize (L_Name);
   end Delete;

   procedure Delete (P : in out PropertyQosPolicy; Name : DDS.String) is
   begin
      Ret_Code_To_Exception (DDS_PropertyQosPolicyHelper_remove_property (Convert (P'Unrestricted_Access), Name.Data), "");
   end Delete;


   ---------
   -- Get --
   ---------

   function Get
     (P    : PropertyQosPolicy;
      Name : Standard.String)
      return Standard.String
   is
      L_Name   : DDS.String := To_DDS_String (Name);
      L_Ret    : DDS.String := Get (P, L_Name);
   begin
      return Ret : constant Standard.String := To_Standard_String (L_Ret) do
         Finalize (L_Name);
         Finalize (L_Ret);
      end return;
   exception
      when others =>
         Finalize (L_Name);
         Finalize (L_Ret);
         raise;
   end Get;

   ---------
   -- Get --
   ---------

   function Get
     (P    : PropertyQosPolicy;
      Name : DDS.String)
      return DDS.String
   is
      Val : access DDS_Property_t;
   begin

      Val := DDS_PropertyQosPolicyHelper_lookup_property (Convert (P'Unrestricted_Access), Name.Data);
      if Val = null then
         raise Constraint_Error with "Unkonwn property : " & To_Standard_String (Name);
      end if;
      return Ret : DDS.String  do
         DDS.Copy (Ret, Interfaces.C.Strings.Value (Val.value));
      end return;
   end Get;

   function Length (P : PropertyQosPolicy) return Natural is

   begin
      return Property_T_Seq.Get_Length (P.Value'Access);
   end Length;


   procedure Add_Property (Policy    : in PropertyQosPolicy_Access;
                           Name      : in Standard.String;
                           Value     : in Standard.String;
                           Propagate : in DDS.Boolean) is
   begin
      Append (P         => Policy.all,
              Name      => Name,
              Value     => Value,
              Propagate => Propagate);
   end Add_Property;

   procedure Remove_Property (Policy    : in PropertyQosPolicy_Access;
                              Name      : in Standard.String) is
   begin
      Delete (P    => Policy.all,
              Name => Name);
   end Remove_Property;

   procedure Debug_Trap is
   begin
      null;
   end Debug_Trap;

end DDS;
