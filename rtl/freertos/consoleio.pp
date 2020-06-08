{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2011 by the Free Pascal development team.

    Console i/o for the FPC FreeRTOS target

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
Unit consoleio;

  interface

    type
      TWriteCharFunc = function(ACh: char; AUserData: pointer): boolean;
      TReadCharFunc = function(var ACh: char; AUserData: pointer): boolean;
      TFlushProc = procedure(var t : TextRec); // from system.inc

    procedure OpenIO(var f: Text; AWrite: TWriteCharFunc; ARead: TReadCharFunc; AMode: word; AUserData: pointer); overload;
    procedure OpenIO(var f: Text; AWrite: TWriteCharFunc; ARead: TReadCharFunc; AMode: word; AUserData: pointer; flushfunc: TFlushProc); overload;

  implementation

    {$i textrec.inc}

    type
      PUserData = ^TUserData;
      TUserData = record
        WriteChar: TWriteCharFunc;
        ReadChar: TReadCharFunc;
        UserData: Pointer;
        FlushOutputProc: TFlushProc;
      end;

    function EmptyWrite(ACh: char; AUserData: pointer): boolean;
      begin
        EmptyWrite:=true;
      end;

    function EmptyRead(var ACh: char; AUserData: pointer): boolean;
      begin
        EmptyRead:=true;
        ACh:=#0;
      end;

    procedure Console_Close(var t:TextRec);
      begin
      end;

    function ReadData(Func: TReadCharFunc; UserData: pointer; Buffer: pchar; count: SizeInt): SizeInt;
      var
        c: char;
        got_linechar: boolean;
      begin
        ReadData:=0;
        got_linechar:=false;
        while (ReadData < count) and (not got_linechar) do
          begin
            if Func(c, UserData) then
              begin
                if c = #10 then
                  got_linechar:=true;
                buffer^:=c;
                inc(buffer);
                inc(ReadData);
              end;
          end;
      end;

    Procedure Console_Read(var t:TextRec);
      var
        userdata: PUserData;
      begin
        userdata:=@t.UserData[1];
        InOutRes:=0;
        t.bufend:=ReadData(userdata^.ReadChar,userdata^.UserData,pchar(t.bufptr),t.bufsize);
        t.bufpos:=0;
      end;

    Procedure Console_Write(var t:TextRec);
      var
        userdata: PUserData;
        p: pchar;
        i: SizeInt;
      begin
        if t.BufPos=0 then exit;
        userdata:=@t.UserData[1];
        i := 0;
        p := pchar(t.bufptr);
        while i < t.bufpos do
          begin
            if not userdata^.WriteChar(p^, userdata^.UserData) then
              break;
            inc(p);
            inc(i);
          end;
        if i<>t.BufPos then
          InOutRes:=101
        else
          InOutRes:=0;
        t.BufPos:=0;
      end;

    procedure Console_FlushOutput(var t:TextRec);
      var
        userdata: PUserData;
    begin
      // Ensure internal buffer gets written
      Console_Write(t);
      // Call low level flush if assigned
      userdata := @t.UserData[1];
      if userdata^.FlushOutputProc <> nil then
        userdata^.FlushOutputProc(system.TextRec(t));
    end;

    procedure OpenIO(var f: Text; AWrite: TWriteCharFunc; ARead: TReadCharFunc; AMode: word; AUserData: pointer);
      var
        userdata: PUserData;
      begin
        { Essentially just init everything, more or less what Assign(f,'');
          does }
        FillChar(f,SizeOf(TextRec),0);
        { only set things that are not zero }
        TextRec(f).Handle:=UnusedHandle;
        TextRec(f).BufSize:=TextRecBufSize;
        TextRec(f).Bufptr:=@TextRec(f).Buffer;
        TextRec(f).OpenFunc:=nil;
        TextRec(f).LineEnd := #13#10;

        userdata:=@TextRec(f).UserData[1];
        TextRec(f).Mode:=AMode;
        case AMode of
          fmInput: TextRec(f).Handle:=StdInputHandle;
          fmOutput: TextRec(f).Handle:=StdOutputHandle;
        end;
        TextRec(f).CloseFunc:=@Console_Close;
        TextRec(f).FlushFunc:=nil;
        case AMode of
          fmInput: TextRec(f).InOutFunc:=@Console_Read;
          fmOutput:
            begin
              TextRec(f).InOutFunc:=@Console_Write;
              TextRec(f).FlushFunc:=@Console_Write;
            end;
        end;
        userdata^.WriteChar := AWrite;
        userdata^.ReadChar := ARead;
        userdata^.UserData := AUserData;
      end;

    procedure OpenIO(var f: Text; AWrite: TWriteCharFunc; ARead: TReadCharFunc;
      AMode: word; AUserData: pointer; flushfunc: TFlushProc);
      var
        userdata: PUserData;
      begin
        OpenIO (f, AWrite, ARead, AMode, AUserData);
        if (flushfunc <> nil) and (AMode = fmOutput) then
          begin
            userdata:=@TextRec(f).UserData[1];
            userdata^.FlushOutputProc :=flushfunc;
            TextRec(f).FlushFunc:=@Console_FlushOutput;
          end;
      end;

    procedure SysInitStdIO;
      begin
        OpenIO(Input, @EmptyWrite, @EmptyRead, fmInput, nil);
        OpenIO(Output, @EmptyWrite, @EmptyRead, fmOutput, nil);
        OpenIO(ErrOutput, @EmptyWrite, @EmptyRead, fmOutput, nil);
        OpenIO(StdOut, @EmptyWrite, @EmptyRead, fmOutput, nil);
        OpenIO(StdErr, @EmptyWrite, @EmptyRead, fmOutput, nil);
      end;

   procedure SysFlushStdIO;
     begin
     end;

var
  ErrorBase : Pointer;external name 'FPC_ERRORBASE';

var
  pstdout : ^Text;

{$ifndef CPUAVR}
initialization
  { Setup stdin, stdout and stderr }
  SysInitStdIO;
finalization
  { Show runtime error and exit }
  pstdout:=@stdout;
  If erroraddr<>nil Then
   Begin
     Writeln(pstdout^,'Runtime error ',Errorcode,' at $',hexstr(erroraddr));
     { to get a nice symify }
     Writeln(pstdout^,BackTraceStrFunc(Erroraddr));
     dump_stack(pstdout^,ErrorBase);
     Writeln(pstdout^,'');
   End;
  SysFlushStdIO;
{$endif CPUAVR}

end.

