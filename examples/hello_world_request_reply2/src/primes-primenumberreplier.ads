with Primes_IDL_File.PrimeNumberRequest_DataReader;
with Primes_IDL_File.PrimeNumberReply_DataWriter;
with DDS.Typed_Replyer_Generic;
package Primes.PrimeNumberReplier is new DDS.Typed_Replyer_Generic
  (Request_DataReaders => Primes_IDL_File.PrimeNumberRequest_DataReader,
   Reply_DataWriters   => Primes_IDL_File.PrimeNumberReply_DataWriter);
