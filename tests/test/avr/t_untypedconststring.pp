{ %cpu=avr }
{ %target=embedded }

program t_untypedconststring;

const
  s1 = '1234'; section '.progmem';
  s2 = 'abcde'; section '.eeprom';

begin
  if length(s1) <> 4 then
    halt(1);

  if s1[3] <> '3' then
    halt(2);

  if length(s2) <> 5 then
    halt(3);

  if s2[3] <> 'c' then
    halt(4);
end.

