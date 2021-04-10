{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2020 by Karoly Balogh

    System unit for the Sinclair QL

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit System;

interface

{$define FPC_IS_SYSTEM}
{$define FPC_STDOUT_TRUE_ALIAS}
{$define FPC_ANSI_TEXTFILEREC}
{$define FPC_QL_USE_OSHEAP}

{$ifdef FPC_QL_USE_OSHEAP}
{$define HAS_MEMORYMANAGER}
{$endif FPC_QL_USE_OSHEAP}

{$i systemh.inc}

{Platform specific information}
const
    LineEnding = #10;
    LFNSupport = false;
    CtrlZMarksEOF: boolean = false; (* #26 not considered as end of file *)
    DirectorySeparator = '\';
    DriveSeparator = ':';
    ExtensionSeparator = '.';
    PathSeparator = ';';
    AllowDirectorySeparators : set of char = ['\','/'];
    AllowDriveSeparators : set of char = [':'];
    FileNameCaseSensitive = false;
    FileNameCasePreserving = false;
    maxExitCode = 255;
    MaxPathLen = 255;
    AllFilesMask = '*.*';

    sLineBreak = LineEnding;
    DefaultTextLineBreakStyle : TTextLineBreakStyle = tlbsLF;

const
    UnusedHandle    = -1;
    StdInputHandle: longint = UnusedHandle;
    StdOutputHandle: longint = UnusedHandle;
    StdErrorHandle: longint = UnusedHandle;

var
    args: PChar;
    argc: LongInt;
    argv: PPChar;
    envp: PPChar;

    heapStart: pointer;


    {$if defined(FPUSOFT)}

    {$define fpc_softfpu_interface}
    {$i softfpu.pp}
    {$undef fpc_softfpu_interface}

    {$endif defined(FPUSOFT)}


implementation

  {$if defined(FPUSOFT)}

  {$define fpc_softfpu_implementation}
  {$define softfpu_compiler_mul32to64}
  {$define softfpu_inline}
  {$i softfpu.pp}
  {$undef fpc_softfpu_implementation}

  { we get these functions and types from the softfpu code }
  {$define FPC_SYSTEM_HAS_float64}
  {$define FPC_SYSTEM_HAS_float32}
  {$define FPC_SYSTEM_HAS_flag}
  {$define FPC_SYSTEM_HAS_extractFloat64Frac0}
  {$define FPC_SYSTEM_HAS_extractFloat64Frac1}
  {$define FPC_SYSTEM_HAS_extractFloat64Exp}
  {$define FPC_SYSTEM_HAS_extractFloat64Sign}
  {$define FPC_SYSTEM_HAS_ExtractFloat32Frac}
  {$define FPC_SYSTEM_HAS_extractFloat32Exp}
  {$define FPC_SYSTEM_HAS_extractFloat32Sign}

  {$endif defined(FPUSOFT)}

  {$i system.inc}
  {$ifdef FPC_QL_USE_OSHEAP}
  {$i osheap.inc}
  {$endif FPC_QL_USE_OSHEAP}


function GetProcessID:SizeUInt;
begin
  GetProcessID := mt_inf(nil, nil);
end;

var
  CmdLine_len : word; external name '__CmdLine_len';
  pCmdLine : pchar; external name '__pCmdLine';
procedure SysInitParamsAndEnv;
var
  str_len, i : word;
  c : char;
  in_word : boolean;
const
  word_separators=[' ',#0];
begin
  str_len:=CmdLine_len;
  argc:=0;
  argv:=nil;
  args:=pCmdLine;
  if not assigned(args) then
    exit;
  { Parse command line }
  { Compute argc imply replace spaces by #0 }
  i:=0;
  in_word:=false;
  while (i < str_len) do
    begin
      c:=args[i];
      if (not in_word) then
        begin
          if not(c in word_separators) then
            begin
              inc(argc);
              argv[argc]:=@args[i];
              in_word:=true;
            end
          else
            begin
              args[i]:=#0;
            end;
       end
     else if (c in word_separators) then
       begin
         in_word:=false;
         args[i]:=#0;
       end;
     inc(i);
   end;
end;

procedure randomize;
begin
  { Get the current date/time }
  randseed:=mt_rclck;
end;

procedure PrintStr(ch: longint; const s: shortstring);
begin
  io_sstrg(ch,-1,@s[1],ord(s[0]));
end;

procedure DebugStr(const s: shortstring); public name '_dbgstr';
var
  i: longint;
begin
  PrintStr(stdOutputHandle,s);
  for i:=0 to 10000 do begin end;
end;


{*****************************************************************************
                        System Dependent Entry code
*****************************************************************************}
{ QL/QDOS specific startup }
procedure SysInitQDOS;
var
  r: TQLRect;
begin
  stdInputHandle:=io_open('con_',Q_OPEN);
  stdOutputHandle:=stdInputHandle;
  stdErrorHandle:=stdInputHandle;

  r.q_width:=512;
  r.q_height:=256;
  r.q_x:=0;
  r.q_y:=0;

  sd_wdef(stdInputHandle,-1,2,1,@r);
  sd_clear(stdInputHandle,-1);
end;

{*****************************************************************************
                         System Dependent Exit code
*****************************************************************************}

procedure haltproc(e:longint); external name '_haltproc';

procedure system_exit;
const
  anyKey: string = 'Press any key to exit';
begin
  io_sstrg(stdOutputHandle, -1, @anyKey[1], ord(anyKey[0]));
  io_fbyte(stdInputHandle, -1);

  stdInputHandle:=UnusedHandle;
  stdOutputHandle:=UnusedHandle;
  stdErrorHandle:=UnusedHandle;
  haltproc(exitcode);
end;

{*****************************************************************************
                         System Unit Initialization
*****************************************************************************}

procedure SysInitStdIO;
begin
  OpenStdIO(Input,fmInput,StdInputHandle);
  OpenStdIO(Output,fmOutput,StdOutputHandle);
  OpenStdIO(ErrOutput,fmOutput,StdErrorHandle);
{$ifndef FPC_STDOUT_TRUE_ALIAS}
  OpenStdIO(StdOut,fmOutput,StdOutputHandle);
  OpenStdIO(StdErr,fmOutput,StdErrorHandle);
{$endif FPC_STDOUT_TRUE_ALIAS}
end;

function CheckInitialStkLen (StkLen: SizeUInt): SizeUInt;
begin
  CheckInitialStkLen := StkLen;
end;


begin
  StackLength := CheckInitialStkLen (InitialStkLen);
{ Initialize ExitProc }
  ExitProc:=Nil;
  SysInitQDOS;
{$ifndef FPC_QL_USE_OSHEAP}
{ Setup heap }
  InitHeap;
{$else FPC_QL_USE_OSHEAP}
//  InitOSHeap;
{$endif FPC_QL_USE_OSHEAP}
  SysInitExceptions;
{$ifdef FPC_HAS_FEATURE_UNICODESTRINGS}
  InitUnicodeStringManager;
{$endif FPC_HAS_FEATURE_UNICODESTRINGS}
{ Setup stdin, stdout and stderr }
  SysInitStdIO;
{ Reset IO Error }
  InOutRes:=0;
{ Setup command line arguments }
  SysInitParamsAndEnv;
{$ifdef FPC_HAS_FEATURE_THREADING}
  InitSystemThreads;
{$endif FPC_HAS_FEATURE_THREADING}
end.
