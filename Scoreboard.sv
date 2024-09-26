class apb_scoreboard extends uvm_scoreboard;

  uvm_analysis_imp #(apb_seqitem, apb_scoreboard) mon_1_item_broadcast_port;
  apb_seqitem pkt_sb_1[$]; // Array to hold received transactions
  bit [31:0] mem_scrb [15:0]; // Memory model to store written data
  
  `uvm_component_utils(apb_scoreboard)

  function new(string name = "apb_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    mon_1_item_broadcast_port = new("mon_1_item_broadcast_port", this);
  endfunction

  function void write(apb_seqitem pkt_1);
    pkt_sb_1.push_back(pkt_1); // Store received transaction in array
  endfunction

  task run_phase(uvm_phase phase);
    apb_seqitem act_tr;

    forever begin
      wait(pkt_sb_1.size() > 0); // Wait until there's a transaction
      act_tr = pkt_sb_1.pop_front(); // Get the first transaction
      
      if (act_tr.pwrite == 1) begin
        mem_scrb[act_tr.paddr] = act_tr.pwdata; // Store written data
      end else begin
        act_tr.prdata = mem_scrb[act_tr.paddr]; // Fetch data for comparison
        
        if (act_tr.prdata == act_tr.pwdata) begin
          `uvm_info(get_type_name(), $sformatf("TEST PASS:: wrdata=%0b  prdata=%0b", act_tr.pwdata, act_tr.prdata), UVM_LOW);
        end else begin
          `uvm_info(get_type_name(), $sformatf("TEST FAIL:: wrdata=%0b  prdata=%0b", act_tr.pwdata, act_tr.prdata), UVM_LOW);
        end
      end
    end
  endtask
endclass
