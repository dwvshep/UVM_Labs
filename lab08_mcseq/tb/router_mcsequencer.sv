class router_mcsequencer extends uvm_sequencer;

    `uvm_component_utils(router_mcsequencer)

    hbus_master_sequencer hbus_seqr;
    yapp_tx_sequencer yapp_seqr;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction



endclass: router_mcsequencer