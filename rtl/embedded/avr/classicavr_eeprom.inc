// EEPROM address as in EEPROM space, starting at 0

procedure writeEEPROMbyte(const EEPROMaddress: pointer; const val: byte);
begin
  while (EECR and 2 <> 0) and (SPMCSR and 1 <> 0) do;
  EEAR := word(EEPROMaddress);
  EEDR := val;
  EECR := EECR or 4;
  EECR := EECR or 2;
end;

function readEEPROMbyte(const EEPROMaddress: pointer): byte;
begin
  while (EECR and 2 <> 0) do;
  EEAR := word(EEPROMaddress);
  EECR := EECR or 1;
  readEEPROMbyte := EEDR;
end;
