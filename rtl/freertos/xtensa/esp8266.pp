{******************************************************************************
Startup code for xtensa-esp32 using idf

******************************************************************************}
unit esp8266;

{$goto on}
{$macro on}

  interface

{$linklib esp8266, static}
  {$linklib util, static}  // esp_crc8
  {$linklib log, static}   // putchar
  {$linklib c_fnano, static} // provides a bunch of libc functionality
  {$linklib newlib, static}
  {$linklib heap, static}
  {$linklib vfs, static}
  {$linklib esp_common, static}
  {$linklib core, static}
  {$linklib freertos, static}  // __reent
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

//{$linklib soc_esp32,static}
//{$linklib libm,static}
//{$linklib libg,static}
//{$linklib c,static}

  implementation

    //uses
    //  consoleio,heapmgr;

    var
      _stack_top: record end; public name '_stack_top';
      operatingsystem_result: longint; external name 'operatingsystem_result';

    procedure PASCALMAIN; external name 'PASCALMAIN';

    procedure esp_deep_sleep(us: uint32); external;
    //procedure putchar(c : char);external;
    //function getchar : char;external;
    //function __getreent : pointer;external;
    //procedure fflush(f : pointer);external;

    //procedure printpchar(p : pchar);
    //  begin
    //    while p^<>#0 do
    //       begin
    //         putchar(p^);
    //         inc(p);
    //       end;
    //    fflush(ppointer(__getreent+8)^);
    //  end;


    //procedure printdword(d : dword);
    //  const
    //    s = '0123456789ABCDEF';
    //  var
    //    i : longint;
    //  begin
    //    for i:=1 to 8 do
    //       begin
    //         putchar(s[(d and $f)+1]);
    //         d:=d shr 4;
    //       end;
    //    fflush(ppointer(__getreent+8)^);
    //  end;


    procedure _FPC_haltproc; public name '_haltproc';noreturn;
      begin
        //printpchar('_haltproc called, going to deep sleep, exit code: $');
        //printdword(operatingsystem_result);
        //printpchar(#10);
        while true do ;
           //esp_deep_sleep(0);
      end;


    procedure app_main;public name 'app_main';noreturn;
      begin
        PASCALMAIN;
        _FPC_haltproc;
      end;

    //function WriteChar(ACh: char; AUserData: pointer): boolean;
    //  begin
    //    WriteChar:=true;
    //    putchar(ACh);
    //  end;
    //
    //
    //function ReadChar(var ACh: char; AUserData: pointer): boolean;
    //  begin
    //    ReadChar:=true;
    //    ACh:=getchar;
    //  end;

begin
  //OpenIO(Input, @WriteChar, @ReadChar, fmInput, nil);
  //OpenIO(Output, @WriteChar, @ReadChar, fmOutput, nil);
  //OpenIO(ErrOutput, @WriteChar, @ReadChar, fmOutput, nil);
  //OpenIO(StdOut, @WriteChar, @ReadChar, fmOutput, nil);
  //OpenIO(StdErr, @WriteChar, @ReadChar, fmOutput, nil);
end.
