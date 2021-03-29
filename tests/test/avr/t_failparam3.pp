{ %cpu=avr }
{ %target=embedded }
{ %fail }

program t_failparam3;

type
  myword_progmem = type word; section '.progmem';

procedure test(w: myword_progmem);
begin
  Halt(low(w));
end;

procedure test(w: word);
begin
  Halt(low(w));
end;

var
  w_eep: word = $1234; section '.eeprom';
  
begin
  { Should fail with: Error: Can't determine which overloaded function to call. 
    Section information has no meaning when passing a value. }
  test(w_eep);
end.

