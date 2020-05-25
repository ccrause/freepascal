{
    Copyright (c) 2005-2017 by Free Pascal Compiler team

    This unit implements support import, export, link routines
    for the FreeRTOS Target

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

 ****************************************************************************
}
unit t_freertos;

{$i fpcdefs.inc}

interface


implementation

    uses
       SysUtils,
       cutils,cfileutl,cclasses,
       globtype,globals,systems,verbose,comphook,cscript,fmodule,i_freertos,link,
       cpuinfo;

    type
       TlinkerFreeRTOS=class(texternallinker)
       private
          Function  WriteResponseFile: Boolean;
       public
          constructor Create; override;
          procedure SetDefaultInfo; override;
          function  MakeExecutable:boolean; override;
          function postprocessexecutable(const fn : string;isdll:boolean):boolean;
       end;



{*****************************************************************************
                                  TlinkerEmbedded
*****************************************************************************}

Constructor TlinkerFreeRTOS.Create;
begin
  Inherited Create;
  SharedLibFiles.doubles:=true;
  StaticLibFiles.doubles:=true;
end;


procedure TlinkerFreeRTOS.SetDefaultInfo;
const
{$ifdef mips}
  {$ifdef mipsel}
    platform_select='-EL';
  {$else}
    platform_select='-EB';
  {$endif}
{$else}
  platform_select='';
{$endif}
begin
  with Info do
   begin
     if target_info.system=system_xtensa_freertos then
       if current_settings.controllertype = ct_esp8266 then
         ExeCmd[1]:='ld -g '+platform_select+' $OPT $DYNLINK $STATIC $GCSECTIONS $STRIP $MAP -L. -o $EXE -T $RES '+
           '-u call_user_start_cpu -u esp_app_desc '+
           '-L /home/christo/xtensa/ESP8266_RTOS_SDK/libs -T build-linker-script.ld'
           //'-L $IDF_PATH/components/esp8266/ld -T esp8266.peripherals.ld -T esp8266.rom.ld ' +
           //'-L . -T esp8266_out.ld -T esp8266.project.ld '
       else
         ExeCmd[1]:='ld -g '+platform_select+' $OPT $DYNLINK $STATIC $GCSECTIONS $STRIP $MAP -L. -o $EXE -T $RES '+
           '-u call_user_start_cpu0 -u ld_include_panic_highint_hdl -u esp_app_desc -u vfs_include_syscalls_impl -u pthread_include_pthread_impl -u pthread_include_pthread_cond_impl -u pthread_include_pthread_local_storage_impl -u newlib_include_locks_impl -u newlib_include_heap_impl -u newlib_include_syscalls_impl -u newlib_include_pthread_impl -u app_main -u uxTopUsedPriority '+
           '-L $IDF_PATH/components/esp_rom/esp32/ld '+
           '-T esp32.rom.ld -T esp32.rom.libgcc.ld -T esp32.rom.newlib-data.ld -T esp32.rom.syscalls.ld -T esp32.rom.newlib-funcs.ld '+
           '-L . -T esp32_out.ld -T esp32.project.ld '+
           '-L $IDF_PATH/components/esp32/ld -T esp32.peripherals.ld'
     else
       ExeCmd[1]:='ld -g '+platform_select+' $OPT $DYNLINK $STATIC $GCSECTIONS $STRIP $MAP -L. -o $EXE -T $RES';
   end;
end;


Function TlinkerFreeRTOS.WriteResponseFile: Boolean;
Var
  linkres  : TLinkRes;
  i        : longint;
  HPath    : TCmdStrListItem;
  s,s1,s2  : TCmdStr;
  prtobj,
  cprtobj  : string[80];
  linklibc : boolean;
  found1,
  found2   : boolean;
{$if defined(ARM)}
  LinkStr  : string;
{$endif}
begin
  WriteResponseFile:=False;
  linklibc:=(SharedLibFiles.Find('c')<>nil);
{$if defined(ARM) or defined(i386) or defined(x86_64) or defined(AVR) or defined(MIPSEL) or defined(RISCV32) or defined(XTENSA)}
  prtobj:='';
{$else}
  prtobj:='prt0';
{$endif}
  cprtobj:='cprt0';
  if linklibc then
    prtobj:=cprtobj;

  { Open link.res file }
  LinkRes:=TLinkRes.Create(outputexedir+Info.ResName,true);

  { Write path to search libraries }
  HPath:=TCmdStrListItem(current_module.locallibrarysearchpath.First);
  while assigned(HPath) do
   begin
    s:=HPath.Str;
    if (cs_link_on_target in current_settings.globalswitches) then
     s:=ScriptFixFileName(s);
    LinkRes.Add('-L'+s);
    HPath:=TCmdStrListItem(HPath.Next);
   end;
  HPath:=TCmdStrListItem(LibrarySearchPath.First);
  while assigned(HPath) do
   begin
    s:=HPath.Str;
    if s<>'' then
     LinkRes.Add('SEARCH_DIR("'+s+'")');
    HPath:=TCmdStrListItem(HPath.Next);
   end;

  LinkRes.Add('INPUT (');
  { add objectfiles, start with prt0 always }
  //s:=FindObjectFile('prt0','',false);
  if prtobj<>'' then
    begin
      s:=FindObjectFile(prtobj,'',false);
      LinkRes.AddFileName(s);
    end;

  { try to add crti and crtbegin if linking to C }
  if linklibc then
   begin
     if librarysearchpath.FindFile('crtbegin.o',false,s) then
      LinkRes.AddFileName(s);
     if librarysearchpath.FindFile('crti.o',false,s) then
      LinkRes.AddFileName(s);
   end;

  while not ObjectFiles.Empty do
   begin
    s:=ObjectFiles.GetFirst;
    if s<>'' then
     begin
      { vlink doesn't use SEARCH_DIR for object files }
      if not(cs_link_on_target in current_settings.globalswitches) then
       s:=FindObjectFile(s,'',false);
      LinkRes.AddFileName((maybequoted(s)));
     end;
   end;

  { Write staticlibraries }
  if not(StaticLibFiles.Empty) then
    begin
      LinkRes.Add(')');
      LinkRes.Add('GROUP(');
      while not StaticLibFiles.Empty do
        begin
          S:=StaticLibFiles.GetFirst;
          LinkRes.AddFileName((maybequoted(s)));
        end;
    end;

   LinkRes.Add(')');

   { Write sharedlibraries like -l<lib>, also add the needed dynamic linker
     here to be sure that it gets linked this is needed for glibc2 systems (PFV) }
   linklibc:=false;
   while not SharedLibFiles.Empty do
    begin
     S:=SharedLibFiles.GetFirst;
     if s<>'c' then
      begin
       i:=Pos(target_info.sharedlibext,S);
       if i>0 then
        Delete(S,i,255);
       LinkRes.Add('-l'+s);
      end
     else
      begin
       LinkRes.Add('-l'+s);
       linklibc:=true;
      end;
    end;
   { be sure that libc&libgcc is the last lib }
   if linklibc then
    begin
     LinkRes.Add('-lc');
     LinkRes.Add('-lgcc');
    end;

  { objects which must be at the end }
  if linklibc then
   begin
     found1:=librarysearchpath.FindFile('crtend.o',false,s1);
     found2:=librarysearchpath.FindFile('crtn.o',false,s2);
     if found1 or found2 then
      begin
        LinkRes.Add('INPUT(');
        if found1 then
         LinkRes.AddFileName(s1);
        if found2 then
         LinkRes.AddFileName(s2);
        LinkRes.Add(')');
      end;
   end;

{$ifdef ARM}
  with embedded_controllers[current_settings.controllertype] do
    with linkres do
      begin
        Add('ENTRY(_START)');
        Add('MEMORY');
        Add('{');
        if flashsize<>0 then
          begin
            LinkStr := '    flash : ORIGIN = 0x' + IntToHex(flashbase,8)
              + ', LENGTH = 0x' + IntToHex(flashsize,8);
            Add(LinkStr);
          end;

        LinkStr := '    ram : ORIGIN = 0x' + IntToHex(srambase,8)
          + ', LENGTH = 0x' + IntToHex(sramsize,8);
        Add(LinkStr);

        Add('}');
        Add('_stack_top = 0x' + IntToHex(sramsize+srambase,8) + ';');
        Add('SECTIONS');
        Add('{');
        Add('    .text :');
        Add('    {');
        Add('    _text_start = .;');
        Add('    KEEP(*(.init .init.*))');
        Add('    *(.text .text.*)');
        Add('    *(.strings)');
        Add('    *(.rodata .rodata.*)');
        Add('    *(.comment)');
        Add('    . = ALIGN(4);');
        Add('    _etext = .;');
        if flashsize<>0 then
          begin
            Add('    } >flash');
            Add('    .note.gnu.build-id : { *(.note.gnu.build-id) } >flash ');
          end
        else
          begin
            Add('    } >ram');
            Add('    .note.gnu.build-id : { *(.note.gnu.build-id) } >ram ');
          end;

        Add('    .data :');
        Add('    {');
        Add('    _data = .;');
        Add('    *(.data .data.*)');
        Add('    KEEP (*(.fpc .fpc.n_version .fpc.n_links))');
        Add('    _edata = .;');
      if flashsize<>0 then
        begin
          Add('    } >ram AT >flash');
        end
      else
        begin
          Add('    } >ram');
        end;
      Add('    .bss :');
      Add('    {');
      Add('    _bss_start = .;');
      Add('    *(.bss .bss.*)');
      Add('    *(COMMON)');
      Add('    } >ram');
      Add('    . = ALIGN(4);');
      Add('    _bss_end = . ;');
      Add('}');
      Add('_end = .;');
    end;
{$endif ARM}

{$ifdef i386}
  with linkres do
    begin
      Add('ENTRY(_START)');
      Add('SECTIONS');
      Add('{');
      Add('     . = 0x100000;');
      Add('     .text ALIGN (0x1000) :');
      Add('    {');
      Add('    _text = .;');
      Add('    KEEP(*(.init .init.*))');
      Add('    *(.text .text.*)');
      Add('    *(.strings)');
      Add('    *(.rodata .rodata.*)');
      Add('    *(.comment)');
      Add('    _etext = .;');
      Add('    }');
      Add('    .data ALIGN (0x1000) :');
      Add('    {');
      Add('    _data = .;');
      Add('    *(.data .data.*)');
      Add('    KEEP (*(.fpc .fpc.n_version .fpc.n_links))');
      Add('    _edata = .;');
      Add('    }');
      Add('    . = ALIGN(4);');
      Add('    .bss :');
      Add('    {');
      Add('    _bss_start = .;');
      Add('    *(.bss .bss.*)');
      Add('    *(COMMON)');
      Add('    }');
      Add('_bss_end = . ;');
      Add('}');
      Add('_end = .;');
    end;
{$endif i386}

{$ifdef x86_64}
  with linkres do
    begin
      Add('ENTRY(_START)');
      Add('SECTIONS');
      Add('{');
      Add('     . = 0x100000;');
      Add('     .text ALIGN (0x1000) :');
      Add('    {');
      Add('    _text = .;');
      Add('    KEEP(*(.init .init.*))');
      Add('    *(.text .text.*)');
      Add('    *(.strings)');
      Add('    *(.rodata .rodata.*)');
      Add('    *(.comment)');
      Add('    _etext = .;');
      Add('    }');
      Add('    .data ALIGN (0x1000) :');
      Add('    {');
      Add('    _data = .;');
      Add('    *(.data .data.*)');
      Add('    KEEP (*(.fpc .fpc.n_version .fpc.n_links))');
      Add('    _edata = .;');
      Add('    }');
      Add('    . = ALIGN(4);');
      Add('    .bss :');
      Add('    {');
      Add('    _bss_start = .;');
      Add('    *(.bss .bss.*)');
      Add('    *(COMMON)');
      Add('    }');
      Add('_bss_end = . ;');
      Add('}');
      Add('_end = .;');
    end;
{$endif x86_64}

{$ifdef AVR}
  with linkres do
    begin
      { linker script from ld 2.19 }
      Add('ENTRY(_START)');
      Add('OUTPUT_FORMAT("elf32-avr","elf32-avr","elf32-avr")');
      case current_settings.cputype of
       cpu_avr1:
         Add('OUTPUT_ARCH(avr:1)');
       cpu_avr2:
         Add('OUTPUT_ARCH(avr:2)');
       cpu_avr25:
         Add('OUTPUT_ARCH(avr:25)');
       cpu_avr3:
         Add('OUTPUT_ARCH(avr:3)');
       cpu_avr31:
         Add('OUTPUT_ARCH(avr:31)');
       cpu_avr35:
         Add('OUTPUT_ARCH(avr:35)');
       cpu_avr4:
         Add('OUTPUT_ARCH(avr:4)');
       cpu_avr5:
         Add('OUTPUT_ARCH(avr:5)');
       cpu_avr51:
         Add('OUTPUT_ARCH(avr:51)');
       cpu_avr6:
         Add('OUTPUT_ARCH(avr:6)');
       cpu_avrxmega3:
         Add('OUTPUT_ARCH(avr:103)');
       cpu_avrtiny:
         Add('OUTPUT_ARCH(avr:100)');
       else
         Internalerror(2015072701);
      end;
      Add('MEMORY');
      with embedded_controllers[current_settings.controllertype] do
        begin
          Add('{');
          Add('  text      (rx)   : ORIGIN = 0, LENGTH = 0x'+IntToHex(flashsize,6));
          Add('  data      (rw!x) : ORIGIN = 0x'+IntToHex($800000+srambase,6)+', LENGTH = 0x'+IntToHex(sramsize,6));
          Add('  eeprom    (rw!x) : ORIGIN = 0x810000, LENGTH = 0x'+IntToHex(eepromsize,6));
          Add('  fuse      (rw!x) : ORIGIN = 0x820000, LENGTH = 1K');
          Add('  lock      (rw!x) : ORIGIN = 0x830000, LENGTH = 1K');
          Add('  signature (rw!x) : ORIGIN = 0x840000, LENGTH = 1K');
          Add('}');
          Add('_stack_top = 0x' + IntToHex(srambase+sramsize-1,4) + ';');
        end;
      Add('SECTIONS');
      Add('{');
      Add('  /* Read-only sections, merged into text segment: */');
      Add('  .hash          : { *(.hash)		}');
      Add('  .dynsym        : { *(.dynsym)		}');
      Add('  .dynstr        : { *(.dynstr)		}');
      Add('  .gnu.version   : { *(.gnu.version)	}');
      Add('  .gnu.version_d   : { *(.gnu.version_d)	}');
      Add('  .gnu.version_r   : { *(.gnu.version_r)	}');
      Add('  .rel.init      : { *(.rel.init)		}');
      Add('  .rela.init     : { *(.rela.init)	}');
      Add('  .rel.text      :');
      Add('    {');
      Add('      *(.rel.text)');
      Add('      *(.rel.text.*)');
      Add('      *(.rel.gnu.linkonce.t*)');
      Add('    }');
      Add('  .rela.text     :');
      Add('    {');
      Add('      *(.rela.text)');
      Add('      *(.rela.text.*)');
      Add('      *(.rela.gnu.linkonce.t*)');
      Add('    }');
      Add('  .rel.fini      : { *(.rel.fini)		}');
      Add('  .rela.fini     : { *(.rela.fini)	}');
      Add('  .rel.rodata    :');
      Add('    {');
      Add('      *(.rel.rodata)');
      Add('      *(.rel.rodata.*)');
      Add('      *(.rel.gnu.linkonce.r*)');
      Add('    }');
      Add('  .rela.rodata   :');
      Add('    {');
      Add('      *(.rela.rodata)');
      Add('      *(.rela.rodata.*)');
      Add('      *(.rela.gnu.linkonce.r*)');
      Add('    }');
      Add('  .rel.data      :');
      Add('    {');
      Add('      *(.rel.data)');
      Add('      *(.rel.data.*)');
      Add('      *(.rel.gnu.linkonce.d*)');
      Add('    }');
      Add('  .rela.data     :');
      Add('    {');
      Add('      *(.rela.data)');
      Add('      *(.rela.data.*)');
      Add('      *(.rela.gnu.linkonce.d*)');
      Add('    }');
      Add('  .rel.ctors     : { *(.rel.ctors)	}');
      Add('  .rela.ctors    : { *(.rela.ctors)	}');
      Add('  .rel.dtors     : { *(.rel.dtors)	}');
      Add('  .rela.dtors    : { *(.rela.dtors)	}');
      Add('  .rel.got       : { *(.rel.got)		}');
      Add('  .rela.got      : { *(.rela.got)		}');
      Add('  .rel.bss       : { *(.rel.bss)		}');
      Add('  .rela.bss      : { *(.rela.bss)		}');
      Add('  .rel.plt       : { *(.rel.plt)		}');
      Add('  .rela.plt      : { *(.rela.plt)		}');
      Add('  /* Internal text space or external memory.  */');
      Add('  .text   :');
      Add('  {');
      Add('    KEEP(*(.init .init.*))');
      Add('    /* For data that needs to reside in the lower 64k of progmem.  */');
      Add('    *(.progmem.gcc*)');
      Add('    *(.progmem*)');
      Add('    . = ALIGN(2);');
      Add('     __trampolines_start = . ;');
      Add('    /* The jump trampolines for the 16-bit limited relocs will reside here.  */');
      Add('    *(.trampolines)');
      Add('    *(.trampolines*)');
      Add('     __trampolines_end = . ;');
      Add('    /* For future tablejump instruction arrays for 3 byte pc devices.');
      Add('       We don''t relax jump/call instructions within these sections.  */');
      Add('    *(.jumptables)');
      Add('    *(.jumptables*)');
      Add('    /* For code that needs to reside in the lower 128k progmem.  */');
      Add('    *(.lowtext)');
      Add('    *(.lowtext*)');
      Add('     __ctors_start = . ;');
      Add('     *(.ctors)');
      Add('     __ctors_end = . ;');
      Add('     __dtors_start = . ;');
      Add('     *(.dtors)');
      Add('     __dtors_end = . ;');
      Add('    KEEP(SORT(*)(.ctors))');
      Add('    KEEP(SORT(*)(.dtors))');
      Add('    /* From this point on, we don''t bother about wether the insns are');
      Add('       below or above the 16 bits boundary.  */');
      Add('    *(.init0)  /* Start here after reset.  */');
      Add('    KEEP (*(.init0))');
      Add('    *(.init1)');
      Add('    KEEP (*(.init1))');
      Add('    *(.init2)  /* Clear __zero_reg__, set up stack pointer.  */');
      Add('    KEEP (*(.init2))');
      Add('    *(.init3)');
      Add('    KEEP (*(.init3))');
      Add('    *(.init4)  /* Initialize data and BSS.  */');
      Add('    KEEP (*(.init4))');
      Add('    *(.init5)');
      Add('    KEEP (*(.init5))');
      Add('    *(.init6)  /* C++ constructors.  */');
      Add('    KEEP (*(.init6))');
      Add('    *(.init7)');
      Add('    KEEP (*(.init7))');
      Add('    *(.init8)');
      Add('    KEEP (*(.init8))');
      Add('    *(.init9)  /* Call main().  */');
      Add('    KEEP (*(.init9))');
      Add('    *(.text)');
      Add('    . = ALIGN(2);');
      Add('    *(.text.*)');
      Add('    . = ALIGN(2);');
      Add('    *(.fini9)  /* _exit() starts here.  */');
      Add('    KEEP (*(.fini9))');
      Add('    *(.fini8)');
      Add('    KEEP (*(.fini8))');
      Add('    *(.fini7)');
      Add('    KEEP (*(.fini7))');
      Add('    *(.fini6)  /* C++ destructors.  */');
      Add('    KEEP (*(.fini6))');
      Add('    *(.fini5)');
      Add('    KEEP (*(.fini5))');
      Add('    *(.fini4)');
      Add('    KEEP (*(.fini4))');
      Add('    *(.fini3)');
      Add('    KEEP (*(.fini3))');
      Add('    *(.fini2)');
      Add('    KEEP (*(.fini2))');
      Add('    *(.fini1)');
      Add('    KEEP (*(.fini1))');
      Add('    *(.fini0)  /* Infinite loop after program termination.  */');
      Add('    KEEP (*(.fini0))');
      Add('     _etext = . ;');
      Add('  }  > text');
      Add('  .data	  : AT (ADDR (.text) + SIZEOF (.text))');
      Add('  {');
      Add('     PROVIDE (__data_start = .) ;');
      Add('    *(.data)');
      Add('    *(.data*)');
      Add('    *(.rodata)  /* We need to include .rodata here if gcc is used */');
      Add('    *(.rodata*) /* with -fdata-sections.  */');
      Add('    *(.gnu.linkonce.d*)');
      Add('    . = ALIGN(2);');
      Add('     _edata = . ;');
      Add('     PROVIDE (__data_end = .) ;');
      Add('  }  > data');
      Add('  .bss   : AT (ADDR (.bss))');
      Add('  {');
      Add('     PROVIDE (__bss_start = .) ;');
      Add('    *(.bss)');
      Add('    *(.bss*)');
      Add('    *(COMMON)');
      Add('     PROVIDE (__bss_end = .) ;');
      Add('  }  > data');
      Add('   __data_load_start = LOADADDR(.data);');
      Add('   __data_load_end = __data_load_start + SIZEOF(.data);');
      Add('  /* Global data not cleared after reset.  */');
      Add('  .noinit  :');
      Add('  {');
      Add('     PROVIDE (__noinit_start = .) ;');
      Add('    *(.noinit*)');
      Add('     PROVIDE (__noinit_end = .) ;');
      Add('     _end = . ;');
      Add('     PROVIDE (__heap_start = .) ;');
      Add('  }  > data');
      Add('  .eeprom  :');
      Add('  {');
      Add('    *(.eeprom*)');
      Add('     __eeprom_end = . ;');
      Add('  }  > eeprom');
      Add('  .fuse  :');
      Add('  {');
      Add('    KEEP(*(.fuse))');
      Add('    KEEP(*(.lfuse))');
      Add('    KEEP(*(.hfuse))');
      Add('    KEEP(*(.efuse))');
      Add('  }  > fuse');
      Add('  .lock  :');
      Add('  {');
      Add('    KEEP(*(.lock*))');
      Add('  }  > lock');
      Add('  .signature  :');
      Add('  {');
      Add('    KEEP(*(.signature*))');
      Add('  }  > signature');
      Add('  /* Stabs debugging sections.  */');
      Add('  .stab 0 : { *(.stab) }');
      Add('  .stabstr 0 : { *(.stabstr) }');
      Add('  .stab.excl 0 : { *(.stab.excl) }');
      Add('  .stab.exclstr 0 : { *(.stab.exclstr) }');
      Add('  .stab.index 0 : { *(.stab.index) }');
      Add('  .stab.indexstr 0 : { *(.stab.indexstr) }');
      Add('  .comment 0 : { *(.comment) }');
      Add('  /* DWARF debug sections.');
      Add('     Symbols in the DWARF debugging sections are relative to the beginning');
      Add('     of the section so we begin them at 0.  */');
      Add('  /* DWARF 1 */');
      Add('  .debug          0 : { *(.debug) }');
      Add('  .line           0 : { *(.line) }');
      Add('  /* GNU DWARF 1 extensions */');
      Add('  .debug_srcinfo  0 : { *(.debug_srcinfo) }');
      Add('  .debug_sfnames  0 : { *(.debug_sfnames) }');
      Add('  /* DWARF 1.1 and DWARF 2 */');
      Add('  .debug_aranges  0 : { *(.debug_aranges) }');
      Add('  .debug_pubnames 0 : { *(.debug_pubnames) }');
      Add('  /* DWARF 2 */');
      Add('  .debug_info     0 : { *(.debug_info) *(.gnu.linkonce.wi.*) }');
      Add('  .debug_abbrev   0 : { *(.debug_abbrev) }');
      Add('  .debug_line     0 : { *(.debug_line) }');
      Add('  .debug_frame    0 : { *(.debug_frame) }');
      Add('  .debug_str      0 : { *(.debug_str) }');
      Add('  .debug_loc      0 : { *(.debug_loc) }');
      Add('  .debug_macinfo  0 : { *(.debug_macinfo) }');
      Add('}');
    end;
{$endif AVR}

{$ifdef MIPSEL}
  case current_settings.controllertype of
      ct_none:
           begin
           end;
      ct_pic32mx110f016b,
      ct_pic32mx110f016c,
      ct_pic32mx110f016d,
      ct_pic32mx120f032b,
      ct_pic32mx120f032c,
      ct_pic32mx120f032d,
      ct_pic32mx130f064b,
      ct_pic32mx130f064c,
      ct_pic32mx130f064d,
      ct_pic32mx150f128b,
      ct_pic32mx150f128c,
      ct_pic32mx150f128d,
      ct_pic32mx210f016b,
      ct_pic32mx210f016c,
      ct_pic32mx210f016d,
      ct_pic32mx220f032b,
      ct_pic32mx220f032c,
      ct_pic32mx220f032d,
      ct_pic32mx230f064b,
      ct_pic32mx230f064c,
      ct_pic32mx230f064d,
      ct_pic32mx250f128b,
      ct_pic32mx250f128c,
      ct_pic32mx250f128d,
      ct_pic32mx775f256h,
      ct_pic32mx775f256l,
      ct_pic32mx775f512h,
      ct_pic32mx775f512l,
      ct_pic32mx795f512h,
      ct_pic32mx795f512l:
        begin
         with embedded_controllers[current_settings.controllertype] do
          with linkres do
            begin
              Add('OUTPUT_FORMAT("elf32-tradlittlemips")');
              Add('OUTPUT_ARCH(pic32mx)');
              Add('ENTRY(_reset)');
              Add('PROVIDE(_vector_spacing = 0x00000001);');
              Add('_ebase_address = 0x'+IntToHex(flashbase,8)+';');
              Add('_RESET_ADDR              = 0xBFC00000;');
              Add('_BEV_EXCPT_ADDR          = 0xBFC00380;');
              Add('_DBG_EXCPT_ADDR          = 0xBFC00480;');
              Add('_GEN_EXCPT_ADDR          = _ebase_address + 0x180;');
              Add('MEMORY');
              Add('{');
              if flashsize<>0 then
                begin
                  Add('  kseg0_program_mem          : ORIGIN = 0x'+IntToHex(flashbase,8)+', LENGTH = 0x'+IntToHex(flashsize,8));
                  //TODO This should better be placed into the controllertype records
                  Add('  kseg1_boot_mem             : ORIGIN = 0xBFC00000, LENGTH = 0xbef');
                  Add('  config3                    : ORIGIN = 0xBFC00BF0, LENGTH = 0x4');
                  Add('  config2                    : ORIGIN = 0xBFC00BF4, LENGTH = 0x4');
                  Add('  config1                    : ORIGIN = 0xBFC00BF8, LENGTH = 0x4');
                  Add('  config0                    : ORIGIN = 0xBFC00BFC, LENGTH = 0x4');
                end;

              Add('  ram                        : ORIGIN = 0x' + IntToHex(srambase,8)
              	+ ', LENGTH = 0x' + IntToHex(sramsize,8));

              Add('}');
              Add('_stack_top = 0x' + IntToHex(sramsize+srambase,8) + ';');
            end;
        end
  end;

  with linkres do
    begin
      Add('SECTIONS');
      Add('{');
      Add('    .reset _RESET_ADDR :');
      Add('    {');
      Add('      KEEP(*(.reset .reset.*))');
      Add('      KEEP(*(.startup .startup.*))');
      Add('    } > kseg1_boot_mem');
      Add('    .bev_excpt _BEV_EXCPT_ADDR :');
      Add('    {');
      Add('      KEEP(*(.bev_handler))');
      Add('    } > kseg1_boot_mem');

      Add('    .text :');
      Add('    {');
      Add('    _text_start = .;');
      Add('    . = _text_start + 0x180;');
      Add('    KEEP(*(.gen_handler))');
      Add('    . = _text_start + 0x200;');
      Add('    KEEP(*(.init .init.*))');
      Add('    *(.text .text.*)');
      Add('    *(.strings)');
      Add('    *(.rodata .rodata.*)');
      Add('    *(.comment)');
      Add('    _etext = .;');
      if embedded_controllers[current_settings.controllertype].flashsize<>0 then
        begin
          Add('    } >kseg0_program_mem');
        end
      else
        begin
          Add('    } >ram');
        end;
      Add('    .note.gnu.build-id : { *(.note.gnu.build-id) }');

      Add('    .data :');
      Add('    {');
      Add('    _data = .;');
      Add('    *(.data .data.*)');
      Add('    KEEP (*(.fpc .fpc.n_version .fpc.n_links))');
      Add('    . = .;');
      Add('    _gp = ALIGN(16) + 0x7ff0;');
      Add('    _edata = .;');
      if embedded_controllers[current_settings.controllertype].flashsize<>0 then
        begin
          Add('    } >ram AT >kseg0_program_mem');
        end
      else
        begin
          Add('    } >ram');
        end;
      Add('  .config_BFC00BF0 : {');
      Add('    KEEP(*(.config_BFC00BF0))');
      Add('  } > config3');
      Add('  .config_BFC00BF4 : {');
      Add('    KEEP(*(.config_BFC00BF4))');
      Add('  } > config2');
      Add('  .config_BFC00BF8 : {');
      Add('    KEEP(*(.config_BFC00BF8))');
      Add('  } > config1');
      Add('  .config_BFC00BFC : {');
      Add('    KEEP(*(.config_BFC00BFC))');
      Add('  } > config0');
      Add('    .bss :');
      Add('    {');
      Add('    _bss_start = .;');
      Add('    *(.bss .bss.*)');
      Add('    *(COMMON)');
      Add('    } >ram');
      Add('. = ALIGN(4);');
      Add('_bss_end = . ;');
      Add('  .comment       0 : { *(.comment) }');
      Add('  /* DWARF debug sections.');
      Add('     Symbols in the DWARF debugging sections are relative to the beginning');
      Add('     of the section so we begin them at 0.  */');
      Add('  /* DWARF 1 */');
      Add('  .debug          0 : { *(.debug) }');
      Add('  .line           0 : { *(.line) }');
      Add('  /* GNU DWARF 1 extensions */');
      Add('  .debug_srcinfo  0 : { *(.debug_srcinfo) }');
      Add('  .debug_sfnames  0 : { *(.debug_sfnames) }');
      Add('  /* DWARF 1.1 and DWARF 2 */');
      Add('  .debug_aranges  0 : { *(.debug_aranges) }');
      Add('  .debug_pubnames 0 : { *(.debug_pubnames) }');
      Add('  /* DWARF 2 */');
      Add('  .debug_info     0 : { *(.debug_info .gnu.linkonce.wi.*) }');
      Add('  .debug_abbrev   0 : { *(.debug_abbrev) }');
      Add('  /DISCARD/         : { *(.debug_line) }');
      Add('  .debug_frame    0 : { *(.debug_frame) }');
      Add('  .debug_str      0 : { *(.debug_str) }');
      Add('  /DISCARD/         : { *(.debug_loc) }');
      Add('  .debug_macinfo  0 : { *(.debug_macinfo) }');
      Add('  /* SGI/MIPS DWARF 2 extensions */');
      Add('  .debug_weaknames 0 : { *(.debug_weaknames) }');
      Add('  .debug_funcnames 0 : { *(.debug_funcnames) }');
      Add('  .debug_typenames 0 : { *(.debug_typenames) }');
      Add('  .debug_varnames  0 : { *(.debug_varnames) }');
      Add('  /* DWARF 3 */');
      Add('  .debug_pubtypes 0 : { *(.debug_pubtypes) }');
      Add('  .debug_ranges   0 : { *(.debug_ranges) }');
      Add('  .gnu.attributes 0 : { KEEP (*(.gnu.attributes)) }');
      Add('  .gptab.sdata : { *(.gptab.data) *(.gptab.sdata) }');
      Add('  .gptab.sbss : { *(.gptab.bss) *(.gptab.sbss) }');
      Add('  .mdebug.abi32 : { KEEP(*(.mdebug.abi32)) }');
      Add('  .mdebug.abiN32 : { KEEP(*(.mdebug.abiN32)) }');
      Add('  .mdebug.abi64 : { KEEP(*(.mdebug.abi64)) }');
      Add('  .mdebug.abiO64 : { KEEP(*(.mdebug.abiO64)) }');
      Add('  .mdebug.eabi32 : { KEEP(*(.mdebug.eabi32)) }');
      Add('  .mdebug.eabi64 : { KEEP(*(.mdebug.eabi64)) }');
      Add('  /DISCARD/ : { *(.rel.dyn) }');
      Add('  /DISCARD/ : { *(.note.GNU-stack) *(.gnu_debuglink) *(.gnu.lto_*) }');
      Add('}');
      Add('_end = .;');
    end;
{$endif MIPSEL}

{$ifdef RISCV32}
  with linkres do
    begin
      Add('OUTPUT_ARCH("riscv")');
      Add('ENTRY(_START)');
      Add('MEMORY');
      with embedded_controllers[current_settings.controllertype] do
        begin
          Add('{');
          Add('  flash      (rx)   : ORIGIN = 0x'+IntToHex(flashbase,6)+', LENGTH = 0x'+IntToHex(flashsize,6));
          Add('  ram        (rw!x) : ORIGIN = 0x'+IntToHex(srambase,6)+', LENGTH = 0x'+IntToHex(sramsize,6));
          Add('}');
          Add('_stack_top = 0x' + IntToHex(srambase+sramsize-1,4) + ';');
        end;
      Add('SECTIONS');
      Add('{');
      Add('  .text :');
      Add('  {');
      Add('    _text_start = .;');
      Add('    KEEP(*(.init .init.*))');
      Add('    *(.text .text.*)');
      Add('    *(.strings)');
      Add('    *(.rodata .rodata.*)');
      Add('    *(.comment)');
      Add('    . = ALIGN(4);');
      Add('    _etext = .;');
      if embedded_controllers[current_settings.controllertype].flashsize<>0 then
        begin
          Add('  } >flash');
          //Add('    .note.gnu.build-id : { *(.note.gnu.build-id) } >flash ');
        end
      else
        begin
          Add('  } >ram');
          //Add('    .note.gnu.build-id : { *(.note.gnu.build-id) } >ram ');
        end;

      Add('  .data :');
      Add('  {');
      Add('    _data = .;');
      Add('    *(.data .data.*)');
      Add('    KEEP (*(.fpc .fpc.n_version .fpc.n_links))');
      Add('    _edata = .;');
      if embedded_controllers[current_settings.controllertype].flashsize<>0 then
        begin
          Add('  } >ram AT >flash');
        end
      else
        begin
          Add('  } >ram');
        end;
      Add('  .bss :');
      Add('  {');
      Add('    _bss_start = .;');
      Add('    *(.bss .bss.*)');
      Add('    *(COMMON)');
      Add('  } >ram');
      Add('  . = ALIGN(4);');
      Add('  _bss_end = . ;');
      Add('  /* Stabs debugging sections.  */');
      Add('  .stab          0 : { *(.stab) }');
      Add('  .stabstr       0 : { *(.stabstr) }');
      Add('  .stab.excl     0 : { *(.stab.excl) }');
      Add('  .stab.exclstr  0 : { *(.stab.exclstr) }');
      Add('  .stab.index    0 : { *(.stab.index) }');
      Add('  .stab.indexstr 0 : { *(.stab.indexstr) }');
      Add('  .comment       0 : { *(.comment) }');
      Add('  /* DWARF debug sections.');
      Add('     Symbols in the DWARF debugging sections are relative to the beginning');
      Add('     of the section so we begin them at 0.  */');
      Add('  /* DWARF 1 */');
      Add('  .debug          0 : { *(.debug) }');
      Add('  .line           0 : { *(.line) }');
      Add('  /* GNU DWARF 1 extensions */');
      Add('  .debug_srcinfo  0 : { *(.debug_srcinfo) }');
      Add('  .debug_sfnames  0 : { *(.debug_sfnames) }');
      Add('  /* DWARF 1.1 and DWARF 2 */');
      Add('  .debug_aranges  0 : { *(.debug_aranges) }');
      Add('  .debug_pubnames 0 : { *(.debug_pubnames) }');
      Add('  /* DWARF 2 */');
      Add('  .debug_info     0 : { *(.debug_info .gnu.linkonce.wi.*) }');
      Add('  .debug_abbrev   0 : { *(.debug_abbrev) }');
      Add('  .debug_line     0 : { *(.debug_line) }');
      Add('  .debug_frame    0 : { *(.debug_frame) }');
      Add('  .debug_str      0 : { *(.debug_str) }');
      Add('  .debug_loc      0 : { *(.debug_loc) }');
      Add('  .debug_macinfo  0 : { *(.debug_macinfo) }');
      Add('  /* SGI/MIPS DWARF 2 extensions */');
      Add('  .debug_weaknames 0 : { *(.debug_weaknames) }');
      Add('  .debug_funcnames 0 : { *(.debug_funcnames) }');
      Add('  .debug_typenames 0 : { *(.debug_typenames) }');
      Add('  .debug_varnames  0 : { *(.debug_varnames) }');
      Add('  /* DWARF 3 */');
      Add('  .debug_pubtypes 0 : { *(.debug_pubtypes) }');
      Add('  .debug_ranges   0 : { *(.debug_ranges) }');

      Add('}');
      Add('_end = .;');

    end;
  {$endif RISCV32}

  {$ifdef XTENSA}
  with linkres do
    begin
      if current_settings.controllertype = ct_esp32 then
        begin
          Add('SECTIONS');
          Add('{');
          Add('  .data :');
          Add('  {');
          Add('    KEEP (*(.fpc .fpc.n_version .fpc.n_links))');
          Add('  }');
          Add('}');
        end
      else // for ESP8266 use internal linker script
        begin
          Add('/* esp8266_out.ld */');
          Add('MEMORY');
          Add('{');
          Add('  /* All these values assume the flash cache is on, and have the blocks this uses subtracted from the length');
          Add('  of the various regions. */');
          Add('  /* IRAM for cpu. The length is due to the cache mode which is able to be set half or full mode. */');
          Add('  iram0_0_seg (RX) : org = 0x40100000, len = 0xC000');
          Add('  /* Even though the segment name is iram, it is actually mapped to flash and mapped constant data */');
          Add('  iram0_2_seg (RX) : org = 0x40200010 + (0x10000 & (0x100000 - 1)),');
          Add('                                     len = 0xf0000 - 0x10');
          Add('  /*');
          Add('    (0x18 offset above is a convenience for the app binary image generation. The .bin file which is flashed');
          Add('    to the chip has a 0x10 byte file header. Setting this offset makes it simple to meet the flash cache.)');
          Add('  */');
          Add('  /* Length of this section is 96KB */');
          Add('  dram0_0_seg (RW) : org = 0x3FFE8000, len = 0x18000');
          Add('  /* (See iram0_2_seg for meaning of 0x10 offset in the above.) */');
          Add('  /* RTC memory. Persists over deep sleep */');
          Add('  rtc_data_seg(RW) : org = 0x60001200, len = 0x200');
          Add('}');
          Add('/* esp8266.project.ld */');
          Add('/*  Default entry point:  */');
          Add('ENTRY(call_start_cpu);');
          Add('');
          Add('SECTIONS');
          Add('{');
          Add('  /* RTC data section holds RTC wake data/rodata');
          Add('     marked with RTC_DATA_ATTR, RTC_RODATA_ATTR attributes.');
          Add('  */');
          Add('  .rtc.data :');
          Add('  {');
          Add('    _rtc_data_start = ABSOLUTE(.);');
          Add('');
          Add('    *( .rtc.data  .rtc.data.*  .rtc.rodata  .rtc.rodata.*)');
          Add('');
          Add('    _rtc_data_end = ABSOLUTE(.);');
          Add('  } > rtc_data_seg');
          Add('');
          Add('  /* RTC bss */');
          Add('  .rtc.bss (NOLOAD) :');
          Add('  {');
          Add('    _rtc_bss_start = ABSOLUTE(.);');
          Add('    *( .rtc.bss)');
          Add('    _rtc_bss_end = ABSOLUTE(.);');
          Add('  } > rtc_data_seg');
          Add('');
          Add('  /* This section holds data that should not be initialized at power up');
          Add('     and will be retained during deep sleep.');
          Add('     User data marked with RTC_NOINIT_ATTR will be placed');
          Add('     into this section. See the file "esp_attr.h" for more information.');
          Add('  */');
          Add('  .rtc_noinit (NOLOAD):');
          Add('  {');
          Add('    . = ALIGN(4);');
          Add('    _rtc_noinit_start = ABSOLUTE(.);');
          Add('    *(.rtc_noinit .rtc_noinit.*)');
          Add('    . = ALIGN(4) ;');
          Add('    _rtc_noinit_end = ABSOLUTE(.);');
          Add('  } > rtc_data_seg');
          Add('');
          Add('  ASSERT(((_rtc_noinit_end - ORIGIN(rtc_data_seg)) <= LENGTH(rtc_data_seg)), "RTC segment data does not fit.")');
          Add('');
          Add('  /* Send .iram0 code to iram */');
          Add('  .iram0.vectors :');
          Add('  {');
          Add('    _iram_start = ABSOLUTE(.);');
          Add('    /* Vectors go to IRAM */');
          Add('    _init_start = ABSOLUTE(.);');
          Add('    KEEP(*(.SystemInfoVector.text));');
          Add('    . = 0x10;');
          Add('    KEEP(*(.DebugExceptionVector.text));');
          Add('    . = 0x20;');
          Add('    KEEP(*(.NMIExceptionVector.text));');
          Add('    . = 0x30;');
          Add('    KEEP(*(.KernelExceptionVector.text));');
          Add('    . = 0x50;');
          Add('    KEEP(*(.UserExceptionVector.text));');
          Add('    . = 0x70;');
          Add('    KEEP(*(.DoubleExceptionVector.text));');
          Add('');
          Add('    *(.text .literal) ');
          Add('');
          Add('    *(.*Vector.literal)');
          Add('');
          Add('    *(.UserEnter.literal);');
          Add('    *(.UserEnter.text);');
          Add('    . = ALIGN (16);');
          Add('    *(.entry.text)');
          Add('    *(.init.literal)');
          Add('    *(.init)');
          Add('    _init_end = ABSOLUTE(.);');
          Add('  } > iram0_0_seg');
          Add('');
          Add('  .iram0.text :');
          Add('  {');
          Add('    /* Code marked as runnning out of IRAM */');
          Add('    _iram_text_start = ABSOLUTE(.);');
          Add('');
          Add('    *( .iram1  .iram1.*)');
          Add('    *libphy.a:( .literal  .literal.*  .text  .text.*)');
          Add('    *libspi_flash.a:spi_flash_raw.*( .literal  .literal.*  .text  .text.*)');
          Add('    *libpp.a:( .literal  .literal.*  .text  .text.*)');
          Add('');
          Add('    _iram_text_end = ABSOLUTE(.);');
          Add('  } > iram0_0_seg');
          Add('');
          Add('  .iram0.bss :');
          Add('  {');
          Add('    . = ALIGN (4);');
          Add('    /* Code marked as runnning out of IRAM */');
          Add('    _iram_bss_start = ABSOLUTE(.);');
          Add('');
          Add('    *libcore.a:( .bss  .bss.*  COMMON)');
          Add('    *libfreertos.a:freertos_hooks.*( .bss  .bss.*  COMMON)');
          Add('    *libfreertos.a:impure.*( .bss  .bss.*  COMMON)');
          Add('    *libfreertos.a:timers.*( .bss  .bss.*  COMMON)');
          Add('    *libfreertos.a:queue.*( .bss  .bss.*  COMMON)');
          Add('    *libfreertos.a:stream_buffer.*( .bss  .bss.*  COMMON)');
          Add('    *libfreertos.a:event_groups.*( .bss  .bss.*  COMMON)');
          Add('    *libfreertos.a:list.*( .bss  .bss.*  COMMON)');
          Add('    *libfreertos.a:tasks.*( .bss  .bss.*  COMMON)');
          Add('    *liblwip.a:( .bss  .bss.*  COMMON)');
          Add('');
          Add('    . = ALIGN (4);');
          Add('    _iram_bss_end = ABSOLUTE(.);');
          Add('    _iram_end = ABSOLUTE(.);');
          Add('  } > iram0_0_seg');
          Add('');
          Add('  ASSERT(((_iram_end - ORIGIN(iram0_0_seg)) <= LENGTH(iram0_0_seg)), "IRAM0 segment data does not fit.")');
          Add('');
          Add('  .dram0.data :');
          Add('  {');
          Add('    _data_start = ABSOLUTE(.);');
          Add('    *(.gnu.linkonce.d.*)');
          Add('    *(.data1)');
          Add('    *(.sdata)');
          Add('    *(.sdata.*)');
          Add('    *(.gnu.linkonce.s.*)');
          Add('    *(.sdata2)');
          Add('    *(.sdata2.*)');
          Add('    *(.gnu.linkonce.s2.*)');
          Add('    *(.jcr)');
          Add('    *(.dram0 .dram0.*)');
          Add('');
          Add('    *( .data  .data.*  .dram1  .dram1.*)');
          Add('    *libspi_flash.a:spi_flash_raw.*( .rodata  .rodata.*)');
          Add('    *liblog.a:( .rodata  .rodata.*)');
          Add('');
          Add('    _data_end = ABSOLUTE(.);');
          Add('    . = ALIGN(4);');
          Add('  } > dram0_0_seg');
          Add('');
          Add('  /*This section holds data that should not be initialized at power up.');
          Add('    The section located in Internal SRAM memory region. The macro _NOINIT');
          Add('    can be used as attribute to place data into this section.');
          Add('    See the esp_attr.h file for more information.');
          Add('  */');
          Add('  .noinit (NOLOAD):');
          Add('  {');
          Add('    . = ALIGN(4);');
          Add('    _noinit_start = ABSOLUTE(.);');
          Add('    *(.noinit .noinit.*)');
          Add('    . = ALIGN(4) ;');
          Add('    _noinit_end = ABSOLUTE(.);');
          Add('  } > dram0_0_seg');
          Add('');
          Add('  /* Shared RAM */');
          Add('  .dram0.bss (NOLOAD) :');
          Add('  {');
          Add('    . = ALIGN (8);');
          Add('    _bss_start = ABSOLUTE(.);');
          Add('');
          Add('    *(EXCLUDE_FILE(*libcore.a *libfreertos.a:tasks.* *libfreertos.a:list.* *libfreertos.a:event_groups.* *libfreertos.a:stream_buffer.* *libfreertos.a:queue.* *libfreertos.a:timers.* *libfreertos.a:impure.* *libfreertos.a:freertos_hooks.* *liblwip.a) .bss EXCLUDE_FILE(*libcore.a *libfreertos.a:tasks.* *libfreertos.a:list.* *libfreertos.a:event_groups.* *libfreertos.a:stream_buffer.* *libfreertos.a:queue.* *libfreertos.a:timers.* *libfreertos.a:impure.* *libfreertos.a:freertos_hooks.* *liblwip.a) .bss.* EXCLUDE_FILE(*libcore.a *libfreertos.a:tasks.* *libfreertos.a:list.* *libfreertos.a:event_groups.* *libfreertos.a:stream_buffer.* *libfreertos.a:queue.* *libfreertos.a:timers.* *libfreertos.a:impure.* *libfreertos.a:freertos_hooks.* *liblwip.a) COMMON)');
          Add('');
          Add('    *(.dynsbss)');
          Add('    *(.sbss)');
          Add('    *(.sbss.*)');
          Add('    *(.gnu.linkonce.sb.*)');
          Add('    *(.scommon)');
          Add('    *(.sbss2)');
          Add('    *(.sbss2.*)');
          Add('    *(.gnu.linkonce.sb2.*)');
          Add('    *(.dynbss)');
          Add('    *(.share.mem)');
          Add('    *(.gnu.linkonce.b.*)');
          Add('');
          Add('    . = ALIGN (8);');
          Add('    _bss_end = ABSOLUTE(.);');
          Add('  } > dram0_0_seg');
          Add('');
          Add('  ASSERT(((_bss_end - ORIGIN(dram0_0_seg)) <= LENGTH(dram0_0_seg)), "DRAM segment data does not fit.")');
          Add('');
          Add('  .flash.text :');
          Add('  {');
          Add('    _stext = .;');
          Add('    _text_start = ABSOLUTE(.);');
          Add('');
          Add('    *(EXCLUDE_FILE(*libphy.a *libspi_flash.a:spi_flash_raw.* *libpp.a) .literal EXCLUDE_FILE(*libphy.a *libspi_flash.a:spi_flash_raw.* *libpp.a) .literal.* EXCLUDE_FILE(*libphy.a *libspi_flash.a:spi_flash_raw.* *libpp.a) .text EXCLUDE_FILE(*libphy.a *libspi_flash.a:spi_flash_raw.* *libpp.a) .text.*  .wifi0iram  .wifi0iram.*)');
          Add('');
          Add('    /* For ESP8266 library function */');
          Add('    *(.irom0.literal .irom0.text)');
          Add('    *(.irom.literal .irom.text .irom.text.literal)');
          Add('    *(.text2 .text2.* .literal2 .literal2.*)');
          Add('    *(.stub .gnu.warning .gnu.linkonce.literal.* .gnu.linkonce.t.*.literal .gnu.linkonce.t.*)');
          Add('    *(.irom0.text) /* catch stray ICACHE_RODATA_ATTR */');
          Add('    *(.fini.literal)');
          Add('    *(.fini)');
          Add('    *(.gnu.version)');
          Add('    _text_end = ABSOLUTE(.);');
          Add('    _etext = .;');
          Add('');
          Add('    /* Similar to _iram_start, this symbol goes here so it is');
          Add('       resolved by addr2line in preference to the first symbol in');
          Add('       the flash.text segment.');
          Add('    */');
          Add('    _flash_cache_start = ABSOLUTE(0);');
          Add('  } >iram0_2_seg');
          Add('');
          Add('  .flash.rodata ALIGN(4) :');
          Add('  {');
          Add('    _rodata_start = ABSOLUTE(.);');
          Add('   /**');
          Add('      Insert 8 bytes data to make realy rodata section''s link address offset to be 0x8,');
          Add('      esptool will remove these data and add real segment header');
          Add('    */');
          Add('    . = 0x8;');
          Add('    *(.rodata_desc .rodata_desc.*)               /* Should be the first.  App version info.        DO NOT PUT ANYTHING BEFORE IT! */');
          Add('    *(.rodata_custom_desc .rodata_custom_desc.*) /* Should be the second. Custom app version info. DO NOT PUT ANYTHING BEFORE IT! */');
          Add('    *(.rodata2 .rodata2.*)                       /* For ESP8266 library function */');
          Add('    *(EXCLUDE_FILE(*libspi_flash.a:spi_flash_raw.* *liblog.a) .rodata EXCLUDE_FILE(*libspi_flash.a:spi_flash_raw.* *liblog.a) .rodata.*)');
          Add('');
          Add('    *(.irom1.text) /* catch stray ICACHE_RODATA_ATTR */');
          Add('    *(.gnu.linkonce.r.*)');
          Add('    *(.rodata1)');
          Add('    __XT_EXCEPTION_TABLE_ = ABSOLUTE(.);');
          Add('    *(.xt_except_table)');
          Add('    *(.gcc_except_table .gcc_except_table.*)');
          Add('    *(.gnu.linkonce.e.*)');
          Add('    *(.gnu.version_r)');
          Add('    . = (. + 3) & ~ 3;');
          Add('    __eh_frame = ABSOLUTE(.);');
          Add('    KEEP(*(.eh_frame))');
          Add('    . = (. + 7) & ~ 3;');
          Add('    /*  C++ constructor and destructor tables');
          Add('');
          Add('        Make a point of not including anything from crtbegin.o or crtend.o, as IDF doesn''t use toolchain crt');
          Add('      */');
          Add('    __init_array_start = ABSOLUTE(.);');
          Add('    KEEP (*(EXCLUDE_FILE (*crtend.* *crtbegin.*) .ctors .ctors.*))');
          Add('    __init_array_end = ABSOLUTE(.);');
          Add('    KEEP (*crtbegin.*(.dtors))');
          Add('    KEEP (*(EXCLUDE_FILE (*crtend.*) .dtors))');
          Add('    KEEP (*(SORT(.dtors.*)))');
          Add('    KEEP (*(.dtors))');
          Add('    /*  C++ exception handlers table:  */');
          Add('    __XT_EXCEPTION_DESCS_ = ABSOLUTE(.);');
          Add('    *(.xt_except_desc)');
          Add('    *(.gnu.linkonce.h.*)');
          Add('    __XT_EXCEPTION_DESCS_END__ = ABSOLUTE(.);');
          Add('    *(.xt_except_desc_end)');
          Add('    *(.dynamic)');
          Add('    *(.gnu.version_d)');
          Add('    /* Addresses of memory regions reserved via');
          Add('       SOC_RESERVE_MEMORY_REGION() */');
          Add('    soc_reserved_memory_region_start = ABSOLUTE(.);');
          Add('    KEEP (*(.reserved_memory_address))');
          Add('    soc_reserved_memory_region_end = ABSOLUTE(.);');
          Add('    _rodata_end = ABSOLUTE(.);');
          Add('    /* Literals are also RO data. */');
          Add('    _lit4_start = ABSOLUTE(.);');
          Add('    *(*.lit4)');
          Add('    *(.lit4.*)');
          Add('    *(.gnu.linkonce.lit4.*)');
          Add('    _lit4_end = ABSOLUTE(.);');
          Add('    . = ALIGN(4);');
          Add('    _thread_local_start = ABSOLUTE(.);');
          Add('    *(.tdata)');
          Add('    *(.tdata.*)');
          Add('    *(.tbss)');
          Add('    *(.tbss.*)');
          Add('    _thread_local_end = ABSOLUTE(.);');
          Add('    . = ALIGN(4);');
          Add('  } >iram0_2_seg');
          Add('}');
          Add('/* esp8266.rom.ld */');
          Add('PROVIDE ( SPI_sector_erase = 0x400040c0 );');
          Add('PROVIDE ( SPI_page_program = 0x40004174 );');
          Add('PROVIDE ( SPI_read_data = 0x400042ac );');
          Add('PROVIDE ( SPI_read_status = 0x400043c8 );');
          Add('PROVIDE ( SPI_write_status = 0x40004400 );');
          Add('PROVIDE ( SPI_write_enable = 0x4000443c );');
          Add('PROVIDE ( Wait_SPI_Idle = 0x4000448c );');
          Add('PROVIDE ( Enable_QMode = 0x400044c0 );');
          Add('PROVIDE ( Disable_QMode = 0x40004508 );');
          Add('PROVIDE ( Cache_Read_Enable = 0x40004678 );');
          Add('PROVIDE ( Cache_Read_Disable = 0x400047f0 );');
          Add('PROVIDE ( lldesc_build_chain = 0x40004f40 );');
          Add('PROVIDE ( lldesc_num2link = 0x40005050 );');
          Add('PROVIDE ( lldesc_set_owner = 0x4000507c );');
          Add('PROVIDE ( __adddf3 = 0x4000c538 );');
          Add('PROVIDE ( __addsf3 = 0x4000c180 );');
          Add('PROVIDE ( __divdf3 = 0x4000cb94 );');
          Add('PROVIDE ( __divdi3 = 0x4000ce60 );');
          Add('PROVIDE ( __divsi3 = 0x4000dc88 );');
          Add('PROVIDE ( __extendsfdf2 = 0x4000cdfc );');
          Add('PROVIDE ( __fixdfsi = 0x4000ccb8 );');
          Add('PROVIDE ( __fixunsdfsi = 0x4000cd00 );');
          Add('PROVIDE ( __fixunssfsi = 0x4000c4c4 );');
          Add('PROVIDE ( __floatsidf = 0x4000e2f0 );');
          Add('PROVIDE ( __floatsisf = 0x4000e2ac );');
          Add('PROVIDE ( __floatunsidf = 0x4000e2e8 );');
          Add('PROVIDE ( __floatunsisf = 0x4000e2a4 );');
          Add('PROVIDE ( __muldf3 = 0x4000c8f0 );');
          Add('PROVIDE ( __muldi3 = 0x40000650 );');
          Add('PROVIDE ( __mulsf3 = 0x4000c3dc );');
          Add('PROVIDE ( __subdf3 = 0x4000c688 );');
          Add('PROVIDE ( __subsf3 = 0x4000c268 );');
          Add('PROVIDE ( __truncdfsf2 = 0x4000cd5c );');
          Add('PROVIDE ( __udivdi3 = 0x4000d310 );');
          Add('PROVIDE ( __udivsi3 = 0x4000e21c );');
          Add('PROVIDE ( __umoddi3 = 0x4000d770 );');
          Add('PROVIDE ( __umodsi3 = 0x4000e268 );');
          Add('PROVIDE ( __umulsidi3 = 0x4000dcf0 );');
          Add('PROVIDE ( bzero = 0x4000de84 );');
          Add('PROVIDE ( memcmp = 0x4000dea8 );');
          Add('PROVIDE ( memcpy = 0x4000df48 );');
          Add('PROVIDE ( memmove = 0x4000e04c );');
          Add('PROVIDE ( memset = 0x4000e190 );');
          Add('PROVIDE ( strcmp = 0x4000bdc8 );');
          Add('PROVIDE ( strcpy = 0x4000bec8 );');
          Add('PROVIDE ( strlen = 0x4000bf4c );');
          Add('PROVIDE ( strncmp = 0x4000bfa8 );');
          Add('PROVIDE ( strncpy = 0x4000c0a0 );');
          Add('PROVIDE ( strstr = 0x4000e1e0 );');
          Add('PROVIDE ( gpio_input_get = 0x40004cf0 );');
          Add('PROVIDE ( gpio_pin_wakeup_disable = 0x40004ed4 );');
          Add('PROVIDE ( gpio_pin_wakeup_enable = 0x40004e90 );');
          Add('PROVIDE ( ets_io_vprintf = 0x40001f00 );');
          Add('PROVIDE ( uart_rx_one_char = 0x40003b8c );');
          Add('PROVIDE ( rom_i2c_readReg = 0x40007268 );');
          Add('PROVIDE ( rom_i2c_readReg_Mask = 0x4000729c );');
          Add('PROVIDE ( rom_i2c_writeReg = 0x400072d8 );');
          Add('PROVIDE ( rom_i2c_writeReg_Mask = 0x4000730c );');
          Add('PROVIDE ( rom_software_reboot = 0x40000080 );');
          Add('/* esp8266.peripherals.ld */');
          Add('PROVIDE ( GPIO = 0x60000300);');
          Add('PROVIDE ( uart0 = 0x60000000 );');
          Add('PROVIDE ( uart1 = 0x60000f00 );');
          Add('PROVIDE ( frc1 = 0x60000600 );');
          Add('PROVIDE ( rtc_sys_info = 0x60001100 );');
          Add('PROVIDE ( SLC0 = 0x60000B00 );');
          Add('PROVIDE ( I2S0 = 0x60000e00 );');
          Add('PROVIDE ( SPI1 = 0x60000100 );');
          Add('PROVIDE ( SPI0 = 0x60000200 );');
        end;
    end;
{$endif XTENSA}

  { Write and Close response }
  linkres.writetodisk;
  linkres.free;

  WriteResponseFile:=True;

end;


function TlinkerFreeRTOS.MakeExecutable:boolean;
var
  StaticStr,
  S,
  binstr,
  cmdstr,
  mapstr: Ansistring;
  success : boolean;
  GCSectionsStr,
  DynLinkStr,
  StripStr,
  FixedExeFileName: string;
  t: Text;
  hp: TCmdStrListItem;
  filepath: TCmdStr;
begin
  { for future use }
  StaticStr:='';
  StripStr:='';
  mapstr:='';
  DynLinkStr:='';

  success:=true;
  Result:=false;

  if (target_info.system=system_xtensa_freertos) and (current_settings.controllertype = ct_esp32) then
    begin
      { generate a sdkconfig.h if none is provided,
        only a few fields are provided to far }
      if not(Sysutils.FileExists('sdkconfig.h')) then
        begin
          Assign(t,'sdkconfig.h');
          {$push}{$I-}
          Rewrite(t);
          if ioresult<>0 then
            exit;
          writeln(t,'#pragma once');
          if current_settings.controllertype <> ct_esp8266 then
            begin
              writeln(t,'#define CONFIG_APP_BUILD_USE_FLASH_SECTIONS 1');
              writeln(t,'#define CONFIG_BT_RESERVE_DRAM 0x0');
              writeln(t,'#define CONFIG_ESP32_ULP_COPROC_RESERVE_MEM 0');
              writeln(t,'#define CONFIG_ESP32_TRACEMEM_RESERVE_DRAM 0x0');
            end;
          Close(t);
          if ioresult<>0 then
            exit;
          {$pop}
        end;

      { generate an sdkconfig if none is provided,
        this is a dummy so far }
      if not(Sysutils.FileExists('sdkconfig')) then
        begin
          Assign(t,'sdkconfig');
          {$push}{$I-}
          Rewrite(t);
          if ioresult<>0 then
            exit;

          writeln(t);

          Close(t);
          if ioresult<>0 then
            exit;
          {$pop}
        end;

      { generate an Kconfig if none is provided,
        this is a dummy so far }
      if not(Sysutils.FileExists('Kconfig')) then
        begin
          Assign(t,'Kconfig');
          {$push}{$I-}
          Rewrite(t);
          if ioresult<>0 then
            exit;

          writeln(t);

          Close(t);
          if ioresult<>0 then
            exit;
          {$pop}
        end;

      { generate an Kconfig.projbuild if none is provided,
        this is a dummy so far }
      if not(Sysutils.FileExists('Kconfig.projbuild')) then
        begin
          Assign(t,'Kconfig.projbuild');
          {$push}{$I-}
          Rewrite(t);
          if ioresult<>0 then
            exit;

          writeln(t);

          Close(t);
          if ioresult<>0 then
            exit;
          {$pop}
        end;

      { generate an kconfigs.in if none is provided,
        this is a dummy so far }
      if not(Sysutils.FileExists('kconfigs.in')) then
        begin
          Assign(t,'kconfigs.in');
          {$push}{$I-}
          Rewrite(t);
          if ioresult<>0 then
            exit;

          writeln(t);

          Close(t);
          if ioresult<>0 then
            exit;
          {$pop}
        end;

      { generate an kconfigs_projbuild.in if none is provided,
        this is a dummy so far }
      if not(Sysutils.FileExists('kconfigs_projbuild.in')) then
        begin
          Assign(t,'kconfigs_projbuild.in');
          {$push}{$I-}
          Rewrite(t);
          if ioresult<>0 then
            exit;

          writeln(t);

          Close(t);
          if ioresult<>0 then
            exit;
          {$pop}
        end;

      { generate a config.env if none is provided,
        COMPONENT_KCONFIGS and COMPONENT_KCONFIGS_PROJBUILD are dummy fields and might
        be needed to be filed properly }
      if not(Sysutils.FileExists('config.env')) then
        begin
          Assign(t,'config.env');
          {$push}{$I-}
          Rewrite(t);
          if ioresult<>0 then
            exit;

          writeln(t,'{');
          writeln(t,'    "COMPONENT_KCONFIGS": "Kconfig",');
          writeln(t,'    "COMPONENT_KCONFIGS_PROJBUILD": "Kconfig.projbuild",');
          writeln(t,'    "IDF_CMAKE": "y",');
          writeln(t,'    "IDF_TARGET": "esp32",');
          writeln(t,'    "IDF_PATH": "'+GetEnvironmentVariable('IDF_PATH')+'",');
          writeln(t,'    "COMPONENT_KCONFIGS_SOURCE_FILE": "kconfigs.in",');
          writeln(t,'    "COMPONENT_KCONFIGS_PROJBUILD_SOURCE_FILE": "kconfigs_projbuild.in"');
          writeln(t,'}');

          Close(t);
          if ioresult<>0 then
            exit;
          {$pop}
        end;

      { generate ldgen_libraries }
      Assign(t,'ldgen_libraries');
      {$push}{$I-}
      Rewrite(t);
      if ioresult<>0 then
        exit;

      hp:=TCmdStrListItem(StaticLibFiles.First);
      while assigned(hp) do
        begin
          FindLibraryFile(hp.Str,target_info.staticClibprefix,target_info.staticClibext,filepath);
          writeln(t,filepath);
          hp:=TCmdStrListItem(hp.Next);
        end;

      Close(t);
      if ioresult<>0 then
        exit;
      {$pop}

      binstr:='xtensa-esp32-elf-gcc';
      cmdstr:='-C -P -x c -E -o esp32_out.ld -I . $IDF_PATH/components/esp32/ld/esp32.ld';

      Replace(binstr,'$IDF_PATH',maybequoted(GetEnvironmentVariable('IDF_PATH')));
      Replace(cmdstr,'$IDF_PATH',maybequoted(GetEnvironmentVariable('IDF_PATH')));
      success:=DoExec(binstr,cmdstr,true,true);

      { generate linker maps for esp32 }
      binstr:='$IDF_PATH/tools/ldgen/ldgen.py';
      cmdstr:='--config sdkconfig --fragments $IDF_PATH/components/xtensa/linker.lf $IDF_PATH/components/soc/linker.lf $IDF_PATH/components/esp_event/linker.lf '+
        '$IDF_PATH/components/spi_flash/linker.lf $IDF_PATH/components/esp_wifi/linker.lf $IDF_PATH/components/lwip/linker.lf '+
        '$IDF_PATH/components/heap/linker.lf $IDF_PATH/components/esp_ringbuf/linker.lf $IDF_PATH/components/espcoredump/linker.lf $IDF_PATH/components/esp32/linker.lf '+
        '$IDF_PATH/components/esp32/ld/esp32_fragments.lf $IDF_PATH/components/freertos/linker.lf $IDF_PATH/components/newlib/newlib.lf '+
        '$IDF_PATH/components/esp_gdbstub/linker.lf '+
        '--input $IDF_PATH/components/esp32/ld/esp32.project.ld.in --output ./esp32.project.ld --kconfig $IDF_PATH/Kconfig --env-file config.env '+
        '--libraries-file ldgen_libraries --objdump xtensa-esp32-elf-objdump';
      Replace(binstr,'$IDF_PATH',maybequoted(GetEnvironmentVariable('IDF_PATH')));
      Replace(cmdstr,'$IDF_PATH',maybequoted(GetEnvironmentVariable('IDF_PATH')));
      if success and not(cs_link_nolink in current_settings.globalswitches) then
        success:=DoExec(binstr,cmdstr,true,false);
    end
  else  // esp8266
    begin
      Info.ExeCmd[1]:='ld -g $OPT $DYNLINK $STATIC $GCSECTIONS $STRIP $MAP '+
       '-u call_user_start_cpu -u esp_app_desc '+
       '-L /home/christo/xtensa/ESP8266_RTOS_SDK/libs '+
       '-L. -o $EXE -T $RES'; //-T build-linker-script.ld'
    end;

  FixedExeFileName:=maybequoted(ScriptFixFileName(ChangeFileExt(current_module.exefilename,'.elf')));

  GCSectionsStr:='--gc-sections';
  //if not(cs_link_extern in current_settings.globalswitches) then
  if not(cs_link_nolink in current_settings.globalswitches) then
   Message1(exec_i_linking,current_module.exefilename);

  if (cs_link_map in current_settings.globalswitches) then
    mapstr:='-Map '+maybequoted(ChangeFileExt(current_module.exefilename,'.map'));

{ Write used files and libraries }
  WriteResponseFile();

{ Call linker }
  SplitBinCmd(Info.ExeCmd[1],binstr,cmdstr);
  Replace(cmdstr,'$OPT',Info.ExtraOptions);
  if target_info.system=system_xtensa_freertos then
    Replace(cmdstr,'$IDF_PATH',maybequoted(GetEnvironmentVariable('IDF_PATH')));
  if not(cs_link_on_target in current_settings.globalswitches) then
   begin
    Replace(cmdstr,'$EXE',FixedExeFileName);
    Replace(cmdstr,'$RES',(maybequoted(ScriptFixFileName(outputexedir+Info.ResName))));
    Replace(cmdstr,'$STATIC',StaticStr);
    Replace(cmdstr,'$STRIP',StripStr);
    Replace(cmdstr,'$MAP',mapstr);
    Replace(cmdstr,'$GCSECTIONS',GCSectionsStr);
    Replace(cmdstr,'$DYNLINK',DynLinkStr);
   end
  else
   begin
    Replace(cmdstr,'$EXE',FixedExeFileName);
    Replace(cmdstr,'$RES',maybequoted(ScriptFixFileName(outputexedir+Info.ResName)));
    Replace(cmdstr,'$STATIC',StaticStr);
    Replace(cmdstr,'$STRIP',StripStr);
    Replace(cmdstr,'$MAP',mapstr);
    Replace(cmdstr,'$GCSECTIONS',GCSectionsStr);
    Replace(cmdstr,'$DYNLINK',DynLinkStr);
   end;
  if success and not(cs_link_nolink in current_settings.globalswitches) then
    success:=DoExec(FindUtil(utilsprefix+BinStr),cmdstr,true,false);

{ Remove ReponseFile }
  if success and not(cs_link_nolink in current_settings.globalswitches) then
   DeleteFile(outputexedir+Info.ResName);

{ Post process }
  if success and not(cs_link_nolink in current_settings.globalswitches) then
    success:=PostProcessExecutable(FixedExeFileName,false);

  if success and (target_info.system=system_xtensa_freertos) then
    if (current_settings.controllertype = ct_esp32) then
      begin
        binstr:='$IDF_PATH/components/esptool_py/esptool/esptool.py';
        Replace(binstr,'$IDF_PATH',maybequoted(GetEnvironmentVariable('IDF_PATH')));
        success:=DoExec(binstr,'--chip esp32 elf2image --flash_mode dio --flash_freq 40m '+
          '--flash_size '+tostr(embedded_controllers[current_settings.controllertype].flashsize div (1024*1024))+'MB '+
          '--elf-sha256-offset 0xb0 '+
          '-o '+maybequoted(ScriptFixFileName(ChangeFileExt(current_module.exefilename,'.bin')))+' '+
          FixedExeFileName,
          true,false);
      end
    else if (current_settings.controllertype = ct_esp8266) then
      begin
        binstr:='/home/christo/xtensa/ESP8266_RTOS_SDK/components/esptool_py/esptool/esptool.py';
        //Replace(binstr,'$IDF_PATH',maybequoted(GetEnvironmentVariable('IDF_PATH')));
        success:=DoExec(binstr,'--chip esp8266 elf2image --flash_mode dout --flash_freq 40m '+
          '--flash_size '+tostr(embedded_controllers[current_settings.controllertype].flashsize div (1024*1024))+'MB '+
          '--version=3 '+
          '-o '+maybequoted(ScriptFixFileName(ChangeFileExt(current_module.exefilename,'.bin')))+' '+
          FixedExeFileName,
          true,false);
      end
  else
    if success then
      success:=DoExec(FindUtil(utilsprefix+'objcopy'),'-O binary '+
        FixedExeFileName+' '+
        maybequoted(ScriptFixFileName(ChangeFileExt(current_module.exefilename,'.bin'))),true,false);

  MakeExecutable:=success;   { otherwise a recursive call to link method }
end;


function TlinkerFreeRTOS.postprocessexecutable(const fn : string;isdll:boolean):boolean;
  type
    TElf32header=packed record
      magic0123         : longint;
      file_class        : byte;
      data_encoding     : byte;
      file_version      : byte;
      padding           : array[$07..$0f] of byte;

      e_type            : word;
      e_machine         : word;
      e_version         : longint;
      e_entry           : longint;          { entrypoint }
      e_phoff           : longint;          { program header offset }

      e_shoff           : longint;          { sections header offset }
      e_flags           : longint;
      e_ehsize          : word;             { elf header size in bytes }
      e_phentsize       : word;             { size of an entry in the program header array }
      e_phnum           : word;             { 0..e_phnum-1 of entrys }
      e_shentsize       : word;             { size of an entry in sections header array }
      e_shnum           : word;             { 0..e_shnum-1 of entrys }
      e_shstrndx        : word;             { index of string section header }
    end;
    TElf32sechdr=packed record
      sh_name           : longint;
      sh_type           : longint;
      sh_flags          : longint;
      sh_addr           : longint;

      sh_offset         : longint;
      sh_size           : longint;
      sh_link           : longint;
      sh_info           : longint;

      sh_addralign      : longint;
      sh_entsize        : longint;
    end;

  function MayBeSwapHeader(h : telf32header) : telf32header;
    begin
      result:=h;
      if source_info.endian<>target_info.endian then
        with h do
          begin
            result.e_type:=swapendian(e_type);
            result.e_machine:=swapendian(e_machine);
            result.e_version:=swapendian(e_version);
            result.e_entry:=swapendian(e_entry);
            result.e_phoff:=swapendian(e_phoff);
            result.e_shoff:=swapendian(e_shoff);
            result.e_flags:=swapendian(e_flags);
            result.e_ehsize:=swapendian(e_ehsize);
            result.e_phentsize:=swapendian(e_phentsize);
            result.e_phnum:=swapendian(e_phnum);
            result.e_shentsize:=swapendian(e_shentsize);
            result.e_shnum:=swapendian(e_shnum);
            result.e_shstrndx:=swapendian(e_shstrndx);
          end;
    end;

  function MaybeSwapSecHeader(h : telf32sechdr) : telf32sechdr;
    begin
      result:=h;
      if source_info.endian<>target_info.endian then
        with h do
          begin
            result.sh_name:=swapendian(sh_name);
            result.sh_type:=swapendian(sh_type);
            result.sh_flags:=swapendian(sh_flags);
            result.sh_addr:=swapendian(sh_addr);
            result.sh_offset:=swapendian(sh_offset);
            result.sh_size:=swapendian(sh_size);
            result.sh_link:=swapendian(sh_link);
            result.sh_info:=swapendian(sh_info);
            result.sh_addralign:=swapendian(sh_addralign);
            result.sh_entsize:=swapendian(sh_entsize);
          end;
    end;

  var
    f : file;

  function ReadSectionName(pos : longint) : String;
    var
      oldpos : longint;
      c : char;
    begin
      oldpos:=filepos(f);
      seek(f,pos);
      Result:='';
      while true do
        begin
          blockread(f,c,1);
          if c=#0 then
            break;
          Result:=Result+c;
        end;
      seek(f,oldpos);
    end;

  var
    elfheader : TElf32header;
    secheader : TElf32sechdr;
    i : longint;
    stringoffset : longint;
    secname : string;
  begin
    postprocessexecutable:=false;
    { open file }
    assign(f,fn);
    {$push}{$I-}
    reset(f,1);
    if ioresult<>0 then
      Message1(execinfo_f_cant_open_executable,fn);
    { read header }
    blockread(f,elfheader,sizeof(tElf32header));
    elfheader:=MayBeSwapHeader(elfheader);
    seek(f,elfheader.e_shoff);
    { read string section header }
    seek(f,elfheader.e_shoff+sizeof(TElf32sechdr)*elfheader.e_shstrndx);
    blockread(f,secheader,sizeof(secheader));
    secheader:=MaybeSwapSecHeader(secheader);
    stringoffset:=secheader.sh_offset;

    seek(f,elfheader.e_shoff);
    status.datasize:=0;
    for i:=0 to elfheader.e_shnum-1 do
      begin
        blockread(f,secheader,sizeof(secheader));
        secheader:=MaybeSwapSecHeader(secheader);
        secname:=ReadSectionName(stringoffset+secheader.sh_name);
        if secname='.text' then
          begin
            Message1(execinfo_x_codesize,tostr(secheader.sh_size));
            status.codesize:=secheader.sh_size;
          end
        else if secname='.data' then
          begin
            Message1(execinfo_x_initdatasize,tostr(secheader.sh_size));
            inc(status.datasize,secheader.sh_size);
          end
        else if secname='.bss' then
          begin
            Message1(execinfo_x_uninitdatasize,tostr(secheader.sh_size));
            inc(status.datasize,secheader.sh_size);
          end;

      end;
    close(f);
    {$pop}
    if ioresult<>0 then
      ;
    postprocessexecutable:=true;
  end;


{*****************************************************************************
                                     Initialize
*****************************************************************************}

initialization
{$ifdef arm}
  RegisterLinker(ld_freertos,TlinkerFreeRTOS);
  RegisterTarget(system_arm_freertos_info);
{$endif arm}

{$ifdef avr}
  RegisterLinker(ld_freertos,TLinkerEmbedded);
  RegisterTarget(system_avr_embedded_info);
{$endif avr}

{$ifdef i386}
  RegisterLinker(ld_freertos,TLinkerEmbedded);
  RegisterTarget(system_i386_embedded_info);
{$endif i386}

{$ifdef x86_64}
  RegisterLinker(ld_freertos,TLinkerEmbedded);
  RegisterTarget(system_x86_64_embedded_info);
{$endif x86_64}

{$ifdef i8086}
  { no need to register linker ld_embedded, because i8086_embedded uses the
    regular msdos linker. In case a flat binary, relocated for a specific
    segment address is needed (e.g. for a BIOS or a real mode bootloader), it
    can be produced post-compilation with exe2bin or a similar tool. }
  RegisterTarget(system_i8086_embedded_info);
{$endif i8086}

{$ifdef mipsel}
  RegisterLinker(ld_freertos,TLinkerEmbedded);
  RegisterTarget(system_mipsel_embedded_info);
{$endif mipsel}

{$ifdef m68k}
  RegisterLinker(ld_freertos,TLinkerEmbedded);
  RegisterTarget(system_m68k_embedded_info);
{$endif m68k}

{$ifdef riscv32}
  RegisterLinker(ld_freertos,TLinkerEmbedded);
  RegisterTarget(system_riscv32_embedded_info);
{$endif riscv32}

{$ifdef riscv64}
  RegisterLinker(ld_freertos,TLinkerEmbedded);
  RegisterTarget(system_riscv64_embedded_info);
{$endif riscv64}

{$ifdef xtensa}
  RegisterLinker(ld_freertos,TlinkerFreeRTOS);
  RegisterTarget(system_xtensa_freertos_info);
{$endif xtensa}
end.
