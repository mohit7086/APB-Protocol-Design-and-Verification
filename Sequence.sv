class apb_seq extends uvm_sequence#(apb_seqitem);  // Sequence for APB transactions
  `uvm_object_utils(apb_seq) // Macro to register the class with the UVM factory
  
  // Constructor
  function new(string name = "apb_seq");
    super.new(name); // Initialize base class with given name
  endfunction
  
  // Main task that defines the sequence behavior
  task body();
    repeat (3) // Repeat the following block 3 times
    begin
      // Create a new sequence item
      req = apb_seqitem::type_id::create("req");

      // Start the transaction
      start_item(req);

      // Randomize item with constraints for a write operation
      if (!req.randomize() with {paddr == 3; pwrite == 1;})
        `uvm_info("mem_sequence", $sformatf("Write data wr_data %d", req.pwdata), UVM_MEDIUM);

      // Finish the transaction
      finish_item(req);

      // Create another new sequence item
      req = apb_seqitem::type_id::create("req");

      // Start the transaction
      start_item(req);

      // Randomize item with constraints for a read operation
      if (!req.randomize() with {paddr == 3; pwrite == 0;})
        `uvm_info("mem_sequence", $sformatf("Read data rd_data %d", rsp.prdata), UVM_MEDIUM);

      // Finish the transaction
      finish_item(req);
    end
  endtask

endclass
