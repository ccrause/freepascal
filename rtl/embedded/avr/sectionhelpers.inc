    {$if declared (NVMCTRL)}
      {$push} {$optimization on}
      procedure writeEEPROMbyte(const EEPROMaddress: pointer; const val: byte);
      begin
        while (NVMCTRL.STATUS and 3 <> 0) do;
        PByte(EEPROMaddress + $1400)^ := val;
        CPU.CCP := $9D;
        // next line MUST finish within 4 clock cycles
        NVMCTRL.CTRLA := 3;
      end;

      // Not required by compiler to read EEPROM
      // Provided for compatibilty of user code with classic AVRs
      function readEEPROMbyte(const EEPROMaddress: pointer): byte;
      begin
        readEEPROMbyte := PByte(EEPROMaddress + $1400)^;
      end;
      {$pop}

    {$elseif declared(EECR)}
      {$push} {$optimization on}
      procedure writeEEPROMbyte(const EEPROMaddress: pointer; const val: byte);
      var
        oldsreg: byte;
      begin
        // Flash writes are unlikely but not impossible for a user program
        // Wait for both EEPROM write enable and SPM enable bits to clear before proceedng
        while (EECR and 2 <> 0) {$if declared(SPMCSR)} and (SPMCSR and 1 <> 0) {$endif declared SPMCSR} do;
        // An interrupt after writing to EEAR or EEDR which changes these two registers would corrupt this code
        oldsreg := avr_save;
        {$if declared(EEAR)}
        EEAR := word(EEPROMaddress);
        {$elseif declared(EEARL)}
        EEARL := byte(EEPROMaddress);
        {$endif EEAR}
        EEDR := val;
        // The next two writes to EECR should not be interrupted
        // as that will break the timing constraint
        EECR := 4;  // EEPROM master write enable
        EECR := 2;  // EEPROM write enable
        avr_restore(oldsreg);
      end;

      function readEEPROMbyte(const EEPROMaddress: pointer): byte;
      begin
        while (EECR and 2 <> 0) do;
        {$if declared(EEAR)}
        EEAR := word(EEPROMaddress);
        {$elseif declared(EEARL)}
        EEARL := byte(EEPROMaddress);
        {$endif EEAR}
        EECR := EECR or 1;
        readEEPROMbyte := EEDR;
      end;
      {$pop}
    {$endif}

    {$if declared (NVMCTRL) or declared(EECR)}
      procedure fpc_shortstr_to_shortstr_eeprom(var res:shortstring; constref sstr: shortstring_eeprom);[public,alias:'FPC_SHORTSTR_TO_SHORTSTR_EEPROM']; compilerproc;
      var
        slen, i : byte;
      begin
        slen:=ord(sstr[0]);

        for i := 0 to slen do
          res[i] := sstr[i];
      end;

      procedure fpc_shortstr_to_shortstr_progmem(var res:shortstring; constref sstr: shortstring_progmem);[public,alias:'FPC_SHORTSTR_TO_SHORTSTR_PROGMEM']; compilerproc;
      var
        slen, i : byte;
      begin
        slen:=ord(sstr[0]);

        for i := 0 to slen do
          res[i] := sstr[i];
      end;

      function fpc_shortstr_copy_from_eeprom(constref s : shortstring_eeprom;index : SizeInt;count : SizeInt): shortstring;[public,alias:'FPC_SHORTSTR_COPY_FROM_EEPROM']; compilerproc;
      var
        i: byte;
      begin
        if count<0 then
         count:=0;
        if index>1 then
         dec(index)
        else
         index:=0;
        if index>ord(s[0]) then
         count:=0
        else
         if count>ord(s[0])-index then
          count:=ord(s[0])-index;

        fpc_shortstr_copy_from_eeprom[0]:=chr(count);
        for i := 1 to count do
          fpc_shortstr_copy_from_eeprom[i] := s[i+index];
      end;

      function fpc_shortstr_copy_from_progmem(constref s : shortstring_progmem;index : SizeInt;count : SizeInt): shortstring;[public,alias:'FPC_SHORTSTR_COPY_FROM_PROGMEM']; compilerproc;
      var
        i: byte;
      begin
        if count<0 then
         count:=0;
        if index>1 then
         dec(index)
        else
         index:=0;
        if index>ord(s[0]) then
         count:=0
        else
         if count>ord(s[0])-index then
          count:=ord(s[0])-index;

        fpc_shortstr_copy_from_progmem[0]:=chr(count);
        for i := 1 to count do
          fpc_shortstr_copy_from_progmem[i] := s[i+index];
      end;

      // Local helpers, also defined in text.inc but not visible
      type
        pointer_progmem = type pointer; section '.progmem';
        pchar_progmem = type pchar; section '.progmem';
        FileFunc = Procedure(var t : TextRec);

      procedure fpc_WriteBuffer(var f:Text;const b: pointer_progmem;len:SizeInt);
      var
        p   : pchar_progmem;
        left,
        idx, i : SizeInt;
      begin
        p:=pchar_progmem(b);
        idx:=0;
        left:=TextRec(f).BufSize-TextRec(f).BufPos;
        while len>left do
         begin
           //move(p[idx],TextRec(f).Bufptr^[TextRec(f).BufPos],left);
           for i := 0 to left-1 do
             TextRec(f).Bufptr^[TextRec(f).BufPos+i] := char(p[idx+i]);
           dec(len,left);
           inc(idx,left);
           inc(TextRec(f).BufPos,left);
           FileFunc(TextRec(f).InOutFunc)(TextRec(f));
           left:=TextRec(f).BufSize-TextRec(f).BufPos;
         end;
        //move(p[idx],TextRec(f).Bufptr^[TextRec(f).BufPos],len);
        for i := 0 to len-1 do
          TextRec(f).Bufptr^[TextRec(f).BufPos+i] := char(p[idx+i]);
        inc(TextRec(f).BufPos,len);
      end;


      Procedure fpc_WriteBlanks(var f:Text;len:longint);
      var
        left : longint;
      begin
        left:=TextRec(f).BufSize-TextRec(f).BufPos;
        while len>left do
         begin
           FillChar(TextRec(f).Bufptr^[TextRec(f).BufPos],left,' ');
           dec(len,left);
           inc(TextRec(f).BufPos,left);
           FileFunc(TextRec(f).InOutFunc)(TextRec(f));
           left:=TextRec(f).BufSize-TextRec(f).BufPos;
         end;
        FillChar(TextRec(f).Bufptr^[TextRec(f).BufPos],len,' ');
        inc(TextRec(f).BufPos,len);
      end;


      procedure fpc_write_text_shortstr_progmem(Len : longint;var f : text;constref s : shortstring_progmem); compilerproc;
      begin
        if (InOutRes<>0) then
         exit;
        case TextRec(f).mode of
          fmOutput { fmAppend gets changed to fmOutPut in do_open (JM) }:
            begin
              if Len>Length(s) then
                fpc_WriteBlanks(f,Len-Length(s));
              fpc_WriteBuffer(f,pointer_progmem(@s[1]),Length(s));
            end;
          fmInput: InOutRes:=105
          else InOutRes:=103;
        end;
      end;

    {$endif}


