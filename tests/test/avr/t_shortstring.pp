{ %cpu=avr }
{ %target=embedded }

program t_shortstring;

type
  shortstring_flash = type shortstring; section '.progmem';

{$writeableconst off}
const
  sf: shortstring_flash = 'qweryt';
  se: shortstring = '!@#$%^&*()'; section '.eeprom';

begin
  if length(sf) <> 6 then
    halt(1);
  if sf[3] <> 'e' then
    halt(2);

  if length(se) <> 10 then
    halt(3);
  if se[3] <> '#' then
    halt(4);
end.
