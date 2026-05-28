module timer  
#(parameter FINAL_VALUE = 30)
(
  input clk,
  input reset_n,
  input start,
  output done,
  output [5:0] count
);

localparam BITS = 6;

reg [BITS-1:0] Q;

always @(posedge clk or negedge reset_n)
begin
  if (~reset_n) begin
    Q <= 0;
  end
  else if (start) begin
    Q <= 0;
  end
  else if (Q < 63) begin  // Keep counting up to max value (prevents overflow)
    Q <= Q + 1;
  end
end

assign done = (Q >= FINAL_VALUE);
assign count = Q;

endmodule

module clock_divider
#(parameter DIV_VALUE = 50000000)
(
  input clk_in,
  input reset_n,
  output reg clk_out
);

generate
  if (DIV_VALUE <= 1) begin : passthrough
    always @(posedge clk_in, negedge reset_n)
    begin
      if (~reset_n)
        clk_out <= 0;
      else
        clk_out <= ~clk_out;
    end
  end
  else begin : divider
    localparam BITS = $clog2(DIV_VALUE) + 1;
    reg [BITS-1:0] counter;
    
    always @(posedge clk_in, negedge reset_n)
    begin
      if (~reset_n) begin
        counter <= 0;
        clk_out <= 0;
      end
      else if (counter >= (DIV_VALUE/2 - 1)) begin
        counter <= 0;
        clk_out <= ~clk_out;
      end
      else begin
        counter <= counter + 1;
      end
    end
  end
endgenerate

endmodule

module mux_clock_divider
#(parameter DIV_VALUE = 50000)
(
  input clk_in,
  input reset_n,
  output reg clk_out
);

generate
  if (DIV_VALUE <= 1) begin : passthrough
    always @(posedge clk_in, negedge reset_n)
    begin
      if (~reset_n)
        clk_out <= 0;
      else
        clk_out <= ~clk_out;
    end
  end
  else begin : divider
    localparam BITS = $clog2(DIV_VALUE) + 1;
    reg [BITS-1:0] counter;
    
    always @(posedge clk_in, negedge reset_n)
    begin
      if (~reset_n) begin
        counter <= 0;
        clk_out <= 0;
      end
      else if (counter >= (DIV_VALUE/2 - 1)) begin
        counter <= 0;
        clk_out <= ~clk_out;
      end
      else begin
        counter <= counter + 1;
      end
    end
  end
endgenerate

endmodule

module seven_seg_decoder(
  input [3:0] digit,
  output reg [6:0] seg
);

always @(*)
begin
  case(digit)
    4'd0: seg = 7'b1000000;
    4'd1: seg = 7'b1111001;
    4'd2: seg = 7'b0100100;
    4'd3: seg = 7'b0110000;
    4'd4: seg = 7'b0011001;
    4'd5: seg = 7'b0010010;
    4'd6: seg = 7'b0000010;
    4'd7: seg = 7'b1111000;
    4'd8: seg = 7'b0000000;
    4'd9: seg = 7'b0010000;
    default: seg = 7'b1111111;
  endcase
end

endmodule
