{ %cpu=avr }
{ %target=embedded }

program t_mixedoverload;

type
  Byte_e = type Byte; section '.eeprom';
  pbyte_e = type ^byte_e;

procedure writeTest(a: Pbyte); overload;
begin
  a^ := 123;
end;

procedure writeTest(a: pbyte_e); overload;
begin
  a^ := 234;
end;

var
  tmp: byte;
  b1: pbyte_e;

begin
  writeTest(@tmp);     // Currently fails here, wrong overloaded proc called
  if tmp <> 123 then
    halt(1);

  writeTest(b1);
  if b1^ <> 234 then
    halt(2);
end.
