{ %cpu=avr }
{ %target=embedded }

program t_valueparamtest1;

type
  Byte_eeprom = type byte; section '.eeprom';
  PByte_eeprom = type PByte; section '.eeprom';

var
  expectedResult: byte;

procedure proc(b1: byte);
begin
  if b1 <> expectedResult then
    halt(1);
end;

const
  b_eep_value = $12;
  b_value = $23;

var
  b_eep: byte = b_eep_value; section '.eeprom';
  b: byte = b_value;

begin
  expectedResult := b_eep_value;
  proc(b_eep);

  expectedResult := b_value;
  proc(b);
end.
