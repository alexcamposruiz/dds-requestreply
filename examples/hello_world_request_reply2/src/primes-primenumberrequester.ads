with Primes_IDL_File.PrimeNumberRequest_DataWriter;
with Primes_IDL_File.PrimeNumberReply_DataReader;
with DDS.Typed_Requester_Generic;
package Primes.PrimeNumberRequester is new DDS.Typed_Requester_Generic
  (Request_DataWriters => Primes_IDL_File.PrimeNumberRequest_DataWriter,
   Reply_DataReaders   => Primes_IDL_File.PrimeNumberReply_DataReader);

