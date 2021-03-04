{ %cpu=avr }
{ %target=embedded }
{ %OPT=-MObjFPC }

program t_arraytest2;

type
  TWord3 = type array[0..2] of word; section '.eeprom';

procedure checkSecondWordConstRef(constref w: TWord3);
begin
  if w[1] <> $5678 then
    halt(1);
end;

procedure checkThirdWordVar(constref w: TWord3);
begin
  if w[2] <> $ABCD then
    halt(2);
end;

// Out parameter needs -MObjFPC
procedure checkFirstWordOut(out w: TWord3);
begin
  w[1] := $DCBA;
end;

const
  w3: TWord3 = ($1234, $5678, $ABCD);

begin
  checkSecondWordConstRef(w3);
  checkThirdWordVar(w3);
  checkFirstWordOut(w3);
  if w3[1] <> $DCBA then
    halt(3);
end.
