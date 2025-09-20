/*-----------------------------------------------------------------
File name     : hw_top.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab06_vif hardware top module for acceleration
              : Instantiates clock generator and YAPP interface only for testing - no DUT
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module hw_top;

  // Clock and reset signals
  logic [31:0]  clock_period;
  logic         run_clock;
  logic         clock;
  logic         reset;

  // YAPP Interface to the DUT
  yapp_if in0(clock, reset);

  clock_and_reset_if crif(clock, reset, run_clock, clock_period);
  channel_if chan0if(clock, reset);
  channel_if chan1if(clock, reset);
  channel_if chan2if(clock, reset);
  hbus_if hbusif(clock, reset);


  // CLKGEN module generates clock
  clkgen clkgen (
    .clock(clock),
    .run_clock(run_clock),
    .clock_period(clock_period)
  );

  yapp_router dut(
    .reset(reset),
    .clock(clock),
    .error(),

    // YAPP interface
    .in_data(in0.in_data),
    .in_data_vld(in0.in_data_vld),
    .in_suspend(in0.in_suspend),

    // Output Channels
    //Channel 0
    .data_0(chan0if.data),
    .data_vld_0(chan0if.data_vld),
    .suspend_0(chan0if.suspend),
    //Channel 1
    .data_1(chan1if.data),
    .data_vld_1(chan1if.data_vld),
    .suspend_1(chan1if.suspend),
    //Channel 2
    .data_2(chan2if.data),
    .data_vld_2(chan2if.data_vld),
    .suspend_2(chan2if.suspend),

    // HBUS Interface 
    .haddr(hbusif.haddr),
    .hdata(hbusif.hdata_w),
    .hen(hbusif.hen),
    .hwr_rd(hbusif.hwr_rd));


endmodule
