{ %cpu=avr }
{ %target=embedded }

program t_pointer2;

type
  Byte_e = type Byte; section '.eeprom';
  PByte_e = type ^byte_e;

var
  b1: pbyte_e;
  b2: byte = $ee; section '.eeprom';

begin
  b1 := @b2;
  if b1^ <> $ee then
    halt(1);
end.
