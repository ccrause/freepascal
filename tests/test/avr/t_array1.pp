{ %cpu=avr }
{ %target=embedded }

program t_arraytest1;

var
  w: array[0..2] of word = ($1234, $5678, $ABCD); section '.eeprom';

begin
  if w[1] <> $5678 then
    halt(2)
  else
    halt(0);
end.
