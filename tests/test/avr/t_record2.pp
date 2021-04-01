{ %cpu=avr }
{ %target=embedded }

program t_record2;

type
  tproc = procedure();

  trec = record
    a,
    b: byte;
    p: tproc;
    case boolean of
      true : (d: dword);
      false: (e: byte);
  end;

  trec_flash = type trec; section '.progmem';

var
  test: byte;

procedure settest12;
begin
  test := 12;
end;

procedure settest21;
begin
  test := 21;
end;

var
  r1: trec_flash = (a: 1; b: 2; p: @settest12; d: $CAFEFACE);
  r2: trec;
  r3: trec = (a: 3; b: 5; p: @settest21; d: $FACECAFE); section '.eeprom';

begin
  // Test record read from progmem
  r2 := r1;
  if r2.a <> 1 then
    halt(1);

  if r2.b <> 2 then
    halt(2);

  if r2.d <> $CAFEFACE then
    halt(4);

  r2.p;
  if test <> 12 then
    halt(5);

  // Test record read from progmem
  r2 := r3;
  if r2.a <> 3 then
    halt(6);

  if r2.b <> 5 then
    halt(7);

  if r2.d <> $FACECAFE then
    halt(8);

  r2.p;
  if test <> 21 then
    halt(9);
end. 
