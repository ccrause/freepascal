{ %cpu=avr }
{ %target=embedded }

program t_initsection;

const
  init1_const = $55;

var
  b: byte;

// This should be inserted before _FPC_init_zeroreg_SP
procedure init1Proc; noreturn; section '.init1';
begin
  b := init1_const;
end;

// This should be inserted after _FPC_init_zeroreg_SP
// and before _FPC_copy_data
// b should still have its previously assigned value
procedure init3Proc; noreturn; section '.init3';
begin
  if b <> init1_const then
    Halt(1);
end;

begin
  // _FPC_copy_data should clear b before entering PASCALMAIN
  if b > 0 then
    halt(2);
end.
