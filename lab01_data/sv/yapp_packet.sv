/*-----------------------------------------------------------------
File name     : yapp_packet.sv
Description   : lab01_data YAPP UVC packet template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

// Define your enumerated type(s) here
typedef enum bit {BAD_PARITY, GOOD_PARITY} parity_type_e;

class yapp_packet extends uvm_sequence_item;

// Follow the lab instructions to create the packet.
// Place the packet declarations in the following order:

  // Define protocol data
  rand logic [1:0] addr;
  rand logic [5:0] length;
  rand logic [7:0] payload[];
  rand logic [7:0] parity;

  // Define control knobs
  rand int packet_delay;
  rand parity_type_e parity_type;

  // Enable automation of the packet's fields
  `uvm_object_utils_begin(yapp_packet)
    `uvm_field_int(addr, UVM_ALL_ON);
    `uvm_field_int(length, UVM_ALL_ON);
    `uvm_field_array_int(payload, UVM_ALL_ON);
    `uvm_field_int(parity, UVM_ALL_ON + UVM_BIN);
    `uvm_field_enum(parity_type_e, parity_type, UVM_ALL_ON);
    `uvm_field_int(packet_delay, UVM_ALL_ON + UVM_NOCOMPARE);
  `uvm_object_utils_end

  // Define packet constraints
  constraint valid_addr {addr != 3;}

  constraint valid_length {1 <= length && length <= 63;}

  constraint valid_payload_sz {payload.size() == length;}

  constraint parity_type_dist {
    parity_type dist {
      GOOD_PARITY := 5, 
      BAD_PARITY := 1
    };
  }

  constraint valid_delay {1 <= packet_delay && packet_delay <= 20;}

  // Add methods for parity calculation and class construction
  function new(string name = "yapp_packet");
    super.new(name);
  endfunction

  function logic [7:0] calc_parity();
    logic [7:0] parity_c;
    parity_c = {length, addr};
    foreach (payload[i]) begin
      parity_c ^= payload[i];
    end
    return parity_c;
  endfunction

  function void set_parity();
    parity = (parity_type == GOOD_PARITY) ? calc_parity() : ~calc_parity();
  endfunction

  function void post_randomize();
    set_parity();
  endfunction

endclass: yapp_packet
