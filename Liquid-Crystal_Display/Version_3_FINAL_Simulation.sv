`timescale 1ns / 1ns

module Version_3_FINAL_Simulation ();

logic clock, reset_active_low, rotate, lcd_rw, lcd_en, lcd_rs, lcd_on; wire [3:0] lcd_data; logic [3:0] unused_pins;

parameter CLOCK_HALF_PERIOD = 10; parameter RESET_DELAY_PERIOD = 25; parameter DELAY_PERIOD = 50_000_000;

Version_3_FINAL simulation (.clock (clock), .reset_active_low (reset_active_low), .rotate (rotate), .lcd_data (lcd_data), .lcd_rw (lcd_rw), .lcd_en (lcd_en), .lcd_rs (lcd_rs), 
.lcd_on (lcd_on), .unused_pins (unused_pins));

always 
begin
clock = 1'b0;
#CLOCK_HALF_PERIOD;
clock = 1'b1;
#CLOCK_HALF_PERIOD;
end

initial
begin
reset_active_low = 1'b0;
#RESET_DELAY_PERIOD;
reset_active_low = 1'b1;
end

initial
begin
rotate = 1'b1;
#DELAY_PERIOD;
rotate = 1'b0;
end

endmodule

