interface apb_inter(input logic pclk, prst);
  
  // Write operation signal
  logic pwrite;      // High for write, low for read
  
  // Address and control signals
  logic [5:0] paddr; // 6-bit address bus
  logic psel;        // High when peripheral is selected
  logic penable;     // High to start data phase
  
  // Handshake and data signals
  logic pready;      // High when peripheral is ready
  logic [31:0] pwdata; // 32-bit write data
  logic [31:0] prdata; // 32-bit read data
  
endinterface
