{ %cpu=avr }
{ %target=embedded }

program t_stringconvert;

type
  shortstring_progmem = type shortstring; section '.progmem';
  ttestproctype = (tpt_shortstring, tpt_shortstring_progmem);

var
  expectedLength: byte;

procedure work(constref s: shortstring; const id: byte; const expectedproc: ttestproctype); overload;
begin
  if expectedproc <> tpt_shortstring then
    halt(id);
  if length(s) <> expectedLength then
    halt(100+id);
end;

procedure work(constref s: shortstring_progmem;const id: byte; const expectedproc: ttestproctype); overload;
begin
  if expectedproc <> tpt_shortstring_progmem then
    halt(id);
  if length(s) <> expectedLength then
    halt(200+id);
end;

var
  s: shortstring = 'str';
  s1: array[0..3] of char = 'str1'; section '.progmem';
  s2: shortstring = 'str3'; section '.progmem';

const
  s_const = 'Constant'; section '.progmem';

begin
  expectedlength := 4;
  work('4321', 1, tpt_shortstring);
  expectedlength := 8;
  work(s_const, 2, tpt_shortstring_progmem);
  expectedlength := 3;
  work(s, 3, tpt_shortstring);
  expectedlength := 4;
  work(s1, 4, tpt_shortstring);
  expectedlength := 4;
  work(s2, 5, tpt_shortstring_progmem);

  {$literalStringsInProgmem+}
  expectedlength := 4;
  work('4321', 6, tpt_shortstring_progmem);
  expectedlength := 8;
  work(s_const, 7, tpt_shortstring_progmem);
  expectedlength := 3;
  work(s, 8, tpt_shortstring);
  expectedlength := 4;
  work(s1, 9, tpt_shortstring);
  expectedlength := 4;
  work(s2, 10, tpt_shortstring_progmem);

  {$convertSectionedStringsToTemp+}
  expectedlength := 4;
  work('4321', 11, tpt_shortstring);
  expectedlength := 8;
  work(s_const, 12, tpt_shortstring);
  expectedlength := 3;
  work(s, 13, tpt_shortstring);
  expectedlength := 4;
  work(s1, 14, tpt_shortstring);
  expectedlength := 4;
  work(s2, 15, tpt_shortstring_progmem);
end.
