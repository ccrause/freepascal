{ %cpu=avr }
{ %target=embedded }
{ %OPT=-Mobjfpc }

program t_shortstr_to_shortstr;

type
  shortstring_eeprom = type shortstring; section '.eeprom';

procedure fpc_shortstr_to_shortstr_eeprom(out res:shortstring; constref sstr: shortstring_eeprom);
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

begin
  fpc_shortstr_to_shortstr_eeprom(s, s_e);

  if s <> 'qweryt' then
    halt(1);
end.
