module UART (clock, reset_key, Seven_Segment_Display_0, Seven_Segment_Display_1, LED_Display, UART_Receiver_RS_232);

input clock, UART_Receiver_RS_232; input [3:0] reset_key;
output logic [6:0] Seven_Segment_Display_0, Seven_Segment_Display_1; output logic [7:0] LED_Display;
	 
parameter DATA_WIDTH = 4'd8;
	
logic receiving_flag, received_flag; logic [(DATA_WIDTH - 1'd1):0] received_data; wire reset = ~reset_key[0];

assign LED_Display[6] = receiving_flag;
assign LED_Display[3] = received_flag;

Receiver_RS_232 final_module (.clock (clock), .reset (reset), .serial_data_in (UART_Receiver_RS_232), .receiving_flag (receiving_flag), .received_flag (received_flag), 
.received_data (received_data));

Seven_Segment_Display SSD_0 (received_data[3:0], Seven_Segment_Display_0); 
Seven_Segment_Display SSD_1 (received_data[7:4], Seven_Segment_Display_1);
	
endmodule

// ---- ---- ---- ---- //

module Receiver_RS_232 (clock, reset, serial_data_in, receiving_flag, received_flag, received_data);

parameter BAUD_COUNT = 9'd434; parameter DATA_WIDTH = 4'd8; parameter TOTAL_DATA_WIDTH = DATA_WIDTH + 2'd2;
	
input clock, reset, serial_data_in;
output logic receiving_flag, received_flag; output logic [(DATA_WIDTH - 1'd1):0] received_data;
	
logic bits_received_flag, previous_receiving_flag, baud_clock; logic [(TOTAL_DATA_WIDTH - 1'd1):0]	shift_register_data_in;

Baud_Counter Receiver_RS_232_Baud_Counter (.clock (clock), .reset (reset), .reset_counter (~receiving_flag), .baud_clock_rising_edge (), .baud_clock_falling_edge (baud_clock),
.bits_done_flag (bits_received_flag));
	
defparam Receiver_RS_232_Baud_Counter.BAUD_COUNT= BAUD_COUNT, Receiver_RS_232_Baud_Counter.DATA_WIDTH= DATA_WIDTH;
	
always_ff @ (posedge clock)
begin
if (reset)
receiving_flag <= 1'b0;
else if (bits_received_flag)
receiving_flag <= 1'b0;
else if (!serial_data_in)
receiving_flag <= 1'b1;
end
	
always_ff @ (posedge clock)
begin
if (reset)
shift_register_data_in <= {TOTAL_DATA_WIDTH{1'b0}};
else if (baud_clock)	
shift_register_data_in <= {serial_data_in, shift_register_data_in[(TOTAL_DATA_WIDTH - 1'd1):1]};
end

always_ff @ (posedge clock)
begin
previous_receiving_flag <= receiving_flag;
if (receiving_flag)
received_flag <= 1'b0;
else if (previous_receiving_flag)
begin
received_flag <= 1'b1;
received_data <= shift_register_data_in[DATA_WIDTH:1];
end
end

endmodule

// ---- ---- ---- ---- //

module Baud_Counter (clock, reset, reset_counter, baud_clock_rising_edge, baud_clock_falling_edge, bits_done_flag);

input clock, reset, reset_counter;
output logic baud_clock_rising_edge, baud_clock_falling_edge, bits_done_flag;

parameter BAUD_COUNTER_WIDTH = 4'd9; parameter BAUD_COUNT = 9'd434; parameter BAUD_TICK_COUNT = BAUD_COUNT - 1'd1; parameter HALF_BAUD_TICK_COUNT = BAUD_COUNT / 2'd2;
parameter DATA_WIDTH = 4'd8; parameter TOTAL_DATA_WIDTH = DATA_WIDTH + 2'd2;

logic [3:0] bit_counter; logic [(BAUD_COUNTER_WIDTH - 1'd1):0] baud_counter;

always_ff @ (posedge clock)
begin
if (reset)
baud_counter <= {BAUD_COUNTER_WIDTH{1'b0}};
else if (reset_counter)
baud_counter <= {BAUD_COUNTER_WIDTH{1'b0}};
else if (baud_counter == BAUD_TICK_COUNT)
baud_counter <= {BAUD_COUNTER_WIDTH{1'b0}};
else
baud_counter <= baud_counter + 1'b1;
end

always_ff @ (posedge clock)
begin
if (reset)
baud_clock_rising_edge <= 1'b0;
else if (baud_counter == BAUD_TICK_COUNT)
baud_clock_rising_edge <= 1'b1;
else
baud_clock_rising_edge <= 1'b0;
end

always_ff @ (posedge clock)
begin
if (reset)
baud_clock_falling_edge <= 1'b0;
else if (baud_counter == HALF_BAUD_TICK_COUNT)
baud_clock_falling_edge <= 1'b1;
else
baud_clock_falling_edge <= 1'b0;
end
 
always_ff @ (posedge clock)
begin
if (reset)
bit_counter <= 4'b0;
else if (reset_counter)
bit_counter <= 4'b0;
else if (bit_counter == TOTAL_DATA_WIDTH)
bit_counter <= 4'b0;
else if (baud_counter == BAUD_TICK_COUNT)
bit_counter <= bit_counter + 1'b1;
end

always_ff @ (posedge clock)
begin
if (reset)
bits_done_flag <= 1'b0;
else if (bit_counter == TOTAL_DATA_WIDTH)
bits_done_flag <= 1'b1;
else
bits_done_flag <= 1'b0;
end

endmodule

// ---- ---- ---- ---- //

module Seven_Segment_Display (input_digit, output_display);
	
input [3:0] input_digit;
output logic [6:0] output_display;

always_comb
begin
case (input_digit)
4'h0: output_display = 7'b1000000;
4'h1: output_display = 7'b1111001; 	
4'h2: output_display = 7'b0100100; 	
4'h3: output_display = 7'b0110000; 	
4'h4: output_display = 7'b0011001; 	
4'h5: output_display = 7'b0010010; 	
4'h6: output_display = 7'b0000010; 	
4'h7: output_display = 7'b1111000;	
4'h8: output_display = 7'b0000000; 	
4'h9: output_display = 7'b0010000;
4'hA: output_display = 7'b0001000;
4'hb: output_display = 7'b0000011;
4'hC: output_display = 7'b1000110;
4'hd: output_display = 7'b0100001;
4'hE: output_display = 7'b0000110;
4'hF: output_display = 7'b0001110;
endcase
end

endmodule