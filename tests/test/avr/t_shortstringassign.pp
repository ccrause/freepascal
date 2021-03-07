{ %cpu=avr }
{ %target=embedded }

program t_shortstringassign;

var
  se: shortstring = 'qweryt'; section '.eeprom';
  s: shortstring = '';

begin
  s := se;

  if s[1] <> 'q' then
    halt(1);

  if length(s) <> 6 then
    halt(2);
end.
