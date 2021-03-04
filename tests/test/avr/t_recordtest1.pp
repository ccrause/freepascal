{ %cpu=avr }
{ %target=embedded }

program t_recordtest1;

type
  trec = record
    a,
    b: byte;
    c: word;
    d: dword;
  end;
 
  trec_flash = type trec; section '.progmem';

var
  r1: trec_flash = (a: 1; b: 2; c: $1234; d: $BEEF0000);
  r2: trec = (a: 3; b: 5; c: $1238; d: $BEEF0008); section '.eeprom';

begin
  // Test record read from progmem
  if r1.a <> 1 then
    halt(1);

  if r1.b <> 2 then
    halt(2);

  if r1.c <> $1234 then
    halt(3);

  if r1.d <> $BEEF0000 then
    halt(4);

  // Test record read from eeprom
  if r2.a <> 3 then
    halt(5);

  if r2.b <> 5 then
    halt(6);

  if r2.c <> $1238 then
    halt(7);

  if r2.d <> $BEEF0008 then
    halt(8);
end.
