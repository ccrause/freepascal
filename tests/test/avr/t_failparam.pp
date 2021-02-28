{ %cpu=avr }
{ %target=embedded }
{ %fail }

program t_failparam;

type
  myword_progmem = type word; section '.progmem';

procedure test(var w: word);
begin
  Halt(w);
end;

var
  wp1: myword_progmem = $1234;
  
begin
  test(wp1);
end.

