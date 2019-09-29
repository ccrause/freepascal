unit ATmega809;

{$goto on}
interface

type
  TAC = object //Analog Comparator
    CTRLA: byte;  //Control A
    Reserved1: byte;
    MUXCTRLA: byte;  //Mux Control A
    Reserved3: byte;
    DACREF: byte;  //Referance scale control
    Reserved5: byte;
    INTCTRL: byte;  //Interrupt Control
    STATUS: byte;  //Status
  const
    ENABLEidx = $00;  ENABLEbm = $01;  // Enable
    HYSMODE0idx = $01;  // Hysteresis Mode
    HYSMODE1idx = $02;  // Hysteresis Mode
    INTMODE0idx = $04;  // Interrupt Mode
    INTMODE1idx = $05;  // Interrupt Mode
    LPMODEidx = $03;  LPMODEbm = $08;  // Low Power Mode
    OUTENidx = $06;  OUTENbm = $40;  // Output Buffer Enable
    RUNSTDBYidx = $07;  RUNSTDBYbm = $80;  // Run in Standby Mode
    DATA0idx = $00;  // DAC voltage reference
    DATA1idx = $01;  // DAC voltage reference
    DATA2idx = $02;  // DAC voltage reference
    DATA3idx = $03;  // DAC voltage reference
    DATA4idx = $04;  // DAC voltage reference
    DATA5idx = $05;  // DAC voltage reference
    DATA6idx = $06;  // DAC voltage reference
    DATA7idx = $07;  // DAC voltage reference
    CMPidx = $00;  CMPbm = $01;  // Analog Comparator 0 Interrupt Enable
    INVERTidx = $07;  INVERTbm = $80;  // Invert AC Output
    MUXNEG0idx = $00;  // Negative Input MUX Selection
    MUXNEG1idx = $01;  // Negative Input MUX Selection
    MUXPOS0idx = $03;  // Positive Input MUX Selection
    MUXPOS1idx = $04;  // Positive Input MUX Selection
    STATEidx = $04;  STATEbm = $10;  // Analog Comparator State
  end;

  TADC = object //Analog to Digital Converter
    CTRLA: byte;  //Control A
    CTRLB: byte;  //Control B
    CTRLC: byte;  //Control C
    CTRLD: byte;  //Control D
    CTRLE: byte;  //Control E
    SAMPCTRL: byte;  //Sample Control
    MUXPOS: byte;  //Positive mux input
    Reserved7: byte;
    COMMAND: byte;  //Command
    EVCTRL: byte;  //Event Control
    INTCTRL: byte;  //Interrupt Control
    INTFLAGS: byte;  //Interrupt Flags
    DBGCTRL: byte;  //Debug Control
    TEMP: byte;  //Temporary Data
    Reserved14: byte;
    Reserved15: byte;
    RES: word;  //ADC Accumulator Result
    WINLT: word;  //Window comparator low threshold
    WINHT: word;  //Window comparator high threshold
    CALIB: byte;  //Calibration
  const
    DUTYCYCidx = $00;  DUTYCYCbm = $01;  // Duty Cycle
    STCONVidx = $00;  STCONVbm = $01;  // Start Conversion Operation
    ENABLEidx = $00;  ENABLEbm = $01;  // ADC Enable
    FREERUNidx = $01;  FREERUNbm = $02;  // ADC Freerun mode
    RESSELidx = $02;  RESSELbm = $04;  // ADC Resolution
    RUNSTBYidx = $07;  RUNSTBYbm = $80;  // Run standby mode
    SAMPNUM0idx = $00;  // Accumulation Samples
    SAMPNUM1idx = $01;  // Accumulation Samples
    SAMPNUM2idx = $02;  // Accumulation Samples
    PRESC0idx = $00;  // Clock Pre-scaler
    PRESC1idx = $01;  // Clock Pre-scaler
    PRESC2idx = $02;  // Clock Pre-scaler
    REFSEL0idx = $04;  // Reference Selection
    REFSEL1idx = $05;  // Reference Selection
    SAMPCAPidx = $06;  SAMPCAPbm = $40;  // Sample Capacitance Selection
    ASDVidx = $04;  ASDVbm = $10;  // Automatic Sampling Delay Variation
    INITDLY0idx = $05;  // Initial Delay Selection
    INITDLY1idx = $06;  // Initial Delay Selection
    INITDLY2idx = $07;  // Initial Delay Selection
    SAMPDLY0idx = $00;  // Sampling Delay Selection
    SAMPDLY1idx = $01;  // Sampling Delay Selection
    SAMPDLY2idx = $02;  // Sampling Delay Selection
    SAMPDLY3idx = $03;  // Sampling Delay Selection
    WINCM0idx = $00;  // Window Comparator Mode
    WINCM1idx = $01;  // Window Comparator Mode
    WINCM2idx = $02;  // Window Comparator Mode
    DBGRUNidx = $00;  DBGRUNbm = $01;  // Debug run
    STARTEIidx = $00;  STARTEIbm = $01;  // Start Event Input Enable
    RESRDYidx = $00;  RESRDYbm = $01;  // Result Ready Interrupt Enable
    WCMPidx = $01;  WCMPbm = $02;  // Window Comparator Interrupt Enable
    MUXPOS0idx = $00;  // Analog Channel Selection Bits
    MUXPOS1idx = $01;  // Analog Channel Selection Bits
    MUXPOS2idx = $02;  // Analog Channel Selection Bits
    MUXPOS3idx = $03;  // Analog Channel Selection Bits
    MUXPOS4idx = $04;  // Analog Channel Selection Bits
    SAMPLEN0idx = $00;  // Sample lenght
    SAMPLEN1idx = $01;  // Sample lenght
    SAMPLEN2idx = $02;  // Sample lenght
    SAMPLEN3idx = $03;  // Sample lenght
    SAMPLEN4idx = $04;  // Sample lenght
    TEMP0idx = $00;  // Temporary
    TEMP1idx = $01;  // Temporary
    TEMP2idx = $02;  // Temporary
    TEMP3idx = $03;  // Temporary
    TEMP4idx = $04;  // Temporary
    TEMP5idx = $05;  // Temporary
    TEMP6idx = $06;  // Temporary
    TEMP7idx = $07;  // Temporary
  end;

  TBOD = object //Bod interface
    CTRLA: byte;  //Control A
    CTRLB: byte;  //Control B
    Reserved2: byte;
    Reserved3: byte;
    Reserved4: byte;
    Reserved5: byte;
    Reserved6: byte;
    Reserved7: byte;
    VLMCTRLA: byte;  //Voltage level monitor Control
    INTCTRL: byte;  //Voltage level monitor interrupt Control
    INTFLAGS: byte;  //Voltage level monitor interrupt Flags
    STATUS: byte;  //Voltage level monitor status
  const
    ACTIVE0idx = $02;  // Operation in active mode
    ACTIVE1idx = $03;  // Operation in active mode
    SAMPFREQidx = $04;  SAMPFREQbm = $10;  // Sample frequency
    SLEEP0idx = $00;  // Operation in sleep mode
    SLEEP1idx = $01;  // Operation in sleep mode
    LVL0idx = $00;  // Bod level
    LVL1idx = $01;  // Bod level
    LVL2idx = $02;  // Bod level
    VLMCFG0idx = $01;  // Configuration
    VLMCFG1idx = $02;  // Configuration
    VLMIEidx = $00;  VLMIEbm = $01;  // voltage level monitor interrrupt enable
    VLMIFidx = $00;  VLMIFbm = $01;  // Voltage level monitor interrupt flag
    VLMSidx = $00;  VLMSbm = $01;  // Voltage level monitor status
    VLMLVL0idx = $00;  // voltage level monitor level
    VLMLVL1idx = $01;  // voltage level monitor level
  end;

  TCCL = object //Configurable Custom Logic
    CTRLA: byte;  //Control Register A
    SEQCTRL0: byte;  //Sequential Control 0
    SEQCTRL1: byte;  //Sequential Control 1
    Reserved3: byte;
    Reserved4: byte;
    INTCTRL0: byte;  //Interrupt Control 0
    Reserved6: byte;
    INTFLAGS: byte;  //Interrupt Flags
    LUT0CTRLA: byte;  //LUT Control 0 A
    LUT0CTRLB: byte;  //LUT Control 0 B
    LUT0CTRLC: byte;  //LUT Control 0 C
    TRUTH0: byte;  //Truth 0
    LUT1CTRLA: byte;  //LUT Control 1 A
    LUT1CTRLB: byte;  //LUT Control 1 B
    LUT1CTRLC: byte;  //LUT Control 1 C
    TRUTH1: byte;  //Truth 1
    LUT2CTRLA: byte;  //LUT Control 2 A
    LUT2CTRLB: byte;  //LUT Control 2 B
    LUT2CTRLC: byte;  //LUT Control 2 C
    TRUTH2: byte;  //Truth 2
    LUT3CTRLA: byte;  //LUT Control 3 A
    LUT3CTRLB: byte;  //LUT Control 3 B
    LUT3CTRLC: byte;  //LUT Control 3 C
    TRUTH3: byte;  //Truth 3
  const
    ENABLEidx = $00;  ENABLEbm = $01;  // Enable
    RUNSTDBYidx = $06;  RUNSTDBYbm = $40;  // Run in Standby
    INTMODE00idx = $00;  // Interrupt Mode for LUT0
    INTMODE01idx = $01;  // Interrupt Mode for LUT0
    INTMODE10idx = $02;  // Interrupt Mode for LUT1
    INTMODE11idx = $03;  // Interrupt Mode for LUT1
    INTMODE20idx = $04;  // Interrupt Mode for LUT2
    INTMODE21idx = $05;  // Interrupt Mode for LUT2
    INTMODE30idx = $06;  // Interrupt Mode for LUT3
    INTMODE31idx = $07;  // Interrupt Mode for LUT3
    INT0idx = $00;  // Interrupt Flags
    INT1idx = $01;  // Interrupt Flags
    INT2idx = $02;  // Interrupt Flags
    INT3idx = $03;  // Interrupt Flags
    CLKSRC0idx = $01;  // Clock Source Selection
    CLKSRC1idx = $02;  // Clock Source Selection
    CLKSRC2idx = $03;  // Clock Source Selection
    EDGEDETidx = $07;  EDGEDETbm = $80;  // Edge Detection Enable
    FILTSEL0idx = $04;  // Filter Selection
    FILTSEL1idx = $05;  // Filter Selection
    OUTENidx = $06;  OUTENbm = $40;  // Output Enable
    INSEL00idx = $00;  // LUT Input 0 Source Selection
    INSEL01idx = $01;  // LUT Input 0 Source Selection
    INSEL02idx = $02;  // LUT Input 0 Source Selection
    INSEL03idx = $03;  // LUT Input 0 Source Selection
    INSEL10idx = $04;  // LUT Input 1 Source Selection
    INSEL11idx = $05;  // LUT Input 1 Source Selection
    INSEL12idx = $06;  // LUT Input 1 Source Selection
    INSEL13idx = $07;  // LUT Input 1 Source Selection
    INSEL20idx = $00;  // LUT Input 2 Source Selection
    INSEL21idx = $01;  // LUT Input 2 Source Selection
    INSEL22idx = $02;  // LUT Input 2 Source Selection
    INSEL23idx = $03;  // LUT Input 2 Source Selection
    SEQSEL00idx = $00;  // Sequential Selection
    SEQSEL01idx = $01;  // Sequential Selection
    SEQSEL02idx = $02;  // Sequential Selection
    SEQSEL10idx = $00;  // Sequential Selection
    SEQSEL11idx = $01;  // Sequential Selection
    SEQSEL12idx = $02;  // Sequential Selection
  end;

  TCLKCTRL = object //Clock controller
    MCLKCTRLA: byte;  //MCLK Control A
    MCLKCTRLB: byte;  //MCLK Control B
    MCLKLOCK: byte;  //MCLK Lock
    MCLKSTATUS: byte;  //MCLK Status
    Reserved4: byte;
    Reserved5: byte;
    Reserved6: byte;
    Reserved7: byte;
    Reserved8: byte;
    Reserved9: byte;
    Reserved10: byte;
    Reserved11: byte;
    Reserved12: byte;
    Reserved13: byte;
    Reserved14: byte;
    Reserved15: byte;
    OSC20MCTRLA: byte;  //OSC20M Control A
    OSC20MCALIBA: byte;  //OSC20M Calibration A
    OSC20MCALIBB: byte;  //OSC20M Calibration B
    Reserved19: byte;
    Reserved20: byte;
    Reserved21: byte;
    Reserved22: byte;
    Reserved23: byte;
    OSC32KCTRLA: byte;  //OSC32K Control A
    Reserved25: byte;
    Reserved26: byte;
    Reserved27: byte;
    XOSC32KCTRLA: byte;  //XOSC32K Control A
  const
    CLKOUTidx = $07;  CLKOUTbm = $80;  // System clock out
    CLKSEL0idx = $00;  // clock select
    CLKSEL1idx = $01;  // clock select
    PDIV0idx = $01;  // Prescaler division
    PDIV1idx = $02;  // Prescaler division
    PDIV2idx = $03;  // Prescaler division
    PDIV3idx = $04;  // Prescaler division
    PENidx = $00;  PENbm = $01;  // Prescaler enable
    LOCKENidx = $00;  LOCKENbm = $01;  // lock ebable
    EXTSidx = $07;  EXTSbm = $80;  // External Clock status
    OSC20MSidx = $04;  OSC20MSbm = $10;  // 20MHz oscillator status
    OSC32KSidx = $05;  OSC32KSbm = $20;  // 32KHz oscillator status
    SOSCidx = $00;  SOSCbm = $01;  // System Oscillator changing
    XOSC32KSidx = $06;  XOSC32KSbm = $40;  // 32.768 kHz Crystal Oscillator status
    CAL20M0idx = $00;  // Calibration
    CAL20M1idx = $01;  // Calibration
    CAL20M2idx = $02;  // Calibration
    CAL20M3idx = $03;  // Calibration
    CAL20M4idx = $04;  // Calibration
    CAL20M5idx = $05;  // Calibration
    CAL20M6idx = $06;  // Calibration
    LOCKidx = $07;  LOCKbm = $80;  // Lock
    TEMPCAL20M0idx = $00;  // Oscillator temperature coefficient
    TEMPCAL20M1idx = $01;  // Oscillator temperature coefficient
    TEMPCAL20M2idx = $02;  // Oscillator temperature coefficient
    TEMPCAL20M3idx = $03;  // Oscillator temperature coefficient
    RUNSTDBYidx = $01;  RUNSTDBYbm = $02;  // Run standby
    CSUT0idx = $04;  // Crystal startup time
    CSUT1idx = $05;  // Crystal startup time
    ENABLEidx = $00;  ENABLEbm = $01;  // Enable
    SELidx = $02;  SELbm = $04;  // Select
  end;

  TCPU = object //CPU
    Reserved0: byte;
    Reserved1: byte;
    Reserved2: byte;
    Reserved3: byte;
    CCP: byte;  //Configuration Change Protection
    Reserved5: byte;
    Reserved6: byte;
    Reserved7: byte;
    Reserved8: byte;
    Reserved9: byte;
    Reserved10: byte;
    Reserved11: byte;
    Reserved12: byte;
    SPL: byte;  //Stack Pointer Low
    SPH: byte;  //Stack Pointer High
    SREG: byte;  //Status Register
  const
    CCP0idx = $00;  // CCP signature
    CCP1idx = $01;  // CCP signature
    CCP2idx = $02;  // CCP signature
    CCP3idx = $03;  // CCP signature
    CCP4idx = $04;  // CCP signature
    CCP5idx = $05;  // CCP signature
    CCP6idx = $06;  // CCP signature
    CCP7idx = $07;  // CCP signature
    Cidx = $00;  Cbm = $01;  // Carry Flag
    Hidx = $05;  Hbm = $20;  // Half Carry Flag
    Iidx = $07;  Ibm = $80;  // Global Interrupt Enable Flag
    Nidx = $02;  Nbm = $04;  // Negative Flag
    Sidx = $04;  Sbm = $10;  // N Exclusive Or V Flag
    Tidx = $06;  Tbm = $40;  // Transfer Bit
    Vidx = $03;  Vbm = $08;  // Two's Complement Overflow Flag
    Zidx = $01;  Zbm = $02;  // Zero Flag
  end;

  TCPUINT = object //Interrupt Controller
    CTRLA: byte;  //Control A
    STATUS: byte;  //Status
    LVL0PRI: byte;  //Interrupt Level 0 Priority
    LVL1VEC: byte;  //Interrupt Level 1 Priority Vector
  const
    CVTidx = $05;  CVTbm = $20;  // Compact Vector Table
    IVSELidx = $06;  IVSELbm = $40;  // Interrupt Vector Select
    LVL0RRidx = $00;  LVL0RRbm = $01;  // Round-robin Scheduling Enable
    LVL0PRI0idx = $00;  // Interrupt Level Priority
    LVL0PRI1idx = $01;  // Interrupt Level Priority
    LVL0PRI2idx = $02;  // Interrupt Level Priority
    LVL0PRI3idx = $03;  // Interrupt Level Priority
    LVL0PRI4idx = $04;  // Interrupt Level Priority
    LVL0PRI5idx = $05;  // Interrupt Level Priority
    LVL0PRI6idx = $06;  // Interrupt Level Priority
    LVL0PRI7idx = $07;  // Interrupt Level Priority
    LVL1VEC0idx = $00;  // Interrupt Vector with High Priority
    LVL1VEC1idx = $01;  // Interrupt Vector with High Priority
    LVL1VEC2idx = $02;  // Interrupt Vector with High Priority
    LVL1VEC3idx = $03;  // Interrupt Vector with High Priority
    LVL1VEC4idx = $04;  // Interrupt Vector with High Priority
    LVL1VEC5idx = $05;  // Interrupt Vector with High Priority
    LVL1VEC6idx = $06;  // Interrupt Vector with High Priority
    LVL1VEC7idx = $07;  // Interrupt Vector with High Priority
    LVL0EXidx = $00;  LVL0EXbm = $01;  // Level 0 Interrupt Executing
    LVL1EXidx = $01;  LVL1EXbm = $02;  // Level 1 Interrupt Executing
    NMIEXidx = $07;  NMIEXbm = $80;  // Non-maskable Interrupt Executing
  end;

  TCRCSCAN = object //CRCSCAN
    CTRLA: byte;  //Control A
    CTRLB: byte;  //Control B
    STATUS: byte;  //Status
  const
    ENABLEidx = $00;  ENABLEbm = $01;  // Enable CRC scan
    NMIENidx = $01;  NMIENbm = $02;  // Enable NMI Trigger
    RESETidx = $07;  RESETbm = $80;  // Reset CRC scan
    MODE0idx = $04;  // CRC Flash Access Mode
    MODE1idx = $05;  // CRC Flash Access Mode
    SRC0idx = $00;  // CRC Source
    SRC1idx = $01;  // CRC Source
    BUSYidx = $00;  BUSYbm = $01;  // CRC Busy
    OKidx = $01;  OKbm = $02;  // CRC Ok
  end;

  TEVSYS = object //Event System
    STROBE: byte;  //Channel Strobe
    Reserved1: byte;
    Reserved2: byte;
    Reserved3: byte;
    Reserved4: byte;
    Reserved5: byte;
    Reserved6: byte;
    Reserved7: byte;
    Reserved8: byte;
    Reserved9: byte;
    Reserved10: byte;
    Reserved11: byte;
    Reserved12: byte;
    Reserved13: byte;
    Reserved14: byte;
    Reserved15: byte;
    CHANNEL0: byte;  //Multiplexer Channel 0
    CHANNEL1: byte;  //Multiplexer Channel 1
    CHANNEL2: byte;  //Multiplexer Channel 2
    CHANNEL3: byte;  //Multiplexer Channel 3
    CHANNEL4: byte;  //Multiplexer Channel 4
    CHANNEL5: byte;  //Multiplexer Channel 5
    CHANNEL6: byte;  //Multiplexer Channel 6
    CHANNEL7: byte;  //Multiplexer Channel 7
    Reserved24: byte;
    Reserved25: byte;
    Reserved26: byte;
    Reserved27: byte;
    Reserved28: byte;
    Reserved29: byte;
    Reserved30: byte;
    Reserved31: byte;
    USERCCLLUT0A: byte;  //User CCL LUT0 Event A
    USERCCLLUT0B: byte;  //User CCL LUT0 Event B
    USERCCLLUT1A: byte;  //User CCL LUT1 Event A
    USERCCLLUT1B: byte;  //User CCL LUT1 Event B
    USERCCLLUT2A: byte;  //User CCL LUT2 Event A
    USERCCLLUT2B: byte;  //User CCL LUT2 Event B
    USERCCLLUT3A: byte;  //User CCL LUT3 Event A
    USERCCLLUT3B: byte;  //User CCL LUT3 Event B
    USERADC0: byte;  //User ADC0
    USEREVOUTA: byte;  //User EVOUT Port A
    USEREVOUTB: byte;  //User EVOUT Port B
    USEREVOUTC: byte;  //User EVOUT Port C
    USEREVOUTD: byte;  //User EVOUT Port D
    USEREVOUTE: byte;  //User EVOUT Port E
    USEREVOUTF: byte;  //User EVOUT Port F
    USERUSART0: byte;  //User USART0
    USERUSART1: byte;  //User USART1
    USERUSART2: byte;  //User USART2
    USERUSART3: byte;  //User USART3
    USERTCA0: byte;  //User TCA0
    USERTCB0: byte;  //User TCB0
    USERTCB1: byte;  //User TCB1
    USERTCB2: byte;  //User TCB2
    USERTCB3: byte;  //User TCB3
  const
    GENERATOR0idx = $00;  // Generator selector
    GENERATOR1idx = $01;  // Generator selector
    GENERATOR2idx = $02;  // Generator selector
    GENERATOR3idx = $03;  // Generator selector
    GENERATOR4idx = $04;  // Generator selector
    GENERATOR5idx = $05;  // Generator selector
    GENERATOR6idx = $06;  // Generator selector
    GENERATOR7idx = $07;  // Generator selector
    STROBE00idx = $00;  // Software event on channels
    STROBE01idx = $01;  // Software event on channels
    STROBE02idx = $02;  // Software event on channels
    STROBE03idx = $03;  // Software event on channels
    STROBE04idx = $04;  // Software event on channels
    STROBE05idx = $05;  // Software event on channels
    STROBE06idx = $06;  // Software event on channels
    STROBE07idx = $07;  // Software event on channels
    CHANNEL0idx = $00;  // Channel selector
    CHANNEL1idx = $01;  // Channel selector
    CHANNEL2idx = $02;  // Channel selector
    CHANNEL3idx = $03;  // Channel selector
    CHANNEL4idx = $04;  // Channel selector
    CHANNEL5idx = $05;  // Channel selector
    CHANNEL6idx = $06;  // Channel selector
    CHANNEL7idx = $07;  // Channel selector
  end;

  TFUSE = object //Fuses
    WDTCFG: byte;  //Watchdog Configuration
    BODCFG: byte;  //BOD Configuration
    OSCCFG: byte;  //Oscillator Configuration
    Reserved3: byte;
    Reserved4: byte;
    SYSCFG0: byte;  //System Configuration 0
    SYSCFG1: byte;  //System Configuration 1
    APPEND: byte;  //Application Code Section End
    BOOTEND: byte;  //Boot Section End
  const
    ACTIVE0idx = $02;  // BOD Operation in Active Mode
    ACTIVE1idx = $03;  // BOD Operation in Active Mode
    LVL0idx = $05;  // BOD Level
    LVL1idx = $06;  // BOD Level
    LVL2idx = $07;  // BOD Level
    SAMPFREQidx = $04;  SAMPFREQbm = $10;  // BOD Sample Frequency
    SLEEP0idx = $00;  // BOD Operation in Sleep Mode
    SLEEP1idx = $01;  // BOD Operation in Sleep Mode
    FREQSEL0idx = $00;  // Frequency Select
    FREQSEL1idx = $01;  // Frequency Select
    OSCLOCKidx = $07;  OSCLOCKbm = $80;  // Oscillator Lock
    CRCSRC0idx = $06;  // CRC Source
    CRCSRC1idx = $07;  // CRC Source
    EESAVEidx = $00;  EESAVEbm = $01;  // EEPROM Save
    RSTPINCFGidx = $03;  RSTPINCFGbm = $08;  // Reset Pin Configuration
    SUT0idx = $00;  // Startup Time
    SUT1idx = $01;  // Startup Time
    SUT2idx = $02;  // Startup Time
    PERIOD0idx = $00;  // Watchdog Timeout Period
    PERIOD1idx = $01;  // Watchdog Timeout Period
    PERIOD2idx = $02;  // Watchdog Timeout Period
    PERIOD3idx = $03;  // Watchdog Timeout Period
    WINDOW0idx = $04;  // Watchdog Window Timeout Period
    WINDOW1idx = $05;  // Watchdog Window Timeout Period
    WINDOW2idx = $06;  // Watchdog Window Timeout Period
    WINDOW3idx = $07;  // Watchdog Window Timeout Period
  end;

  TGPIO = object //General Purpose IO
    GPIOR0: byte;  //General Purpose IO Register 0
    GPIOR1: byte;  //General Purpose IO Register 1
    GPIOR2: byte;  //General Purpose IO Register 2
    GPIOR3: byte;  //General Purpose IO Register 3
  end;

  TLOCKBIT = object //Lockbit
    LOCKBIT: byte;  //Lock Bits
  const
    LB0idx = $00;  // Lock Bits
    LB1idx = $01;  // Lock Bits
    LB2idx = $02;  // Lock Bits
    LB3idx = $03;  // Lock Bits
    LB4idx = $04;  // Lock Bits
    LB5idx = $05;  // Lock Bits
    LB6idx = $06;  // Lock Bits
    LB7idx = $07;  // Lock Bits
  end;

  TNVMCTRL = object //Non-volatile Memory Controller
    CTRLA: byte;  //Control A
    CTRLB: byte;  //Control B
    STATUS: byte;  //Status
    INTCTRL: byte;  //Interrupt Control
    INTFLAGS: byte;  //Interrupt Flags
    Reserved5: byte;
    DATA: word;  //Data
    ADDR: word;  //Address
  const
    CMD0idx = $00;  // Command
    CMD1idx = $01;  // Command
    CMD2idx = $02;  // Command
    APCWPidx = $00;  APCWPbm = $01;  // Application code write protect
    BOOTLOCKidx = $01;  BOOTLOCKbm = $02;  // Boot Lock
    EEREADYidx = $00;  EEREADYbm = $01;  // EEPROM Ready
    EEBUSYidx = $01;  EEBUSYbm = $02;  // EEPROM busy
    FBUSYidx = $00;  FBUSYbm = $01;  // Flash busy
    WRERRORidx = $02;  WRERRORbm = $04;  // Write error
  end;

  TPORT = object //I/O Ports
    DIR: byte;  //Data Direction
    DIRSET: byte;  //Data Direction Set
    DIRCLR: byte;  //Data Direction Clear
    DIRTGL: byte;  //Data Direction Toggle
    OUT_: byte;  //Output Value
    OUTSET: byte;  //Output Value Set
    OUTCLR: byte;  //Output Value Clear
    OUTTGL: byte;  //Output Value Toggle
    IN_: byte;  //Input Value
    INTFLAGS: byte;  //Interrupt Flags
    PORTCTRL: byte;  //Port Control
    Reserved11: byte;
    Reserved12: byte;
    Reserved13: byte;
    Reserved14: byte;
    Reserved15: byte;
    PIN0CTRL: byte;  //Pin 0 Control
    PIN1CTRL: byte;  //Pin 1 Control
    PIN2CTRL: byte;  //Pin 2 Control
    PIN3CTRL: byte;  //Pin 3 Control
    PIN4CTRL: byte;  //Pin 4 Control
    PIN5CTRL: byte;  //Pin 5 Control
    PIN6CTRL: byte;  //Pin 6 Control
    PIN7CTRL: byte;  //Pin 7 Control
  const
    INT0idx = $00;  // Pin Interrupt
    INT1idx = $01;  // Pin Interrupt
    INT2idx = $02;  // Pin Interrupt
    INT3idx = $03;  // Pin Interrupt
    INT4idx = $04;  // Pin Interrupt
    INT5idx = $05;  // Pin Interrupt
    INT6idx = $06;  // Pin Interrupt
    INT7idx = $07;  // Pin Interrupt
    INVENidx = $07;  INVENbm = $80;  // Inverted I/O Enable
    ISC0idx = $00;  // Input/Sense Configuration
    ISC1idx = $01;  // Input/Sense Configuration
    ISC2idx = $02;  // Input/Sense Configuration
    PULLUPENidx = $03;  PULLUPENbm = $08;  // Pullup enable
    SRLidx = $00;  SRLbm = $01;  // Slew Rate Limit Enable
  end;

  TPORTMUX = object //Port Multiplexer
    EVSYSROUTEA: byte;  //Port Multiplexer EVSYS
    CCLROUTEA: byte;  //Port Multiplexer CCL
    USARTROUTEA: byte;  //Port Multiplexer USART register A
    TWISPIROUTEA: byte;  //Port Multiplexer TWI and SPI
    TCAROUTEA: byte;  //Port Multiplexer TCA
    TCBROUTEA: byte;  //Port Multiplexer TCB
  const
    LUT0idx = $00;  LUT0bm = $01;  // CCL LUT0
    LUT1idx = $01;  LUT1bm = $02;  // CCL LUT1
    LUT2idx = $02;  LUT2bm = $04;  // CCL LUT2
    LUT3idx = $03;  LUT3bm = $08;  // CCL LUT3
    EVOUT0idx = $00;  EVOUT0bm = $01;  // Event Output 0
    EVOUT1idx = $01;  EVOUT1bm = $02;  // Event Output 1
    EVOUT2idx = $02;  EVOUT2bm = $04;  // Event Output 2
    EVOUT3idx = $03;  EVOUT3bm = $08;  // Event Output 3
    EVOUT4idx = $04;  EVOUT4bm = $10;  // Event Output 4
    EVOUT5idx = $05;  EVOUT5bm = $20;  // Event Output 5
    TCA00idx = $00;  // Port Multiplexer TCA0
    TCA01idx = $01;  // Port Multiplexer TCA0
    TCA02idx = $02;  // Port Multiplexer TCA0
    TCB0idx = $00;  TCB0bm = $01;  // Port Multiplexer TCB0
    TCB1idx = $01;  TCB1bm = $02;  // Port Multiplexer TCB1
    TCB2idx = $02;  TCB2bm = $04;  // Port Multiplexer TCB2
    TCB3idx = $03;  TCB3bm = $08;  // Port Multiplexer TCB3
    SPI00idx = $00;  // Port Multiplexer SPI0
    SPI01idx = $01;  // Port Multiplexer SPI0
    TWI00idx = $04;  // Port Multiplexer TWI0
    TWI01idx = $05;  // Port Multiplexer TWI0
    USART00idx = $00;  // Port Multiplexer USART0
    USART01idx = $01;  // Port Multiplexer USART0
    USART10idx = $02;  // Port Multiplexer USART1
    USART11idx = $03;  // Port Multiplexer USART1
    USART20idx = $04;  // Port Multiplexer USART2
    USART21idx = $05;  // Port Multiplexer USART2
    USART30idx = $06;  // Port Multiplexer USART3
    USART31idx = $07;  // Port Multiplexer USART3
  end;

  TRSTCTRL = object //Reset controller
    RSTFR: byte;  //Reset Flags
    SWRR: byte;  //Software Reset
  const
    BORFidx = $01;  BORFbm = $02;  // Brown out detector Reset flag
    EXTRFidx = $02;  EXTRFbm = $04;  // External Reset flag
    PORFidx = $00;  PORFbm = $01;  // Power on Reset flag
    SWRFidx = $04;  SWRFbm = $10;  // Software Reset flag
    UPDIRFidx = $05;  UPDIRFbm = $20;  // UPDI Reset flag
    WDRFidx = $03;  WDRFbm = $08;  // Watch dog Reset flag
    SWREidx = $00;  SWREbm = $01;  // Software reset enable
  end;

  TRTC = object //Real-Time Counter
    CTRLA: byte;  //Control A
    STATUS: byte;  //Status
    INTCTRL: byte;  //Interrupt Control
    INTFLAGS: byte;  //Interrupt Flags
    TEMP: byte;  //Temporary
    DBGCTRL: byte;  //Debug control
    CALIB: byte;  //Calibration
    CLKSEL: byte;  //Clock Select
    CNT: word;  //Counter
    PER: word;  //Period
    CMP: word;  //Compare
    Reserved14: byte;
    Reserved15: byte;
    PITCTRLA: byte;  //PIT Control A
    PITSTATUS: byte;  //PIT Status
    PITINTCTRL: byte;  //PIT Interrupt Control
    PITINTFLAGS: byte;  //PIT Interrupt Flags
    Reserved20: byte;
    PITDBGCTRL: byte;  //PIT Debug control
  const
    ERROR0idx = $00;  // Error Correction Value
    ERROR1idx = $01;  // Error Correction Value
    ERROR2idx = $02;  // Error Correction Value
    ERROR3idx = $03;  // Error Correction Value
    ERROR4idx = $04;  // Error Correction Value
    ERROR5idx = $05;  // Error Correction Value
    ERROR6idx = $06;  // Error Correction Value
    SIGNidx = $07;  SIGNbm = $80;  // Error Correction Sign Bit
    CLKSEL0idx = $00;  // Clock Select
    CLKSEL1idx = $01;  // Clock Select
    PRESCALER0idx = $03;  // Prescaling Factor
    PRESCALER1idx = $04;  // Prescaling Factor
    PRESCALER2idx = $05;  // Prescaling Factor
    PRESCALER3idx = $06;  // Prescaling Factor
    RTCENidx = $00;  RTCENbm = $01;  // Enable
    RUNSTDBYidx = $07;  RUNSTDBYbm = $80;  // Run In Standby
    DBGRUNidx = $00;  DBGRUNbm = $01;  // Run in debug
    CMPidx = $01;  CMPbm = $02;  // Compare Match Interrupt enable
    OVFidx = $00;  OVFbm = $01;  // Overflow Interrupt enable
    PERIOD0idx = $03;  // Period
    PERIOD1idx = $04;  // Period
    PERIOD2idx = $05;  // Period
    PERIOD3idx = $06;  // Period
    PITENidx = $00;  PITENbm = $01;  // Enable
    PIidx = $00;  PIbm = $01;  // Periodic Interrupt
    CTRLBUSYidx = $00;  CTRLBUSYbm = $01;  // CTRLA Synchronization Busy Flag
    CMPBUSYidx = $03;  CMPBUSYbm = $08;  // Comparator Synchronization Busy Flag
    CNTBUSYidx = $01;  CNTBUSYbm = $02;  // Count Synchronization Busy Flag
    CTRLABUSYidx = $00;  CTRLABUSYbm = $01;  // CTRLA Synchronization Busy Flag
    PERBUSYidx = $02;  PERBUSYbm = $04;  // Period Synchronization Busy Flag
  end;

  TSIGROW = object //Signature row
    DEVICEID0: byte;  //Device ID Byte 0
    DEVICEID1: byte;  //Device ID Byte 1
    DEVICEID2: byte;  //Device ID Byte 2
    SERNUM0: byte;  //Serial Number Byte 0
    SERNUM1: byte;  //Serial Number Byte 1
    SERNUM2: byte;  //Serial Number Byte 2
    SERNUM3: byte;  //Serial Number Byte 3
    SERNUM4: byte;  //Serial Number Byte 4
    SERNUM5: byte;  //Serial Number Byte 5
    SERNUM6: byte;  //Serial Number Byte 6
    SERNUM7: byte;  //Serial Number Byte 7
    SERNUM8: byte;  //Serial Number Byte 8
    SERNUM9: byte;  //Serial Number Byte 9
    Reserved13: byte;
    Reserved14: byte;
    Reserved15: byte;
    Reserved16: byte;
    Reserved17: byte;
    Reserved18: byte;
    Reserved19: byte;
    OSCCAL32K: byte;  //Oscillator Calibration for 32kHz ULP
    Reserved21: byte;
    Reserved22: byte;
    Reserved23: byte;
    OSCCAL16M0: byte;  //Oscillator Calibration 16 MHz Byte 0
    OSCCAL16M1: byte;  //Oscillator Calibration 16 MHz Byte 1
    OSCCAL20M0: byte;  //Oscillator Calibration 20 MHz Byte 0
    OSCCAL20M1: byte;  //Oscillator Calibration 20 MHz Byte 1
    Reserved28: byte;
    Reserved29: byte;
    Reserved30: byte;
    Reserved31: byte;
    TEMPSENSE0: byte;  //Temperature Sensor Calibration Byte 0
    TEMPSENSE1: byte;  //Temperature Sensor Calibration Byte 1
    OSC16ERR3V: byte;  //OSC16 error at 3V
    OSC16ERR5V: byte;  //OSC16 error at 5V
    OSC20ERR3V: byte;  //OSC20 error at 3V
    OSC20ERR5V: byte;  //OSC20 error at 5V
    Reserved38: byte;
    Reserved39: byte;
    Reserved40: byte;
    Reserved41: byte;
    Reserved42: byte;
    Reserved43: byte;
    Reserved44: byte;
    Reserved45: byte;
    Reserved46: byte;
    CHECKSUM1: byte;  //CRC Checksum Byte 1
  end;

  TSLPCTRL = object //Sleep Controller
    CTRLA: byte;  //Control
  const
    SENidx = $00;  SENbm = $01;  // Sleep enable
    SMODE0idx = $01;  // Sleep mode
    SMODE1idx = $02;  // Sleep mode
  end;

  TSPI = object //Serial Peripheral Interface
    CTRLA: byte;  //Control A
    CTRLB: byte;  //Control B
    INTCTRL: byte;  //Interrupt Control
    INTFLAGS: byte;  //Interrupt Flags
    DATA: byte;  //Data
  const
    CLK2Xidx = $04;  CLK2Xbm = $10;  // Enable Double Speed
    DORDidx = $06;  DORDbm = $40;  // Data Order Setting
    ENABLEidx = $00;  ENABLEbm = $01;  // Enable Module
    MASTERidx = $05;  MASTERbm = $20;  // Master Operation Enable
    PRESC0idx = $01;  // Prescaler
    PRESC1idx = $02;  // Prescaler
    BUFENidx = $07;  BUFENbm = $80;  // Buffer Mode Enable
    BUFWRidx = $06;  BUFWRbm = $40;  // Buffer Write Mode
    MODE0idx = $00;  // SPI Mode
    MODE1idx = $01;  // SPI Mode
    SSDidx = $02;  SSDbm = $04;  // Slave Select Disable
    DREIEidx = $05;  DREIEbm = $20;  // Data Register Empty Interrupt Enable
    IEidx = $00;  IEbm = $01;  // Interrupt Enable
    RXCIEidx = $07;  RXCIEbm = $80;  // Receive Complete Interrupt Enable
    SSIEidx = $04;  SSIEbm = $10;  // Slave Select Trigger Interrupt Enable
    TXCIEidx = $06;  TXCIEbm = $40;  // Transfer Complete Interrupt Enable
  end;

  TSYSCFG = object //System Configuration Registers
    Reserved0: byte;
    REVID: byte;  //Revision ID
    EXTBRK: byte;  //External Break
    Reserved3: byte;
    Reserved4: byte;
    Reserved5: byte;
    Reserved6: byte;
    Reserved7: byte;
    Reserved8: byte;
    Reserved9: byte;
    Reserved10: byte;
    Reserved11: byte;
    Reserved12: byte;
    Reserved13: byte;
    Reserved14: byte;
    Reserved15: byte;
    Reserved16: byte;
    Reserved17: byte;
    Reserved18: byte;
    Reserved19: byte;
    Reserved20: byte;
    Reserved21: byte;
    Reserved22: byte;
    Reserved23: byte;
    OCDM: byte;  //OCD Message Register
    OCDMS: byte;  //OCD Message Status
  const
    ENEXTBRKidx = $00;  ENEXTBRKbm = $01;  // External break enable
    OCDMRidx = $00;  OCDMRbm = $01;  // OCD Message Read
  end;

  TTCA_SINGLE = object //16-bit Timer/Counter Type A - Single Mode
    CTRLA: byte;  //Control A
    CTRLB: byte;  //Control B
    CTRLC: byte;  //Control C
    CTRLD: byte;  //Control D
    CTRLECLR: byte;  //Control E Clear
    CTRLESET: byte;  //Control E Set
    CTRLFCLR: byte;  //Control F Clear
    CTRLFSET: byte;  //Control F Set
    Reserved8: byte;
    EVCTRL: byte;  //Event Control
    INTCTRL: byte;  //Interrupt Control
    INTFLAGS: byte;  //Interrupt Flags
    Reserved12: byte;
    Reserved13: byte;
    DBGCTRL: byte;  //Degbug Control
    TEMP: byte;  //Temporary data for 16-bit Access
    Reserved16: byte;
    Reserved17: byte;
    Reserved18: byte;
    Reserved19: byte;
    Reserved20: byte;
    Reserved21: byte;
    Reserved22: byte;
    Reserved23: byte;
    Reserved24: byte;
    Reserved25: byte;
    Reserved26: byte;
    Reserved27: byte;
    Reserved28: byte;
    Reserved29: byte;
    Reserved30: byte;
    Reserved31: byte;
    CNT: word;  //Count
    Reserved34: byte;
    Reserved35: byte;
    Reserved36: byte;
    Reserved37: byte;
    PER: word;  //Period
    CMP0: word;  //Compare 0
    CMP1: word;  //Compare 1
    CMP2: word;  //Compare 2
    Reserved46: byte;
    Reserved47: byte;
    Reserved48: byte;
    Reserved49: byte;
    Reserved50: byte;
    Reserved51: byte;
    Reserved52: byte;
    Reserved53: byte;
    PERBUF: word;  //Period Buffer
    CMP0BUF: word;  //Compare 0 Buffer
    CMP1BUF: word;  //Compare 1 Buffer
    CMP2BUF: word;  //Compare 2 Buffer
  const
    CLKSEL0idx = $01;  // Clock Selection
    CLKSEL1idx = $02;  // Clock Selection
    CLKSEL2idx = $03;  // Clock Selection
    ENABLEidx = $00;  ENABLEbm = $01;  // Module Enable
    ALUPDidx = $03;  ALUPDbm = $08;  // Auto Lock Update
    CMP0ENidx = $04;  CMP0ENbm = $10;  // Compare 0 Enable
    CMP1ENidx = $05;  CMP1ENbm = $20;  // Compare 1 Enable
    CMP2ENidx = $06;  CMP2ENbm = $40;  // Compare 2 Enable
    WGMODE0idx = $00;  // Waveform generation mode
    WGMODE1idx = $01;  // Waveform generation mode
    WGMODE2idx = $02;  // Waveform generation mode
    CMP0OVidx = $00;  CMP0OVbm = $01;  // Compare 0 Waveform Output Value
    CMP1OVidx = $01;  CMP1OVbm = $02;  // Compare 1 Waveform Output Value
    CMP2OVidx = $02;  CMP2OVbm = $04;  // Compare 2 Waveform Output Value
    SPLITMidx = $00;  SPLITMbm = $01;  // Split Mode Enable
    CMD0idx = $02;  // Command
    CMD1idx = $03;  // Command
    DIRidx = $00;  DIRbm = $01;  // Direction
    LUPDidx = $01;  LUPDbm = $02;  // Lock Update
    CMP0BVidx = $01;  CMP0BVbm = $02;  // Compare 0 Buffer Valid
    CMP1BVidx = $02;  CMP1BVbm = $04;  // Compare 1 Buffer Valid
    CMP2BVidx = $03;  CMP2BVbm = $08;  // Compare 2 Buffer Valid
    PERBVidx = $00;  PERBVbm = $01;  // Period Buffer Valid
    DBGRUNidx = $00;  DBGRUNbm = $01;  // Debug Run
    CNTEIidx = $00;  CNTEIbm = $01;  // Count on Event Input
    EVACT0idx = $01;  // Event Action
    EVACT1idx = $02;  // Event Action
    CMP0idx = $04;  CMP0bm = $10;  // Compare 0 Interrupt
    CMP1idx = $05;  CMP1bm = $20;  // Compare 1 Interrupt
    CMP2idx = $06;  CMP2bm = $40;  // Compare 2 Interrupt
    OVFidx = $00;  OVFbm = $01;  // Overflow Interrupt
  end;

  TTCA_SPLIT = object //16-bit Timer/Counter Type A - Split Mode
    CTRLA: byte;  //Control A
    CTRLB: byte;  //Control B
    CTRLC: byte;  //Control C
    CTRLD: byte;  //Control D
    CTRLECLR: byte;  //Control E Clear
    CTRLESET: byte;  //Control E Set
    Reserved6: byte;
    Reserved7: byte;
    Reserved8: byte;
    Reserved9: byte;
    INTCTRL: byte;  //Interrupt Control
    INTFLAGS: byte;  //Interrupt Flags
    Reserved12: byte;
    Reserved13: byte;
    DBGCTRL: byte;  //Degbug Control
    Reserved15: byte;
    Reserved16: byte;
    Reserved17: byte;
    Reserved18: byte;
    Reserved19: byte;
    Reserved20: byte;
    Reserved21: byte;
    Reserved22: byte;
    Reserved23: byte;
    Reserved24: byte;
    Reserved25: byte;
    Reserved26: byte;
    Reserved27: byte;
    Reserved28: byte;
    Reserved29: byte;
    Reserved30: byte;
    Reserved31: byte;
    LCNT: byte;  //Low Count
    HCNT: byte;  //High Count
    Reserved34: byte;
    Reserved35: byte;
    Reserved36: byte;
    Reserved37: byte;
    LPER: byte;  //Low Period
    HPER: byte;  //High Period
    LCMP0: byte;  //Low Compare
    HCMP0: byte;  //High Compare
    LCMP1: byte;  //Low Compare
    HCMP1: byte;  //High Compare
    LCMP2: byte;  //Low Compare
    HCMP2: byte;  //High Compare
  const
    CLKSEL0idx = $01;  // Clock Selection
    CLKSEL1idx = $02;  // Clock Selection
    CLKSEL2idx = $03;  // Clock Selection
    ENABLEidx = $00;  ENABLEbm = $01;  // Module Enable
    HCMP0ENidx = $04;  HCMP0ENbm = $10;  // High Compare 0 Enable
    HCMP1ENidx = $05;  HCMP1ENbm = $20;  // High Compare 1 Enable
    HCMP2ENidx = $06;  HCMP2ENbm = $40;  // High Compare 2 Enable
    LCMP0ENidx = $00;  LCMP0ENbm = $01;  // Low Compare 0 Enable
    LCMP1ENidx = $01;  LCMP1ENbm = $02;  // Low Compare 1 Enable
    LCMP2ENidx = $02;  LCMP2ENbm = $04;  // Low Compare 2 Enable
    HCMP0OVidx = $04;  HCMP0OVbm = $10;  // High Compare 0 Output Value
    HCMP1OVidx = $05;  HCMP1OVbm = $20;  // High Compare 1 Output Value
    HCMP2OVidx = $06;  HCMP2OVbm = $40;  // High Compare 2 Output Value
    LCMP0OVidx = $00;  LCMP0OVbm = $01;  // Low Compare 0 Output Value
    LCMP1OVidx = $01;  LCMP1OVbm = $02;  // Low Compare 1 Output Value
    LCMP2OVidx = $02;  LCMP2OVbm = $04;  // Low Compare 2 Output Value
    SPLITMidx = $00;  SPLITMbm = $01;  // Split Mode Enable
    CMD0idx = $02;  // Command
    CMD1idx = $03;  // Command
    DBGRUNidx = $00;  DBGRUNbm = $01;  // Debug Run
    HUNFidx = $01;  HUNFbm = $02;  // High Underflow Interrupt Enable
    LCMP0idx = $04;  LCMP0bm = $10;  // Low Compare 0 Interrupt Enable
    LCMP1idx = $05;  LCMP1bm = $20;  // Low Compare 1 Interrupt Enable
    LCMP2idx = $06;  LCMP2bm = $40;  // Low Compare 2 Interrupt Enable
    LUNFidx = $00;  LUNFbm = $01;  // Low Underflow Interrupt Enable
  end;

  TTCA = record //16-bit Timer/Counter Type A
    case byte of
      0: (SINGLE: TTCA_SINGLE);
      1: (SPLIT: TTCA_SPLIT);
    end;

  TTCB = object //16-bit Timer Type B
    CTRLA: byte;  //Control A
    CTRLB: byte;  //Control Register B
    Reserved2: byte;
    Reserved3: byte;
    EVCTRL: byte;  //Event Control
    INTCTRL: byte;  //Interrupt Control
    INTFLAGS: byte;  //Interrupt Flags
    STATUS: byte;  //Status
    DBGCTRL: byte;  //Debug Control
    TEMP: byte;  //Temporary Value
    CNT: word;  //Count
    CCMP: word;  //Compare or Capture
  const
    CLKSEL0idx = $01;  // Clock Select
    CLKSEL1idx = $02;  // Clock Select
    ENABLEidx = $00;  ENABLEbm = $01;  // Enable
    RUNSTDBYidx = $06;  RUNSTDBYbm = $40;  // Run Standby
    SYNCUPDidx = $04;  SYNCUPDbm = $10;  // Synchronize Update
    ASYNCidx = $06;  ASYNCbm = $40;  // Asynchronous Enable
    CCMPENidx = $04;  CCMPENbm = $10;  // Pin Output Enable
    CCMPINITidx = $05;  CCMPINITbm = $20;  // Pin Initial State
    CNTMODE0idx = $00;  // Timer Mode
    CNTMODE1idx = $01;  // Timer Mode
    CNTMODE2idx = $02;  // Timer Mode
    DBGRUNidx = $00;  DBGRUNbm = $01;  // Debug Run
    CAPTEIidx = $00;  CAPTEIbm = $01;  // Event Input Enable
    EDGEidx = $04;  EDGEbm = $10;  // Event Edge
    FILTERidx = $06;  FILTERbm = $40;  // Input Capture Noise Cancellation Filter
    CAPTidx = $00;  CAPTbm = $01;  // Capture or Timeout
    RUNidx = $00;  RUNbm = $01;  // Run
  end;

  TTWI = object //Two-Wire Interface
    CTRLA: byte;  //Control A
    DUALCTRL: byte;  //Dual Control
    DBGCTRL: byte;  //Debug Control Register
    MCTRLA: byte;  //Master Control A
    MCTRLB: byte;  //Master Control B
    MSTATUS: byte;  //Master Status
    MBAUD: byte;  //Master Baurd Rate Control
    MADDR: byte;  //Master Address
    MDATA: byte;  //Master Data
    SCTRLA: byte;  //Slave Control A
    SCTRLB: byte;  //Slave Control B
    SSTATUS: byte;  //Slave Status
    SADDR: byte;  //Slave Address
    SDATA: byte;  //Slave Data
    SADDRMASK: byte;  //Slave Address Mask
  const
    ENABLEidx = $00;  ENABLEbm = $01;  // Enable TWI Master
    QCENidx = $04;  QCENbm = $10;  // Quick Command Enable
    RIENidx = $07;  RIENbm = $80;  // Read Interrupt Enable
    SMENidx = $01;  SMENbm = $02;  // Smart Mode Enable
    TIMEOUT0idx = $02;  // Inactive Bus Timeout
    TIMEOUT1idx = $03;  // Inactive Bus Timeout
    WIENidx = $06;  WIENbm = $40;  // Write Interrupt Enable
    ACKACTidx = $02;  ACKACTbm = $04;  // Acknowledge Action
    FLUSHidx = $03;  FLUSHbm = $08;  // Flush
    MCMD0idx = $00;  // Command
    MCMD1idx = $01;  // Command
    ARBLOSTidx = $03;  ARBLOSTbm = $08;  // Arbitration Lost
    BUSERRidx = $02;  BUSERRbm = $04;  // Bus Error
    BUSSTATE0idx = $00;  // Bus State
    BUSSTATE1idx = $01;  // Bus State
    CLKHOLDidx = $05;  CLKHOLDbm = $20;  // Clock Hold
    RIFidx = $07;  RIFbm = $80;  // Read Interrupt Flag
    RXACKidx = $04;  RXACKbm = $10;  // Received Acknowledge
    WIFidx = $06;  WIFbm = $40;  // Write Interrupt Flag
    ADDRENidx = $00;  ADDRENbm = $01;  // Address Enable
    ADDRMASK0idx = $01;  // Address Mask
    ADDRMASK1idx = $02;  // Address Mask
    ADDRMASK2idx = $03;  // Address Mask
    ADDRMASK3idx = $04;  // Address Mask
    ADDRMASK4idx = $05;  // Address Mask
    ADDRMASK5idx = $06;  // Address Mask
    ADDRMASK6idx = $07;  // Address Mask
    APIENidx = $06;  APIENbm = $40;  // Address/Stop Interrupt Enable
    DIENidx = $07;  DIENbm = $80;  // Data Interrupt Enable
    PIENidx = $05;  PIENbm = $20;  // Stop Interrupt Enable
    PMENidx = $02;  PMENbm = $04;  // Promiscuous Mode Enable
    SCMD0idx = $00;  // Command
    SCMD1idx = $01;  // Command
    APidx = $00;  APbm = $01;  // Slave Address or Stop
    APIFidx = $06;  APIFbm = $40;  // Address/Stop Interrupt Flag
    COLLidx = $03;  COLLbm = $08;  // Collision
    DIFidx = $07;  DIFbm = $80;  // Data Interrupt Flag
    DIRidx = $01;  DIRbm = $02;  // Read/Write Direction
  end;

  TUSART = object //Universal Synchronous and Asynchronous Receiver and Transmitter
    RXDATAL: byte;  //Receive Data Low Byte
    RXDATAH: byte;  //Receive Data High Byte
    TXDATAL: byte;  //Transmit Data Low Byte
    TXDATAH: byte;  //Transmit Data High Byte
    STATUS: byte;  //Status
    CTRLA: byte;  //Control A
    CTRLB: byte;  //Control B
    CTRLC: byte;  //Control C
    BAUD: word;  //Baud Rate
    CTRLD: byte;  //Control D
    DBGCTRL: byte;  //Debug Control
    EVCTRL: byte;  //Event Control
    TXPLCTRL: byte;  //IRCOM Transmitter Pulse Length Control
    RXPLCTRL: byte;  //IRCOM Receiver Pulse Length Control
  const
    ABEIEidx = $02;  ABEIEbm = $04;  // Auto-baud Error Interrupt Enable
    DREIEidx = $05;  DREIEbm = $20;  // Data Register Empty Interrupt Enable
    LBMEidx = $03;  LBMEbm = $08;  // Loop-back Mode Enable
    RS4850idx = $00;  // RS485 Mode internal transmitter
    RS4851idx = $01;  // RS485 Mode internal transmitter
    RXCIEidx = $07;  RXCIEbm = $80;  // Receive Complete Interrupt Enable
    RXSIEidx = $04;  RXSIEbm = $10;  // Receiver Start Frame Interrupt Enable
    TXCIEidx = $06;  TXCIEbm = $40;  // Transmit Complete Interrupt Enable
    MPCMidx = $00;  MPCMbm = $01;  // Multi-processor Communication Mode
    ODMEidx = $03;  ODMEbm = $08;  // Open Drain Mode Enable
    RXENidx = $07;  RXENbm = $80;  // Reciever enable
    RXMODE0idx = $01;  // Receiver Mode
    RXMODE1idx = $02;  // Receiver Mode
    SFDENidx = $04;  SFDENbm = $10;  // Start Frame Detection Enable
    TXENidx = $06;  TXENbm = $40;  // Transmitter Enable
    ABW0idx = $06;  // Auto Baud Window
    ABW1idx = $07;  // Auto Baud Window
    ABMBPidx = $07;  ABMBPbm = $80;  // Autobaud majority voter bypass
    DBGRUNidx = $00;  DBGRUNbm = $01;  // Debug Run
    IREIidx = $00;  IREIbm = $01;  // IrDA Event Input Enable
    BUFOVFidx = $06;  BUFOVFbm = $40;  // Buffer Overflow
    DATA8idx = $00;  DATA8bm = $01;  // Receiver Data Register
    FERRidx = $02;  FERRbm = $04;  // Frame Error
    PERRidx = $01;  PERRbm = $02;  // Parity Error
    RXCIFidx = $07;  RXCIFbm = $80;  // Receive Complete Interrupt Flag
    DATA0idx = $00;  // RX Data
    DATA1idx = $01;  // RX Data
    DATA2idx = $02;  // RX Data
    DATA3idx = $03;  // RX Data
    DATA4idx = $04;  // RX Data
    DATA5idx = $05;  // RX Data
    DATA6idx = $06;  // RX Data
    DATA7idx = $07;  // RX Data
    RXPL0idx = $00;  // Receiver Pulse Lenght
    RXPL1idx = $01;  // Receiver Pulse Lenght
    RXPL2idx = $02;  // Receiver Pulse Lenght
    RXPL3idx = $03;  // Receiver Pulse Lenght
    RXPL4idx = $04;  // Receiver Pulse Lenght
    RXPL5idx = $05;  // Receiver Pulse Lenght
    RXPL6idx = $06;  // Receiver Pulse Lenght
    BDFidx = $01;  BDFbm = $02;  // Break Detected Flag
    DREIFidx = $05;  DREIFbm = $20;  // Data Register Empty Flag
    ISFIFidx = $03;  ISFIFbm = $08;  // Inconsistent Sync Field Interrupt Flag
    RXSIFidx = $04;  RXSIFbm = $10;  // Receive Start Interrupt
    TXCIFidx = $06;  TXCIFbm = $40;  // Transmit Interrupt Flag
    WFBidx = $00;  WFBbm = $01;  // Wait For Break
    TXPL0idx = $00;  // Transmit pulse length
    TXPL1idx = $01;  // Transmit pulse length
    TXPL2idx = $02;  // Transmit pulse length
    TXPL3idx = $03;  // Transmit pulse length
    TXPL4idx = $04;  // Transmit pulse length
    TXPL5idx = $05;  // Transmit pulse length
    TXPL6idx = $06;  // Transmit pulse length
    TXPL7idx = $07;  // Transmit pulse length
  end;

  TUSERROW = object //User Row
    USERROW0: byte;  //User Row Byte 0
    USERROW1: byte;  //User Row Byte 1
    USERROW2: byte;  //User Row Byte 2
    USERROW3: byte;  //User Row Byte 3
    USERROW4: byte;  //User Row Byte 4
    USERROW5: byte;  //User Row Byte 5
    USERROW6: byte;  //User Row Byte 6
    USERROW7: byte;  //User Row Byte 7
    USERROW8: byte;  //User Row Byte 8
    USERROW9: byte;  //User Row Byte 9
    USERROW10: byte;  //User Row Byte 10
    USERROW11: byte;  //User Row Byte 11
    USERROW12: byte;  //User Row Byte 12
    USERROW13: byte;  //User Row Byte 13
    USERROW14: byte;  //User Row Byte 14
    USERROW15: byte;  //User Row Byte 15
    USERROW16: byte;  //User Row Byte 16
    USERROW17: byte;  //User Row Byte 17
    USERROW18: byte;  //User Row Byte 18
    USERROW19: byte;  //User Row Byte 19
    USERROW20: byte;  //User Row Byte 20
    USERROW21: byte;  //User Row Byte 21
    USERROW22: byte;  //User Row Byte 22
    USERROW23: byte;  //User Row Byte 23
    USERROW24: byte;  //User Row Byte 24
    USERROW25: byte;  //User Row Byte 25
    USERROW26: byte;  //User Row Byte 26
    USERROW27: byte;  //User Row Byte 27
    USERROW28: byte;  //User Row Byte 28
    USERROW29: byte;  //User Row Byte 29
    USERROW30: byte;  //User Row Byte 30
    USERROW31: byte;  //User Row Byte 31
    USERROW32: byte;  //User Row Byte 32
    USERROW33: byte;  //User Row Byte 33
    USERROW34: byte;  //User Row Byte 34
    USERROW35: byte;  //User Row Byte 35
    USERROW36: byte;  //User Row Byte 36
    USERROW37: byte;  //User Row Byte 37
    USERROW38: byte;  //User Row Byte 38
    USERROW39: byte;  //User Row Byte 39
    USERROW40: byte;  //User Row Byte 40
    USERROW41: byte;  //User Row Byte 41
    USERROW42: byte;  //User Row Byte 42
    USERROW43: byte;  //User Row Byte 43
    USERROW44: byte;  //User Row Byte 44
    USERROW45: byte;  //User Row Byte 45
    USERROW46: byte;  //User Row Byte 46
    USERROW47: byte;  //User Row Byte 47
    USERROW48: byte;  //User Row Byte 48
    USERROW49: byte;  //User Row Byte 49
    USERROW50: byte;  //User Row Byte 50
    USERROW51: byte;  //User Row Byte 51
    USERROW52: byte;  //User Row Byte 52
    USERROW53: byte;  //User Row Byte 53
    USERROW54: byte;  //User Row Byte 54
    USERROW55: byte;  //User Row Byte 55
    USERROW56: byte;  //User Row Byte 56
    USERROW57: byte;  //User Row Byte 57
    USERROW58: byte;  //User Row Byte 58
    USERROW59: byte;  //User Row Byte 59
    USERROW60: byte;  //User Row Byte 60
    USERROW61: byte;  //User Row Byte 61
    USERROW62: byte;  //User Row Byte 62
    USERROW63: byte;  //User Row Byte 63
  end;

  TVPORT = object //Virtual Ports
    DIR: byte;  //Data Direction
    OUT_: byte;  //Output Value
    IN_: byte;  //Input Value
    INTFLAGS: byte;  //Interrupt Flags
  const
    INT0idx = $00;  // Pin Interrupt
    INT1idx = $01;  // Pin Interrupt
    INT2idx = $02;  // Pin Interrupt
    INT3idx = $03;  // Pin Interrupt
    INT4idx = $04;  // Pin Interrupt
    INT5idx = $05;  // Pin Interrupt
    INT6idx = $06;  // Pin Interrupt
    INT7idx = $07;  // Pin Interrupt
  end;

  TVREF = object //Voltage reference
    CTRLA: byte;  //Control A
    CTRLB: byte;  //Control B
  const
    AC0REFSEL0idx = $00;  // AC0 reference select
    AC0REFSEL1idx = $01;  // AC0 reference select
    AC0REFSEL2idx = $02;  // AC0 reference select
    ADC0REFSEL0idx = $04;  // ADC0 reference select
    ADC0REFSEL1idx = $05;  // ADC0 reference select
    ADC0REFSEL2idx = $06;  // ADC0 reference select
    AC0REFENidx = $00;  AC0REFENbm = $01;  // AC0 DACREF reference enable
    ADC0REFENidx = $01;  ADC0REFENbm = $02;  // ADC0 reference enable
  end;

  TWDT = object //Watch-Dog Timer
    CTRLA: byte;  //Control A
    STATUS: byte;  //Status
  const
    PERIOD0idx = $00;  // Period
    PERIOD1idx = $01;  // Period
    PERIOD2idx = $02;  // Period
    PERIOD3idx = $03;  // Period
    WINDOW0idx = $04;  // Window
    WINDOW1idx = $05;  // Window
    WINDOW2idx = $06;  // Window
    WINDOW3idx = $07;  // Window
    LOCKidx = $07;  LOCKbm = $80;  // Lock enable
    SYNCBUSYidx = $00;  SYNCBUSYbm = $01;  // Syncronization busy
  end;


const
 Pin0idx = 0;  Pin0bm = 1;
 Pin1idx = 1;  Pin1bm = 2;
 Pin2idx = 2;  Pin2bm = 4;
 Pin3idx = 3;  Pin3bm = 8;
 Pin4idx = 4;  Pin4bm = 16;
 Pin5idx = 5;  Pin5bm = 32;
 Pin6idx = 6;  Pin6bm = 64;
 Pin7idx = 7;  Pin7bm = 128;

var
  VPORTA: TVPORT absolute $0000;
  VPORTB: TVPORT absolute $0004;
  VPORTC: TVPORT absolute $0008;
  VPORTD: TVPORT absolute $000C;
  VPORTE: TVPORT absolute $0010;
  VPORTF: TVPORT absolute $0014;
  GPIO: TGPIO absolute $001C;
  CPU: TCPU absolute $0030;
  RSTCTRL: TRSTCTRL absolute $0040;
  SLPCTRL: TSLPCTRL absolute $0050;
  CLKCTRL: TCLKCTRL absolute $0060;
  BOD: TBOD absolute $0080;
  VREF: TVREF absolute $00A0;
  WDT: TWDT absolute $0100;
  CPUINT: TCPUINT absolute $0110;
  CRCSCAN: TCRCSCAN absolute $0120;
  RTC: TRTC absolute $0140;
  EVSYS: TEVSYS absolute $0180;
  CCL: TCCL absolute $01C0;
  PORTA: TPORT absolute $0400;
  PORTB: TPORT absolute $0420;
  PORTC: TPORT absolute $0440;
  PORTD: TPORT absolute $0460;
  PORTE: TPORT absolute $0480;
  PORTF: TPORT absolute $04A0;
  PORTMUX: TPORTMUX absolute $05E0;
  ADC0: TADC absolute $0600;
  AC0: TAC absolute $0680;
  USART0: TUSART absolute $0800;
  USART1: TUSART absolute $0820;
  USART2: TUSART absolute $0840;
  USART3: TUSART absolute $0860;
  TWI0: TTWI absolute $08A0;
  SPI0: TSPI absolute $08C0;
  TCA0: TTCA absolute $0A00;
  TCB0: TTCB absolute $0A80;
  TCB1: TTCB absolute $0A90;
  TCB2: TTCB absolute $0AA0;
  TCB3: TTCB absolute $0AB0;
  SYSCFG: TSYSCFG absolute $0F00;
  NVMCTRL: TNVMCTRL absolute $1000;
  SIGROW: TSIGROW absolute $1100;
  FUSE: TFUSE absolute $1280;
  LOCKBIT: TLOCKBIT absolute $128A;
  USERROW: TUSERROW absolute $1300;

implementation
{$define RELBRANCHES}
{$i avrcommon.inc}

procedure CRCSCAN_NMI_ISR; external name 'CRCSCAN_NMI_ISR'; // Interrupt 1 
procedure BOD_VLM_ISR; external name 'BOD_VLM_ISR'; // Interrupt 2 
procedure RTC_CNT_ISR; external name 'RTC_CNT_ISR'; // Interrupt 3 
procedure RTC_PIT_ISR; external name 'RTC_PIT_ISR'; // Interrupt 4 
procedure CCL_CCL_ISR; external name 'CCL_CCL_ISR'; // Interrupt 5 
procedure PORTA_PORT_ISR; external name 'PORTA_PORT_ISR'; // Interrupt 6 
procedure TCA0_LUNF_ISR; external name 'TCA0_LUNF_ISR'; // Interrupt 7 
//procedure TCA0_OVF_ISR; external name 'TCA0_OVF_ISR'; // Interrupt 7 
procedure TCA0_HUNF_ISR; external name 'TCA0_HUNF_ISR'; // Interrupt 8 
procedure TCA0_LCMP0_ISR; external name 'TCA0_LCMP0_ISR'; // Interrupt 9 
//procedure TCA0_CMP0_ISR; external name 'TCA0_CMP0_ISR'; // Interrupt 9 
procedure TCA0_CMP1_ISR; external name 'TCA0_CMP1_ISR'; // Interrupt 10 
//procedure TCA0_LCMP1_ISR; external name 'TCA0_LCMP1_ISR'; // Interrupt 10 
procedure TCA0_CMP2_ISR; external name 'TCA0_CMP2_ISR'; // Interrupt 11 
//procedure TCA0_LCMP2_ISR; external name 'TCA0_LCMP2_ISR'; // Interrupt 11 
procedure TCB0_INT_ISR; external name 'TCB0_INT_ISR'; // Interrupt 12 
procedure TCB1_INT_ISR; external name 'TCB1_INT_ISR'; // Interrupt 13 
procedure TWI0_TWIS_ISR; external name 'TWI0_TWIS_ISR'; // Interrupt 14 
procedure TWI0_TWIM_ISR; external name 'TWI0_TWIM_ISR'; // Interrupt 15 
procedure SPI0_INT_ISR; external name 'SPI0_INT_ISR'; // Interrupt 16 
procedure USART0_RXC_ISR; external name 'USART0_RXC_ISR'; // Interrupt 17 
procedure USART0_DRE_ISR; external name 'USART0_DRE_ISR'; // Interrupt 18 
procedure USART0_TXC_ISR; external name 'USART0_TXC_ISR'; // Interrupt 19 
procedure PORTD_PORT_ISR; external name 'PORTD_PORT_ISR'; // Interrupt 20 
procedure AC0_AC_ISR; external name 'AC0_AC_ISR'; // Interrupt 21 
procedure ADC0_RESRDY_ISR; external name 'ADC0_RESRDY_ISR'; // Interrupt 22 
procedure ADC0_WCOMP_ISR; external name 'ADC0_WCOMP_ISR'; // Interrupt 23 
procedure PORTC_PORT_ISR; external name 'PORTC_PORT_ISR'; // Interrupt 24 
procedure TCB2_INT_ISR; external name 'TCB2_INT_ISR'; // Interrupt 25 
procedure USART1_RXC_ISR; external name 'USART1_RXC_ISR'; // Interrupt 26 
procedure USART1_DRE_ISR; external name 'USART1_DRE_ISR'; // Interrupt 27 
procedure USART1_TXC_ISR; external name 'USART1_TXC_ISR'; // Interrupt 28 
procedure PORTF_PORT_ISR; external name 'PORTF_PORT_ISR'; // Interrupt 29 
procedure NVMCTRL_EE_ISR; external name 'NVMCTRL_EE_ISR'; // Interrupt 30 
procedure USART2_RXC_ISR; external name 'USART2_RXC_ISR'; // Interrupt 31 
procedure USART2_DRE_ISR; external name 'USART2_DRE_ISR'; // Interrupt 32 
procedure USART2_TXC_ISR; external name 'USART2_TXC_ISR'; // Interrupt 33 
procedure PORTB_PORT_ISR; external name 'PORTB_PORT_ISR'; // Interrupt 34 
procedure PORTE_PORT_ISR; external name 'PORTE_PORT_ISR'; // Interrupt 35 
procedure TCB3_INT_ISR; external name 'TCB3_INT_ISR'; // Interrupt 36 
procedure USART3_RXC_ISR; external name 'USART3_RXC_ISR'; // Interrupt 37 
procedure USART3_DRE_ISR; external name 'USART3_DRE_ISR'; // Interrupt 38 
procedure USART3_TXC_ISR; external name 'USART3_TXC_ISR'; // Interrupt 39 

procedure _FPC_start; assembler; nostackframe;
label
  _start;
asm
  .init
  .globl _start

  rjmp _start
  rjmp CRCSCAN_NMI_ISR
  rjmp BOD_VLM_ISR
  rjmp RTC_CNT_ISR
  rjmp RTC_PIT_ISR
  rjmp CCL_CCL_ISR
  rjmp PORTA_PORT_ISR
  rjmp TCA0_LUNF_ISR
//  rjmp TCA0_OVF_ISR
  rjmp TCA0_HUNF_ISR
  rjmp TCA0_LCMP0_ISR
//  rjmp TCA0_CMP0_ISR
  rjmp TCA0_CMP1_ISR
//  rjmp TCA0_LCMP1_ISR
  rjmp TCA0_CMP2_ISR
//  rjmp TCA0_LCMP2_ISR
  rjmp TCB0_INT_ISR
  rjmp TCB1_INT_ISR
  rjmp TWI0_TWIS_ISR
  rjmp TWI0_TWIM_ISR
  rjmp SPI0_INT_ISR
  rjmp USART0_RXC_ISR
  rjmp USART0_DRE_ISR
  rjmp USART0_TXC_ISR
  rjmp PORTD_PORT_ISR
  rjmp AC0_AC_ISR
  rjmp ADC0_RESRDY_ISR
  rjmp ADC0_WCOMP_ISR
  rjmp PORTC_PORT_ISR
  rjmp TCB2_INT_ISR
  rjmp USART1_RXC_ISR
  rjmp USART1_DRE_ISR
  rjmp USART1_TXC_ISR
  rjmp PORTF_PORT_ISR
  rjmp NVMCTRL_EE_ISR
  rjmp USART2_RXC_ISR
  rjmp USART2_DRE_ISR
  rjmp USART2_TXC_ISR
  rjmp PORTB_PORT_ISR
  rjmp PORTE_PORT_ISR
  rjmp TCB3_INT_ISR
  rjmp USART3_RXC_ISR
  rjmp USART3_DRE_ISR
  rjmp USART3_TXC_ISR

  {$i start.inc}

  .weak CRCSCAN_NMI_ISR
  .weak BOD_VLM_ISR
  .weak RTC_CNT_ISR
  .weak RTC_PIT_ISR
  .weak CCL_CCL_ISR
  .weak PORTA_PORT_ISR
  .weak TCA0_LUNF_ISR
//  .weak TCA0_OVF_ISR
  .weak TCA0_HUNF_ISR
  .weak TCA0_LCMP0_ISR
//  .weak TCA0_CMP0_ISR
  .weak TCA0_CMP1_ISR
//  .weak TCA0_LCMP1_ISR
  .weak TCA0_CMP2_ISR
//  .weak TCA0_LCMP2_ISR
  .weak TCB0_INT_ISR
  .weak TCB1_INT_ISR
  .weak TWI0_TWIS_ISR
  .weak TWI0_TWIM_ISR
  .weak SPI0_INT_ISR
  .weak USART0_RXC_ISR
  .weak USART0_DRE_ISR
  .weak USART0_TXC_ISR
  .weak PORTD_PORT_ISR
  .weak AC0_AC_ISR
  .weak ADC0_RESRDY_ISR
  .weak ADC0_WCOMP_ISR
  .weak PORTC_PORT_ISR
  .weak TCB2_INT_ISR
  .weak USART1_RXC_ISR
  .weak USART1_DRE_ISR
  .weak USART1_TXC_ISR
  .weak PORTF_PORT_ISR
  .weak NVMCTRL_EE_ISR
  .weak USART2_RXC_ISR
  .weak USART2_DRE_ISR
  .weak USART2_TXC_ISR
  .weak PORTB_PORT_ISR
  .weak PORTE_PORT_ISR
  .weak TCB3_INT_ISR
  .weak USART3_RXC_ISR
  .weak USART3_DRE_ISR
  .weak USART3_TXC_ISR

  .set CRCSCAN_NMI_ISR, Default_IRQ_handler
  .set BOD_VLM_ISR, Default_IRQ_handler
  .set RTC_CNT_ISR, Default_IRQ_handler
  .set RTC_PIT_ISR, Default_IRQ_handler
  .set CCL_CCL_ISR, Default_IRQ_handler
  .set PORTA_PORT_ISR, Default_IRQ_handler
  .set TCA0_LUNF_ISR, Default_IRQ_handler
//  .set TCA0_OVF_ISR, Default_IRQ_handler
  .set TCA0_HUNF_ISR, Default_IRQ_handler
  .set TCA0_LCMP0_ISR, Default_IRQ_handler
//  .set TCA0_CMP0_ISR, Default_IRQ_handler
  .set TCA0_CMP1_ISR, Default_IRQ_handler
//  .set TCA0_LCMP1_ISR, Default_IRQ_handler
  .set TCA0_CMP2_ISR, Default_IRQ_handler
//  .set TCA0_LCMP2_ISR, Default_IRQ_handler
  .set TCB0_INT_ISR, Default_IRQ_handler
  .set TCB1_INT_ISR, Default_IRQ_handler
  .set TWI0_TWIS_ISR, Default_IRQ_handler
  .set TWI0_TWIM_ISR, Default_IRQ_handler
  .set SPI0_INT_ISR, Default_IRQ_handler
  .set USART0_RXC_ISR, Default_IRQ_handler
  .set USART0_DRE_ISR, Default_IRQ_handler
  .set USART0_TXC_ISR, Default_IRQ_handler
  .set PORTD_PORT_ISR, Default_IRQ_handler
  .set AC0_AC_ISR, Default_IRQ_handler
  .set ADC0_RESRDY_ISR, Default_IRQ_handler
  .set ADC0_WCOMP_ISR, Default_IRQ_handler
  .set PORTC_PORT_ISR, Default_IRQ_handler
  .set TCB2_INT_ISR, Default_IRQ_handler
  .set USART1_RXC_ISR, Default_IRQ_handler
  .set USART1_DRE_ISR, Default_IRQ_handler
  .set USART1_TXC_ISR, Default_IRQ_handler
  .set PORTF_PORT_ISR, Default_IRQ_handler
  .set NVMCTRL_EE_ISR, Default_IRQ_handler
  .set USART2_RXC_ISR, Default_IRQ_handler
  .set USART2_DRE_ISR, Default_IRQ_handler
  .set USART2_TXC_ISR, Default_IRQ_handler
  .set PORTB_PORT_ISR, Default_IRQ_handler
  .set PORTE_PORT_ISR, Default_IRQ_handler
  .set TCB3_INT_ISR, Default_IRQ_handler
  .set USART3_RXC_ISR, Default_IRQ_handler
  .set USART3_DRE_ISR, Default_IRQ_handler
  .set USART3_TXC_ISR, Default_IRQ_handler
end;

end.
