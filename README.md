Free Pascal Compiler - an open source Object Pascal compiler. This is an unofficial mirror of the FPC SubVersion repository and is used for experimental testing of new AVR controller related features.

# ~~Convert bit shift loops to byte shifts~~
~~The compiler currently only generates byte shift code for an 8 bit shift of a 16 bit operand.  Try to also cover 32 bit operands at least.  Perhaps generalize to reduce bit shifts to less than 8 bits by first doing byte shifts if possible.~~  

_Included in rev. 43169_

