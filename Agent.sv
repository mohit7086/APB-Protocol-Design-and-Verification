`include "apb_seqitem.sv"  // Include the APB sequence item definition
`include "apb_seq.sv"      // Include the APB sequence definition
`include "apb_sequencer.sv" // Include the APB sequencer definition
`include "apb_dri.sv"       // Include the APB driver definition
`include "apb_mon.sv"       // Include the APB monitor definition

class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)  // Macro to register this agent with the UVM factory

  apb_sequencer sqr;  // APB sequencer instance to control the sequence execution
  apb_dri dri;        // APB driver instance to drive the DUT signals based on the sequence
  apb_mon mon;        // APB monitor instance to observe and collect DUT signals
  
  function new(string name = "apb_agent", uvm_component parent = null);
    super.new(name, parent);  // Call the parent constructor to initialize the agent
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);  // Call the parent's build phase to perform standard setup tasks
    // Create and initialize the sequencer, driver, and monitor instances
    sqr = apb_sequencer::type_id::create("sqr", this);  
    dri = apb_dri::type_id::create("dri", this);        
    mon = apb_mon::type_id::create("mon", this);        
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);  // Call the parent's connect phase to establish connections
    // Connect the driver's sequence item port to the sequencer's sequence item export
    dri.seq_item_port.connect(sqr.seq_item_export);
  endfunction
  
endclass
