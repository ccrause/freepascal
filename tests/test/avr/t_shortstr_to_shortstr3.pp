{ %cpu=avr }
{ %target=embedded }

program t_shortstr_to_shortstr3;

type
  shortstring_progmem = type shortstring; section '.progmem';

procedure checkStringVal(s: shortstring_progmem);
begin
  if s[1] <> 'q' then
    halt(1);

  if length(s) <> 6 then
    halt(2);
end;

{$writeableconst off}
const
  sp: shortstring_progmem = 'qweryt';

var
  s: shortstring = '';

begin
  checkStringVal(sp);

  if length(s) <> 0 then
    halt(3);
end.
