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

    {$if declared(EECR)}
      {$mode objfpc}

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

      procedure fpc_shortstr_concat_progmem(var dests:shortstring;const s1:shortstring; constref s2:shortstring_progmem);[public,alias:'FPC_SHORTSTR_CONCAT_PROGMEM']; compilerproc;
      var
        s1l, s2l, i: byte;
      begin
        s1l:=length(s1);
        s2l:=length(s2);
        if s1l+s2l>high(dests) then
          begin
            if s1l>high(dests) then
              s1l:=high(dests);
            s2l:=high(dests)-s1l;
          end;
        if @dests=@s1 then
          begin
            for i := 1 to s2l do
              dests[s1l+i]:=s2[i];
          end
        // Only cater for assignment to normal variable not in section
        //else
        //  if @dests=@s2 then
        //    begin
        //      fpc_shortstr_shortstr_intern_charmove(dests,1,dests,s1l+1,s2l);
        //      fpc_shortstr_shortstr_intern_charmove(s1,1,dests,1,s1l);
        //    end
        else
          begin
            for i := 1 to s1l do
              dests[i]:=s1[i];

            for i := 1 to s2l do
              dests[s1l+i]:=s2[i];
          end;
        dests[0]:=chr(s1l+s2l);
      end;

      procedure fpc_shortstr_concat_progmem_progmem(var dests:shortstring;constref s1, s2:shortstring_progmem);[public,alias:'FPC_SHORTSTR_CONCAT_PROGMEM_PROGMEM']; compilerproc;
      var
        s1l, s2l, i: byte;
      begin
        s1l:=length(s1);
        s2l:=length(s2);
        if s1l+s2l>high(dests) then
          begin
            if s1l>high(dests) then
              s1l:=high(dests);
            s2l:=high(dests)-s1l;
          end;
        if @dests=@s1 then
          begin
            for i := 1 to s2l do
              dests[s1l+i]:=s2[i];
          end
        // Only cater for assignment to normal variable not in section
        //else
        //  if @dests=@s2 then
        //    begin
        //      fpc_shortstr_shortstr_intern_charmove(dests,1,dests,s1l+1,s2l);
        //      fpc_shortstr_shortstr_intern_charmove(s1,1,dests,1,s1l);
        //    end
        else
          begin
            for i := 1 to s1l do
              dests[i]:=s1[i];

            for i := 1 to s2l do
              dests[s1l+i]:=s2[i];
          end;
        dests[0]:=chr(s1l+s2l);
      end;

procedure fpc_shortstr_concat_eeprom(var dests:shortstring;const s1:shortstring; constref s2:shortstring_eeprom);[public,alias:'FPC_SHORTSTR_CONCAT_EEPROM']; compilerproc;
      var
        s1l, s2l, i: byte;
      begin
        s1l:=length(s1);
        s2l:=length(s2);
        if s1l+s2l>high(dests) then
          begin
            if s1l>high(dests) then
              s1l:=high(dests);
            s2l:=high(dests)-s1l;
          end;
        if @dests=@s1 then
          begin
            for i := 1 to s2l do
              dests[s1l+i]:=s2[i];
          end
        // Only cater for assignment to normal variable not in section
        //else
        //  if @dests=@s2 then
        //    begin
        //      fpc_shortstr_shortstr_intern_charmove(dests,1,dests,s1l+1,s2l);
        //      fpc_shortstr_shortstr_intern_charmove(s1,1,dests,1,s1l);
        //    end
        else
          begin
            for i := 1 to s1l do
              dests[i]:=s1[i];

            for i := 1 to s2l do
              dests[s1l+i]:=s2[i];
          end;
        dests[0]:=chr(s1l+s2l);
      end;

      procedure fpc_shortstr_concat_eeprom_eeprom(var dests:shortstring;constref s1, s2:shortstring_eeprom);[public,alias:'FPC_SHORTSTR_CONCAT_EEPROM_EEPROM']; compilerproc;
      var
        s1l, s2l, i: byte;
      begin
        s1l:=length(s1);
        s2l:=length(s2);
        if s1l+s2l>high(dests) then
          begin
            if s1l>high(dests) then
              s1l:=high(dests);
            s2l:=high(dests)-s1l;
          end;
        if @dests=@s1 then
          begin
            for i := 1 to s2l do
              dests[s1l+i]:=s2[i];
          end
        // Only cater for assignment to normal variable not in section
        //else
        //  if @dests=@s2 then
        //    begin
        //      fpc_shortstr_shortstr_intern_charmove(dests,1,dests,s1l+1,s2l);
        //      fpc_shortstr_shortstr_intern_charmove(s1,1,dests,1,s1l);
        //    end
        else
          begin
            for i := 1 to s1l do
              dests[i]:=s1[i];

            for i := 1 to s2l do
              dests[s1l+i]:=s2[i];
          end;
        dests[0]:=chr(s1l+s2l);
      end;

      function fpc_shortstr_compare_equal_progmem(const left:shortstring; constref right: shortstring_progmem): longint; [public,alias:'FPC_SHORTSTR_COMPARE_EQUAL_PROGMEM']; compilerproc;
      var
        i: byte;
      begin
        fpc_shortstr_compare_equal_progmem := byte(left[0]) - byte(right[0]);
        if fpc_shortstr_compare_equal_progmem = 0 then
          begin
            //Result := CompareByte(left[1],right[1], ObjpasInt(left[0]));
            i := 0;
            while (i < length(left)) and (left[i] = right[i]) do
              inc(i);

            fpc_shortstr_compare_equal_progmem := byte(left[i]) - byte(right[i]);
          end;
      end;

      function fpc_shortstr_compare_equal_eeprom(const left:shortstring; constref right: shortstring_eeprom): longint; [public,alias:'FPC_SHORTSTR_COMPARE_EQUAL_EEPROM']; compilerproc;
      var
        i: byte;
      begin
        fpc_shortstr_compare_equal_eeprom := byte(left[0]) - byte(right[0]);
        if fpc_shortstr_compare_equal_eeprom = 0 then
          begin
            i := 0;
            while (i < length(left)) and (left[i] = right[i]) do
              inc(i);

            fpc_shortstr_compare_equal_eeprom := byte(left[i]) - byte(right[i]);
          end;
      end;

      function IndexByte_progmem(Const buf: pointer_progmem;len:SizeInt;b:byte):SizeInt;
      var
        psrc,pend : pbyte_progmem;
      begin
        psrc:=buf;
        { simulate assembler implementations behaviour, which is expected }
        { fpc_pchar_to_ansistr in astrings.inc                            }
        if (len < 0) or
           (psrc+len < psrc) then
          pend:=pbyte_progmem(high(PtrUInt)-sizeof(byte))
        else
          pend:=psrc+len;
        while (psrc<pend) do
          begin
            if psrc^=b then
              begin
                IndexByte_progmem:=psrc-pbyte_progmem(buf);
                exit;
              end;
            inc(psrc);
          end;
        IndexByte_progmem:=-1;
      end;

      function IndexByte_eeprom(Const buf: pointer_eeprom;len:SizeInt;b:byte):SizeInt;
      var
        psrc,pend : pbyte_eeprom;
      begin
        psrc:=buf;
        { simulate assembler implementations behaviour, which is expected }
        { fpc_pchar_to_ansistr in astrings.inc                            }
        if (len < 0) or
           (psrc+len < psrc) then
          pend:=pbyte_eeprom(high(PtrUInt)-sizeof(byte))
        else
          pend:=psrc+len;
        while (psrc<pend) do
          begin
            if psrc^=b then
              begin
                IndexByte_eeprom:=psrc-pbyte_eeprom(buf);
                exit;
              end;
            inc(psrc);
          end;
        IndexByte_eeprom:=-1;
      end;

      procedure fpc_chararray_to_shortstr_progmem(var res: shortstring; const arr: array of char_progmem; zerobased: boolean{ = true}); [public,alias:'FPC_CHARARRAY_TO_SHORTSTR_PROGMEM']; compilerproc;
      var
        l, index, len, i: integer;
      begin
        l:=high(arr)+1;
        if l>=high(res)+1 then
          l:=high(res)
        else if l<0 then
          l:=0;
        if zerobased then
          begin
            index:=IndexByte_progmem(pointer_progmem(@arr[0]),l,0);
            if index<0 then
              len:=l
            else
              len:=index;
          end
        else
          len:=l;

        //move(arr[0],res[1],len);
        for i := 1 to len do
          res[i] := arr[i-1];

        res[0]:=chr(len);
      end;

      procedure fpc_chararray_to_shortstr_eeprom(var res: shortstring; const arr: array of char_eeprom; zerobased: boolean{ = true}); [public,alias:'FPC_CHARARRAY_TO_SHORTSTR_EEPROM']; compilerproc;
      var
        l, index, len, i: integer;
      begin
        l:=high(arr)+1;
        if l>=high(res)+1 then
          l:=high(res)
        else if l<0 then
          l:=0;
        if zerobased then
          begin
            index:=IndexByte_eeprom(pointer_eeprom(@arr[0]),l,0);
            if index<0 then
              len:=l
            else
              len:=index;
          end
        else
          len:=l;

        //move(arr[0],res[1],len);
        for i := 1 to len do
          res[i] := arr[i-1];

        res[0]:=chr(len);
      end;

      type
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

      procedure fpc_WriteBuffer(var f:Text;const b: pointer_eeprom;len:SizeInt);
      var
        p   : pchar_eeprom;
        left,
        idx, i : SizeInt;
      begin
        p:=pchar_eeprom(b);
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

      procedure fpc_write_text_shortstr_progmem(Len : longint;var f : text;constref s : shortstring_progmem); [public,alias:'FPC_WRITE_TEXT_SHORTSTR_PROGMEM']; compilerproc;
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

      procedure fpc_write_text_shortstr_eeprom(Len : longint;var f : text;constref s : shortstring_eeprom); [public,alias:'FPC_WRITE_TEXT_SHORTSTR_EEPROM']; compilerproc;
      begin
        if (InOutRes<>0) then
         exit;
        case TextRec(f).mode of
          fmOutput { fmAppend gets changed to fmOutPut in do_open (JM) }:
            begin
              if Len>Length(s) then
                fpc_WriteBlanks(f,Len-Length(s));
              fpc_WriteBuffer(f,pointer_eeprom(@s[1]),Length(s));
            end;
          fmInput: InOutRes:=105
          else InOutRes:=103;
        end;
      end;

      procedure fpc_write_text_pchar_as_array_progmem(Len : longint;var f: Text; const s: array of char_progmem; zerobased: boolean{ = true}); iocheck;  [public,alias:'FPC_WRITE_TEXT_PCHAR_AS_ARRAY_PROGMEM']; compilerproc;
      var
        ArrayLen : longint;
        p : pchar_progmem;
      Begin
        If (InOutRes<>0) then
         exit;
        case TextRec(f).mode of
          fmOutput { fmAppend gets changed to fmOutPut in do_open (JM) }:
            begin
              p:=pchar_progmem(@s);
              if zerobased then
                begin
                  { can't use StrLen, since that one could try to read past the end }
                  { of the heap (JM)                                                }
                  ArrayLen:=IndexByte_progmem(pbyte_progmem(p),high(s)+1,0);
                  { IndexByte returns -1 if not found (JM) }
                  if ArrayLen = -1 then
                    ArrayLen := high(s)+1;
                end
              else
                ArrayLen := high(s)+1;
              If Len>ArrayLen Then
                fpc_WriteBlanks(f,Len-ArrayLen);
              fpc_WriteBuffer(f,p,ArrayLen);
            end;
          fmInput: InOutRes:=105
          else InOutRes:=103;
        end;
      End;

      procedure fpc_write_text_pchar_as_array_eeprom(Len : longint;var f: Text; const s: array of char_eeprom; zerobased: boolean{ = true}); iocheck;  [public,alias:'FPC_WRITE_TEXT_PCHAR_AS_ARRAY_EEPROM']; compilerproc;
      var
        ArrayLen : longint;
        p : pchar_eeprom;
      Begin
        If (InOutRes<>0) then
         exit;
        case TextRec(f).mode of
          fmOutput { fmAppend gets changed to fmOutPut in do_open (JM) }:
            begin
              p:=pchar_eeprom(@s);
              if zerobased then
                begin
                  { can't use StrLen, since that one could try to read past the end }
                  { of the heap (JM)                                                }
                  ArrayLen:=IndexByte_eeprom(pbyte_eeprom(p),high(s)+1,0);
                  { IndexByte returns -1 if not found (JM) }
                  if ArrayLen = -1 then
                    ArrayLen := high(s)+1;
                end
              else
                ArrayLen := high(s)+1;
              If Len>ArrayLen Then
                fpc_WriteBlanks(f,Len-ArrayLen);
              fpc_WriteBuffer(f,p,ArrayLen);
            end;
          fmInput: InOutRes:=105
          else InOutRes:=103;
        end;
      End;

      // sstrings.inc
      function fpc_shortstr_copy_progmem(constref s : shortstring_progmem;index : SizeInt;count : SizeInt): shortstring; [public,alias:'FPC_SHORTSTR_COPY_PROGMEM']; compilerproc;
      var
        i: byte;
      begin
        if count<0 then
          count:=0;
        if index>1 then
          dec(index)
        else
          index:=0;
        if index>length(s) then
          count:=0
        else if count>length(s)-index then
          count:=length(s)-index;
        fpc_shortstr_copy_progmem[0]:=chr(Count);

        for i := 1 to count do
          fpc_shortstr_copy_progmem[i] := s[i+index];
      end;

      function fpc_shortstr_copy_eeprom(constref s : shortstring_eeprom;index : SizeInt;count : SizeInt): shortstring; [public,alias:'FPC_SHORTSTR_COPY_EEPROM']; compilerproc;
      var
        i: byte;
      begin
        if count<0 then
          count:=0;
        if index>1 then
          dec(index)
        else
          index:=0;
        if index>length(s) then
          count:=0
        else if count>length(s)-index then
          count:=length(s)-index;
        fpc_shortstr_copy_eeprom[0]:=chr(Count);

        for i := 1 to count do
          fpc_shortstr_copy_eeprom[i] := s[i+index];
      end;

    {$endif}
