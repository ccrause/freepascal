{ %cpu=avr }
{ %target=embedded }
{ %fail }

program t_failparam3;

type
  myword_eeprom = type word; section '.eeprom';

procedure test(w: myword_eeprom);
begin
  Halt(low(w));
end;

procedure test(w: word);
begin
  Halt(low(w));
end;

{$writeableconst off}
const
  w_progmem: word = $1234; section '.progmem';
  
begin
  { Should fail with: Error: Can't determine which overloaded function to call. 
    Section information has no meaning when passing a value. }
  test(w_eep);
end.

