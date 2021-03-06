{ %cpu=avr }
{ %target=embedded }
{ %fail }

program t_failtypealias;

{ A type alias overwrites the original type definition so is not allowed }

type
  Byte_e = Byte; section '.eeprom';

begin
end.
