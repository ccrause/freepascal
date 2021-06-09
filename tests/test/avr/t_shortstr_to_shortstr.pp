{ %cpu=avr }
{ %target=embedded }

program t_shortstr_to_shortstr;

type
  shortstring_eeprom = type shortstring; section '.eeprom';
  shortstring_progmem = type shortstring; section '.progmem';

procedure fpc_shortstr_to_shortstr_eeprom(var res:shortstring; constref sstr: shortstring_eeprom);
var
  slen, i: byte;
begin
  slen := ord(sstr[0]);

  for i := 0 to slen do
    res[i] := sstr[i];
end;

procedure fpc_shortstr_to_shortstr_progmem(var res:shortstring; constref sstr: shortstring_progmem);
var
  slen, i: byte;
begin
  slen := ord(sstr[0]);

  for i := 0 to slen do
    res[i] := sstr[i];
end;

var
  s_e: shortstring_eeprom = 'qweryt';
  s: shortstring;

{$writeableconst off}
const
  s_p: shortstring = 'tyrewq'; section '.progmem';

begin
  fpc_shortstr_to_shortstr_eeprom(s, s_e);
  if s <> 'qweryt' then
    halt(1);

  fpc_shortstr_to_shortstr_progmem(s, s_p);
  if s <> 'tyrewq' then
    halt(2);
end.
