{ %cpu=avr }
{ %target=embedded }
{ %fail }

program t_failparam;

type
  myword_eeprom = type word; section '.eeprom';

procedure test(var w: word);
begin
  Halt(w);
end;

var
  wp1: myword_eeprom = $1234;
  
begin
  // Incompatible sections between wp1 and w
  test(wp1);
end.

