{ %cpu=avr }
{ %target=embedded }
{ %OPT=-B } // to force rebuild of unit

program t_mixedoverloadunit;

uses
  u_mixedoverload;

var
  tmp: byte;
  b1: byte_e;

begin
  writeTest(tmp);
  if tmp <> 123 then
    halt(1);

  writeTest(b1);
  if b1 <> 234 then
    halt(2);
end.
