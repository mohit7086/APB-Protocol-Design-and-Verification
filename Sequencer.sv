class apb_sequencer extends uvm_sequencer#(apb_seqitem);

  // UVM macro for component registration
  `uvm_component_utils(apb_sequencer)
  
  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent); // Initialize base class with name and parent
  endfunction

endclass
