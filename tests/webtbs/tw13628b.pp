{ %SKIPCPU=avr }
{ %needlibrary }
{ %delfiles=tw13628a }

program loadmodule;

uses
  popuperr,
  dynlibs;

const
  {$ifdef unix}
  libname = './libtw13628a.'+SharedSuffix;
  {$endif unix}

  {$ifdef windows}
   {$DEFINE NODLLPREFIX}
  {$endif windows}

  {$ifdef os2}
   {$DEFINE NODLLPREFIX}
  {$endif os2}

  {$IFDEF NODLLPREFIX}
  libname = 'tw13628a.' + SharedSuffix;
  {$ENDIF NODLLPREFIX}

var
  hdl: TLibHandle;
begin
  hdl := loadlibrary(libname);
  if (hdl=nilhandle) then
    begin
      writeln(GetLoadErrorStr);
      halt(1);
    end;
  if not UnloadLibrary(hdl) then
    halt(2);
  writeln('ok');
end.
