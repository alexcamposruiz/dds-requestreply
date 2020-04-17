with Primes_IDL_File.PrimeNumberRequest_DataReader;
with Primes_IDL_File.PrimeNumberReply_DataWriter;
with DDS.Request_Reply.Typed_Replier_Generic;
package Primes.PrimeNumberReplier is new DDS.Request_Reply.Typed_Replier_Generic
  (Request_DataReaders => Primes_IDL_File.PrimeNumberRequest_DataReader,
   Reply_DataWriters   => Primes_IDL_File.PrimeNumberReply_DataWriter);
