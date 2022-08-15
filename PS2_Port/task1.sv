`timescale 1ns / 1ps

module task1 (clock, reset_neg, PS2_clock, PS2_data, finish_flag, neg_edge, overflow, bit_counter, output_data, Seven_Segment_display, Seven_Segment_display_1, 
Seven_Segment_display_2, Seven_Segment_display_3, Seven_Segment_display_4, Seven_Segment_display_5);

input clock, reset_neg, PS2_clock, PS2_data;
output logic finish_flag, neg_edge, overflow; output logic [3:0] bit_counter; output logic [6:0] Seven_Segment_display, Seven_Segment_display_1, Seven_Segment_display_2, 
Seven_Segment_display_3, Seven_Segment_display_4, Seven_Segment_display_5; output logic [7:0] output_data;

logic PS2_clock_delay, packet_detect, filter_PS2_clock_current, filter_PS2_clock_next; logic [1:0] current_state, next_state; 
logic [7:0] filter_current, filter_next; logic [10:0] current_register, next_register;
 
parameter IDLE_STATE = 2'b00; parameter RX_STATE = 2'b01;

always_ff @ (posedge clock, negedge reset_neg)
begin
if (!reset_neg)
begin
filter_current <= 8'b0;
filter_PS2_clock_current <= 1'b0;
end
else
begin
filter_current <= filter_next;
filter_PS2_clock_current <= filter_PS2_clock_next;
end
end

assign filter_next = {PS2_clock, filter_current[7:1]};

assign filter_PS2_clock_next = (filter_current == 8'b11111111) ? 1'b1 : ((filter_current == 8'b00000000) ? 1'b0 : filter_PS2_clock_current);

assign neg_edge = (~filter_PS2_clock_next) & (filter_PS2_clock_current);

//always_ff @ (posedge clock, negedge reset_neg)
//begin
//if (!reset_neg)
//PS2_clock_delay <= 1'b0;
//else
//PS2_clock_delay <= PS2_clock;
//end

//assign neg_edge = (~PS2_clock) & (PS2_clock_delay);

always_ff @ (posedge clock, negedge reset_neg)
begin
if (!reset_neg)
bit_counter <= 4'b0;
else if (bit_counter == 4'b1010)
bit_counter <= 4'b0;
else if ((current_state == RX_STATE) & (neg_edge))
bit_counter <= bit_counter + 4'b1;
end

assign overflow = (bit_counter == 4'b1010) ? 1'b1 : 1'b0;

always_ff @ (posedge clock, negedge reset_neg)
begin
if (!reset_neg)
begin
current_state <= IDLE_STATE;
current_register <= 11'b0;
end
else
begin
current_state <= next_state;
current_register <= next_register;
end
end

//always @ (current_state, current_register, neg_edge, PS2_data)
always_comb
begin
next_state = current_state;
next_register = current_register;
finish_flag = 1'b0;
case (current_state)
IDLE_STATE:
if (neg_edge)
begin
next_state = RX_STATE;
end
RX_STATE:
begin
if (neg_edge)
begin
next_register = {PS2_data, current_register[10:1]};
end
if (overflow)
begin
finish_flag = 1'b1;
next_state = IDLE_STATE;
end
end
endcase
end

always_ff @ (posedge clock, negedge reset_neg)
begin
if (!reset_neg)
begin
output_data <= 8'b0;
packet_detect <= 1'b0;
end
else if ((overflow) & (current_register[8:1] == 8'hF0))
begin
packet_detect <= 1'b1;
end
else if ((overflow) & (current_register[8:1] != 8'hF0) & (packet_detect))
begin
output_data <= current_register[8:1];
packet_detect <= 1'b0;
end
end

Seven_Segment_display digit (.output_data (output_data), .Seven_Segment_display_output (Seven_Segment_display));
Seven_Segment_display_default digit_1 (.output_data (output_data), .Seven_Segment_display_output (Seven_Segment_display_1));
Seven_Segment_display_default digit_2 (.output_data (output_data), .Seven_Segment_display_output (Seven_Segment_display_2));
Seven_Segment_display_default digit_3 (.output_data (output_data), .Seven_Segment_display_output (Seven_Segment_display_3));
Seven_Segment_display_default digit_4 (.output_data (output_data), .Seven_Segment_display_output (Seven_Segment_display_4));
Seven_Segment_display_default digit_5 (.output_data (output_data), .Seven_Segment_display_output (Seven_Segment_display_5));

endmodule

// ---- ---- ---- ---- //

module Seven_Segment_display (output_data, Seven_Segment_display_output);

input logic [7:0] output_data;
output logic [6:0] Seven_Segment_display_output;

always_comb
begin
case (output_data)
8'h45: Seven_Segment_display_output = 7'b1000000;
8'h16: Seven_Segment_display_output = 7'b1111001;
8'h1E: Seven_Segment_display_output = 7'b0100100;
8'h26: Seven_Segment_display_output = 7'b0110000;
8'h25: Seven_Segment_display_output = 7'b0011001;
8'h2E: Seven_Segment_display_output = 7'b0010010;
8'h36: Seven_Segment_display_output = 7'b0000010;
8'h3D: Seven_Segment_display_output = 7'b1111000;
8'h3E: Seven_Segment_display_output = 7'b0000000;
8'h46: Seven_Segment_display_output = 7'b0010000;
default: Seven_Segment_display_output = 7'b0111111;
endcase
end

endmodule

// ---- ---- ---- ---- //

module Seven_Segment_display_default (output_data, Seven_Segment_display_output);

input logic [7:0] output_data;
output logic [6:0] Seven_Segment_display_output;

always_comb
begin
case (output_data)
default: Seven_Segment_display_output = 7'b1111111;
endcase
end

endmodule

// ---- ---- ---- ---- //

module task1_testbench ();

logic clock, reset_neg, PS2_clock, PS2_data; logic [6:0] Seven_Segment_display; logic [7:0] output_data, PS2_data_simulation [39:0], output_data_simulation [39:0];

localparam CLOCK_HALF_PERIOD = 10, RESET_DELAY_PERIOD = 25, DELAY_PERIOD = 1000, DELAY_PERIOD_MINUS_ONE = 999, PS2_CLOCK_FREQUENCY = 500, PS2_CLOCK_HALF_FREQUENCY = 250;

task1 simulation (.clock (clock), .reset_neg (reset_neg), .PS2_clock (PS2_clock), .PS2_data (PS2_data), .output_data (output_data), .Seven_Segment_display (Seven_Segment_display));

always 
begin
clock = 1'b0;
#CLOCK_HALF_PERIOD;
clock = 1'b1;
#CLOCK_HALF_PERIOD;
end

initial
begin
reset_neg = 1'b0;
#RESET_DELAY_PERIOD;
reset_neg = 1'b1;
end

initial
begin
PS2_data = 1'b1;
$readmemh ("input.txt", PS2_data_simulation);
$readmemh ("output.txt", output_data_simulation);
for (int i = 0; i < 40; i++) 
begin
#DELAY_PERIOD_MINUS_ONE;
PS2_data = 1'b0;
#PS2_CLOCK_FREQUENCY;
for (int j = 0; j < 8; j++) 
begin 
PS2_data = PS2_data_simulation[i][j];
#PS2_CLOCK_FREQUENCY;
end
if (i % 2 != 0)
begin
if (output_data != output_data_simulation[i])
begin
$display ("At ", $time, " ns");
$display ("ERROR: Input Code = %h, Previous Output Code = %h, and Previous Expected Code = %h", PS2_data_simulation[i], output_data, output_data_simulation[i]);
end
else
begin
$display ("At ", $time, " ns");
$display ("SUCCESS: Input Code = %h, Previous Output Code = %h, and Previous Expected Code = %h", PS2_data_simulation[i], output_data, output_data_simulation[i]);
end
end 
PS2_data = 1'b1;
#PS2_CLOCK_FREQUENCY;
PS2_data = 1'b1;
#PS2_CLOCK_FREQUENCY;
end
end

initial 
begin
PS2_clock = 1'b1;
for (int k = 0; k < 40; k++) 		
begin
#DELAY_PERIOD;
for (int l = 0; l < 22; l++) 
begin
PS2_clock = ~PS2_clock;
#PS2_CLOCK_HALF_FREQUENCY;
end
end
end 

endmodule