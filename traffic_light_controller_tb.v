module traffic_light_controller_tb ();

localparam T = 10;  

localparam GREEN_TIME = 5;
localparam YELLOW_TIME = 2;
localparam CLK_DIV = 1;
localparam MUX_CLK_DIV = 1;

reg clk, reset_n;
reg sensor_N, sensor_E;

wire G_N, Y_N, R_N;
wire G_E, Y_E, R_E;
wire [6:0] seg;
wire [1:0] digit_sel;


traffic_light_controller #(
  .GREEN_TIME(GREEN_TIME),
  .YELLOW_TIME(YELLOW_TIME),
  .CLK_DIV(CLK_DIV),
  .MUX_CLK_DIV(MUX_CLK_DIV)
) UUT (
  .clk(clk),
  .reset_n(reset_n),
  .sensor_N(sensor_N),
  .sensor_E(sensor_E),
  .G_N(G_N), .Y_N(Y_N), .R_N(R_N),
  .G_E(G_E), .Y_E(Y_E), .R_E(R_E),
  .seg(seg),
  .digit_sel(digit_sel)
);
  
initial begin
  clk = 1'b0;
  forever #(T/2) clk = ~clk;
end

initial begin
  
  reset_n = 1'b0;
  sensor_N = 1'b0;
  sensor_E = 1'b0;
  
  repeat(4) @(negedge clk);
  reset_n = 1'b1;
  
  $display("Traffic Light Controller Testbench");
  
  $display("\nTest 1: No cars - North should stay Green\n");
  repeat((GREEN_TIME + 2) * 4) @(negedge clk);
  if (G_N && R_E) begin
    $display("  PASS: North Green, East Red (stays without East car)");
  end else begin
    $display("  FAIL: Expected N=Green, E=Red, Got G_N=%b R_E=%b", G_N, R_E);
  end
  
  $display("\nTest 2: Only North car - should stay North Green");
  sensor_N = 1'b1;
  sensor_E = 1'b0;
  repeat((GREEN_TIME + 2) * 4) @(negedge clk);
  if (G_N && R_E) begin
    $display("  PASS: North stays Green when only North car present");
  end else begin
    $display("  FAIL: North should stay Green, Got G_N=%b R_E=%b", G_N, R_E);
  end
  
  $display("\nTest 3: Only East car - should transition to East Green");
  sensor_N = 1'b0;
  sensor_E = 1'b1;
  
  repeat((GREEN_TIME + YELLOW_TIME + 3) * 2) @(negedge clk);
  
  if (R_N && G_E) begin
    $display("  PASS: Transitioned to East Green");
  end else begin
    $display("  FAIL: Should be N=Red, E=Green, Got R_N=%b G_E=%b", R_N, G_E);
  end
  
  $display("\nTest 4: Both cars - testing full cycle");
  
  reset_n = 1'b0;
  repeat(4) @(negedge clk);
  reset_n = 1'b1;
  
  sensor_N = 1'b1;
  sensor_E = 1'b1;
  
  repeat(4) @(negedge clk);
  
  if (G_N && R_E) begin
    $display("  PASS: Started in North Green, East Red");
  end else begin
    $display("  FAIL: Should start N=Green, E=Red, Got G_N=%b R_E=%b", G_N, R_E);
  end
  
  while (!(Y_N && Y_E)) @(negedge clk);
  $display("  PASS: Detected Yellow transition (N->E)");
  
  while (!(R_N && G_E)) @(negedge clk);
  $display("  PASS: North Red, East Green");
  
  while (!(Y_N && Y_E)) @(negedge clk);
  $display("  PASS: Detected Yellow transition (E->N)");
  
  while (!(G_N && R_E)) @(negedge clk);
  $display("  PASS: Cycle complete - back to North Green");
  
  $display("\nTest 5: East car leaves during North green - should stay North green");
  sensor_N = 1'b1;
  sensor_E = 1'b0;
  
  repeat((GREEN_TIME + YELLOW_TIME + 3) * 4) @(negedge clk);
  
  if (G_N && R_E) begin
    $display("  PASS: Stays in North Green when East car leaves");
  end else begin
    $display("  FAIL: Should stay in North Green, Got G_N=%b R_E=%b", G_N, R_E);
  end
  

  $stop; 
end

initial begin
  $monitor("Time=%0t | sensor_N=%b sensor_E=%b | N:[G=%b Y=%b R=%b] E:[G=%b Y=%b R=%b]",
           $time, sensor_N, sensor_E, G_N, Y_N, R_N, G_E, Y_E, R_E);
end
  
endmodule
