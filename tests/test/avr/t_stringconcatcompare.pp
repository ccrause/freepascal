{ %cpu=avr }
{ %target=embedded }

program t_stringconcatcompare;

var
  s: string;
  test_in_eeprom: shortstring = '43210-?'; section '.eeprom';

begin
  {$literalstringsinprogmem+} // store literal in progmem
  s := '43210';
  s := s + '-?';

  if s <> '43210-?' then
    halt(1);

  if s <> test_in_eeprom then
    halt(2);
end.
