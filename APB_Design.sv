module apb(pclk, prst, pwrite, psel, penable, pwdata, pready, paddr, prdata);
  
  input pclk, prst;
  input pwrite;
  input [5:0] paddr;  // Address for accessing peripheral registers
  input psel, penable;  // Select and enable signals
  input pready;  // Ready signal from the peripheral
  input [31:0] pwdata;  // Data to be written to the peripheral
  
  output reg [31:0] prdata;  // Data read from the peripheral
  reg [31:0] mem[31:0];  // Memory to simulate peripheral registers
  
  // State encoding for the APB state machine
  parameter idle = 0;
  parameter setup = 1;
  parameter write = 2;
  parameter read = 3;
  reg [1:0] apb_st;  // Current state of the APB state machine
  
  // APB state machine operation
  always @(posedge pclk or posedge prst) begin
    if (prst == 1) begin
      prdata = 0;  // Reset read data
      apb_st = idle;  // Reset state to idle
    end else begin
      case (apb_st)
        idle: begin
          if (psel && !penable) begin
            apb_st = setup;  // Move to setup state when a peripheral is selected
          end else begin
            apb_st = idle;  // Remain in idle state
          end
        end
        setup: begin
          if (pwrite) begin
            apb_st = write;  // Move to write state if pwrite is high
          end else begin
            apb_st = read;  // Move to read state if pwrite is low
          end
        end
        write: begin
          if (psel && penable && pwrite) begin
            mem[paddr] = pwdata;  // Write data to the peripheral register
            if (!pready) begin
              apb_st = write;  // Wait if the peripheral is not ready
            end else begin
              apb_st = setup;  // Return to setup state
            end
          end
        end
        read: begin
          if (psel && penable && !pwrite) begin
            prdata = mem[paddr];  // Read data from the peripheral register
            if (!pready) begin
              apb_st = read;  // Wait if the peripheral is not ready
            end else begin
              apb_st = setup;  // Return to setup state
            end
          end
        end
      endcase
    end
  end

endmodule