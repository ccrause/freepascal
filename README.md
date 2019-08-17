Free Pascal Compiler - an open source Object Pascal compiler. This is an unofficial mirror of the FPC SubVersion repository and is used for experimental testing of new AVR controller related features.

# Reducing code footprint of runtime error handling
Eliminates some code from the error handling sequence in the RTL to reduce code size:
* Remove EXITCODE from features
* Do not set errorcode, erroraddr or errorbase variables, also do not raise an exception in HandleErrorAddrFrame
* Skip get_caller_stackinfo in HandleErrorAddrFrameInd


