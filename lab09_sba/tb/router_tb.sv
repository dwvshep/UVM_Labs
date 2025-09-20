class router_tb extends uvm_env;

    `uvm_component_utils(router_tb)

    yapp_env yapp;
    channel_env chan0;
    channel_env chan1;
    channel_env chan2;
    hbus_env hbus;
    clock_and_reset_env clk_rst;
    router_mcsequencer r_mcseqr;
    router_scoreboard r_scb;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("ROUTER_TB_CLASS", "Build Phase!", UVM_HIGH)
        uvm_config_int::set(this, "chan0", "channel_id", 0);
        uvm_config_int::set(this, "chan1", "channel_id", 1);
        uvm_config_int::set(this, "chan2", "channel_id", 2);
        uvm_config_int::set(this, "hbus", "num_masters", 1);
        uvm_config_int::set(this, "hbus", "num_slaves", 0);
        yapp = yapp_env::type_id::create("yapp", this);
        chan0 = channel_env::type_id::create("chan0", this);
        chan1 = channel_env::type_id::create("chan1", this);
        chan2 = channel_env::type_id::create("chan2", this);
        hbus = hbus_env::type_id::create("hbus", this);
        clk_rst = clock_and_reset_env::type_id::create("clk_rst", this);
        r_mcseqr = router_mcsequencer::type_id::create("r_mcseqr", this);
        r_scb = router_scoreboard::type_id::create("r_scb", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        r_mcseqr.hbus_seqr = hbus.masters[0].sequencer;
        r_mcseqr.yapp_seqr = yapp.agent.sequencer;
        yapp.agent.monitor.yapp_monitor_port.connect(r_scb.yapp_in);
        chan0.rx_agent.monitor.item_collected_port.connect(r_scb.chan0_in);
        chan1.rx_agent.monitor.item_collected_port.connect(r_scb.chan1_in);
        chan2.rx_agent.monitor.item_collected_port.connect(r_scb.chan2_in);
    endfunction




endclass : router_tb