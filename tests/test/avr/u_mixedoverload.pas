unit u_mixedoverload;

interface

type
  Byte_e = type Byte; section '.eeprom';

procedure writeTest(var b1: Byte); overload;
procedure writeTest(var b1: Byte_e); overload;

implementation

procedure writeTest(var b1: Byte); overload;
begin
  b1 := 123;
end;

procedure writeTest(var b1: Byte_e); overload;
begin
  b1 := 234;
end;

end.

