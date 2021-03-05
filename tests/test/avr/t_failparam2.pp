{ %cpu=avr }
{ %target=embedded }
{ %fail }

program t_failparam2;

type
  myword_progmem = type word; section '.progmem';

procedure test(var w: myword_progmem);
begin
  Halt(w);
end;

var
  w_eep: word = $1234; section '.eeprom';
  
begin
    // Incompatible sections between w_eep and w
  test(w_eep);
end.

