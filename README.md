Free Pascal Compiler - an open source Object Pascal compiler. This is an unofficial mirror of the FPC SubVersion repository and is used for experimental testing of new AVR controller related features.

# avrxmega3 support
This branch added support for the following controllers: atmega3208, atmega3209, atmega4808, atmega4809
* Added to rtl/embedded: Updated MakeFile to recognize avrxmega3 subarch.
* Added to rtl/embedded/avr: atmega(3208 - 4809).pp files with just the interrupt vectors and normal startup code, no register & port definitions yet

Make cross compiler as usual. To compile the avrxmega3 RTL, specify SUBARCH=avrxmega3.


