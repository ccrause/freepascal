{ %cpu=avr }
{ %target=embedded }

program t_mixedtest;

type
  Byte_e = type Byte; section '.eeprom';

var
  tmp: byte = 123;
  b1: byte_e = 234;

begin
  if tmp <> 123 then
    halt(1);

  if b1 <> 234 then
    halt(2);
end.
