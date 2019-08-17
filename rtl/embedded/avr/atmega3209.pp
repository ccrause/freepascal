unit ATmega3209;

{$goto on}
interface

type
  TAC = record //Analog Comparator
    CTRLA: byte;  //Control A
    Reserved1: byte;
    MUXCTRLA: byte;  //Mux Control A
    Reserved3: byte;
    DACREF: byte;  //Referance scale control
    Reserved5: byte;
    INTCTRL: byte;  //Interrupt Control
    STATUS: byte;  //Status
  end;

  TADC = record //Analog to Digital Converter
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
    Reserved23: byte;
  end;

  TBOD = record //Bod interface
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
    Reserved12: byte;
    Reserved13: byte;
    Reserved14: byte;
    Reserved15: byte;
  end;

  TCCL = record //Configurable Custom Logic
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
    Reserved24: byte;
    Reserved25: byte;
    Reserved26: byte;
    Reserved27: byte;
    Reserved28: byte;
    Reserved29: byte;
    Reserved30: byte;
    Reserved31: byte;
    Reserved32: byte;
    Reserved33: byte;
    Reserved34: byte;
    Reserved35: byte;
    Reserved36: byte;
    Reserved37: byte;
    Reserved38: byte;
    Reserved39: byte;
    Reserved40: byte;
    Reserved41: byte;
    Reserved42: byte;
    Reserved43: byte;
    Reserved44: byte;
    Reserved45: byte;
    Reserved46: byte;
    Reserved47: byte;
    Reserved48: byte;
    Reserved49: byte;
    Reserved50: byte;
    Reserved51: byte;
    Reserved52: byte;
    Reserved53: byte;
    Reserved54: byte;
    Reserved55: byte;
    Reserved56: byte;
    Reserved57: byte;
    Reserved58: byte;
    Reserved59: byte;
    Reserved60: byte;
    Reserved61: byte;
    Reserved62: byte;
    Reserved63: byte;
  end;

  TCLKCTRL = record //Clock controller
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
    OSC32KCALIB: byte;  //OSC32K Calibration
    Reserved26: byte;
    Reserved27: byte;
    XOSC32KCTRLA: byte;  //XOSC32K Control A
    Reserved29: byte;
    Reserved30: byte;
    Reserved31: byte;
  end;

  TCPU = record //CPU
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
    RAMPZ: byte;  //Extended Z-pointer Register
    Reserved12: byte;
    SPL: byte;  //Stack Pointer Low
    SPH: byte;  //Stack Pointer High
    SREG: byte;  //Status Register
  end;

  TCPUINT = record //Interrupt Controller
    CTRLA: byte;  //Control A
    STATUS: byte;  //Status
    LVL0PRI: byte;  //Interrupt Level 0 Priority
    LVL1VEC: byte;  //Interrupt Level 1 Priority Vector
  end;

  TCRCSCAN = record //CRCSCAN
    CTRLA: byte;  //Control A
    CTRLB: byte;  //Control B
    STATUS: byte;  //Status
    Reserved3: byte;
  end;

  TEVSYS = record //Event System
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
    Reserved56: byte;
    Reserved57: byte;
    Reserved58: byte;
    Reserved59: byte;
    Reserved60: byte;
    Reserved61: byte;
    Reserved62: byte;
    Reserved63: byte;
  end;

  TFUSE = record //Fuses
    WDTCFG: byte;  //Watchdog Configuration
    BODCFG: byte;  //BOD Configuration
    OSCCFG: byte;  //Oscillator Configuration
    Reserved3: byte;
    Reserved4: byte;
    SYSCFG0: byte;  //System Configuration 0
    SYSCFG1: byte;  //System Configuration 1
    APPEND: byte;  //Application Code Section End
    BOOTEND: byte;  //Boot Section End
  end;

  TGPIO = record //General Purpose IO
    GPIOR0: byte;  //General Purpose IO Register 0
    GPIOR1: byte;  //General Purpose IO Register 1
    GPIOR2: byte;  //General Purpose IO Register 2
    GPIOR3: byte;  //General Purpose IO Register 3
  end;

  TLOCKBIT = record //Lockbit
    LOCKBIT: byte;  //Lock Bits
    Reserved1: byte;
  end;

  TNVMCTRL = record //Non-volatile Memory Controller
    CTRLA: byte;  //Control A
    CTRLB: byte;  //Control B
    STATUS: byte;  //Status
    INTCTRL: byte;  //Interrupt Control
    INTFLAGS: byte;  //Interrupt Flags
    Reserved5: byte;
    DATA: word;  //Data
    ADDR: word;  //Address
    Reserved10: byte;
    Reserved11: byte;
    Reserved12: byte;
    Reserved13: byte;
    Reserved14: byte;
    Reserved15: byte;
  end;

  TPORT = record //I/O Ports
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
    Reserved24: byte;
    Reserved25: byte;
    Reserved26: byte;
    Reserved27: byte;
    Reserved28: byte;
    Reserved29: byte;
    Reserved30: byte;
    Reserved31: byte;
  end;

  TPORTMUX = record //Port Multiplexer
    EVSYSROUTEA: byte;  //Port Multiplexer EVSYS
    CCLROUTEA: byte;  //Port Multiplexer CCL
    USARTROUTEA: byte;  //Port Multiplexer USART register A
    TWISPIROUTEA: byte;  //Port Multiplexer TWI and SPI
    TCAROUTEA: byte;  //Port Multiplexer TCA
    TCBROUTEA: byte;  //Port Multiplexer TCB
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
  end;

  TRSTCTRL = record //Reset controller
    RSTFR: byte;  //Reset Flags
    SWRR: byte;  //Software Reset
    Reserved2: byte;
    Reserved3: byte;
  end;

  TRTC = record //Real-Time Counter
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
  end;

  TSIGROW = record //Signature row
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
    Reserved48: byte;
    Reserved49: byte;
    Reserved50: byte;
    Reserved51: byte;
    Reserved52: byte;
    Reserved53: byte;
    Reserved54: byte;
    Reserved55: byte;
    Reserved56: byte;
    Reserved57: byte;
    Reserved58: byte;
    Reserved59: byte;
    Reserved60: byte;
    Reserved61: byte;
    Reserved62: byte;
    Reserved63: byte;
  end;

  TSLPCTRL = record //Sleep Controller
    CTRLA: byte;  //Control
    Reserved1: byte;
  end;

  TSPI = record //Serial Peripheral Interface
    CTRLA: byte;  //Control A
    CTRLB: byte;  //Control B
    INTCTRL: byte;  //Interrupt Control
    INTFLAGS: byte;  //Interrupt Flags
    DATA: byte;  //Data
    Reserved5: byte;
    Reserved6: byte;
    Reserved7: byte;
  end;

  TSYSCFG = record //System Configuration Registers
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
    Reserved26: byte;
    Reserved27: byte;
    Reserved28: byte;
    Reserved29: byte;
    Reserved30: byte;
    Reserved31: byte;
  end;

  TTCA_SINGLE = record //16-bit Timer/Counter Type A - Single Mode
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
    Reserved62: byte;
    Reserved63: byte;
  end;

  TTCA_SPLIT = record //16-bit Timer/Counter Type A - Split Mode
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
    Reserved46: byte;
    Reserved47: byte;
    Reserved48: byte;
    Reserved49: byte;
    Reserved50: byte;
    Reserved51: byte;
    Reserved52: byte;
    Reserved53: byte;
    Reserved54: byte;
    Reserved55: byte;
    Reserved56: byte;
    Reserved57: byte;
    Reserved58: byte;
    Reserved59: byte;
    Reserved60: byte;
    Reserved61: byte;
    Reserved62: byte;
    Reserved63: byte;
  end;

  TTCA = record //16-bit Timer/Counter Type A
    case byte of
    0: (SINGLE: TTCA_SINGLE);
    1: (SPLIT: TTCA_SPLIT);
    end;

  TTCB = record //16-bit Timer Type B
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
    Reserved14: byte;
    Reserved15: byte;
  end;

  TTWI = record //Two-Wire Interface
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
    Reserved15: byte;
  end;

  TUSART = record //Universal Synchronous and Asynchronous Receiver and Transmitter
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
    Reserved15: byte;
  end;

  TUSERROW = record //User Row
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

  TVPORT = record //Virtual Ports
    DIR: byte;  //Data Direction
    OUT_: byte;  //Output Value
    IN_: byte;  //Input Value
    INTFLAGS: byte;  //Interrupt Flags
  end;

  TVREF = record //Voltage reference
    CTRLA: byte;  //Control A
    CTRLB: byte;  //Control B
  end;

  TWDT = record //Watch-Dog Timer
    CTRLA: byte;  //Control A
    STATUS: byte;  //Status
  end;

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

  jmp _start
  jmp CRCSCAN_NMI_ISR
  jmp BOD_VLM_ISR
  jmp RTC_CNT_ISR
  jmp RTC_PIT_ISR
  jmp CCL_CCL_ISR
  jmp PORTA_PORT_ISR
  jmp TCA0_LUNF_ISR
//  jmp TCA0_OVF_ISR
  jmp TCA0_HUNF_ISR
  jmp TCA0_LCMP0_ISR
//  jmp TCA0_CMP0_ISR
  jmp TCA0_CMP1_ISR
//  jmp TCA0_LCMP1_ISR
  jmp TCA0_CMP2_ISR
//  jmp TCA0_LCMP2_ISR
  jmp TCB0_INT_ISR
  jmp TCB1_INT_ISR
  jmp TWI0_TWIS_ISR
  jmp TWI0_TWIM_ISR
  jmp SPI0_INT_ISR
  jmp USART0_RXC_ISR
  jmp USART0_DRE_ISR
  jmp USART0_TXC_ISR
  jmp PORTD_PORT_ISR
  jmp AC0_AC_ISR
  jmp ADC0_RESRDY_ISR
  jmp ADC0_WCOMP_ISR
  jmp PORTC_PORT_ISR
  jmp TCB2_INT_ISR
  jmp USART1_RXC_ISR
  jmp USART1_DRE_ISR
  jmp USART1_TXC_ISR
  jmp PORTF_PORT_ISR
  jmp NVMCTRL_EE_ISR
  jmp USART2_RXC_ISR
  jmp USART2_DRE_ISR
  jmp USART2_TXC_ISR
  jmp PORTB_PORT_ISR
  jmp PORTE_PORT_ISR
  jmp TCB3_INT_ISR
  jmp USART3_RXC_ISR
  jmp USART3_DRE_ISR
  jmp USART3_TXC_ISR

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

