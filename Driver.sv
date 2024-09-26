class apb_dri extends uvm_driver#(apb_seqitem);

  // Virtual interface to connect with the DUT
  virtual apb_inter fi;
  
  // UVM macro for component registration
  `uvm_component_utils(apb_dri)
  
  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent); // Initialize base class with name and parent
  endfunction
  
  // Build phase to set up the environment
  function void build_phase(uvm_phase phase);
    super.build_phase(phase); // Initialize base class build phase
    // Get the virtual interface from the configuration database
    if (!uvm_config_db#(virtual apb_inter)::get(this, "", "fi.div", fi))
      `uvm_fatal("no fi", {"virtual interface must be set for:", get_full_name(), ".fi"});
  endfunction
  
  // Run phase where the actual driving of transactions occurs
  virtual task run_phase(uvm_phase phase);
    repeat (5) // Repeat the following block 5 times
    begin
      fi.pready <= 1; // Set the ready signal
      
      // Get the next item from the sequence
      seq_item_port.get_next_item(req);
      @(posedge fi.pclk); // Wait for positive edge of the clock
      
      if (req.pwrite) // Check if it is a write operation
      begin
        fi.penable <= 0; // Initially set enable to 0
        @(posedge fi.pclk);
        fi.psel <= 1; // Set the select signal
        // fi.penable <= 1; // (Commented out: Control enable signal timing)
        
        // Set signals based on sequence item
        fi.pwrite <= req.pwrite;
        fi.paddr <= req.paddr;
        fi.pwdata <= req.pwdata;
        `uvm_info("DRV", $sformatf("Write Transfer - paddr = %0d, pwdata = %0h, pwrite = %0d", req.paddr, req.pwdata, req.pwrite), UVM_LOW);
        
        @(posedge fi.pclk);
        fi.pready <= 1;
        fi.penable <= 1; // Enable the transaction
      end
      else // Handle read operations
      begin
        @(posedge fi.pclk);
        fi.psel <= 1; // Set the select signal
        fi.penable <= 1; // Enable the transaction
        
        // Set signals based on sequence item
        fi.pwrite <= req.pwrite;
        fi.paddr <= req.paddr;
        req.prdata <= fi.prdata; // Read data from the interface
        `uvm_info("DRV", $sformatf("Read Transfer - paddr = %0d, prdata = %0h, pwrite = %0d", req.paddr, req.prdata, req.pwrite), UVM_LOW);
        fi.pready <= 1;
      end
      
      // Mark item as done
      seq_item_port.item_done();
    end
  endtask
endclass
