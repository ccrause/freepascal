{

    This file is part of the Free Pascal run time library.
    Copyright (c) 2003 by the Free Pascal development team.

    Processor dependent implementation for the system unit for
    Xtensa

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
{$define FPC_SYSTEM_HAS_SYSRESETFPU}
Procedure SysResetFPU;{$ifdef SYSTEMINLINE}inline;{$endif}
begin
end;

{$define FPC_SYSTEM_HAS_SYSINITFPU}
Procedure SysInitFPU;{$ifdef SYSTEMINLINE}inline;{$endif}
begin
end;

procedure fpc_cpuinit;
begin
  { don't let libraries influence the FPU cw set by the host program }
  if not IsLibrary then
    SysInitFPU;
end;

const
  {$ifdef fpc_abi_windowed}
    { Minimum call8 calls to force register spilling to stack for caller of forceSpilledRegs }
    spillcount = 6;
    { Offsets relative to SP (a1) }
    calleraddroffset = -16;
    callerframeoffset = -12;
  {$else fpc_abi_windowed}
    { Offset relative to FP (a15) }
    calleraddroffset = -8;
    callerframeoffset = -4;
  {$endif fpc_abi_windowed}

{$ifdef fpc_abi_windowed}
procedure forceSpilledRegs(n: uint32); assembler; public name 'forcespilledregs';
  label
    done, fin;
  asm
    beqz a2, done
    addi a10, a2, -1
    call8 forcespilledregs
    done:
    bnez a2, fin
    movi a15, 0
    fin:
  end;
{$endif fpc_abi_windowed}

procedure fixCodeAddress(var addr: pointer);
  begin
    { Check if valid code address }
    if ptruint(addr) and $C0000000 >= $40000000 then
      begin
        {$ifdef fpc_abi_windowed}
          { Replace windowed call prefix }
          addr:=codepointer((ptruint(addr)and$00FFFFFF) or $40000000);
        {$endif fpc_abi_windowed}
        { Rewind to call instruction address }
        dec(addr,3);
      end
    else
      addr:=nil;
  end;

{$IFNDEF INTERNAL_BACKTRACE}
  {$define FPC_SYSTEM_HAS_GET_FRAME}
  function get_frame:pointer;assembler;
    asm
      {$ifdef fpc_abi_windowed}
        { Force registers to spill onto stack }
        movi a10, spillcount
        call8 forcespilledregs
      {$endif}
      { get frame pointer of caller }
      addi a2, {$ifdef fpc_abi_windowed}a1{$else}a15{$endif}, callerframeoffset
      l32i a2, a2, 0
    end;
{$ENDIF not INTERNAL_BACKTRACE}


{$define FPC_SYSTEM_HAS_GET_CALLER_ADDR}
function get_caller_addr(framebp:pointer;addr:pointer=nil):pointer;
  begin
    {$ifdef fpc_abi_windowed}
      forceSpilledRegs(spillcount);
    {$endif fpc_abi_windowed}
    if (ptruint(framebp)>$3ff00000)and(ptruint(framebp)<$40000000) then
      begin
        get_caller_addr:=pointer((framebp+calleraddroffset)^);
        fixCodeAddress(get_caller_addr);
      end
    else
      get_caller_addr:=nil;
  end;

{$define FPC_SYSTEM_HAS_GET_CALLER_FRAME}
function get_caller_frame(framebp:pointer;addr:pointer=nil):pointer;
  begin
    if (ptruint(framebp)>$3ff00000)and(ptruint(framebp)<$40000000) then
      begin
        {$ifdef fpc_abi_windowed}
          forceSpilledRegs(spillcount);
        {$endif fpc_abi_windowed}
        get_caller_frame:=pointer((framebp+callerframeoffset)^);
      end
    else
      get_caller_frame:=nil;
  end;


{$define FPC_SYSTEM_HAS_GET_CALLER_STACKINFO}
procedure get_caller_stackinfo(var framebp : pointer; var addr : codepointer);
  begin
    if (ptruint(framebp)>$3ff00000)and(ptruint(framebp)<$40000000) then
      begin
        {$ifdef fpc_abi_windowed}
          forceSpilledRegs(spillcount);
        {$endif fpc_abi_windowed}
        addr:=codepointer((framebp+calleraddroffset)^);
        framebp := pointer((framebp+callerframeoffset)^);
        fixCodeAddress(addr);
      end
    else
      begin
        addr:=nil;
        framebp:=nil;
      end;
  end;

{$define FPC_SYSTEM_HAS_SPTR}
Function Sptr : pointer; assembler;
  asm
    mov a2,a1
  end;


{$define FPC_SYSTEM_HAS_STACKTOP}
// Interim fix for now, set to large address
// TODO: provide more realistic value, possibly by inspecting stack pointer
// when main or task is started
function StackTop: pointer;
  begin
    StackTop:=pointer($3fffffff);
  end;

function InterLockedDecrement (var Target: longint) : longint;
  var
    temp_sreg : byte;
  begin
    Result:=Target-1;
    Target:=Result;
  end;


function InterLockedIncrement (var Target: longint) : longint;
  var
    temp_sreg : byte;
  begin
    Result:=Target+1;
    Target:=Result;
  end;


function InterLockedExchange (var Target: longint;Source : longint) : longint;
  var
    temp_sreg : byte;
  begin
    Result:=Target;
    Target:=Source;
  end;


function InterlockedCompareExchange(var Target: longint; NewValue: longint; Comperand: longint): longint;
  var
    temp_sreg : byte;
  begin
    Result:=Target;
    if Result=Comperand then
      Target:=NewValue;
  end;


function InterLockedExchangeAdd (var Target: longint;Source : longint) : longint;
  var
    temp_sreg : byte;
  begin
    Result:=Target;
    Target:=Result+Source;
  end;


function InterLockedDecrement (var Target: smallint) : smallint;
  var
    temp_sreg : byte;
  begin
    Result:=Target-1;
    Target:=Result;
  end;


function InterLockedIncrement (var Target: smallint) : smallint;
  var
    temp_sreg : byte;
  begin
    Result:=Target+1;
    Target:=Result;
  end;


function InterLockedExchange (var Target: smallint;Source : smallint) : smallint;
  var
    temp_sreg : byte;
  begin
    Result:=Target;
    Target:=Source;
  end;


function InterlockedCompareExchange(var Target: smallint; NewValue: smallint; Comperand: smallint): smallint;
  var
    temp_sreg : byte;
  begin
    Result:=Target;
    if Result=Comperand then
      Target:=NewValue;
  end;


function InterLockedExchangeAdd (var Target: smallint;Source : smallint) : smallint;
  var
    temp_sreg : byte;
  begin
    Result:=Target;
    Target:=Result+Source;
  end;


