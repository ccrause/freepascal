Free Pascal Compiler - an open source Object Pascal compiler. This is an unofficial mirror of the FPC SubVersion repository and is used for experimental testing of new AVR controller related features.

# avrxmega3 support
This branch adds support for the avrMega 0 range of controllers:
* atmega808
* atmega809
* atmega1608
* atmega1609
* atmega3208
* atmega3209
* atmega4808
* atmega4809

# Compiler updates
The following changes were made to the compiler and RTL:
* Updated rtl/embedded/MakeFile to recognize avrxmega3 subarch.
* Added to rtl/embedded/avr: atmega(808 - 4809).pp. Include object style
peripheral types that encaptulates the I/O register structure and some bit constants.
Bit constants are postfixed with _idx_ to indicate bit index, while some bit constants
with a size of one bit are also postfixed with _bm_ to mark them as bitmapped.
* Added avrxmega3 as new subarch and new units to compiler/avr/cpuinfo.pp
* Added output architecture 103 to linker script in compiler/systems/t_embedded.pas

Make cross compiler as usual. To compile the avrxmega3 RTL, specify SUBARCH=avrxmega3.
