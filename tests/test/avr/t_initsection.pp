{ %cpu=avr }
{ %target=embedded }

program t_initsection;

const
  init1_const = $55;
  init3_const = $AA;

var
  b1, b3: byte; section '.noinit';

procedure init1Proc; noreturn; section '.init0';
begin
  b1 := init1_const;
end;

procedure init3Proc; noreturn; section '.init3';
begin
  b3 := init3_const;
end;

begin
  if b1 <> init1_const then
    halt(1);

  if b3 <> init3_const then
    halt(3);
end. 
