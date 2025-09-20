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