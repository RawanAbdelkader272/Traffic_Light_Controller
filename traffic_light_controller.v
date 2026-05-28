module traffic_light_controller 
#(parameter GREEN_TIME = 30, YELLOW_TIME = 5, CLK_DIV = 50000000, MUX_CLK_DIV = 50000)
(
  input clk,
  input reset_n,
  input sensor_N,
  input sensor_E,
  output G_N,
  output Y_N,
  output R_N,
  output G_E,		
  output Y_E,
  output R_E,
  output [6:0] seg,
  output [1:0] digit_sel
);
  
  localparam STATE_N_GREEN   = 2'b00,
             STATE_N_YELLOW  = 2'b01,
             STATE_E_GREEN   = 2'b10,
             STATE_E_YELLOW  = 2'b11;
 
  reg [1:0] state_reg, state_next;
  reg [1:0] prev_state;
  
  wire clk_1hz;
  wire clk_mux;
  reg digit_toggle;
  
  wire timer_done;
  wire [5:0] timer_count;
  reg [5:0] timer_target;
  
  // Timer reset signal - active when state is about to change OR when staying in green with no sensor
  wire timer_reset;
  wire stay_green_n;  // Stay in North green because no East sensor
  wire stay_green_e;  // Stay in East green because no North sensor (and East sensor not active)
  
  wire [5:0] display_time;
  wire [3:0] ones_digit, tens_digit;
  wire [3:0] current_digit;
  wire [6:0] seg_data;
  
  clock_divider #(.DIV_VALUE(CLK_DIV)) clk_div(
    .clk_in(clk),
    .reset_n(reset_n),
    .clk_out(clk_1hz)
  );
  
  mux_clock_divider #(.DIV_VALUE(MUX_CLK_DIV)) mux_clk_div(
    .clk_in(clk),
    .reset_n(reset_n),
    .clk_out(clk_mux)
  );
  
  timer #(.FINAL_VALUE(GREEN_TIME)) main_timer(
    .clk(clk_1hz),
    .reset_n(reset_n),
    .start(timer_reset),
    .done(timer_done),
    .count(timer_count)
  );
  
  // Compute timer done based on current state's target
  wire timer_target_reached;
  assign timer_target_reached = (timer_count >= timer_target);
  
  // Conditions to stay in green state (reset timer instead of changing state)
  assign stay_green_n = (state_reg == STATE_N_GREEN) && timer_target_reached && ~sensor_E;
  assign stay_green_e = (state_reg == STATE_E_GREEN) && timer_target_reached && ~sensor_N && sensor_E;
  
  // Timer resets when: state is about to change, OR staying in green with no sensor
  assign timer_reset = (state_next != state_reg) || stay_green_n || stay_green_e;

  always @(posedge clk_1hz, negedge reset_n)
  begin
    if (~reset_n) begin
      state_reg <= STATE_N_GREEN;
      prev_state <= STATE_N_GREEN;
    end
    else begin
      prev_state <= state_reg;
      state_reg <= state_next;
    end
  end
  
  always @(*) begin
    case(state_reg)
      STATE_N_GREEN:  timer_target = GREEN_TIME;
      STATE_N_YELLOW: timer_target = YELLOW_TIME;
      STATE_E_GREEN:  timer_target = GREEN_TIME;
      STATE_E_YELLOW: timer_target = YELLOW_TIME;
      default:        timer_target = GREEN_TIME;
    endcase
  end
  
  always @(*)
  begin
    state_next = state_reg;
    
    case(state_reg)
      STATE_N_GREEN: begin
        if (timer_target_reached) begin
          if (sensor_E)
            state_next = STATE_N_YELLOW;
        end
      end
      
      STATE_N_YELLOW: begin
        if (timer_target_reached)
          state_next = STATE_E_GREEN;
      end
      
      STATE_E_GREEN: begin
        if (timer_target_reached) begin
          if (sensor_N)
            state_next = STATE_E_YELLOW;
          else if (~sensor_E)
            state_next = STATE_E_YELLOW;
        end
      end
      
      STATE_E_YELLOW: begin
        if (timer_target_reached)
          state_next = STATE_N_GREEN;
      end
      
      default: state_next = STATE_N_GREEN;
    endcase
  end
  
  // North traffic light outputs (active-low LEDs: 0 = ON, 1 = OFF):
  // - Green when North has green
  // - Yellow ONLY when North is transitioning from green to red (STATE_N_YELLOW)
  // - Red when East has green OR when East is in yellow (waiting to go green)
  assign G_N = ~(state_reg == STATE_N_GREEN);
  assign Y_N = ~(state_reg == STATE_N_YELLOW);
  assign R_N = ~((state_reg == STATE_E_GREEN) || (state_reg == STATE_E_YELLOW));
  
  // East traffic light outputs (active-low LEDs: 0 = ON, 1 = OFF):
  // - Green when East has green
  // - Yellow ONLY when East is transitioning from green to red (STATE_E_YELLOW)
  // - Red when North has green OR when North is in yellow (waiting to go green)
  assign G_E = ~(state_reg == STATE_E_GREEN);
  assign Y_E = ~(state_reg == STATE_E_YELLOW);
  assign R_E = ~((state_reg == STATE_N_GREEN) || (state_reg == STATE_N_YELLOW));
  
  assign display_time = (state_reg == STATE_N_GREEN || state_reg == STATE_E_GREEN) ? 
                        ((GREEN_TIME > timer_count) ? (GREEN_TIME - timer_count) : 6'd0) :
                        ((YELLOW_TIME > timer_count) ? (YELLOW_TIME - timer_count) : 6'd0);
  
  assign ones_digit = display_time % 10;
  assign tens_digit = display_time / 10;
  
  always @(posedge clk_mux, negedge reset_n)
  begin
    if (~reset_n)
      digit_toggle <= 1'b0;
    else
      digit_toggle <= ~digit_toggle;
  end
  
  assign current_digit = digit_toggle ? ones_digit : tens_digit;
  assign digit_sel = digit_toggle ? 2'b01 : 2'b10;
  
  seven_seg_decoder seg_decoder(
    .digit(current_digit),
    .seg(seg)
  );

endmodule
