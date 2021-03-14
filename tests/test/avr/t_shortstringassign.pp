{ %cpu=avr }
{ %target=embedded }

program t_shortstringassign;

var
  se: shortstring = 'qweryt'; section '.eeprom';
  sf: shortstring = 'trewq'; section '.progmem';
  s: shortstring = '';

begin
  s := se;
  if s[1] <> 'q' then
    halt(1);
  if length(s) <> 6 then
    halt(2);

  s := sf;
  if s[1] <> 't' then
    halt(3);
  if length(s) <> 5 then
    halt(4);
end.
