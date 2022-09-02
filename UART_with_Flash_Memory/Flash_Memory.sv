module Flash_Memory (clock_input, switch_input, key_input, LED_output, oFLASH_CE_N, oFLASH_WP_N, oFLASH_RST_N, oFLASH_BYTE_N, oFLASH_OE_N, oFLASH_WE_N, oFLASH_A, FLASH_DQ,
FLASH_DQ15_AM1);
	
input clock_input; input [1:0] key_input; input [17:0] switch_input; 
output logic oFLASH_CE_N, oFLASH_WP_N, oFLASH_RST_N, oFLASH_BYTE_N, oFLASH_OE_N, oFLASH_WE_N; output [7:0] LED_output; output [21:0] oFLASH_A;
inout FLASH_DQ15_AM1; inout [14:0] FLASH_DQ;

enum logic [2:0] {power_on = 3'b000, read = 3'b001, program_first_cycle = 3'b010, program_second_cycle = 3'b011, program_third_cycle = 3'b100, write = 3'b101} state, next_state; 
						
logic clock_output, reset; logic [5:0] stage, state_count; logic [15:0] data_input;
	
assign reset = key_input[0];
assign oFLASH_RST_N = key_input[0];
assign oFLASH_WP_N = 1'b1;
assign oFLASH_BYTE_N = 1'b1;
assign FLASH_DQ = (state == read) ? 15'bz : data_input[14:0];
assign FLASH_DQ15_AM1 = (state == read) ? 1'bz : data_input[15];

Frequency_Divider Clock_Divider (.clock_input (clock_input), .clock_output (clock_output), .reset (reset));
			
always_ff @ (posedge clock_output, negedge reset)
begin
if (!reset)
state <= power_on;
else 
state <= next_state;
end

always_comb 
begin
case (state)

power_on: next_state <= read;
			
read: 
if (!key_input[1])									
next_state <= program_first_cycle;
else
next_state <= read;	
						
program_first_cycle:
if (state_count == 6'd5)
next_state <= program_second_cycle;
else
next_state <= program_first_cycle;
								
program_second_cycle:
if (state_count == 6'd9)
next_state <= program_third_cycle;
else 
next_state <= program_second_cycle;
						
program_third_cycle:								
if (state_count == 6'd13)
next_state <= write;
else
next_state <= program_third_cycle;
						
write:
if (state_count == 6'd17)
next_state <= read;
else
next_state <= write;

endcase
end

always_ff @ (posedge clock_output, negedge reset)
begin
if (!reset) 
begin
stage <= 6'd0;
state_count <= 6'd0;
oFLASH_WE_N <= 1'b1;
oFLASH_CE_N <= 1'b1;
oFLASH_OE_N <= 1'b1;
end
else 
begin
case (state)

power_on:
begin
stage <= 6'd0;
state_count <= 6'd0;
oFLASH_WE_N <= 1'b1;
oFLASH_CE_N <= 1'b1;
oFLASH_OE_N <= 1'b1;
end

read: 
begin
state_count <= 6'd0;
oFLASH_A[21:8] <= 0;
oFLASH_A[7:0] <= switch_input[7:0];
case (stage)
6'd0: 
begin
oFLASH_WE_N <= 1'b1;
stage <= stage + 6'd1;
end
6'd1:
begin
oFLASH_CE_N <= 1'b0;
stage <= stage + 6'd1;
end	
6'd2: 
begin
oFLASH_OE_N <= 1'b0;
stage <= stage + 6'd1;
end	
6'd3:
begin
LED_output[7:0] <= FLASH_DQ[7:0];
stage <= stage + 6'd1;
end
default:
begin
stage <= 6'd0;
end
endcase
end
					
program_first_cycle:
begin
stage <= 6'd0;
oFLASH_A[21:0] <= 22'h0555;
data_input[15:0] <= 16'h00AA;
case (state_count)
6'd0: 
begin
oFLASH_OE_N <= 1'b1;
oFLASH_CE_N <= 1'b1;
oFLASH_WE_N <= 1'b1;
state_count <= state_count + 6'd1;
end
6'd1: 
begin
oFLASH_CE_N <= 1'b0;						
state_count <= state_count + 6'd1;
end								
6'd2: 
begin
oFLASH_WE_N <= 1'b0;						
state_count <= state_count + 6'd1;
end								
6'd3:
begin
oFLASH_WE_N <= 1'b1;
state_count <= state_count + 6'd1;
end
6'd4:
begin
oFLASH_CE_N <= 1'b1;
state_count <= state_count + 6'd1;
end
endcase
end

program_second_cycle:
begin
oFLASH_A[21:0] <= 22'h02AA;
data_input[15:0] <= 16'h0055;		
case (state_count)
6'd5: 
begin
oFLASH_CE_N <= 1'b0;
state_count <= state_count + 6'd1;
end
6'd6: 
begin
oFLASH_WE_N <= 1'b0;
state_count <= state_count + 6'd1;
end
6'd7: 
begin
oFLASH_WE_N <= 1'b1;
state_count <= state_count + 6'd1;
end
6'd8:
begin
oFLASH_CE_N <= 1'b1;
state_count <= state_count + 6'd1;
end
endcase
end

program_third_cycle:
begin
oFLASH_A[21:0] <= 22'h0555;
data_input[15:0] <= 16'h00A0;
case (state_count)
6'd9: 
begin
oFLASH_CE_N <= 1'b0;
state_count <= state_count + 6'd1;
end
6'd10: 
begin
oFLASH_WE_N <= 1'b0;
state_count <= state_count + 6'd1;
end								
6'd11: 
begin
oFLASH_WE_N <= 1'b1;
state_count <= state_count + 6'd1;
end
6'd12:
begin
oFLASH_CE_N <= 1'b1;
state_count <= state_count + 6'd1;
end
endcase
end			
		
write:		
begin
oFLASH_A[21:8] <= 0;
oFLASH_A[7:0] <= switch_input[7:0];
data_input[15:8] <= 0;
data_input[7:0] <= switch_input[15:8];
case (state_count)
6'd13: 
begin
oFLASH_OE_N <= 1'b1;
oFLASH_CE_N <= 1'b1;
oFLASH_WE_N <= 1'b1;
state_count <= state_count + 6'd1;
end
6'd14: 
begin
oFLASH_CE_N <= 1'b0;
state_count <= state_count + 6'd1;
end
6'd15: 
begin
oFLASH_WE_N <= 1'b0;
state_count <= state_count + 6'd1;
end
6'd16:
begin
oFLASH_WE_N <= 1'b1;
state_count <= state_count + 6'd1;
end
6'd17:
begin
oFLASH_CE_N <= 1'b1;
state_count <= state_count + 6'd1;
end
endcase
end

endcase
end
end

endmodule

// ---- ---- ---- ---- //

module Frequency_Divider (clock_input, clock_output, reset);

input clock_input, reset;
output logic clock_output;

logic [11:0] clock_counter;

parameter Divisor = 12'd1250;

always_ff @ (posedge clock_input, negedge reset)
begin
if (!reset)
clock_counter <= 12'd0;
else if (clock_counter == Divisor) 
begin
clock_output <= ~clock_output;
clock_counter <= 12'd0;
end
else
clock_counter <= clock_counter + 12'd1;
end
	
endmodule
	