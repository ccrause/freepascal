{ %cpu=avr }
{ %target=embedded }

program t_pointer3;

type
  PByte_e = type PByte; section '.eeprom';

var
  b1: pbyte_e;
  b2: byte = $ee; section '.eeprom';

begin
  b1 := @b2;
  if b1^ <> $ee then
    halt(1);
end.
