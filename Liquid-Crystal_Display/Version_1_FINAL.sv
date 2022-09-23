module Version_1_FINAL (clock, reset_active_low, rotate, lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, unused_pins);

input logic clock, reset_active_low, rotate;
output logic lcd_rw, lcd_en, lcd_rs, lcd_on; output logic [3:0] lcd_data; output logic [3:0] unused_pins;

logic screen_1_flag = 1'b0;
logic screen_2_flag = 1'b0;
logic screen_3_flag = 1'b0; 
logic screen_4_flag = 1'b0; 
logic [3:0] lcd_command_data; 
logic [9:0] state = 10'd0; 
logic [24:0] counter = 25'd0;

parameter delay_15_ms = 850000;//750000 
parameter delay_230_ns = 22;//12
parameter delay_4_1_ms = 305000;//205000
parameter delay_100_us = 6000;//5000
parameter delay_40_us = 3000;//2000
parameter delay_1_us = 60;//50
parameter delay_1_64_ms = 92000;//82000
parameter delay_debounce = 9_000_000;

parameter IDLE_STATE = 10'd0; 
parameter INITIALIZATION_STATE_1 = 10'd1; 
parameter INITIALIZATION_STATE_1_DELAY = 10'd2; 
parameter INITIALIZATION_STATE_2 = 10'd3; 
parameter INITIALIZATION_STATE_2_DELAY = 10'd4; 
parameter INITIALIZATION_STATE_3 = 10'd5; 
parameter INITIALIZATION_STATE_3_DELAY = 10'd6;
parameter INITIALIZATION_STATE_4 = 10'd7; 
parameter INITIALIZATION_STATE_4_DELAY = 10'd8;
parameter FUNCTION_SET_STATE_UPPER_NIBBLE = 10'd9;
parameter FUNCTION_SET_STATE_LOWER_NIBBLE = 10'd10;
parameter FUNCTION_SET_STATE_NIBBLE_DELAY = 10'd11;
parameter BYTE_DELAY_1 = 10'd12;
parameter DISPLAY_ON_OFF_CONTROL_STATE_UPPER_NIBBLE = 10'd13;
parameter DISPLAY_ON_OFF_CONTROL_STATE_LOWER_NIBBLE = 10'd14;
parameter DISPLAY_ON_OFF_CONTROL_STATE_NIBBLE_DELAY = 10'd15;
parameter BYTE_DELAY_2 = 10'd16;
parameter CLEAR_DISPLAY_STATE_UPPER_NIBBLE = 10'd17;
parameter CLEAR_DISPLAY_STATE_LOWER_NIBBLE = 10'd18;
parameter CLEAR_DISPLAY_STATE_NIBBLE_DELAY = 10'd19;
parameter BYTE_DELAY_3 = 10'd20;
parameter ENTRY_MODE_SET_STATE_UPPER_NIBBLE = 10'd21;
parameter ENTRY_MODE_SET_STATE_LOWER_NIBBLE = 10'd22;
parameter ENTRY_MODE_SET_STATE_NIBBLE_DELAY = 10'd23;
parameter BYTE_DELAY_4 = 10'd24;
parameter CURSOR_FIRST_LINE_STATE_UPPER_NIBBLE = 10'd25;
parameter CURSOR_FIRST_LINE_STATE_LOWER_NIBBLE = 10'd26;
parameter CURSOR_FIRST_LINE_STATE_NIBBLE_DELAY = 10'd27;
parameter BYTE_DELAY_5 = 10'd28;
parameter DISPLAY_A_UC_Altera_STATE_UPPER_NIBBLE = 10'd29;
parameter DISPLAY_A_UC_Altera_STATE_LOWER_NIBBLE = 10'd30;
parameter DISPLAY_A_UC_Altera_STATE_NIBBLE_DELAY = 10'd31;
parameter BYTE_DELAY_A_UC_Altera = 10'd32;
parameter DISPLAY_l_Altera_STATE_UPPER_NIBBLE = 10'd33;
parameter DISPLAY_l_Altera_STATE_LOWER_NIBBLE = 10'd34;
parameter DISPLAY_l_Altera_STATE_NIBBLE_DELAY = 10'd35;
parameter BYTE_DELAY_l_Altera = 10'd36;
parameter DISPLAY_t_Altera_STATE_UPPER_NIBBLE = 10'd37;
parameter DISPLAY_t_Altera_STATE_LOWER_NIBBLE = 10'd38;
parameter DISPLAY_t_Altera_STATE_NIBBLE_DELAY = 10'd39;
parameter BYTE_DELAY_t_Altera = 10'd40;
parameter DISPLAY_e_Altera_STATE_UPPER_NIBBLE = 10'd41;
parameter DISPLAY_e_Altera_STATE_LOWER_NIBBLE = 10'd42;
parameter DISPLAY_e_Altera_STATE_NIBBLE_DELAY = 10'd43;
parameter BYTE_DELAY_e_Altera = 10'd44;
parameter DISPLAY_r_Altera_STATE_UPPER_NIBBLE = 10'd45;
parameter DISPLAY_r_Altera_STATE_LOWER_NIBBLE = 10'd46;
parameter DISPLAY_r_Altera_STATE_NIBBLE_DELAY = 10'd47;
parameter BYTE_DELAY_r_Altera = 10'd48;
parameter DISPLAY_a_Altera_STATE_UPPER_NIBBLE = 10'd49;
parameter DISPLAY_a_Altera_STATE_LOWER_NIBBLE = 10'd50;
parameter DISPLAY_a_Altera_STATE_NIBBLE_DELAY = 10'd51;
parameter BYTE_DELAY_a_Altera = 10'd52;
parameter DISPLAY_SPACE_1_STATE_UPPER_NIBBLE = 10'd53;
parameter DISPLAY_SPACE_1_STATE_LOWER_NIBBLE = 10'd54;
parameter DISPLAY_SPACE_1_STATE_NIBBLE_DELAY = 10'd55;
parameter BYTE_DELAY_SPACE_1 = 10'd56;
parameter DISPLAY_D_DE2_STATE_UPPER_NIBBLE = 10'd57;
parameter DISPLAY_D_DE2_STATE_LOWER_NIBBLE = 10'd58;
parameter DISPLAY_D_DE2_STATE_NIBBLE_DELAY = 10'd59;
parameter BYTE_DELAY_D_DE2 = 10'd60;
parameter DISPLAY_E_DE2_STATE_UPPER_NIBBLE = 10'd61;
parameter DISPLAY_E_DE2_STATE_LOWER_NIBBLE = 10'd62;
parameter DISPLAY_E_DE2_STATE_NIBBLE_DELAY = 10'd63;
parameter BYTE_DELAY_E_DE2 = 10'd64;
parameter DISPLAY_2_DE2_STATE_UPPER_NIBBLE = 10'd65;
parameter DISPLAY_2_DE2_STATE_LOWER_NIBBLE = 10'd66;
parameter DISPLAY_2_DE2_STATE_NIBBLE_DELAY = 10'd67;
parameter BYTE_DELAY_2_DE2 = 10'd68;
parameter DISPLAY_SPACE_2_STATE_UPPER_NIBBLE = 10'd69;
parameter DISPLAY_SPACE_2_STATE_LOWER_NIBBLE = 10'd70;
parameter DISPLAY_SPACE_2_STATE_NIBBLE_DELAY = 10'd71;
parameter BYTE_DELAY_SPACE_2 = 10'd72;
parameter DISPLAY_B_Board_STATE_UPPER_NIBBLE = 10'd73;
parameter DISPLAY_B_Board_STATE_LOWER_NIBBLE = 10'd74;
parameter DISPLAY_B_Board_STATE_NIBBLE_DELAY = 10'd75;
parameter BYTE_DELAY_B_Board = 10'd76;
parameter DISPLAY_o_Board_STATE_UPPER_NIBBLE = 10'd77;
parameter DISPLAY_o_Board_STATE_LOWER_NIBBLE = 10'd78;
parameter DISPLAY_o_Board_STATE_NIBBLE_DELAY = 10'd79;
parameter BYTE_DELAY_o_Board = 10'd80;
parameter DISPLAY_a_Board_STATE_UPPER_NIBBLE = 10'd81;
parameter DISPLAY_a_Board_STATE_LOWER_NIBBLE = 10'd82;
parameter DISPLAY_a_Board_STATE_NIBBLE_DELAY = 10'd83;
parameter BYTE_DELAY_a_Board = 10'd84;
parameter DISPLAY_r_Board_STATE_UPPER_NIBBLE = 10'd85;
parameter DISPLAY_r_Board_STATE_LOWER_NIBBLE = 10'd86;
parameter DISPLAY_r_Board_STATE_NIBBLE_DELAY = 10'd87;
parameter BYTE_DELAY_r_Board = 10'd88;
parameter DISPLAY_d_Board_STATE_UPPER_NIBBLE = 10'd89;
parameter DISPLAY_d_Board_STATE_LOWER_NIBBLE = 10'd90;
parameter DISPLAY_d_Board_STATE_NIBBLE_DELAY = 10'd91;
parameter BYTE_DELAY_d_Board = 10'd92;
parameter CURSOR_SECOND_LINE_STATE_UPPER_NIBBLE = 10'd93;
parameter CURSOR_SECOND_LINE_STATE_LOWER_NIBBLE = 10'd94;
parameter CURSOR_SECOND_LINE_STATE_NIBBLE_DELAY = 10'd95;
parameter BYTE_DELAY_6 = 10'd96;
parameter DISPLAY_N_Nice_STATE_UPPER_NIBBLE = 10'd97;
parameter DISPLAY_N_Nice_STATE_LOWER_NIBBLE = 10'd98;
parameter DISPLAY_N_Nice_STATE_NIBBLE_DELAY = 10'd99;
parameter BYTE_DELAY_N_Nice = 10'd100;
parameter DISPLAY_i_Nice_STATE_UPPER_NIBBLE = 10'd101;
parameter DISPLAY_i_Nice_STATE_LOWER_NIBBLE = 10'd102;
parameter DISPLAY_i_Nice_STATE_NIBBLE_DELAY = 10'd103;
parameter BYTE_DELAY_i_Nice = 10'd104;
parameter DISPLAY_c_Nice_STATE_UPPER_NIBBLE = 10'd105;
parameter DISPLAY_c_Nice_STATE_LOWER_NIBBLE = 10'd106;
parameter DISPLAY_c_Nice_STATE_NIBBLE_DELAY = 10'd107;
parameter BYTE_DELAY_c_Nice = 10'd108;
parameter DISPLAY_e_Nice_STATE_UPPER_NIBBLE = 10'd109;
parameter DISPLAY_e_Nice_STATE_LOWER_NIBBLE = 10'd110;
parameter DISPLAY_e_Nice_STATE_NIBBLE_DELAY = 10'd111;
parameter BYTE_DELAY_e_Nice = 10'd112;
parameter DISPLAY_SPACE_3_STATE_UPPER_NIBBLE = 10'd113;
parameter DISPLAY_SPACE_3_STATE_LOWER_NIBBLE = 10'd114;
parameter DISPLAY_SPACE_3_STATE_NIBBLE_DELAY = 10'd115;
parameter BYTE_DELAY_SPACE_3 = 10'd116;
parameter DISPLAY_T_To_STATE_UPPER_NIBBLE = 10'd117;
parameter DISPLAY_T_To_STATE_LOWER_NIBBLE = 10'd118;
parameter DISPLAY_T_To_STATE_NIBBLE_DELAY = 10'd119;
parameter BYTE_DELAY_T_To = 10'd120;
parameter DISPLAY_o_To_STATE_UPPER_NIBBLE = 10'd121;
parameter DISPLAY_o_To_STATE_LOWER_NIBBLE = 10'd122;
parameter DISPLAY_o_To_STATE_NIBBLE_DELAY = 10'd123;
parameter BYTE_DELAY_o_To = 10'd124;
parameter DISPLAY_SPACE_4_STATE_UPPER_NIBBLE = 10'd125;
parameter DISPLAY_SPACE_4_STATE_LOWER_NIBBLE = 10'd126;
parameter DISPLAY_SPACE_4_STATE_NIBBLE_DELAY = 10'd127;
parameter BYTE_DELAY_SPACE_4 = 10'd128;
parameter DISPLAY_S_See_STATE_UPPER_NIBBLE = 10'd129;
parameter DISPLAY_S_See_STATE_LOWER_NIBBLE = 10'd130;
parameter DISPLAY_S_See_STATE_NIBBLE_DELAY = 10'd131;
parameter BYTE_DELAY_S_See = 10'd132;
parameter DISPLAY_e_See_STATE_UPPER_NIBBLE = 10'd133;
parameter DISPLAY_e_See_STATE_LOWER_NIBBLE = 10'd134;
parameter DISPLAY_e_See_STATE_NIBBLE_DELAY = 10'd135;
parameter BYTE_DELAY_e_See = 10'd136;
parameter DISPLAY_e_again_See_STATE_UPPER_NIBBLE = 10'd137;
parameter DISPLAY_e_again_See_STATE_LOWER_NIBBLE = 10'd138;
parameter DISPLAY_e_again_See_STATE_NIBBLE_DELAY = 10'd139;
parameter BYTE_DELAY_e_again_See = 10'd140;
parameter DISPLAY_SPACE_5_STATE_UPPER_NIBBLE = 10'd141;
parameter DISPLAY_SPACE_5_STATE_LOWER_NIBBLE = 10'd142;
parameter DISPLAY_SPACE_5_STATE_NIBBLE_DELAY = 10'd143;
parameter BYTE_DELAY_SPACE_5 = 10'd144;
parameter DISPLAY_Y_You_EM_STATE_UPPER_NIBBLE = 10'd145;
parameter DISPLAY_Y_You_EM_STATE_LOWER_NIBBLE = 10'd146;
parameter DISPLAY_Y_You_EM_STATE_NIBBLE_DELAY = 10'd147;
parameter BYTE_DELAY_Y_You_EM = 10'd148;
parameter DISPLAY_o_You_EM_STATE_UPPER_NIBBLE = 10'd149;
parameter DISPLAY_o_You_EM_STATE_LOWER_NIBBLE = 10'd150;
parameter DISPLAY_o_You_EM_STATE_NIBBLE_DELAY = 10'd151;
parameter BYTE_DELAY_o_You_EM = 10'd152;
parameter DISPLAY_u_You_EM_STATE_UPPER_NIBBLE = 10'd153;
parameter DISPLAY_u_You_EM_STATE_LOWER_NIBBLE = 10'd154;
parameter DISPLAY_u_You_EM_STATE_NIBBLE_DELAY = 10'd155;
parameter BYTE_DELAY_u_You_EM = 10'd156;
parameter DISPLAY_EM_You_EM_STATE_UPPER_NIBBLE = 10'd157;
parameter DISPLAY_EM_You_EM_STATE_LOWER_NIBBLE = 10'd158;
parameter DISPLAY_EM_You_EM_STATE_NIBBLE_DELAY = 10'd159;
parameter BYTE_DELAY_EM_You_EM = 10'd160;

parameter IDLE_STATE_SCREEN_2 = 10'd0; 
parameter INITIALIZATION_STATE_1_SCREEN_2 = 10'd1; 
parameter INITIALIZATION_STATE_1_DELAY_SCREEN_2 = 10'd2; 
parameter INITIALIZATION_STATE_2_SCREEN_2 = 10'd3; 
parameter INITIALIZATION_STATE_2_DELAY_SCREEN_2 = 10'd4; 
parameter INITIALIZATION_STATE_3_SCREEN_2 = 10'd5; 
parameter INITIALIZATION_STATE_3_DELAY_SCREEN_2 = 10'd6;
parameter INITIALIZATION_STATE_4_SCREEN_2 = 10'd7; 
parameter INITIALIZATION_STATE_4_DELAY_SCREEN_2 = 10'd8;
parameter FUNCTION_SET_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd9;
parameter FUNCTION_SET_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd10;
parameter FUNCTION_SET_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd11;
parameter BYTE_DELAY_1_SCREEN_2 = 10'd12;
parameter DISPLAY_ON_OFF_CONTROL_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd13;
parameter DISPLAY_ON_OFF_CONTROL_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd14;
parameter DISPLAY_ON_OFF_CONTROL_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd15;
parameter BYTE_DELAY_2_SCREEN_2 = 10'd16;
parameter CLEAR_DISPLAY_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd17;
parameter CLEAR_DISPLAY_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd18;
parameter CLEAR_DISPLAY_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd19;
parameter BYTE_DELAY_3_SCREEN_2 = 10'd20;
parameter ENTRY_MODE_SET_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd21;
parameter ENTRY_MODE_SET_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd22;
parameter ENTRY_MODE_SET_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd23;
parameter BYTE_DELAY_4_SCREEN_2 = 10'd24;
parameter CURSOR_FIRST_LINE_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd25;
parameter CURSOR_FIRST_LINE_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd26;
parameter CURSOR_FIRST_LINE_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd27;
parameter BYTE_DELAY_5_SCREEN_2 = 10'd28;
parameter DISPLAY_SPACE_1_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd29;
parameter DISPLAY_SPACE_1_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd30;
parameter DISPLAY_SPACE_1_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd31;
parameter BYTE_DELAY_SPACE_1_SCREEN_2 = 10'd32;
parameter DISPLAY_SPACE_2_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd33;
parameter DISPLAY_SPACE_2_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd34;
parameter DISPLAY_SPACE_2_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd35;
parameter BYTE_DELAY_SPACE_2_SCREEN_2 = 10'd36;
parameter DISPLAY_SPACE_3_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd37;
parameter DISPLAY_SPACE_3_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd38;
parameter DISPLAY_SPACE_3_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd39;
parameter BYTE_DELAY_SPACE_3_SCREEN_2 = 10'd40;
parameter DISPLAY_SPACE_4_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd41;
parameter DISPLAY_SPACE_4_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd42;
parameter DISPLAY_SPACE_4_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd43;
parameter BYTE_DELAY_SPACE_4_SCREEN_2 = 10'd44;
parameter DISPLAY_SPACE_5_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd45;
parameter DISPLAY_SPACE_5_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd46;
parameter DISPLAY_SPACE_5_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd47;
parameter BYTE_DELAY_SPACE_5_SCREEN_2 = 10'd48;
parameter DISPLAY_SPACE_6_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd49;
parameter DISPLAY_SPACE_6_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd50;
parameter DISPLAY_SPACE_6_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd51;
parameter BYTE_DELAY_SPACE_6_SCREEN_2 = 10'd52;
parameter DISPLAY_R_RMIT_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd53;
parameter DISPLAY_R_RMIT_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd54;
parameter DISPLAY_R_RMIT_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd55;
parameter BYTE_DELAY_R_RMIT_SCREEN_2 = 10'd56;
parameter DISPLAY_M_RMIT_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd57;
parameter DISPLAY_M_RMIT_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd58;
parameter DISPLAY_M_RMIT_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd59;
parameter BYTE_DELAY_M_RMIT_SCREEN_2 = 10'd60;
parameter DISPLAY_I_RMIT_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd61;
parameter DISPLAY_I_RMIT_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd62;
parameter DISPLAY_I_RMIT_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd63;
parameter BYTE_DELAY_I_RMIT_SCREEN_2 = 10'd64;
parameter DISPLAY_T_RMIT_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd65;
parameter DISPLAY_T_RMIT_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd66;
parameter DISPLAY_T_RMIT_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd67;
parameter BYTE_DELAY_T_RMIT_SCREEN_2 = 10'd68;
parameter CURSOR_SECOND_LINE_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd69;
parameter CURSOR_SECOND_LINE_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd70;
parameter CURSOR_SECOND_LINE_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd71;
parameter BYTE_DELAY_6_SCREEN_2 = 10'd72;
parameter DISPLAY_SPACE_7_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd73;
parameter DISPLAY_SPACE_7_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd74;
parameter DISPLAY_SPACE_7_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd75;
parameter BYTE_DELAY_SPACE_7_SCREEN_2 = 10'd76;
parameter DISPLAY_SPACE_8_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd77;
parameter DISPLAY_SPACE_8_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd78;
parameter DISPLAY_SPACE_8_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd79;
parameter BYTE_DELAY_SPACE_8_SCREEN_2 = 10'd80;
parameter DISPLAY_SPACE_9_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd81;
parameter DISPLAY_SPACE_9_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd82;
parameter DISPLAY_SPACE_9_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd83;
parameter BYTE_DELAY_SPACE_9_SCREEN_2 = 10'd84;
parameter DISPLAY_SPACE_10_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd85;
parameter DISPLAY_SPACE_10_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd86;
parameter DISPLAY_SPACE_10_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd87;
parameter BYTE_DELAY_SPACE_10_SCREEN_2 = 10'd88;
parameter DISPLAY_SPACE_11_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd89;
parameter DISPLAY_SPACE_11_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd90;
parameter DISPLAY_SPACE_11_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd91;
parameter BYTE_DELAY_SPACE_11_SCREEN_2 = 10'd92;
parameter DISPLAY_SPACE_12_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd93;
parameter DISPLAY_SPACE_12_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd94;
parameter DISPLAY_SPACE_12_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd95;
parameter BYTE_DELAY_SPACE_12_SCREEN_2 = 10'd96;
parameter DISPLAY_2_FIRST_2022_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd97;
parameter DISPLAY_2_FIRST_2022_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd98;
parameter DISPLAY_2_FIRST_2022_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd99;
parameter BYTE_DELAY_2_FIRST_2022_SCREEN_2 = 10'd100;
parameter DISPLAY_0_2022_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd101;
parameter DISPLAY_0_2022_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd102;
parameter DISPLAY_0_2022_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd103;
parameter BYTE_DELAY_0_2022_SCREEN_2 = 10'd104;
parameter DISPLAY_2_SECOND_2022_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd105;
parameter DISPLAY_2_SECOND_2022_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd106;
parameter DISPLAY_2_SECOND_2022_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd107;
parameter BYTE_DELAY_2_SECOND_2022_SCREEN_2 = 10'd108;
parameter DISPLAY_2_THIRD_2022_STATE_UPPER_NIBBLE_SCREEN_2 = 10'd109;
parameter DISPLAY_2_THIRD_2022_STATE_LOWER_NIBBLE_SCREEN_2 = 10'd110;
parameter DISPLAY_2_THIRD_2022_STATE_NIBBLE_DELAY_SCREEN_2 = 10'd111;
parameter BYTE_DELAY_2_THIRD_2022_SCREEN_2 = 10'd112;

parameter IDLE_STATE_SCREEN_3 = 10'd0; 
parameter INITIALIZATION_STATE_1_SCREEN_3 = 10'd1; 
parameter INITIALIZATION_STATE_1_DELAY_SCREEN_3 = 10'd2; 
parameter INITIALIZATION_STATE_2_SCREEN_3 = 10'd3; 
parameter INITIALIZATION_STATE_2_DELAY_SCREEN_3 = 10'd4; 
parameter INITIALIZATION_STATE_3_SCREEN_3 = 10'd5; 
parameter INITIALIZATION_STATE_3_DELAY_SCREEN_3 = 10'd6;
parameter INITIALIZATION_STATE_4_SCREEN_3 = 10'd7; 
parameter INITIALIZATION_STATE_4_DELAY_SCREEN_3 = 10'd8;
parameter FUNCTION_SET_STATE_UPPER_NIBBLE_SCREEN_3 = 10'd9;
parameter FUNCTION_SET_STATE_LOWER_NIBBLE_SCREEN_3 = 10'd10;
parameter FUNCTION_SET_STATE_NIBBLE_DELAY_SCREEN_3 = 10'd11;
parameter BYTE_DELAY_1_SCREEN_3 = 10'd12;
parameter DISPLAY_ON_OFF_CONTROL_STATE_UPPER_NIBBLE_SCREEN_3 = 10'd13;
parameter DISPLAY_ON_OFF_CONTROL_STATE_LOWER_NIBBLE_SCREEN_3 = 10'd14;
parameter DISPLAY_ON_OFF_CONTROL_STATE_NIBBLE_DELAY_SCREEN_3 = 10'd15;
parameter BYTE_DELAY_2_SCREEN_3 = 10'd16;
parameter CLEAR_DISPLAY_STATE_UPPER_NIBBLE_SCREEN_3 = 10'd17;
parameter CLEAR_DISPLAY_STATE_LOWER_NIBBLE_SCREEN_3 = 10'd18;
parameter CLEAR_DISPLAY_STATE_NIBBLE_DELAY_SCREEN_3 = 10'd19;
parameter BYTE_DELAY_3_SCREEN_3 = 10'd20;
parameter ENTRY_MODE_SET_STATE_UPPER_NIBBLE_SCREEN_3 = 10'd21;
parameter ENTRY_MODE_SET_STATE_LOWER_NIBBLE_SCREEN_3 = 10'd22;
parameter ENTRY_MODE_SET_STATE_NIBBLE_DELAY_SCREEN_3 = 10'd23;
parameter BYTE_DELAY_4_SCREEN_3 = 10'd24;
parameter CURSOR_FIRST_LINE_STATE_UPPER_NIBBLE_SCREEN_3 = 10'd25;
parameter CURSOR_FIRST_LINE_STATE_LOWER_NIBBLE_SCREEN_3 = 10'd26;
parameter CURSOR_FIRST_LINE_STATE_NIBBLE_DELAY_SCREEN_3 = 10'd27;
parameter BYTE_DELAY_5_SCREEN_3 = 10'd28;
parameter DISPLAY_SPACE_1_STATE_UPPER_NIBBLE_SCREEN_3 = 10'd29;
parameter DISPLAY_SPACE_1_STATE_LOWER_NIBBLE_SCREEN_3 = 10'd30;
parameter DISPLAY_SPACE_1_STATE_NIBBLE_DELAY_SCREEN_3 = 10'd31;
parameter BYTE_DELAY_SPACE_1_SCREEN_3 = 10'd32;
parameter DISPLAY_SPACE_2_STATE_UPPER_NIBBLE_SCREEN_3 = 10'd33;
parameter DISPLAY_SPACE_2_STATE_LOWER_NIBBLE_SCREEN_3 = 10'd34;
parameter DISPLAY_SPACE_2_STATE_NIBBLE_DELAY_SCREEN_3 = 10'd35;
parameter BYTE_DELAY_SPACE_2_SCREEN_3 = 10'd36;
parameter DISPLAY_SPACE_3_STATE_UPPER_NIBBLE_SCREEN_3 = 10'd37;
parameter DISPLAY_SPACE_3_STATE_LOWER_NIBBLE_SCREEN_3 = 10'd38;
parameter DISPLAY_SPACE_3_STATE_NIBBLE_DELAY_SCREEN_3 = 10'd39;
parameter BYTE_DELAY_SPACE_3_SCREEN_3 = 10'd40;
parameter DISPLAY_SPACE_4_STATE_UPPER_NIBBLE_SCREEN_3 = 10'd41;
parameter DISPLAY_SPACE_4_STATE_LOWER_NIBBLE_SCREEN_3 = 10'd42;
parameter DISPLAY_SPACE_4_STATE_NIBBLE_DELAY_SCREEN_3 = 10'd43;
parameter BYTE_DELAY_SPACE_4_SCREEN_3 = 10'd44;
parameter DISPLAY_E_E_mc_2_STATE_UPPER_NIBBLE_SCREEN_3 = 10'd45;
parameter DISPLAY_E_E_mc_2_STATE_LOWER_NIBBLE_SCREEN_3 = 10'd46;
parameter DISPLAY_E_E_mc_2_STATE_NIBBLE_DELAY_SCREEN_3 = 10'd47;
parameter BYTE_DELAY_E_E_mc_2_SCREEN_3 = 10'd48;
parameter DISPLAY_SPACE_5_STATE_UPPER_NIBBLE_SCREEN_3 = 10'd49;
parameter DISPLAY_SPACE_5_STATE_LOWER_NIBBLE_SCREEN_3 = 10'd50;
parameter DISPLAY_SPACE_5_STATE_NIBBLE_DELAY_SCREEN_3 = 10'd51;
parameter BYTE_DELAY_SPACE_5_SCREEN_3 = 10'd52;
parameter DISPLAY_ES_E_mc_2_STATE_UPPER_NIBBLE_SCREEN_3 = 10'd53;
parameter DISPLAY_ES_E_mc_2_STATE_LOWER_NIBBLE_SCREEN_3 = 10'd54;
parameter DISPLAY_ES_E_mc_2_STATE_NIBBLE_DELAY_SCREEN_3 = 10'd55;
parameter BYTE_DELAY_ES_E_mc_2_SCREEN_3 = 10'd56;
parameter DISPLAY_SPACE_6_STATE_UPPER_NIBBLE_SCREEN_3 = 10'd57;
parameter DISPLAY_SPACE_6_STATE_LOWER_NIBBLE_SCREEN_3 = 10'd58;
parameter DISPLAY_SPACE_6_STATE_NIBBLE_DELAY_SCREEN_3 = 10'd59;
parameter BYTE_DELAY_SPACE_6_SCREEN_3 = 10'd60;
parameter DISPLAY_m_E_mc_2_STATE_UPPER_NIBBLE_SCREEN_3 = 10'd61;
parameter DISPLAY_m_E_mc_2_STATE_LOWER_NIBBLE_SCREEN_3 = 10'd62;
parameter DISPLAY_m_E_mc_2_STATE_NIBBLE_DELAY_SCREEN_3 = 10'd63;
parameter BYTE_DELAY_m_E_mc_2_SCREEN_3 = 10'd64;
parameter DISPLAY_c_E_mc_2_STATE_UPPER_NIBBLE_SCREEN_3 = 10'd65;
parameter DISPLAY_c_E_mc_2_STATE_LOWER_NIBBLE_SCREEN_3 = 10'd66;
parameter DISPLAY_c_E_mc_2_STATE_NIBBLE_DELAY_SCREEN_3 = 10'd67;
parameter BYTE_DELAY_c_E_mc_2_SCREEN_3 = 10'd68;
parameter DISPLAY_EF_E_mc_2_STATE_UPPER_NIBBLE_SCREEN_3 = 10'd69;
parameter DISPLAY_EF_E_mc_2_STATE_LOWER_NIBBLE_SCREEN_3 = 10'd70;
parameter DISPLAY_EF_E_mc_2_STATE_NIBBLE_DELAY_SCREEN_3 = 10'd71;
parameter BYTE_DELAY_EF_E_mc_2_SCREEN_3 = 10'd72;
parameter DISPLAY_2_E_mc_2_STATE_UPPER_NIBBLE_SCREEN_3 = 10'd73;
parameter DISPLAY_2_E_mc_2_STATE_LOWER_NIBBLE_SCREEN_3 = 10'd74;
parameter DISPLAY_2_E_mc_2_STATE_NIBBLE_DELAY_SCREEN_3 = 10'd75;
parameter BYTE_DELAY_2_E_mc_2_SCREEN_3 = 10'd76;

parameter IDLE_STATE_SCREEN_4 = 10'd0; 
parameter INITIALIZATION_STATE_1_SCREEN_4 = 10'd1; 
parameter INITIALIZATION_STATE_1_DELAY_SCREEN_4 = 10'd2; 
parameter INITIALIZATION_STATE_2_SCREEN_4 = 10'd3; 
parameter INITIALIZATION_STATE_2_DELAY_SCREEN_4 = 10'd4; 
parameter INITIALIZATION_STATE_3_SCREEN_4 = 10'd5; 
parameter INITIALIZATION_STATE_3_DELAY_SCREEN_4 = 10'd6;
parameter INITIALIZATION_STATE_4_SCREEN_4 = 10'd7; 
parameter INITIALIZATION_STATE_4_DELAY_SCREEN_4 = 10'd8;
parameter FUNCTION_SET_STATE_UPPER_NIBBLE_SCREEN_4 = 10'd9;
parameter FUNCTION_SET_STATE_LOWER_NIBBLE_SCREEN_4 = 10'd10;
parameter FUNCTION_SET_STATE_NIBBLE_DELAY_SCREEN_4 = 10'd11;
parameter BYTE_DELAY_1_SCREEN_4 = 10'd12;
parameter DISPLAY_ON_OFF_CONTROL_STATE_UPPER_NIBBLE_SCREEN_4 = 10'd13;
parameter DISPLAY_ON_OFF_CONTROL_STATE_LOWER_NIBBLE_SCREEN_4 = 10'd14;
parameter DISPLAY_ON_OFF_CONTROL_STATE_NIBBLE_DELAY_SCREEN_4 = 10'd15;
parameter BYTE_DELAY_2_SCREEN_4 = 10'd16;
parameter CLEAR_DISPLAY_STATE_UPPER_NIBBLE_SCREEN_4 = 10'd17;
parameter CLEAR_DISPLAY_STATE_LOWER_NIBBLE_SCREEN_4 = 10'd18;
parameter CLEAR_DISPLAY_STATE_NIBBLE_DELAY_SCREEN_4 = 10'd19;
parameter BYTE_DELAY_3_SCREEN_4 = 10'd20;
parameter ENTRY_MODE_SET_STATE_UPPER_NIBBLE_SCREEN_4 = 10'd21;
parameter ENTRY_MODE_SET_STATE_LOWER_NIBBLE_SCREEN_4 = 10'd22;
parameter ENTRY_MODE_SET_STATE_NIBBLE_DELAY_SCREEN_4 = 10'd23;
parameter BYTE_DELAY_4_SCREEN_4 = 10'd24;
parameter CURSOR_FIRST_LINE_STATE_UPPER_NIBBLE_SCREEN_4 = 10'd25;
parameter CURSOR_FIRST_LINE_STATE_LOWER_NIBBLE_SCREEN_4 = 10'd26;
parameter CURSOR_FIRST_LINE_STATE_NIBBLE_DELAY_SCREEN_4 = 10'd27;
parameter BYTE_DELAY_5_SCREEN_4 = 10'd28;
parameter DISPLAY_SPACE_1_STATE_UPPER_NIBBLE_SCREEN_4 = 10'd29;
parameter DISPLAY_SPACE_1_STATE_LOWER_NIBBLE_SCREEN_4 = 10'd30;
parameter DISPLAY_SPACE_1_STATE_NIBBLE_DELAY_SCREEN_4 = 10'd31;
parameter BYTE_DELAY_SPACE_1_SCREEN_4 = 10'd32;
parameter DISPLAY_SPACE_2_STATE_UPPER_NIBBLE_SCREEN_4 = 10'd33;
parameter DISPLAY_SPACE_2_STATE_LOWER_NIBBLE_SCREEN_4 = 10'd34;
parameter DISPLAY_SPACE_2_STATE_NIBBLE_DELAY_SCREEN_4 = 10'd35;
parameter BYTE_DELAY_SPACE_2_SCREEN_4 = 10'd36;
parameter DISPLAY_SPACE_3_STATE_UPPER_NIBBLE_SCREEN_4 = 10'd37;
parameter DISPLAY_SPACE_3_STATE_LOWER_NIBBLE_SCREEN_4 = 10'd38;
parameter DISPLAY_SPACE_3_STATE_NIBBLE_DELAY_SCREEN_4 = 10'd39;
parameter BYTE_DELAY_SPACE_3_SCREEN_4 = 10'd40;
parameter DISPLAY_SPACE_4_STATE_UPPER_NIBBLE_SCREEN_4 = 10'd41;
parameter DISPLAY_SPACE_4_STATE_LOWER_NIBBLE_SCREEN_4 = 10'd42;
parameter DISPLAY_SPACE_4_STATE_NIBBLE_DELAY_SCREEN_4 = 10'd43;
parameter BYTE_DELAY_SPACE_4_SCREEN_4 = 10'd44;
parameter DISPLAY_H_HD_STATE_UPPER_NIBBLE_SCREEN_4 = 10'd45;
parameter DISPLAY_H_HD_STATE_LOWER_NIBBLE_SCREEN_4 = 10'd46;
parameter DISPLAY_H_HD_STATE_NIBBLE_DELAY_SCREEN_4 = 10'd47;
parameter BYTE_DELAY_H_HD_SCREEN_4 = 10'd48;
parameter DISPLAY_D_HD_STATE_UPPER_NIBBLE_SCREEN_4 = 10'd49;
parameter DISPLAY_D_HD_STATE_LOWER_NIBBLE_SCREEN_4 = 10'd50;
parameter DISPLAY_D_HD_STATE_NIBBLE_DELAY_SCREEN_4 = 10'd51;
parameter BYTE_DELAY_D_HD_SCREEN_4 = 10'd52;
parameter DISPLAY_SPACE_5_STATE_UPPER_NIBBLE_SCREEN_4 = 10'd53;
parameter DISPLAY_SPACE_5_STATE_LOWER_NIBBLE_SCREEN_4 = 10'd54;
parameter DISPLAY_SPACE_5_STATE_NIBBLE_DELAY_SCREEN_4 = 10'd55;
parameter BYTE_DELAY_SPACE_5_SCREEN_4 = 10'd56;
parameter DISPLAY_o_or_STATE_UPPER_NIBBLE_SCREEN_4 = 10'd57;
parameter DISPLAY_o_or_STATE_LOWER_NIBBLE_SCREEN_4 = 10'd58;
parameter DISPLAY_o_or_STATE_NIBBLE_DELAY_SCREEN_4 = 10'd59;
parameter BYTE_DELAY_o_or_SCREEN_4 = 10'd60;
parameter DISPLAY_r_or_STATE_UPPER_NIBBLE_SCREEN_4 = 10'd61;
parameter DISPLAY_r_or_STATE_LOWER_NIBBLE_SCREEN_4 = 10'd62;
parameter DISPLAY_r_or_STATE_NIBBLE_DELAY_SCREEN_4 = 10'd63;
parameter BYTE_DELAY_r_or_SCREEN_4 = 10'd64;
parameter DISPLAY_SPACE_6_STATE_UPPER_NIBBLE_SCREEN_4 = 10'd65;
parameter DISPLAY_SPACE_6_STATE_LOWER_NIBBLE_SCREEN_4 = 10'd66;
parameter DISPLAY_SPACE_6_STATE_NIBBLE_DELAY_SCREEN_4 = 10'd67;
parameter BYTE_DELAY_SPACE_6_SCREEN_4 = 10'd68;
parameter DISPLAY_N_FIRST_NN_STATE_UPPER_NIBBLE_SCREEN_4 = 10'd69;
parameter DISPLAY_N_FIRST_NN_STATE_LOWER_NIBBLE_SCREEN_4 = 10'd70;
parameter DISPLAY_N_FIRST_NN_STATE_NIBBLE_DELAY_SCREEN_4 = 10'd71;
parameter BYTE_DELAY_N_FIRST_NN_SCREEN_4 = 10'd72;
parameter DISPLAY_N_SECOND_NN_STATE_UPPER_NIBBLE_SCREEN_4 = 10'd73;
parameter DISPLAY_N_SECOND_NN_STATE_LOWER_NIBBLE_SCREEN_4 = 10'd74;
parameter DISPLAY_N_SECOND_NN_STATE_NIBBLE_DELAY_SCREEN_4 = 10'd75;
parameter BYTE_DELAY_N_SECOND_NN_SCREEN_4 = 10'd76;

assign lcd_data = lcd_command_data;
assign unused_pins = 4'b1111;
assign lcd_on = 1'b1;

always_ff @ (posedge clock)
begin

if (!reset_active_low)
begin
lcd_rw <= 1'b0;
lcd_en <= 1'b0;
lcd_rs <= 1'b0;
end

else if ((screen_1_flag == 1'b0 & screen_2_flag == 1'b0 & screen_3_flag == 1'b0 & screen_4_flag == 1'b0) | (screen_4_flag == 1'b1 & rotate == 1'b0))
begin

case (state)

IDLE_STATE:
begin 
lcd_rw <= 1'b0;
lcd_en <= 1'b0;
lcd_rs <= 1'b0;
if (counter == delay_15_ms)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_1:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_1_DELAY:
begin
lcd_en <= 1'b0;
if (counter == delay_4_1_ms)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_2_DELAY:
begin
lcd_en <= 1'b0;
if (counter == delay_100_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_3_DELAY:
begin
lcd_en <= 1'b0;
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_4_DELAY:
begin
lcd_en <= 1'b0;
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

FUNCTION_SET_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

FUNCTION_SET_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1100;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

FUNCTION_SET_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_1:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_ON_OFF_CONTROL_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_ON_OFF_CONTROL_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1111;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_ON_OFF_CONTROL_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CLEAR_DISPLAY_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CLEAR_DISPLAY_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0001;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CLEAR_DISPLAY_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_3:
begin
if (counter == delay_1_64_ms)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

ENTRY_MODE_SET_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

ENTRY_MODE_SET_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0110;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

ENTRY_MODE_SET_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_4:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_FIRST_LINE_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1000;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_FIRST_LINE_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_FIRST_LINE_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_5:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_A_UC_Altera_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b1;
lcd_command_data <= 4'b0100;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_A_UC_Altera_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0001;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_A_UC_Altera_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_A_UC_Altera:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_l_Altera_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0110;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_l_Altera_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1100;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_l_Altera_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_l_Altera:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_t_Altera_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0111;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_t_Altera_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0100;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_t_Altera_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_t_Altera:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_e_Altera_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0110;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_e_Altera_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0101;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_e_Altera_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_e_Altera:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_r_Altera_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0111;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_r_Altera_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_r_Altera_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_r_Altera:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_a_Altera_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0110;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_a_Altera_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0001;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_a_Altera_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_a_Altera:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_1_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_1_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_1_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_1:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_D_DE2_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0100;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_D_DE2_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0100;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_D_DE2_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_D_DE2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_E_DE2_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0100;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_E_DE2_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0101;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_E_DE2_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_E_DE2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_2_DE2_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_2_DE2_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_2_DE2_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_2_DE2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_2_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_2_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_2_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_B_Board_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0100;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_B_Board_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_B_Board_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_B_Board:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_o_Board_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0110;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_o_Board_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1111;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_o_Board_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_o_Board:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_a_Board_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0110;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_a_Board_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0001;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_a_Board_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_a_Board:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_r_Board_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0111;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_r_Board_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_r_Board_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_r_Board:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_d_Board_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0110;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_d_Board_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0100;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_d_Board_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_d_Board:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_SECOND_LINE_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
lcd_command_data <= 4'b1100;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_SECOND_LINE_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_SECOND_LINE_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_6:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_N_Nice_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b1;
lcd_command_data <= 4'b0100;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_N_Nice_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1110;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_N_Nice_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_N_Nice:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_i_Nice_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0110;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_i_Nice_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1001;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_i_Nice_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_i_Nice:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_c_Nice_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0110;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_c_Nice_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_c_Nice_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_c_Nice:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_e_Nice_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0110;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_e_Nice_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0101;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_e_Nice_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_e_Nice:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_3_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_3_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_3_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_3:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_T_To_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0101;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_T_To_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0100;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_T_To_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_T_To:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_o_To_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0110;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_o_To_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1111;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_o_To_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_o_To:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_4_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_4_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_4_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_4:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_S_See_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0101;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_S_See_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_S_See_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_S_See:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_e_See_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0110;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_e_See_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0101;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_e_See_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_e_See:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_e_again_See_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0110;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_e_again_See_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0101;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_e_again_See_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_e_again_See:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_5_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_5_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_5_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_5:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_Y_You_EM_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0101;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_Y_You_EM_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1001;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_Y_You_EM_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_Y_You_EM:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_o_You_EM_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0110;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_o_You_EM_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1111;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_o_You_EM_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_o_You_EM:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_u_You_EM_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0111;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_u_You_EM_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0101;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_u_You_EM_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_u_You_EM:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_EM_You_EM_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_EM_You_EM_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0001;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_EM_You_EM_STATE_NIBBLE_DELAY:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_EM_You_EM:
begin
if (counter == delay_debounce)
begin
counter <= 25'd0;
state <= 10'd0;
screen_1_flag = 1'b1;
screen_2_flag = 1'b0;
screen_3_flag = 1'b0;
screen_4_flag = 1'b0;
end
else
begin
counter <= counter + 25'd1;
end
end

endcase

end

else if (screen_1_flag == 1'b1 & rotate == 1'b0)
begin

case (state)

IDLE_STATE_SCREEN_2:
begin 
lcd_rw <= 1'b0;
lcd_en <= 1'b0;
lcd_rs <= 1'b0;
if (counter == delay_15_ms)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_1_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_1_DELAY_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_4_1_ms)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_2_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_2_DELAY_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_100_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_3_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_3_DELAY_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_4_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_4_DELAY_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

FUNCTION_SET_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

FUNCTION_SET_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1100;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

FUNCTION_SET_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_1_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_ON_OFF_CONTROL_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_ON_OFF_CONTROL_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1111;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_ON_OFF_CONTROL_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_2_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CLEAR_DISPLAY_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CLEAR_DISPLAY_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0001;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CLEAR_DISPLAY_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_3_SCREEN_2:
begin
if (counter == delay_1_64_ms)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

ENTRY_MODE_SET_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

ENTRY_MODE_SET_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0110;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

ENTRY_MODE_SET_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_4_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_FIRST_LINE_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1000;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_FIRST_LINE_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_FIRST_LINE_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_5_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_1_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_1_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_1_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_1_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_2_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_2_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_2_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_2_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_3_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_3_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_3_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_3_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_4_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_4_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_4_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_4_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_5_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_5_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_5_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_5_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_6_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_6_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_6_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_6_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_R_RMIT_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0101;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_R_RMIT_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_R_RMIT_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_R_RMIT_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_M_RMIT_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0100;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_M_RMIT_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1101;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_M_RMIT_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_M_RMIT_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_I_RMIT_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0100;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_I_RMIT_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1001;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_I_RMIT_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_I_RMIT_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_T_RMIT_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0101;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_T_RMIT_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0100;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_T_RMIT_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_T_RMIT_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_SECOND_LINE_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
lcd_command_data <= 4'b1100;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_SECOND_LINE_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_SECOND_LINE_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_6_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_7_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_7_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_7_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_7_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_8_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_8_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_8_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_8_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_9_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_9_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_9_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_9_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_10_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_10_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_10_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_10_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_11_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_11_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_11_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_11_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_12_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_12_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_12_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_12_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_2_FIRST_2022_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_2_FIRST_2022_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_2_FIRST_2022_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_2_FIRST_2022_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_0_2022_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_0_2022_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_0_2022_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_0_2022_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_2_SECOND_2022_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_2_SECOND_2022_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_2_SECOND_2022_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_2_SECOND_2022_SCREEN_2:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_2_THIRD_2022_STATE_UPPER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_2_THIRD_2022_STATE_LOWER_NIBBLE_SCREEN_2:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_2_THIRD_2022_STATE_NIBBLE_DELAY_SCREEN_2:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_2_THIRD_2022_SCREEN_2:
begin
if (counter == delay_debounce)
begin
counter <= 25'd0;
state <= 10'd0;
screen_1_flag = 1'b0;
screen_2_flag = 1'b1;
screen_3_flag = 1'b0;
screen_4_flag = 1'b0;
end
else
begin
counter <= counter + 25'd1;
end
end

endcase

end

else if (screen_2_flag == 1'b1 & rotate == 1'b0)
begin

case (state)

IDLE_STATE_SCREEN_3:
begin 
lcd_rw <= 1'b0;
lcd_en <= 1'b0;
lcd_rs <= 1'b0;
if (counter == delay_15_ms)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_1_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_1_DELAY_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_4_1_ms)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_2_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_2_DELAY_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_100_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_3_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_3_DELAY_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_4_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_4_DELAY_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

FUNCTION_SET_STATE_UPPER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

FUNCTION_SET_STATE_LOWER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1100;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

FUNCTION_SET_STATE_NIBBLE_DELAY_SCREEN_3:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_1_SCREEN_3:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_ON_OFF_CONTROL_STATE_UPPER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_ON_OFF_CONTROL_STATE_LOWER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1111;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_ON_OFF_CONTROL_STATE_NIBBLE_DELAY_SCREEN_3:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_2_SCREEN_3:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CLEAR_DISPLAY_STATE_UPPER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CLEAR_DISPLAY_STATE_LOWER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0001;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CLEAR_DISPLAY_STATE_NIBBLE_DELAY_SCREEN_3:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_3_SCREEN_3:
begin
if (counter == delay_1_64_ms)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

ENTRY_MODE_SET_STATE_UPPER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

ENTRY_MODE_SET_STATE_LOWER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0110;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

ENTRY_MODE_SET_STATE_NIBBLE_DELAY_SCREEN_3:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_4_SCREEN_3:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_FIRST_LINE_STATE_UPPER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1000;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_FIRST_LINE_STATE_LOWER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_FIRST_LINE_STATE_NIBBLE_DELAY_SCREEN_3:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_5_SCREEN_3:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_1_STATE_UPPER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_1_STATE_LOWER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_1_STATE_NIBBLE_DELAY_SCREEN_3:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_1_SCREEN_3:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_2_STATE_UPPER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_2_STATE_LOWER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_2_STATE_NIBBLE_DELAY_SCREEN_3:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_2_SCREEN_3:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_3_STATE_UPPER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_3_STATE_LOWER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_3_STATE_NIBBLE_DELAY_SCREEN_3:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_3_SCREEN_3:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_4_STATE_UPPER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_4_STATE_LOWER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_4_STATE_NIBBLE_DELAY_SCREEN_3:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_4_SCREEN_3:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_E_E_mc_2_STATE_UPPER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0100;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_E_E_mc_2_STATE_LOWER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0101;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_E_E_mc_2_STATE_NIBBLE_DELAY_SCREEN_3:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_E_E_mc_2_SCREEN_3:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_5_STATE_UPPER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_5_STATE_LOWER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_5_STATE_NIBBLE_DELAY_SCREEN_3:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_5_SCREEN_3:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_ES_E_mc_2_STATE_UPPER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_ES_E_mc_2_STATE_LOWER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1101;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_ES_E_mc_2_STATE_NIBBLE_DELAY_SCREEN_3:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_ES_E_mc_2_SCREEN_3:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_6_STATE_UPPER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_6_STATE_LOWER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_6_STATE_NIBBLE_DELAY_SCREEN_3:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_6_SCREEN_3:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_m_E_mc_2_STATE_UPPER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0110;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_m_E_mc_2_STATE_LOWER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1101;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_m_E_mc_2_STATE_NIBBLE_DELAY_SCREEN_3:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_m_E_mc_2_SCREEN_3:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_c_E_mc_2_STATE_UPPER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0110;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_c_E_mc_2_STATE_LOWER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_c_E_mc_2_STATE_NIBBLE_DELAY_SCREEN_3:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_c_E_mc_2_SCREEN_3:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_EF_E_mc_2_STATE_UPPER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0101;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_EF_E_mc_2_STATE_LOWER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1110;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_EF_E_mc_2_STATE_NIBBLE_DELAY_SCREEN_3:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_EF_E_mc_2_SCREEN_3:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_2_E_mc_2_STATE_UPPER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_2_E_mc_2_STATE_LOWER_NIBBLE_SCREEN_3:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_2_E_mc_2_STATE_NIBBLE_DELAY_SCREEN_3:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_2_E_mc_2_SCREEN_3:
begin
if (counter == delay_debounce)
begin
counter <= 25'd0;
state <= 10'd0;
screen_1_flag = 1'b0;
screen_2_flag = 1'b0;
screen_3_flag = 1'b1;
screen_4_flag = 1'b0;
end
else
begin
counter <= counter + 25'd1;
end
end

endcase

end

else if (screen_3_flag == 1'b1 & rotate == 1'b0)
begin

case (state)

IDLE_STATE_SCREEN_4:
begin 
lcd_rw <= 1'b0;
lcd_en <= 1'b0;
lcd_rs <= 1'b0;
if (counter == delay_15_ms)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_1_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_1_DELAY_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_4_1_ms)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_2_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_2_DELAY_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_100_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_3_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0011;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_3_DELAY_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_4_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

INITIALIZATION_STATE_4_DELAY_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

FUNCTION_SET_STATE_UPPER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

FUNCTION_SET_STATE_LOWER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1100;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

FUNCTION_SET_STATE_NIBBLE_DELAY_SCREEN_4:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_1_SCREEN_4:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_ON_OFF_CONTROL_STATE_UPPER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_ON_OFF_CONTROL_STATE_LOWER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1111;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_ON_OFF_CONTROL_STATE_NIBBLE_DELAY_SCREEN_4:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_2_SCREEN_4:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CLEAR_DISPLAY_STATE_UPPER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CLEAR_DISPLAY_STATE_LOWER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0001;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CLEAR_DISPLAY_STATE_NIBBLE_DELAY_SCREEN_4:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_3_SCREEN_4:
begin
if (counter == delay_1_64_ms)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

ENTRY_MODE_SET_STATE_UPPER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

ENTRY_MODE_SET_STATE_LOWER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0110;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

ENTRY_MODE_SET_STATE_NIBBLE_DELAY_SCREEN_4:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_4_SCREEN_4:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_FIRST_LINE_STATE_UPPER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1000;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_FIRST_LINE_STATE_LOWER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_FIRST_LINE_STATE_NIBBLE_DELAY_SCREEN_4:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_5_SCREEN_4:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_1_STATE_UPPER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_1_STATE_LOWER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_1_STATE_NIBBLE_DELAY_SCREEN_4:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_1_SCREEN_4:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_2_STATE_UPPER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_2_STATE_LOWER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_2_STATE_NIBBLE_DELAY_SCREEN_4:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_2_SCREEN_4:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_3_STATE_UPPER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_3_STATE_LOWER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_3_STATE_NIBBLE_DELAY_SCREEN_4:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_3_SCREEN_4:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_4_STATE_UPPER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_4_STATE_LOWER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_4_STATE_NIBBLE_DELAY_SCREEN_4:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_4_SCREEN_4:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_H_HD_STATE_UPPER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0100;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_H_HD_STATE_LOWER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_H_HD_STATE_NIBBLE_DELAY_SCREEN_4:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_H_HD_SCREEN_4:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_D_HD_STATE_UPPER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0100;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_D_HD_STATE_LOWER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0100;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_D_HD_STATE_NIBBLE_DELAY_SCREEN_4:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_D_HD_SCREEN_4:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_5_STATE_UPPER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_5_STATE_LOWER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_5_STATE_NIBBLE_DELAY_SCREEN_4:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_5_SCREEN_4:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_o_or_STATE_UPPER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0110;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_o_or_STATE_LOWER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1111;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_o_or_STATE_NIBBLE_DELAY_SCREEN_4:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_o_or_SCREEN_4:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_r_or_STATE_UPPER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0111;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_r_or_STATE_LOWER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_r_or_STATE_NIBBLE_DELAY_SCREEN_4:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_r_or_SCREEN_4:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_6_STATE_UPPER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0010;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_6_STATE_LOWER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0000;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_SPACE_6_STATE_NIBBLE_DELAY_SCREEN_4:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_SPACE_6_SCREEN_4:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_N_FIRST_NN_STATE_UPPER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0100;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_N_FIRST_NN_STATE_LOWER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1110;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_N_FIRST_NN_STATE_NIBBLE_DELAY_SCREEN_4:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_N_FIRST_NN_SCREEN_4:
begin
if (counter == delay_40_us)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_N_SECOND_NN_STATE_UPPER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0100;
if (counter == delay_230_ns)
begin
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_N_SECOND_NN_STATE_LOWER_NIBBLE_SCREEN_4:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1110;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

DISPLAY_N_SECOND_NN_STATE_NIBBLE_DELAY_SCREEN_4:
begin
if (counter == delay_230_ns)
begin
lcd_en <= 1'b0;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

BYTE_DELAY_N_SECOND_NN_SCREEN_4:
begin
if (counter == delay_debounce)
begin
counter <= 25'd0;
state <= 10'd0;
screen_1_flag = 1'b0;
screen_2_flag = 1'b0;
screen_3_flag = 1'b0;
screen_4_flag = 1'b1;
end
else
begin
counter <= counter + 25'd1;
end
end

endcase

end

end

endmodule
