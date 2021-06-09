{ %cpu=avr }
{ %target=embedded }
{ %fail }

program t_failparam2;

type
  myword_eeprom = type word; section '.eeprom';

procedure test(var w: myword_eeprom);
begin
  Halt(w);
end;

{$writeableconst off}
const
  w_progmem: word = $1234; section '.progmem';
  
begin
    // Incompatible sections between w_eep and w
  test(w_eep);
end.

