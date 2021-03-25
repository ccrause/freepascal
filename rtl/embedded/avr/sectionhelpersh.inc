// Check if EEPROM access is supported by controller
{$if declared (NVMCTRL) or declared(EECR)}
  {$mode objfpc}
  procedure writeEEPROMbyte(const EEPROMaddress: pointer; const val: byte); public name 'FPC_WRITE_EEPROM_BYTE';
  function readEEPROMbyte(const EEPROMaddress: pointer): byte; public name 'FPC_READ_EEPROM_BYTE';

  type
    shortstring_eeprom = type shortstring; section '.eeprom';
    shortstring_progmem = type shortstring; section '.progmem';
    pointer_progmem = type pointer; section '.progmem';
    pointer_eeprom = type pointer; section '.eeprom';
    char_progmem = type char; section '.progmem';
    char_eeprom = type char; section '.eeprom';
    pchar_progmem = type pchar; section '.progmem';
    pchar_eeprom = type pchar; section '.eeprom';
    pbyte_progmem = type pbyte; section '.progmem';
    pbyte_eeprom = type pbyte; section '.eeprom';

// compproc.inc
  procedure fpc_shortstr_to_shortstr_eeprom(var res:shortstring; constref sstr: shortstring_eeprom); compilerproc;
  procedure fpc_shortstr_to_shortstr_progmem(var res:shortstring; constref sstr: shortstring_progmem); compilerproc;
  procedure fpc_shortstr_concat_progmem(var dests:shortstring;const s1:shortstring; constref s2:shortstring_progmem);compilerproc;
  procedure fpc_shortstr_concat_eeprom(var dests:shortstring;const s1:shortstring; constref s2:shortstring_eeprom);compilerproc;
  function fpc_shortstr_compare_equal_progmem(const left:shortstring; constref right: shortstring_progmem): longint; compilerproc;
  function fpc_shortstr_compare_equal_eeprom(const left:shortstring; constref right: shortstring_eeprom): longint; compilerproc;
  procedure fpc_chararray_to_shortstr_progmem(var res : shortstring; const arr: array of char_progmem; zerobased: boolean{ = true}); compilerproc;
  procedure fpc_chararray_to_shortstr_eeprom(var res : shortstring; const arr: array of char_eeprom; zerobased: boolean{ = true}); compilerproc;

// text.inc
  procedure fpc_write_text_shortstr_progmem(Len: longint; var f: text; constref s: shortstring_progmem); compilerproc;
  procedure fpc_write_text_shortstr_eeprom(Len: longint; var f: text; constref s: shortstring_eeprom); compilerproc;
  procedure fpc_write_text_pchar_as_array_progmem(Len : longint;var f: Text; const s: array of char_progmem; zerobased: boolean{ = true}); compilerproc;
  procedure fpc_write_text_pchar_as_array_eeprom(Len : longint;var f: Text; const s: array of char_eeprom; zerobased: boolean{ = true}); compilerproc;

// sstrings.inc
  function fpc_shortstr_copy_progmem(constref s : shortstring_progmem;index : SizeInt;count : SizeInt): shortstring; compilerproc;
  function fpc_shortstr_copy_eeprom(constref s : shortstring_eeprom;index : SizeInt;count : SizeInt): shortstring; compilerproc;
{$endif}

