class router_module extends uvm_env;

    `uvm_component_utils(router_module)

    router_scoreboard r_scb;
    router_reference r_ref;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), "Build Phase!", UVM_HIGH)
        r_scb = router_scoreboard::type_id::create("r_scb", this);
        r_ref = router_reference::type_id::create("r_ref", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        r_ref.valid_yapp_port.connect(r_scb.yapp_in);
    endfunction

endclass: router_module