/*-----------------------------------------------------------------
File name     : top.sv
Description   : lab01_data top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module top;
// import the UVM library
// include the UVM macros
    import uvm_pkg::*;
    `include "uvm_macros.svh"

// import the YAPP package
    import yapp_pkg::*;

// generate 5 random packets and use the print method
// to display the results
    yapp_packet my_packet = new("my_packet");

    initial begin
        for(int i = 0; i < 5; i++) begin
            my_packet.randomize();
            my_packet.print();
        end
    end

// experiment with the copy, clone and compare UVM method

endmodule : top
