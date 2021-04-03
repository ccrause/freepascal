{******************************************************************************
Startup code for an avr simulator

******************************************************************************}
unit avrsim;

{$goto on}
{$macro on}

  interface
    var
      OUTPUTREG        : byte absolute $20;    // Interpreted by fp-avrsim as similar to a UART TX data register, data written here will be printed to console
      EXITCODEREG      : byte absolute $21;    // The value written to this register will be returned as exit code by fp-avrsim
      HALTREQUEST      : byte absolute $22;    // In fp-avrsim setting this register to 1 exits the simulation
      EXCEPTIONJMPZERO : boolean absolute $34; // Writing a value > 0 to this register will cause an exception when a jump or call instruction with address 0 as target is encountered in fp-avrsim
      EECR             : byte absolute $3F;    // EEPROM Control Register
      EEDR             : byte absolute $40;    // EEPROM Data Register
      EEAR             : word absolute $41;    // EEPROM Address Register
      EEARL            : byte absolute $41;    // EEPROM Address Register Low
      EEARH            : byte absolute $41+1;  // EEPROM Address Register High
      MCUSR            : byte absolute $54;    // Controller status register
      SPMCSR           : byte absolute $57;    // Store Program Memory Control and Status Register
      SPL              : byte absolute $5D;
      SP               : word absolute $5D;
      SPH              : byte absolute $5E;
      SREG             : byte absolute $5F;

    const
      // EECR bits
      EEPM  = 4;  // EEPROM Programming Mode Bits
      EERIE = 3;  // EEPROM Ready Interrupt Enable
      EEMPE = 2;  // EEPROM Master Write Enable
      EEPE  = 1;  // EEPROM Write Enable
      EERE  = 0;  // EEPROM Read Enable

    {$include sectionhelpersh.inc}

    {$define DOCALL:=call}
    {$define DOJMP:=jmp}

  implementation

    uses
      consoleio, heapmgr, intrinsics;

    procedure PASCALMAIN; external name 'PASCALMAIN';

    procedure _FPC_haltproc; public name '_haltproc'; noreturn;
      begin
        EXITCODEREG:=exitcode;
        HALTREQUEST:=1;
        { really stop }
        while true do
          ;
      end;

    procedure Default_IRQ_handler; public name '_Default_IRQ_handler';noreturn;
      begin
        while true do
          ;
      end;

    var
      _data: record end; external name '__data_start';
      _edata: record end; external name '__data_end';
      _etext: record end; external name '_etext';
      _bss_start: record end; external name '__bss_start';
      _bss_end: record end; external name '__bss_end';
      _stack_top: record end; external name '_stack_top';
      __trampolines_end: record end; external name '__trampolines_end';

    procedure EE_READY_ISR; external name 'EE_READY_ISR'; // Interrupt 1 EEPROM Ready

    procedure _FPC_start; assembler; nostackframe; noreturn; public name '_START'; section '.init';
      asm
        jmp __trampolines_end // Jump to code starting after interrupt vectors and possible progmem data
        jmp EE_READY_ISR
        .weak EE_READY_ISR
        .set EE_READY_ISR, Default_IRQ_handler
      end;

    procedure _FPC_init_zeroreg_SP; assembler; nostackframe; noreturn; public name '_init_zeroreg_SP'; section '.init2';
      asm
{$ifdef CPUAVR_16_REGS}
        clr r17
{$else CPUAVR_16_REGS}
        clr r1
{$endif CPUAVR_16_REGS}
{$ifndef CPUAVR1}
        // load stack pointer
        ldi r30,lo8(_stack_top)
        out 0x3d,r30
  {$if declared(SPH) or declared(CPU)}
        ldi r30,hi8(_stack_top)
        out 0x3e,r30
  {$endif declared}
{$endif CPUAVR1}
      end;

    procedure _FPC_copy_data; assembler; nostackframe; noreturn; section '.init4';
      asm
        // Initialize .data section
        ldi XL,lo8(_data)
        ldi XH,hi8(_data)
        ldi YH,hi8(_edata)
        ldi ZL,lo8(_etext)
{$ifdef CPUAVR_16_REGS}
        ldi ZH,hi8(_etext)+(0x40) // program memory mapped to $4000 in data space
{$else CPUAVR_16_REGS}
        ldi ZH,hi8(_etext)
{$endif CPUAVR_16_REGS}

        rjmp .LCopyDataLoopEntry
.LCopyDataLoop:
{$ifdef CPUAVR_16_REGS}
        ld r16, Z+
{$else CPUAVR_16_REGS}
        lpm r16, Z+
{$endif CPUAVR_16_REGS}
        st X+, r16

.LCopyDataLoopEntry:
        cpi XL, lo8(_edata)
        cpc XH, YH
        brne .LCopyDataLoop

        // Zero .bss section
        ldi XL,lo8(_bss_start)
        ldi XH,hi8(_bss_start)
        ldi YH,hi8(_bss_end)

{$ifdef RELBRANCHES}
        rjmp .LZeroBssLoopEntry
{$else RELBRANCHES}
        jmp .LZeroBssLoopEntry
{$endif RELBRANCHES}
.LZeroBssLoop:
{$ifdef CPUAVR_16_REGS}
        st X+, r17
{$else CPUAVR_16_REGS}
        st X+, r1
{$endif CPUAVR_16_REGS}

.LZeroBssLoopEntry:
        cpi XL, lo8(_bss_end)
        cpc XH, YH
        brne .LZeroBssLoop
      end;

    procedure _FPC_jmp_main; noreturn; assembler; nostackframe; section '.init9';
      asm
{$ifdef RELBRANCHES}
        rjmp PASCALMAIN
{$else RELBRANCHES}
        jmp PASCALMAIN
{$endif RELBRANCHES}
      end;

    function WriteChar(ACh: char; AUserData: pointer): boolean;
      begin
        WriteChar:=true;
        OUTPUTREG:=ord(ACh);
      end;


    function ReadChar(var ACh: char; AUserData: pointer): boolean;
      begin
        ReadChar:=true;
        ACh:=#0;
      end;

    {$include sectionhelpers.inc}

begin
  EXCEPTIONJMPZERO:=true;
  OpenIO(Input, @WriteChar, @ReadChar, fmInput, nil);
  OpenIO(Output, @WriteChar, @ReadChar, fmOutput, nil);
  OpenIO(ErrOutput, @WriteChar, @ReadChar, fmOutput, nil);
  OpenIO(StdOut, @WriteChar, @ReadChar, fmOutput, nil);
  OpenIO(StdErr, @WriteChar, @ReadChar, fmOutput, nil);
end.
