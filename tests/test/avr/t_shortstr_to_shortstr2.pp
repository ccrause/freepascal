{ %cpu=avr }
{ %target=embedded }

program t_shortstr_to_shortstr2;

type
  shortstring_eeprom = type shortstring; section '.eeprom';

procedure checkStringVal(s: shortstring_eeprom);
begin
  if s[1] <> 'q' then
    halt(1);

  if length(s) <> 6 then
    halt(2);
end;

var
  se: shortstring_eeprom = 'qweryt';
  s: shortstring = '';

begin
  checkStringVal(se);

  if length(s) <> 0 then
    halt(3);
end.
