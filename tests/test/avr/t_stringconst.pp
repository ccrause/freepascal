{ %cpu=avr }
{ %target=embedded }

{ Check that the same string constants end up in the same section specific pool }

program t_stringconst;

type
  pchar_progmem = type PChar; section '.progmem';
  pchar_eeprom = type PChar; section '.eeprom';

const
  sconstprogmem1 = '43210'; section '.progmem';
  sconstprogmem2 = '43210'; section '.progmem';
  sconsteeprom1 = '0123'; section '.eeprom';
  sconsteeprom2 = '0123'; section '.eeprom';

procedure checkAddressesEqualP(p1, p2: pchar_progmem);
begin
  if p1 <> p2 then
    Halt(1);
end;

procedure checkAddressesEqualE(p1, p2: pchar_eeprom);
begin
  if p1 <> p2 then
    Halt(2);
end;

var
  x_p: char = 'P'; section '.progmem';
  p_p: pchar_progmem;
  x_e: char = 'E'; section '.eeprom';
  p_e: pchar_eeprom;

begin
  { Check that only one copy of const is stored per section }
  checkAddressesEqualP(sconstprogmem1, sconstprogmem2);
  checkAddressesEqualE(sconsteeprom1, sconsteeprom2);
 
  { Check that the progmem string is stored in progmem }
  p_p := @x_p;
  { The 1st byte after x_p should be the first character of the const }
  inc(p_p, 1);
  if (p_p[0] <> '4') or (p_p[4] <> '0') then
    halt(3);

  { Check that the EEPROM string is stored in EEPROM }
  p_e := @x_e;
  { The 1st byte after x_e should be the first character of the const }
  inc(p_e, 1);
  if (p_e[0] <> '0') or (p_e[3] <> '3') then
    halt(4);
end.
