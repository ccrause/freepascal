{ %cpu=avr }
{ %target=embedded }
{ %fail }

program t_failwritetoflash2;

var
  w: word = 1234; section '.progmem';

begin
  // Write to flash not supported
  w := 2;
end.

