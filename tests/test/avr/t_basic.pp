{ %cpu=avr }
{ %target=embedded }

program t_basictest;

type
  myword_eeprom = type word; section '.eeprom';
  myword_progmem = type word; section '.progmem';

var
  we1: myword_eeprom = $1234;
  we2: word = $5678; section '.eeprom';
  wp1: myword_progmem = $9ABC;
  wp2: word = $DEF0; section '.progmem';
  
  b1, b2, b3, b4: byte;

begin
  b1 := lo(we1);
  b2 := hi(we2);
  b3 := lo(wp1);
  b4 := hi(wp2);
  if (b1 = $34) and (b2 = $56) and (b3 = $BC) and (b4 = $DE) then
    halt(0)
  else
    halt(1);
end.

