{ %cpu=avr }
{ %target=embedded }
{ %fail }

program t_failwritetoflash;

type
  myword_progmem = type word; section '.progmem';

var
  wp1: myword_progmem = 1234;
  
  b: byte;

begin
  // Write to flash not supported
  wp1 := 1;
end.

