{ %cpu=avr }
{ %target=embedded }

program t_initsection2;

const
  magic = $B055;

var
  checkValue: word;
  secondPass: boolean;

// Insert after _FPC_init_zeroreg_SP and before _FPC_copy_data
// b should still have its previously assigned value
// The conditional check requires an initialized zero register
procedure init3Proc; noreturn; section '.init3';
begin
  if (checkValue = magic) then
    if secondPass then
      Halt(0)
    else
      Halt(1);
end;

begin
  if secondPass then
    Halt(2);

  checkValue := magic;
  secondPass := true;

  // avrsim enables the exception option for jmp/call 0 in fp-avrsim
  // This disables it again so that fp-avrsim can simulate the second pass through init
  {$if declared(EXCEPTIONJMPZERO)}
  EXCEPTIONJMPZERO := false;
  {$endif EXCEPTIONJMPZERO}
  asm
    jmp 0
  end
end. 
