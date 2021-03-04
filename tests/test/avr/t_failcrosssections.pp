{ %cpu=avr }
{ %target=embedded }
{ %fail }

program t_failcrosssections;

type
  myword_eeprom = type word; section '.eeprom';

var
  wp1: myword_eeprom = $1234; section '.progmem';
  
begin

end.

