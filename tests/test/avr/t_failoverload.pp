{ %cpu=avr }
{ %target=embedded }
{ %fail }

program t_failoverload;

type
  Byte_e = type Byte; section '.eeprom';

{ Pass by value nullifies the section information
  So the following two overloads are actually the same
  but not identical, so the compiler doesn't yet complain }

procedure writeTest(a: byte); overload;
begin
  a := 123;
end;

procedure writeTest(a: byte_e); overload;
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
