// EEPROM address as in EEPROM space, starting at 0

procedure writeEEPROMbyte(const EEPROMaddress: pointer; const val: byte);
var
  oldsreg: byte;
begin
  // Flash writes are unlikely but not impossible for a user program
  // Wait for both EEPROM write enable and SPM enable bits to clear before proceedng
  while (EECR and 2 <> 0) and (SPMCSR and 1 <> 0) do;
  // An interrupt after writing to EEAR or EEDR which changes these two registers would corrupt this code
  oldsreg := avr_save;
  EEAR := word(EEPROMaddress);
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
  EEAR := word(EEPROMaddress);
  EECR := EECR or 1;
  readEEPROMbyte := EEDR;
end;
