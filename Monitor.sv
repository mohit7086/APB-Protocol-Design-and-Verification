class apb_mon extends uvm_driver#(apb_seqitem);
  
  virtual apb_inter fi;  // Virtual interface to interact with DUT
  
  `uvm_component_utils(apb_mon)  // Macro for UVM utilities
  
  apb_seqitem sqtm;  // Sequence item to store transaction data
  uvm_analysis_port#(apb_seqitem)  port_collected;  // Port to send observed data
  
  function new(string name = "apb_mon", uvm_component parent=null);
    super.new(name, parent);  // Call parent constructor
    port_collected = new("port_collected",this);  // Initialize analysis port
    sqtm = new();  // Create a new sequence item instance
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);  // Call parent build phase
    if(!uvm_config_db#(virtual apb_inter)::get(this,"","fi.mon",fi))
      `uvm_fatal("no fi", {"Virtual interface must be set for:",get_full_name(),".fi"});  // Error if interface not set
  endfunction
  
  virtual task run_phase(uvm_phase phase);
         forever begin
           @(posedge fi.pclk);  // Trigger on clock edge
        	 sqtm.pwrite = fi.pwrite;  // Capture write signal
    		 sqtm.paddr = fi.paddr;  // Capture address
    		 sqtm.pwdata = fi.pwdata;  // Capture write data
    		 sqtm.prdata = fi.prdata;  // Capture read data
           `uvm_info("MON1", $sformatf("Read Transfer - paddr = %0d, prdata = %0h, pwrite = %0d", sqtm.paddr, sqtm.prdata, sqtm.pwrite), UVM_LOW);  // Log transaction details
           port_collected.write(sqtm);  // Send the captured transaction to the analysis port
         end
  endtask 
endclass
