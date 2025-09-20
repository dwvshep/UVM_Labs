/*-----------------------------------------------------------------
File name     : top.sv
Description   : lab01_data top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module tb_top;
// import the UVM library
// include the UVM macros
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import channel_pkg::*;
    import clock_and_reset_pkg::*;
    import hbus_pkg::*;

// import the YAPP package
    import yapp_pkg::*;

    //import router package
    import router_pkg::*;

    `include "router_mcsequencer.sv"
    `include "router_mcseqs_lib.sv"
    `include "router_tb.sv"
    `include "router_test_lib.sv"

    initial begin
        channel_vif_config::set(null, "uvm_test_top.tb.chan0.*", "vif", hw_top.chan0if);
        channel_vif_config::set(null, "uvm_test_top.tb.chan1.*", "vif", hw_top.chan1if);
        channel_vif_config::set(null, "uvm_test_top.tb.chan2.*", "vif", hw_top.chan2if);
        clock_and_reset_vif_config::set(null, "uvm_test_top.tb.clk_rst.*", "vif", hw_top.crif);
        hbus_vif_config::set(null, "uvm_test_top.tb.hbus.*", "vif", hw_top.hbusif);
        yapp_vif_config::set(null, "uvm_test_top.tb.yapp.*", "vif", hw_top.in0);
        run_test();
    end

endmodule : tb_top
