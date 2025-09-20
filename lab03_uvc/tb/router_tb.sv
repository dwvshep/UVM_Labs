class router_tb extends uvm_env;

    `uvm_component_utils(router_tb)

    yapp_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("ROUTER_TB_CLASS", "Build Phase!", UVM_HIGH)
        env = new("env", this);
    endfunction




endclass : router_tb