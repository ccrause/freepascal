{******************************************************************************
Startup code for xtensa-esp8266 using ESP8266_RTOS_SDK
******************************************************************************}
unit esp8266;

{$goto on}
{$macro on}

  interface

{$linklib esp8266, static}
  {$linklib util, static}
  {$linklib log, static}
  {$linklib c_fnano, static}
  {$linklib newlib, static}
  {$linklib heap, static}
  {$linklib vfs, static}
  {$linklib esp_common, static}
  {$linklib core, static}
  {$linklib freertos, static}
  {$linklib phy, static}
  {$linklib net80211, static}
  {$linklib hal, static}
  {$linklib nvs_flash, static}
  {$linklib rtc, static}
  {$linklib spi_flash, static}
  {$linklib esp_ringbuf, static}
  {$linklib gcc, static}
  {$linklib pp, static}
  {$linklib stdc++, static}
  {$linklib pthread, static}
  {$linklib wpa_supplicant, static}
  {$linklib esp_event, static}
  {$linklib wpa, static}
  {$linklib lwip, static}

  implementation

    uses
      consoleio,heapmgr;

    var
      _stack_top: record end; public name '_stack_top';
      operatingsystem_result: longint; external name 'operatingsystem_result';

    procedure PASCALMAIN; external name 'PASCALMAIN';

    procedure esp_deep_sleep(us: uint32); external;
    procedure putchar(c : char);external;
    function getchar : char;external;
    function __getreent : pointer;external;
    procedure fflush(f : pointer);external;

    procedure esp_task_wdt_reset(); external;

    procedure printpchar(p : pchar);
      begin
        while p^<>#0 do
           begin
             putchar(p^);
             inc(p);
           end;
        fflush(ppointer(__getreent+8)^);
      end;

    procedure printDecimalDword(val : dword);
      const
        s = '0123456789';
      var
        i : longint;
        d, q: uint32;
        LeadingZeroes: boolean = true;
      begin
        d := 1000000000;
        while d > 0 do
           begin
             q := val div d;
             if LeadingZeroes and (q > 0) then
               LeadingZeroes := false;
             if not LeadingZeroes then
               putchar(s[q + 1]);
             val := val - (q*d);
             d := d div 10;
           end;
        fflush(ppointer(__getreent+8)^);
      end;

    procedure printdword(d : dword);
      const
        s = '0123456789ABCDEF';
      var
        i : longint;
      begin
        for i:=1 to 8 do
           begin
             putchar(s[(d shr 28) + 1]);
             d := d shl 4;
           end;
        fflush(ppointer(__getreent+8)^);
      end;


    procedure _FPC_haltproc; public name '_haltproc';noreturn;
      begin
        writeln;
        if operatingsystem_result <> 0 then
          writeln('Runtime error ', operatingsystem_result);

        write('_haltproc called, going to deep sleep.');
        // Flush output buffer before sleeping
        fflush(ppointer(__getreent+8)^);
        while true do
          esp_deep_sleep(0);
      end;


    procedure app_main;public name 'app_main';noreturn;
      begin
        PASCALMAIN;
        _FPC_haltproc;
      end;

    function WriteChar(ACh: char; AUserData: pointer): boolean;
      begin
        WriteChar:=true;
        putchar(ACh);
      end;


    function ReadChar(var ACh: char; AUserData: pointer): boolean;
      begin
        ReadChar:=true;
        ACh:=getchar;
      end;

begin
  OpenIO(Input, @WriteChar, @ReadChar, fmInput, nil);
  OpenIO(Output, @WriteChar, @ReadChar, fmOutput, nil);
  OpenIO(ErrOutput, @WriteChar, @ReadChar, fmOutput, nil);
  OpenIO(StdOut, @WriteChar, @ReadChar, fmOutput, nil);
  OpenIO(StdErr, @WriteChar, @ReadChar, fmOutput, nil);
end.
