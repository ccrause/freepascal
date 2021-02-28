{ %cpu=avr }
{ %target=embedded }

program t_paramtest;

type
  PByte_eeprom = type PByte; section '.eeprom';

var
  expectedResult: byte;

procedure proc_ptr(b1: pbyte_eeprom);
begin
  if b1^ <> expectedResult then
    halt(2);
end;

var
  b: byte = $12; section '.eeprom';  // This should automatically sit at offset 0 of EEPROM
  pb: PByte_eeprom;

begin
  // Remember to use b, else the linker will discard the associated .eeprom data
  expectedResult := b;
  pb := PByte_eeprom(0);
  if pb^ <> expectedResult then 
    halt(1);
  proc_ptr(pb);

  // Test writing to EEPROM
  b := $CC;
  if pb^ <> $CC then
    halt(3);  
end.
