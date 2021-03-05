{ %cpu=avr }
{ %target=embedded }

program t_mixedoverload;

type
  Byte_e = type Byte; section '.eeprom';

procedure writeTest(var a: byte); overload;
begin
  a := 123;
end;

procedure writeTest(var a: byte_e); overload;
begin
  a := 234;
end;

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
