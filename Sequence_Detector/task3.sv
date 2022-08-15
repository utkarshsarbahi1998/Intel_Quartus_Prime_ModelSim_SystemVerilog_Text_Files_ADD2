`timescale 1ns / 1ps

module task3 (input_bit, output_bit, reset_pos_edge, clock);

input logic input_bit, reset_pos_edge, clock;
output logic output_bit;
logic [2:0] current_state, next_state;

parameter S_0 = 3'b000; parameter S_1 = 3'b001; parameter S_2 = 3'b011; parameter S_3 = 3'b010; parameter S_4 = 3'b110;

always_ff @ (posedge clock)
begin
if (reset_pos_edge == 1'b1)
begin
current_state <= S_0;
end
else
begin
current_state <= next_state;
end
end

always_comb
begin
next_state = S_0;
case (current_state)

S_0:
begin
if (input_bit == 1'b1)
next_state = S_1;
else if (input_bit == 1'b0)
next_state = S_0;
end

S_1:
begin
if (input_bit == 1'b1)
next_state = S_2;
else if (input_bit == 1'b0)
next_state = S_0;
end

S_2:
begin
if (input_bit == 1'b1)
next_state = S_2;
else if (input_bit == 1'b0)
next_state = S_3;
end

S_3:
begin
if (input_bit == 1'b1)
next_state = S_4;
else if (input_bit == 1'b0)
next_state = S_0;
end

S_4:
begin
if (input_bit == 1'b1)
next_state = S_2;
else if (input_bit == 1'b0)
next_state = S_0;
end

default:
begin
end

endcase
end

always_comb
begin
output_bit = 1'b0;
case (current_state)

S_0: output_bit = 1'b0;
S_1: output_bit = 1'b0;
S_2: output_bit = 1'b0;
S_3: output_bit = 1'b0;
S_4: output_bit = 1'b1;
default: ;

endcase
end

endmodule

// ---- ---- ---- ---- //

module task3_testbench ();

logic input_bit, output_bit, reset_pos_edge, clock, input_bit_data [99:0], output_bit_data [99:0];

parameter CLOCK_HALF_PERIOD = 10; parameter RESET_DELAY_PERIOD = 25; parameter DELAY_PERIOD = 8;

task3 simulation (.input_bit (input_bit), .output_bit (output_bit), .reset_pos_edge (reset_pos_edge), .clock (clock));

always 
begin
clock = 1'b0;
#CLOCK_HALF_PERIOD;
clock = 1'b1;
#CLOCK_HALF_PERIOD;
end

initial
begin
reset_pos_edge = 1'b1;
#RESET_DELAY_PERIOD;
reset_pos_edge = 1'b0;
end

initial
begin
$readmemb ("input.txt", input_bit_data);
$readmemb ("output.txt", output_bit_data);
for (int i = 0; i < 100; i++) 
begin
input_bit = input_bit_data[i];
#DELAY_PERIOD;

if ((output_bit) && (output_bit_data[i]))
begin
$display ("At ", $time, " ns");
$display ("SUCCESS: Continuous Sequence of 1101 detected in 4 Clock Cycles - Output set to HIGH");
end

end
end

endmodule