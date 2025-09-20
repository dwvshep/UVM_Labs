class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    router_tb tb;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("BASE_TEST_CLASS", "Build Phase!", UVM_HIGH)
        tb = router_tb::type_id::create("tb", this);
        uvm_config_int::set(this, "*", "recording_detail", 1);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

    virtual function void check_phase(uvm_phase phase);
        check_config_usage();
    endfunction

    virtual task run_phase(uvm_phase phase);
        uvm_objection obj = phase.get_objection();
        obj.set_drain_time(this, 200ns);
        super.run_phase(phase);
    endtask

endclass: base_test


class short_packet_test extends base_test;

    `uvm_component_utils(short_packet_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        super.build_phase(phase);
        uvm_config_wrapper::set(this, "tb.env.agent.sequencer.run_phase",
                                "default_sequence",
                                yapp_5_packets::get_type());
    endfunction

endclass: short_packet_test


class set_config_test extends base_test;

    `uvm_component_utils(set_config_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        uvm_config_int::set(this, "tb.env.agent", "is_active", UVM_PASSIVE);
        super.build_phase(phase);
    endfunction

endclass: set_config_test


class incr_payload_test extends base_test;

    `uvm_component_utils(incr_payload_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        uvm_config_wrapper::set(this, "tb.env.agent.sequencer.run_phase",
                                "default_sequence",
                                yapp_incr_payload_seq::get_type());
        super.build_phase(phase);
    endfunction

endclass : incr_payload_test


class exhaustive_seq_test extends base_test;

    `uvm_component_utils(exhaustive_seq_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        uvm_config_wrapper::set(this, "tb.env.agent.sequencer.run_phase",
                                "default_sequence",
                                yapp_exhaustive_seq::get_type());
        super.build_phase(phase);
    endfunction

endclass : exhaustive_seq_test


class yapp_012_test extends base_test;

    `uvm_component_utils(yapp_012_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        uvm_config_wrapper::set(this, "tb.env.agent.sequencer.run_phase",
                                "default_sequence",
                                yapp_012_seq::get_type());
        super.build_phase(phase);
    endfunction

endclass : yapp_012_test


class simple_test extends base_test;

    `uvm_component_utils(simple_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        uvm_config_wrapper::set(this, "tb.env.agent.sequencer.run_phase",
                                "default_sequence",
                                yapp_012_seq::get_type());
        uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase",
                                "default_sequence",
                                channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.clk_rst.agent.sequencer.run_phase",
                                "default_sequence",
                                clk10_rst5_seq::get_type());
        super.build_phase(phase);
    endfunction

endclass: simple_test


class simple_mctest extends base_test;
    
    `uvm_component_utils(simple_mctest)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        //set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase",
                                "default_sequence",
                                channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.clk_rst.agent.sequencer.run_phase",
                                "default_sequence",
                                clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "tb.r_mcseqr.run_phase",
                                "default_sequence",
                                router_simple_mcseq::get_type());
        super.build_phase(phase);
    endfunction

endclass: simple_mctest


class  uvm_reset_test extends base_test;

    uvm_reg_hw_reset_seq reset_seq;

  // component macro
  `uvm_component_utils(uvm_reset_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      reset_seq = uvm_reg_hw_reset_seq::type_id::create("uvm_reset_seq");
      uvm_config_wrapper::set(this, "tb.clk_rst.agent.sequencer.run_phase",
                                "default_sequence",
                                clk10_rst5_seq::get_type());
      super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase (uvm_phase phase);
     phase.raise_objection(this, "Raising Objection to run uvm built in reset test");
     // Set the model property of the sequence to our Register Model instance
     // Update the RHS of this assignment to match your instance names. Syntax is:
     //  <testbench instance>.<register model instance>
     reset_seq.model = tb.yapp_rm;
     // Execute the sequence (sequencer is already set in the testbench)
     reset_seq.start(null);
     phase.drop_objection(this," Dropping Objection to uvm built reset test finished");
     
     
  endtask

endclass : uvm_reset_test


class reg_access_test extends base_test;

    uvm_reg_hw_reset_seq reset_seq;
    yapp_regs_c yapp_regs;
    uvm_status_e status;

    int read_data = 0;

  // component macro
  `uvm_component_utils(reg_access_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);

  endfunction : new

  function void build_phase(uvm_phase phase);
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      reset_seq = uvm_reg_hw_reset_seq::type_id::create("uvm_reset_seq");
      uvm_config_wrapper::set(this, "tb.clk_rst.agent.sequencer.run_phase",
                                "default_sequence",
                                clk10_rst5_seq::get_type());
      super.build_phase(phase);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    yapp_regs = tb.yapp_rm.router_yapp_regs;
  endfunction

  virtual task run_phase (uvm_phase phase);
     phase.raise_objection(this, "Raising Objection to run uvm built in reset test");
     // Set the model property of the sequence to our Register Model instance
     // Update the RHS of this assignment to match your instance names. Syntax is:
     //  <testbench instance>.<register model instance>
     reset_seq.model = tb.yapp_rm;
     // Execute the sequence (sequencer is already set in the testbench)
     `uvm_info(get_type_name(), "Ctrl Reg Write", UVM_NONE)
     yapp_regs.ctrl_reg.write(status, 8'h20);
     `uvm_info(get_type_name(), "Ctrl Reg Peek", UVM_NONE)
     yapp_regs.ctrl_reg.peek(status, read_data);
     if (read_data != 8'h20) begin
        `uvm_error(get_type_name(), $sformatf("Peeked register value: (%0h) different from written value: (%0h)", read_data, 8'h20))
     end
     `uvm_info(get_type_name(), "Ctrl Reg Poke", UVM_NONE)
     yapp_regs.ctrl_reg.poke(status, 8'h02);
     `uvm_info(get_type_name(), "Ctrl Reg Read", UVM_NONE)
     yapp_regs.ctrl_reg.read(status, read_data);
     if (read_data != 8'h02) begin
        `uvm_error(get_type_name(), $sformatf("Read register value: (%0h) different from poked value: (%0h)", read_data, 8'h02))
     end
     `uvm_info(get_type_name(), "Ctrl Reg Poke", UVM_NONE)
     yapp_regs.addr3_cnt_reg.poke(status, 8'h20);
     `uvm_info(get_type_name(), "Ctrl Reg Read", UVM_NONE)
     yapp_regs.addr3_cnt_reg.read(status, read_data);
     if (read_data != 8'h20) begin
        `uvm_error(get_type_name(), $sformatf("Read register value: (%0h) different from poked value: (%0h)", read_data, 8'h20))
     end
     `uvm_info(get_type_name(), "Ctrl Reg Write", UVM_NONE)
     yapp_regs.addr3_cnt_reg.write(status, 8'h02);
     `uvm_info(get_type_name(), "Ctrl Reg Peek", UVM_NONE)
     yapp_regs.addr3_cnt_reg.peek(status, read_data);
     if (read_data != 8'h20) begin
        `uvm_error(get_type_name(), $sformatf("Peeked register value: (%0h) different from originally poked value: (%0h)", read_data, 8'h20))
     end

     //reset_seq.start(null);
     phase.drop_objection(this," Dropping Objection to uvm built reset test finished");
     
  endtask

endclass : reg_access_test


class reg_function_test extends base_test;

    //uvm_reg_hw_reset_seq reset_seq;
    yapp_regs_c yapp_regs;
    uvm_status_e status;
    yapp_tx_sequencer yapp_seqr;
    yapp_012_seq y012;

    int read_data = 0;

  // component macro
  `uvm_component_utils(reg_function_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);

  endfunction : new

  function void build_phase(uvm_phase phase);
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      //reset_seq = uvm_reg_hw_reset_seq::type_id::create("uvm_reset_seq");
      uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase",
                                "default_sequence",
                                channel_rx_resp_seq::get_type());
      uvm_config_wrapper::set(this, "tb.clk_rst.agent.sequencer.run_phase",
                                "default_sequence",
                                clk10_rst5_seq::get_type());
      y012 = yapp_012_seq::type_id::create("y012", this);
      super.build_phase(phase);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    yapp_regs = tb.yapp_rm.router_yapp_regs;
    yapp_seqr = tb.yapp.agent.sequencer;
  endfunction

  virtual task run_phase (uvm_phase phase);
     phase.raise_objection(this, "Raising Objection to run uvm built in reset test");
     // Set the model property of the sequence to our Register Model instance
     // Update the RHS of this assignment to match your instance names. Syntax is:
     //  <testbench instance>.<register model instance>
     //reset_seq.model = tb.yapp_rm;
     // Execute the sequence (sequencer is already set in the testbench)
     yapp_regs.en_reg.write(status, 8'h01);
     yapp_regs.en_reg.read(status, read_data);
     if (read_data != 8'h01) begin
        `uvm_error(get_type_name(), $sformatf("Enable Reg value: (%0h) different from written value: (%0h)", read_data, 8'h01))
     end
     y012.start(yapp_seqr);
     yapp_regs.addr0_cnt_reg.read(status, read_data);
     if (read_data != 8'h00) begin
        `uvm_error(get_type_name(), $sformatf("Addr 0 Count Reg value: (%0h) is nonzero", read_data))
     end
     yapp_regs.addr1_cnt_reg.read(status, read_data);
     if (read_data != 8'h00) begin
        `uvm_error(get_type_name(), $sformatf("Addr 1 Count Reg value: (%0h) is nonzero", read_data))
     end
     yapp_regs.addr2_cnt_reg.read(status, read_data);
     if (read_data != 8'h00) begin
        `uvm_error(get_type_name(), $sformatf("Addr 2 Count Reg value: (%0h) is nonzero", read_data))
     end
     yapp_regs.addr3_cnt_reg.read(status, read_data);
     if (read_data != 8'h00) begin
        `uvm_error(get_type_name(), $sformatf("Addr 3 Count Reg value: (%0h) is nonzero", read_data))
     end
     yapp_regs.en_reg.write(status, 8'hFF);
     y012.start(yapp_seqr);
     y012.start(yapp_seqr);
     yapp_regs.addr0_cnt_reg.read(status, read_data);
     if (read_data != 8'h02) begin
        `uvm_error(get_type_name(), $sformatf("Addr 0 Count Reg value: (%0h) is different from expected count (%0h)", read_data, 2))
     end
     yapp_regs.addr1_cnt_reg.read(status, read_data);
     if (read_data != 8'h02) begin
        `uvm_error(get_type_name(), $sformatf("Addr 1 Count Reg value: (%0h) is different from expected count (%0h)", read_data, 2))
     end
     yapp_regs.addr2_cnt_reg.read(status, read_data);
     if (read_data != 8'h02) begin
        `uvm_error(get_type_name(), $sformatf("Addr 2 Count Reg value: (%0h) is different from expected count (%0h)", read_data, 2))
     end
     yapp_regs.addr3_cnt_reg.read(status, read_data);
     if (read_data != 8'h00) begin
        `uvm_error(get_type_name(), $sformatf("Addr 3 Count Reg value: (%0h) is nonzero", read_data))
     end
     //reset_seq.start(null);
     phase.drop_objection(this," Dropping Objection to uvm built reset test finished");
     
  endtask

endclass : reg_function_test