class apb_seqitem extends uvm_sequence_item;

  // Randomizable fields for the APB transaction
  randc bit pwrite;      // Write signal
  randc bit [31:0] pwdata; // Data to write
  randc bit [5:0] paddr;  // Address for transaction
  bit psel;              // Peripheral select signal
  bit penable;           // Start of transaction
  bit pready;            // Peripheral ready signal
  bit [31:0] prdata;    // Data read from peripheral

  // UVM macros for factory registration and field operations
  `uvm_object_utils_begin(apb_seqitem)
  `uvm_field_int(pwrite, UVM_ALL_ON)
  `uvm_field_int(pwdata, UVM_ALL_ON)
  `uvm_field_int(paddr, UVM_ALL_ON)
  `uvm_field_int(psel, UVM_ALL_ON)
  `uvm_field_int(pready, UVM_ALL_ON)
  `uvm_field_int(prdata, UVM_ALL_ON)
  `uvm_object_utils_end

  // Constructor
  function new(string name="seq_item");
    super.new(name); // Initialize base class
  endfunction

endclass
