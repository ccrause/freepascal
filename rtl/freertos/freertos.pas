{$MODE objfpc}
{$MODESWITCH OUT}
{$H+}

unit freertos;

interface

type
  // Only used to access errno which is first field of record
  TDummyReentryRecord = record
    errno: integer;
  end;
  PReentryRecord = ^TDummyReentryRecord;

const
  portTICK_PERIOD_MS = 10;  // Configurable in ESP-IDF, assume default value

procedure vTaskDelay(xTicksToDelay: uint16); external;
function __getreent: PReentryRecord; external;

implementation


end.

