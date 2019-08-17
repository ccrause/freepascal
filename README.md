Free Pascal Compiler - an open source Object Pascal compiler. This is an unofficial mirror of the FPC SubVersion repository and is used for experimental testing of new AVR controller related features.

# Peephole MovLDx2LDx optimization
This branch checks for and eliminate a redundant move operation in code.  Examples:  
```
  mov rx, ry
  ldi rx, const
````

This code should be converted to:
```
  ldi rx, const
```
