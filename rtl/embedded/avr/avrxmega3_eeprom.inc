// EEPROM address as in EEPROM space, starting at 0

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

