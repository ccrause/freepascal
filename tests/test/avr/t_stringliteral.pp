{ %cpu=avr }
{ %target=embedded }

program t_stringliteral;

type
  pchar_progmem = type PChar; section '.progmem';

var
  s: shortstring;
  X: char = 'X'; section '.progmem';
  p_p: pchar_progmem;

begin
  {$stringinprogmem+} // store literal in progmem
  s := '43210';

  { The address of progmem in flash is not fixed.
    Use address of variable x as pointer to start of progmem }
  p_p := @x;
  { The 2nd byte after x should be the first character of the literal }
  inc(p_p,2);
  if p_p^ <> '4' then
    halt(255);

  if length(s) <> 5 then
    halt(1);

  if s[5] <> '0' then
    halt(2);
end.

