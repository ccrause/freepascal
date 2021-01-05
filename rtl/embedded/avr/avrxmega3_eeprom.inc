// EEPROM address as in EEPROM space, starting at 0

procedure writeEEPROMbyte(const EEPROMaddress: pointer; const val: byte);
begin
  while (NVMCTRL.STATUS and 3 <> 0) do;
  PByte(EEPROMaddress + $1400)^ := val;
  CPU.CCP := $9D;
  // next line MUST finish within 4 clock cycles
  NVMCTRL.CTRLA := 3;
end;

function readEEPROMbyte(const EEPROMaddress: pointer): byte;
begin
  readEEPROMbyte := PByte(EEPROMaddress + $1400)^;
end;

