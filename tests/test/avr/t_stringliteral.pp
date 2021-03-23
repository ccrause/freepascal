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

  { Verify length of s }
  if length(s) <> 5 then
    halt(1);

  { Verify that literal is stored in progmem.
    The address of progmem in flash is not fixed.
    Use address of variable x as pointer to start of progmem }
  p_p := @x;
  { The 1st byte after x should be the length of the literal }
  inc(p_p);
  if p_p^ <> #5 then
    halt(2);

  { The 2nd byte after x should be the first character of the literal }
  inc(p_p);
  if p_p^ <> '4' then
    halt(3);

  { Check the last character of the literal }
  inc(p_p,4);
  if p_p^ <> '0' then
    halt(4);
end.

