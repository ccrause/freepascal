Free Pascal Compiler - an open source Object Pascal compiler. This is an unofficial mirror of the FPC SubVersion repository and is used for experimental testing of new AVR controller related features.

# ~~Bug~~ Fixed in rev. 43390
~~The test program below succeeds when compiled without optimization, but fails when compiled with optimization (-O1 or -O2). The problem appears to originate in tcgcallnode.pass_generate_code where registers are allocated for procedure parameters, then deallocated (freeparas) before the actual procedure call instruction. The non-volatile registers r0, r1, r18-r27, r30-r31 are then separately (re)allocated just after freeparas are called.  This prevents issues when the registers required for the parameters fit in r18 - r25.  In the example code below the 2x 64 bit parameters are allocated to r10-r25.~~

```
program tshlshr;

procedure test(value, required: int64);
begin
  if value <> required then
    halt(1)
  else
    halt(0);
end;

var
 longres : longint;

begin
   longres := 32768;
   test(longres, 32768);
end.
```

# ~~Fix~~ Not required anymore
~~The fix proposed here is to move the `freeparas` call to after the hlcg.a_load_XX calls which generate the call instruction.  This ensures that all the registers allocated for the parameters remain marked as allocated until after the procedure gets called.~~
