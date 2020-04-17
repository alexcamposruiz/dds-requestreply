package DDS.Request_Reply.connext_c_log is
   type RTILogMessage is private;
   type RTILogBitmap is private;
   
  --  
   --    #define SUBMODULE_XMQ_DUMMY                    (0 << 10)
   --    #define SUBMODULE_XMQ_REQUESTREPLY             (1 << 10)
   SUBMODULE_XMQ_DUMMY : constant := 0;
   SUBMODULE_XMQ_REQUESTREPLY : constant := 2#1_000_000_000#;
   --  
   --    #define XMQ_SUBMODULE_MASK_DUMMY                    (0x0001)
   XMQ_SUBMODULE_MASK_DUMMY   : constant := 16#0001#;
   --  
   --    #define XMQ_SUBMODULE_MASK_REQUESTREPLY             (0x0002)
   XMQ_SUBMODULE_MASK_REQUESTREPLY   : constant := 16#0001#;
   --  
   --  
   --    #define XMQ_SUBMODULE_MASK_ALL                        (0xFFFFFF)
   XMQ_SUBMODULE_MASK_ALL            : constant := 16#FF_FF_FF#;
   
   --  
   --  extern XMQCDllExport void
   --  XMQLog_getBitmaps(RTILogBitmap *submoduleMask,
   --  		  RTILogBitmap *instrumentationMask);
   procedure XMQLog_GetBitmaps (SubmoduleMask       : out RTILogBitmap;
                                InstrumentationMask : out RTILogBitmap);
                                
   
   --  extern XMQCDllExport void
   --  XMQLog_setBitmaps(RTILogBitmap submoduleMask,
   --  		  RTILogBitmap instrumentationMask);
   procedure XMQLog_SetBitmaps (SubmoduleMask       : RTILogBitmap;
                                InstrumentationMask : RTILogBitmap);

   --  extern XMQCDllExport
   --  void XMQLog_setVerbosity(RTILogBitmap submoduleMask, int verbosity);
   procedure XMQLog_setVerbosity (SubmoduleMask       : RTILogBitmap;
                                  Verbosity           : Integer);
   
   
   --  extern XMQCDllVariable const struct RTILogMessage XMQ_LOG_REPLIER_SEND_ERROR_d;
private
   type RTILogMessage is new Integer;
   type RTILogBitmap is new Integer;
   XMQ_LOG_REPLIER_SEND_ERROR_D : RTILogMessage := 1;

end DDS.Request_Reply.connext_c_log;
