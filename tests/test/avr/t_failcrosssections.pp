{ %cpu=avr }
{ %target=embedded }
{ %fail }

program t_failcrosssections;

type
  myword_eeprom = type word; section '.eeprom';

{$writeableconst off}
const
  // Section defined for type not compatible with section specified for symbol
  wp1: myword_eeprom = $1234; section '.progmem';
  
begin

end.

