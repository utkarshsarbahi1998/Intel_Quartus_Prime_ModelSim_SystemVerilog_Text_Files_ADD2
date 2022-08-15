`timescale 1ns / 1ps

module task2 (clock, reset_neg, PS2_clock, PS2_data, finish_flag, neg_edge, overflow, bit_counter, output_data, output_data_2, Seven_Segment_display, Seven_Segment_display_1, 
Seven_Segment_display_2, Seven_Segment_display_3, Seven_Segment_display_4, Seven_Segment_display_5);

input clock, reset_neg, PS2_clock, PS2_data;
output logic finish_flag, neg_edge, overflow; output logic [3:0] bit_counter; output logic [6:0] Seven_Segment_display, Seven_Segment_display_1, Seven_Segment_display_2, 
Seven_Segment_display_3, Seven_Segment_display_4, Seven_Segment_display_5; output logic [7:0] output_data, output_data_2;

logic PS2_clock_delay, packet_detect, filter_PS2_clock_current, filter_PS2_clock_next, first_digit_detect, second_digit_detect, enter_detect_1, enter_detect_2, sum_detected; 
logic [1:0] current_state, next_state; 
logic [7:0] filter_current, filter_next, first_digit_temp, second_digit_temp, first_digit, second_digit, first_digit_converted, second_digit_converted, decimal_0_output, 
decimal_1_output, final_sum;
logic [10:0] current_register, next_register;
 
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
output_data_2 <= 8'b0;
packet_detect <= 1'b0;
first_digit_detect <= 1'b0;
second_digit_detect <= 1'b0;
first_digit_temp <= 8'b0;
second_digit_temp <= 8'b0;
first_digit <= 8'b0;
second_digit <= 8'b0;
enter_detect_1 <= 1'b0;
enter_detect_2 <= 1'b0;
sum_detected <= 1'b0;
end
else if ((overflow) & (current_register[8:1] == 8'hF0))
begin
packet_detect <= 1'b1;
sum_detected <= 1'b0;
end
else if ((overflow) & ((current_register[8:1] == 8'h45) || (current_register[8:1] == 8'h16) || (current_register[8:1] == 8'h1E) || (current_register[8:1] == 8'h26) ||
(current_register[8:1] == 8'h25) || (current_register[8:1] == 8'h2E) || (current_register[8:1] == 8'h36) || (current_register[8:1] == 8'h3D) || (current_register[8:1] == 8'h3E) ||
(current_register[8:1] == 8'h46)) & (packet_detect) & (!second_digit_detect) & (!enter_detect_1) & (!enter_detect_2))
begin
output_data <= current_register[8:1];
packet_detect <= 1'b0;
first_digit_detect <= 1'b1;
first_digit_temp <= current_register[8:1];
sum_detected <= 1'b0;
output_data_2 <= 8'h45;
end
else if ((overflow) & (current_register[8:1] == 8'h5A) & (packet_detect) & (first_digit_detect) & (!second_digit_detect) & (!enter_detect_2))
begin
packet_detect <= 1'b0;
first_digit_detect <= 1'b0;
first_digit <= first_digit_temp;
enter_detect_1 <= 1'b1;
sum_detected <= 1'b0;
end
else if ((overflow) & ((current_register[8:1] == 8'h45) || (current_register[8:1] == 8'h16) || (current_register[8:1] == 8'h1E) || (current_register[8:1] == 8'h26) ||
(current_register[8:1] == 8'h25) || (current_register[8:1] == 8'h2E) || (current_register[8:1] == 8'h36) || (current_register[8:1] == 8'h3D) || (current_register[8:1] == 8'h3E) ||
(current_register[8:1] == 8'h46)) & (packet_detect) & (!first_digit_detect) & (enter_detect_1) & (!enter_detect_2))
begin
output_data <= current_register[8:1];
packet_detect <= 1'b0;
second_digit_detect <= 1'b1;
second_digit_temp <= current_register[8:1];
enter_detect_1 <= 1'b0;
sum_detected <= 1'b0;
output_data_2 <= 8'h45;
end
else if ((overflow) & (current_register[8:1] == 8'h5A) & (packet_detect) & (!first_digit_detect) & (second_digit_detect) & (!enter_detect_1))
begin
packet_detect <= 1'b0;
second_digit_detect <= 1'b0;
second_digit <= second_digit_temp;
enter_detect_2 <= 1'b1;
sum_detected <= 1'b0;
end
else if (enter_detect_2)
begin
enter_detect_2 <= 1'b0;
sum_detected <= 1'b1;
end
else if (sum_detected)
begin
final_sum <= first_digit_converted + second_digit_converted;
output_data <= decimal_0_output;
output_data_2 <= decimal_1_output;
end
end

Seven_Segment_display digit (.output_data (output_data), .Seven_Segment_display_output (Seven_Segment_display), .sum_detected_flag (sum_detected));
Seven_Segment_display digit_1 (.output_data (output_data_2), .Seven_Segment_display_output (Seven_Segment_display_1), .sum_detected_flag (sum_detected));
Seven_Segment_display_default digit_2 (.output_data (output_data), .Seven_Segment_display_output (Seven_Segment_display_2));
Seven_Segment_display_default digit_3 (.output_data (output_data), .Seven_Segment_display_output (Seven_Segment_display_3));
Seven_Segment_display_default digit_4 (.output_data (output_data), .Seven_Segment_display_output (Seven_Segment_display_4));
Seven_Segment_display_default digit_5 (.output_data (output_data), .Seven_Segment_display_output (Seven_Segment_display_5));
PS2_Binary sum_digit_1 (.output_data_conversion (first_digit), .binary_output (first_digit_converted));
PS2_Binary sum_digit_2 (.output_data_conversion (second_digit), .binary_output (second_digit_converted));
Binary_Decimal sum_to_digits (.sum_input (final_sum), .decimal_0 (decimal_0_output), .decimal_1 (decimal_1_output));

endmodule

// ---- ---- ---- ---- //

module Seven_Segment_display (output_data, Seven_Segment_display_output, sum_detected_flag);

input logic sum_detected_flag; input logic [7:0] output_data;
output logic [6:0] Seven_Segment_display_output;

always_comb
begin
if (sum_detected_flag)
begin
case (output_data)
8'd0: Seven_Segment_display_output = 7'b1000000;
8'd1: Seven_Segment_display_output = 7'b1111001;
8'd2: Seven_Segment_display_output = 7'b0100100;
8'd3: Seven_Segment_display_output = 7'b0110000;
8'd4: Seven_Segment_display_output = 7'b0011001;
8'd5: Seven_Segment_display_output = 7'b0010010;
8'd6: Seven_Segment_display_output = 7'b0000010;
8'd7: Seven_Segment_display_output = 7'b1111000;
8'd8: Seven_Segment_display_output = 7'b0000000;
8'd9: Seven_Segment_display_output = 7'b0010000;
default: Seven_Segment_display_output = 7'b1000000;
endcase
end
else 
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
default: Seven_Segment_display_output = 7'b1000000;
endcase
end
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

module PS2_Binary (output_data_conversion, binary_output);

input logic [7:0] output_data_conversion;
output logic [7:0] binary_output;

always_comb
begin
case (output_data_conversion)
8'h45: binary_output = 8'b00000000;
8'h16: binary_output = 8'b00000001;
8'h1E: binary_output = 8'b00000010;
8'h26: binary_output = 8'b00000011;
8'h25: binary_output = 8'b00000100;
8'h2E: binary_output = 8'b00000101;
8'h36: binary_output = 8'b00000110;
8'h3D: binary_output = 8'b00000111;
8'h3E: binary_output = 8'b00001000;
8'h46: binary_output = 8'b00001001;
default: binary_output = 8'b11111111;
endcase
end

endmodule

// ---- ---- ---- ---- //

module Binary_Decimal (sum_input, decimal_0, decimal_1);

input logic [7:0] sum_input;
output logic [7:0] decimal_0, decimal_1;

always_comb
begin
case (sum_input)
8'b00000000:
begin
decimal_0 = 8'd0;
decimal_1 = 8'd0;
end
8'b00000001:
begin
decimal_0 = 8'd1;
decimal_1 = 8'd0;
end
8'b00000010:
begin
decimal_0 = 8'd2;
decimal_1 = 8'd0;
end
8'b00000011:
begin
decimal_0 = 8'd3;
decimal_1 = 8'd0;
end
8'b00000100:
begin
decimal_0 = 8'd4;
decimal_1 = 8'd0;
end
8'b00000101:
begin
decimal_0 = 8'd5;
decimal_1 = 8'd0;
end
8'b00000110:
begin
decimal_0 = 8'd6;
decimal_1 = 8'd0;
end
8'b00000111:
begin
decimal_0 = 8'd7;
decimal_1 = 8'd0;
end
8'b00001000:
begin
decimal_0 = 8'd8;
decimal_1 = 8'd0;
end
8'b00001001:
begin
decimal_0 = 8'd9;
decimal_1 = 8'd0;
end
8'b00001010:
begin
decimal_0 = 8'd0;
decimal_1 = 8'd1;
end
8'b00001011:
begin
decimal_0 = 8'd1;
decimal_1 = 8'd1;
end
8'b00001100:
begin
decimal_0 = 8'd2;
decimal_1 = 8'd1;
end
8'b00001101:
begin
decimal_0 = 8'd3;
decimal_1 = 8'd1;
end
8'b00001110:
begin
decimal_0 = 8'd4;
decimal_1 = 8'd1;
end
8'b00001111:
begin
decimal_0 = 8'd5;
decimal_1 = 8'd1;
end
8'b00010000:
begin
decimal_0 = 8'd6;
decimal_1 = 8'd1;
end
8'b00010001:
begin
decimal_0 = 8'd7;
decimal_1 = 8'd1;
end
8'b00010010:
begin
decimal_0 = 8'd8;
decimal_1 = 8'd1;
end
default: 
begin
decimal_0 = 8'd0;
decimal_1 = 8'd0;
end
endcase
end

endmodule

// ---- ---- ---- ---- //

module task2_testbench ();

logic clock, reset_neg, PS2_clock, PS2_data; logic [6:0] Seven_Segment_display, Seven_Segment_display_1; 
logic [7:0] output_data, output_data_2, PS2_data_simulation [33:0], output_data_simulation [33:0], output_data_2_simulation [33:0];

localparam CLOCK_HALF_PERIOD = 10, RESET_DELAY_PERIOD = 25, DELAY_PERIOD = 1000, DELAY_PERIOD_MINUS_ONE = 999, PS2_CLOCK_FREQUENCY = 500, PS2_CLOCK_HALF_FREQUENCY = 250;

task2 simulation (.clock (clock), .reset_neg (reset_neg), .PS2_clock (PS2_clock), .PS2_data (PS2_data), .output_data (output_data), .output_data_2 (output_data_2),
.Seven_Segment_display (Seven_Segment_display), .Seven_Segment_display_1 (Seven_Segment_display_1));

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
$readmemh ("output_2.txt", output_data_2_simulation);
for (int i = 0; i < 34; i++) 
begin
#DELAY_PERIOD_MINUS_ONE;
PS2_data = 1'b0;
#PS2_CLOCK_FREQUENCY;
for (int j = 0; j < 8; j++) 
begin 
PS2_data = PS2_data_simulation[i][j];
#PS2_CLOCK_FREQUENCY;
end

if (i == 8)
begin
if ((output_data != output_data_simulation[i]) && (output_data_2 != output_data_2_simulation[i]))
begin
$display ("At ", $time, " ns");
$display ("ERROR: Input 8(%H) + 6(%H), Output SUM = %1h%1h, and Expected SUM = %1h%1h", PS2_data_simulation[i-7], PS2_data_simulation[i-3], 
output_data_2, output_data, output_data_2_simulation[i], output_data_simulation[i]);
end
else
begin
$display ("At ", $time, " ns");
$display ("SUCCESS: Input 8(%H) + 6(%H), Output SUM = %1h%1h, and Expected SUM = %1h%1h", PS2_data_simulation[i-7], PS2_data_simulation[i-3],
output_data_2, output_data, output_data_2_simulation[i], output_data_simulation[i]);
end
end

else if (i == 16)
begin
if ((output_data != output_data_simulation[i]) && (output_data_2 != output_data_2_simulation[i]))
begin
$display ("At ", $time, " ns");
$display ("ERROR: Input 2(%H) + 4(%H), Output SUM = %1h%1h, and Expected SUM = %1h%1h", PS2_data_simulation[i-7], PS2_data_simulation[i-3], 
output_data_2, output_data, output_data_2_simulation[i], output_data_simulation[i]);
end
else
begin
$display ("At ", $time, " ns");
$display ("SUCCESS: Input 2(%H) + 4(%H), Output SUM = %1h%1h, and Expected SUM = %1h%1h", PS2_data_simulation[i-7], PS2_data_simulation[i-3],
output_data_2, output_data, output_data_2_simulation[i], output_data_simulation[i]);
end
end

else if (i == 24)
begin
if ((output_data != output_data_simulation[i]) && (output_data_2 != output_data_2_simulation[i]))
begin
$display ("At ", $time, " ns");
$display ("ERROR: Input 9(%H) + 3(%H), Output SUM = %1h%1h, and Expected SUM = %1h%1h", PS2_data_simulation[i-7], PS2_data_simulation[i-3], 
output_data_2, output_data, output_data_2_simulation[i], output_data_simulation[i]);
end
else
begin
$display ("At ", $time, " ns");
$display ("SUCCESS: Input 9(%H) + 3(%H), Output SUM = %1h%1h, and Expected SUM = %1h%1h", PS2_data_simulation[i-7], PS2_data_simulation[i-3],
output_data_2, output_data, output_data_2_simulation[i], output_data_simulation[i]);
end
end

else if (i == 32)
begin
if ((output_data != output_data_simulation[i]) && (output_data_2 != output_data_2_simulation[i]))
begin
$display ("At ", $time, " ns");
$display ("ERROR: Input 1(%H) + 7(%H), Output SUM = %1h%1h, and Expected SUM = %1h%1h", PS2_data_simulation[i-7], PS2_data_simulation[i-3], 
output_data_2, output_data, output_data_2_simulation[i], output_data_simulation[i]);
end
else
begin
$display ("At ", $time, " ns");
$display ("SUCCESS: Input 1(%H) + 7(%H), Output SUM = %1h%1h, and Expected SUM = %1h%1h", PS2_data_simulation[i-7], PS2_data_simulation[i-3],
output_data_2, output_data, output_data_2_simulation[i], output_data_simulation[i]);
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
for (int k = 0; k < 34; k++) 		
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