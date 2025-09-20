class router_reference extends uvm_component;

    `uvm_component_utils(router_reference)

    `uvm_analysis_imp_decl(_yapp)
    `uvm_analysis_imp_decl(_hbus)

    uvm_analysis_imp_yapp #(yapp_packet, router_reference) yapp_in;
    uvm_analysis_imp_hbus #(hbus_transaction, router_reference) hbus_in;

    uvm_analysis_port #(yapp_packet) valid_yapp_port;

    bit [7:0] maxpktsize = 8'h3F;
    bit [7:0] router_en = 1'b1;

    int disabled_count = 0;
    int invalid_addr_count = 0;
    int invalid_length_count = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        yapp_in = new("yapp_in", this);
        hbus_in = new("hbus_in", this);
        valid_yapp_port = new("valid_yapp_port", this);
    endfunction

    function write_hbus(input hbus_transaction hbus_trxn);
        if(hbus_trxn.haddr == 16'h1000 && hbus_trxn.hwr_rd == HBUS_WRITE) begin
            maxpktsize = hbus_trxn.hdata;
        end
        if(hbus_trxn.haddr == 16'h1001 && hbus_trxn.hwr_rd == HBUS_WRITE) begin
            router_en = hbus_trxn.hdata;
        end
    endfunction

    function write_yapp(input yapp_packet packet);
        if(!router_en) begin
            disabled_count++;
        end else if(packet.length > maxpktsize) begin
            invalid_length_count++;
        end else if(packet.addr == 3) begin
            invalid_addr_count++;
        end else begin
            valid_yapp_port.write(packet);
        end
    endfunction

endclass: router_reference