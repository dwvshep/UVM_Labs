class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    router_tb tb;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("BASE_TEST_CLASS", "Build Phase!", UVM_HIGH)
        uvm_config_wrapper::set(this, "tb.env.agent.sequencer.run_phase",
                                "default_sequence",
                                yapp_5_packets::get_type());
        tb = new("tb", this);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

endclass: base_test