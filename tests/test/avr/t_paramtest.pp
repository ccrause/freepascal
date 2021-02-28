{ %cpu=avr }
{ %target=embedded }

program t_paramtest;

type
  Byte_eeprom = type byte; section '.eeprom';
  PByte_eeprom = type PByte; section '.eeprom';

var
  expectedResult: byte;

procedure proc_def(b1: byte);
begin
  if b1 <> expectedResult then
    halt(1);
end;

procedure proc_const(const b1: byte);
begin
  if b1 <> expectedResult then
    halt(2);
end;

procedure proc_constref(constref b1: byte_eeprom);
begin
  if b1 <> expectedResult then
    halt(3);
end;

procedure proc_ptr(b1: pbyte_eeprom);
begin
  if b1^ <> expectedResult then
    halt(4);
end;

var
  b: byte = $12; section '.eeprom';
  b_: Byte_eeprom = $34;
  pb: PByte_eeprom;

begin
  expectedResult := b;
  proc_def(b);
  proc_const(b);
  proc_constref(b);
  proc_ptr(@b);

  expectedResult := b_;
  proc_def(b_);
  proc_constref(b_);
  proc_ptr(@b_);

{  pb := PByte_eeprom(0);
  proc_ptr(pb);}
end.
