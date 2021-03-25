{ %cpu=avr }
{ %target=embedded }

program t_writeln;

type
  shortstring_progmem = type shortstring; section '.progmem';
  shortstring_eeprom = type shortstring; section '.eeprom';
  FileFunc = Procedure(var t : TextRec);

const
  a_progmem: array[0..6] of char = 'progmem'; section '.progmem';
  a_eeprom: array[0..5] of char = 'eeprom'; section '.eeprom';
  a_normal: array[0..2] of char = 'RAM';
  s_progmem: shortstring = 'progmemss'; section '.progmem';
  s_eeprom: shortstring = 'eepromss'; section '.eeprom';
  s_normal: shortstring = 'RAMss';

var
  s, stemp: shortstring;
  stdOutFlushFunc: codepointer;

procedure flushStdOut;
begin
  if stdOutFlushFunc<>nil then
    FileFunc(stdOutFlushFunc)(TextRec(stdout));
end;

function compareWriteBufferWith(const s: shortstring): boolean;
var
  buf: shortstring;
begin
  buf := copy(TextRec(stdout).buffer, 1, TextRec(stdout).bufpos);
  compareWriteBufferWith := buf = s;
end;

begin
  // Disable auto flushing of output buffer
  stdOutFlushFunc := TextRec(stdout).flushfunc;
  TextRec(stdout).flushfunc := nil;
  // For embedded target DefaultTextLineBreakStyle is not equivalent to LineEnding
  // Set stdout.LineEnd the same as LineEnding
  SetTextLineEnding(stdout, LineEnding);

  {$stringinprogmem+} // store literal in progmem
  writeln('literal');
  stemp := 'literal' + LineEnding;
  if not compareWriteBufferWith(stemp) then
    halt(1);
  flushStdOut;

  writeln(a_progmem);
  stemp := a_progmem + LineEnding;
  if not compareWriteBufferWith(stemp) then
    halt(2);
  flushStdOut;

  writeln(a_eeprom);
  stemp := a_eeprom + LineEnding;
  if not compareWriteBufferWith(stemp) then
    halt(3);
  flushStdOut;

  writeln(a_normal);
  stemp := a_normal + LineEnding;
  if not compareWriteBufferWith(stemp) then
    halt(4);
  flushStdOut;

  writeln(s_progmem);
  // Split up concatenation, not all helpers are implemented yet
  stemp := s_progmem;
  stemp := stemp + LineEnding;
  if not compareWriteBufferWith(stemp) then
    halt(5);
  flushStdOut;

  writeln(s_eeprom);
  // Split up concatenation, not all helpers are implemented yet
  stemp := s_eeprom;
  stemp := stemp + LineEnding;
  if not compareWriteBufferWith(stemp) then
    halt(6);
  flushStdOut;

  writeln(s_normal);
  stemp := s_normal + LineEnding;
  if not compareWriteBufferWith(stemp) then
    halt(7);
  flushStdOut;
end.
