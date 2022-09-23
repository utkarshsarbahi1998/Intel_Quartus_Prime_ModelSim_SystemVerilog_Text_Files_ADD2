module Version_2_FINAL (clock, reset_active_low, rotate, lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, unused_pins);

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
parameter CURSOR_ROW_1_COLUMN_1_STATE_UPPER_NIBBLE = 10'd25;
parameter CURSOR_ROW_1_COLUMN_1_STATE_LOWER_NIBBLE = 10'd26;
parameter CURSOR_ROW_1_COLUMN_1_STATE_NIBBLE_DELAY = 10'd27;
parameter BYTE_DELAY_ROW_1_COLUMN_1 = 10'd28;
parameter DISPLAY_A_UC_Altera_STATE_UPPER_NIBBLE = 10'd29;
parameter DISPLAY_A_UC_Altera_STATE_LOWER_NIBBLE = 10'd30;
parameter DISPLAY_A_UC_Altera_STATE_NIBBLE_DELAY = 10'd31;
parameter BYTE_DELAY_A_UC_Altera = 10'd32;
parameter CURSOR_ROW_1_COLUMN_2_STATE_UPPER_NIBBLE = 10'd33;
parameter CURSOR_ROW_1_COLUMN_2_STATE_LOWER_NIBBLE = 10'd34;
parameter CURSOR_ROW_1_COLUMN_2_STATE_NIBBLE_DELAY = 10'd35;
parameter BYTE_DELAY_ROW_1_COLUMN_2 = 10'd36;
parameter DISPLAY_l_Altera_STATE_UPPER_NIBBLE = 10'd37;
parameter DISPLAY_l_Altera_STATE_LOWER_NIBBLE = 10'd38;
parameter DISPLAY_l_Altera_STATE_NIBBLE_DELAY = 10'd39;
parameter BYTE_DELAY_l_Altera = 10'd40;
parameter CURSOR_ROW_1_COLUMN_3_STATE_UPPER_NIBBLE = 10'd41;
parameter CURSOR_ROW_1_COLUMN_3_STATE_LOWER_NIBBLE = 10'd42;
parameter CURSOR_ROW_1_COLUMN_3_STATE_NIBBLE_DELAY = 10'd43;
parameter BYTE_DELAY_ROW_1_COLUMN_3 = 10'd44;
parameter DISPLAY_t_Altera_STATE_UPPER_NIBBLE = 10'd45;
parameter DISPLAY_t_Altera_STATE_LOWER_NIBBLE = 10'd46;
parameter DISPLAY_t_Altera_STATE_NIBBLE_DELAY = 10'd47;
parameter BYTE_DELAY_t_Altera = 10'd48;
parameter CURSOR_ROW_1_COLUMN_4_STATE_UPPER_NIBBLE = 10'd49;
parameter CURSOR_ROW_1_COLUMN_4_STATE_LOWER_NIBBLE = 10'd50;
parameter CURSOR_ROW_1_COLUMN_4_STATE_NIBBLE_DELAY = 10'd51;
parameter BYTE_DELAY_ROW_1_COLUMN_4 = 10'd52;
parameter DISPLAY_e_Altera_STATE_UPPER_NIBBLE = 10'd53;
parameter DISPLAY_e_Altera_STATE_LOWER_NIBBLE = 10'd54;
parameter DISPLAY_e_Altera_STATE_NIBBLE_DELAY = 10'd55;
parameter BYTE_DELAY_e_Altera = 10'd56;
parameter CURSOR_ROW_1_COLUMN_5_STATE_UPPER_NIBBLE = 10'd57;
parameter CURSOR_ROW_1_COLUMN_5_STATE_LOWER_NIBBLE = 10'd58;
parameter CURSOR_ROW_1_COLUMN_5_STATE_NIBBLE_DELAY = 10'd59;
parameter BYTE_DELAY_ROW_1_COLUMN_5 = 10'd60;
parameter DISPLAY_r_Altera_STATE_UPPER_NIBBLE = 10'd61;
parameter DISPLAY_r_Altera_STATE_LOWER_NIBBLE = 10'd62;
parameter DISPLAY_r_Altera_STATE_NIBBLE_DELAY = 10'd63;
parameter BYTE_DELAY_r_Altera = 10'd64;
parameter CURSOR_ROW_1_COLUMN_6_STATE_UPPER_NIBBLE = 10'd65;
parameter CURSOR_ROW_1_COLUMN_6_STATE_LOWER_NIBBLE = 10'd66;
parameter CURSOR_ROW_1_COLUMN_6_STATE_NIBBLE_DELAY = 10'd67;
parameter BYTE_DELAY_ROW_1_COLUMN_6 = 10'd68;
parameter DISPLAY_a_Altera_STATE_UPPER_NIBBLE = 10'd69;
parameter DISPLAY_a_Altera_STATE_LOWER_NIBBLE = 10'd70;
parameter DISPLAY_a_Altera_STATE_NIBBLE_DELAY = 10'd71;
parameter BYTE_DELAY_a_Altera = 10'd72;
parameter CURSOR_ROW_1_COLUMN_7_STATE_UPPER_NIBBLE = 10'd73;
parameter CURSOR_ROW_1_COLUMN_7_STATE_LOWER_NIBBLE = 10'd74;
parameter CURSOR_ROW_1_COLUMN_7_STATE_NIBBLE_DELAY = 10'd75;
parameter BYTE_DELAY_ROW_1_COLUMN_7 = 10'd76;
parameter DISPLAY_SPACE_1_STATE_UPPER_NIBBLE = 10'd77;
parameter DISPLAY_SPACE_1_STATE_LOWER_NIBBLE = 10'd78;
parameter DISPLAY_SPACE_1_STATE_NIBBLE_DELAY = 10'd79;
parameter BYTE_DELAY_SPACE_1 = 10'd80;
parameter CURSOR_ROW_1_COLUMN_8_STATE_UPPER_NIBBLE = 10'd81;
parameter CURSOR_ROW_1_COLUMN_8_STATE_LOWER_NIBBLE = 10'd82;
parameter CURSOR_ROW_1_COLUMN_8_STATE_NIBBLE_DELAY = 10'd83;
parameter BYTE_DELAY_ROW_1_COLUMN_8 = 10'd84;
parameter DISPLAY_D_DE2_STATE_UPPER_NIBBLE = 10'd85;
parameter DISPLAY_D_DE2_STATE_LOWER_NIBBLE = 10'd86;
parameter DISPLAY_D_DE2_STATE_NIBBLE_DELAY = 10'd87;
parameter BYTE_DELAY_D_DE2 = 10'd88;
parameter CURSOR_ROW_1_COLUMN_9_STATE_UPPER_NIBBLE = 10'd89;
parameter CURSOR_ROW_1_COLUMN_9_STATE_LOWER_NIBBLE = 10'd90;
parameter CURSOR_ROW_1_COLUMN_9_STATE_NIBBLE_DELAY = 10'd91;
parameter BYTE_DELAY_ROW_1_COLUMN_9 = 10'd92;
parameter DISPLAY_E_DE2_STATE_UPPER_NIBBLE = 10'd93;
parameter DISPLAY_E_DE2_STATE_LOWER_NIBBLE = 10'd94;
parameter DISPLAY_E_DE2_STATE_NIBBLE_DELAY = 10'd95;
parameter BYTE_DELAY_E_DE2 = 10'd96;
parameter CURSOR_ROW_1_COLUMN_10_STATE_UPPER_NIBBLE = 10'd97;
parameter CURSOR_ROW_1_COLUMN_10_STATE_LOWER_NIBBLE = 10'd98;
parameter CURSOR_ROW_1_COLUMN_10_STATE_NIBBLE_DELAY = 10'd99;
parameter BYTE_DELAY_ROW_1_COLUMN_10 = 10'd100;
parameter DISPLAY_2_DE2_STATE_UPPER_NIBBLE = 10'd101;
parameter DISPLAY_2_DE2_STATE_LOWER_NIBBLE = 10'd102;
parameter DISPLAY_2_DE2_STATE_NIBBLE_DELAY = 10'd103;
parameter BYTE_DELAY_2_DE2 = 10'd104;
parameter CURSOR_ROW_1_COLUMN_11_STATE_UPPER_NIBBLE = 10'd105;
parameter CURSOR_ROW_1_COLUMN_11_STATE_LOWER_NIBBLE = 10'd106;
parameter CURSOR_ROW_1_COLUMN_11_STATE_NIBBLE_DELAY = 10'd107;
parameter BYTE_DELAY_ROW_1_COLUMN_11 = 10'd108;
parameter DISPLAY_SPACE_2_STATE_UPPER_NIBBLE = 10'd109;
parameter DISPLAY_SPACE_2_STATE_LOWER_NIBBLE = 10'd110;
parameter DISPLAY_SPACE_2_STATE_NIBBLE_DELAY = 10'd111;
parameter BYTE_DELAY_SPACE_2 = 10'd112;
parameter CURSOR_ROW_1_COLUMN_12_STATE_UPPER_NIBBLE = 10'd113;
parameter CURSOR_ROW_1_COLUMN_12_STATE_LOWER_NIBBLE = 10'd114;
parameter CURSOR_ROW_1_COLUMN_12_STATE_NIBBLE_DELAY = 10'd115;
parameter BYTE_DELAY_ROW_1_COLUMN_12 = 10'd116;
parameter DISPLAY_B_Board_STATE_UPPER_NIBBLE = 10'd117;
parameter DISPLAY_B_Board_STATE_LOWER_NIBBLE = 10'd118;
parameter DISPLAY_B_Board_STATE_NIBBLE_DELAY = 10'd119;
parameter BYTE_DELAY_B_Board = 10'd120;
parameter CURSOR_ROW_1_COLUMN_13_STATE_UPPER_NIBBLE = 10'd121;
parameter CURSOR_ROW_1_COLUMN_13_STATE_LOWER_NIBBLE = 10'd122;
parameter CURSOR_ROW_1_COLUMN_13_STATE_NIBBLE_DELAY = 10'd123;
parameter BYTE_DELAY_ROW_1_COLUMN_13 = 10'd124;
parameter DISPLAY_o_Board_STATE_UPPER_NIBBLE = 10'd125;
parameter DISPLAY_o_Board_STATE_LOWER_NIBBLE = 10'd126;
parameter DISPLAY_o_Board_STATE_NIBBLE_DELAY = 10'd127;
parameter BYTE_DELAY_o_Board = 10'd128;
parameter CURSOR_ROW_1_COLUMN_14_STATE_UPPER_NIBBLE = 10'd129;
parameter CURSOR_ROW_1_COLUMN_14_STATE_LOWER_NIBBLE = 10'd130;
parameter CURSOR_ROW_1_COLUMN_14_STATE_NIBBLE_DELAY = 10'd131;
parameter BYTE_DELAY_ROW_1_COLUMN_14 = 10'd132;
parameter DISPLAY_a_Board_STATE_UPPER_NIBBLE = 10'd133;
parameter DISPLAY_a_Board_STATE_LOWER_NIBBLE = 10'd134;
parameter DISPLAY_a_Board_STATE_NIBBLE_DELAY = 10'd135;
parameter BYTE_DELAY_a_Board = 10'd136;
parameter CURSOR_ROW_1_COLUMN_15_STATE_UPPER_NIBBLE = 10'd137;
parameter CURSOR_ROW_1_COLUMN_15_STATE_LOWER_NIBBLE = 10'd138;
parameter CURSOR_ROW_1_COLUMN_15_STATE_NIBBLE_DELAY = 10'd139;
parameter BYTE_DELAY_ROW_1_COLUMN_15 = 10'd140;
parameter DISPLAY_r_Board_STATE_UPPER_NIBBLE = 10'd141;
parameter DISPLAY_r_Board_STATE_LOWER_NIBBLE = 10'd142;
parameter DISPLAY_r_Board_STATE_NIBBLE_DELAY = 10'd143;
parameter BYTE_DELAY_r_Board = 10'd144;
parameter CURSOR_ROW_1_COLUMN_16_STATE_UPPER_NIBBLE = 10'd145;
parameter CURSOR_ROW_1_COLUMN_16_STATE_LOWER_NIBBLE = 10'd146;
parameter CURSOR_ROW_1_COLUMN_16_STATE_NIBBLE_DELAY = 10'd147;
parameter BYTE_DELAY_ROW_1_COLUMN_16 = 10'd148;
parameter DISPLAY_d_Board_STATE_UPPER_NIBBLE = 10'd149;
parameter DISPLAY_d_Board_STATE_LOWER_NIBBLE = 10'd150;
parameter DISPLAY_d_Board_STATE_NIBBLE_DELAY = 10'd151;
parameter BYTE_DELAY_d_Board = 10'd152;
parameter CURSOR_ROW_2_COLUMN_1_STATE_UPPER_NIBBLE = 10'd153;
parameter CURSOR_ROW_2_COLUMN_1_STATE_LOWER_NIBBLE = 10'd154;
parameter CURSOR_ROW_2_COLUMN_1_STATE_NIBBLE_DELAY = 10'd155;
parameter BYTE_DELAY_ROW_2_COLUMN_1 = 10'd156;
parameter DISPLAY_N_Nice_STATE_UPPER_NIBBLE = 10'd157;
parameter DISPLAY_N_Nice_STATE_LOWER_NIBBLE = 10'd158;
parameter DISPLAY_N_Nice_STATE_NIBBLE_DELAY = 10'd159;
parameter BYTE_DELAY_N_Nice = 10'd160;
parameter CURSOR_ROW_2_COLUMN_2_STATE_UPPER_NIBBLE = 10'd161;
parameter CURSOR_ROW_2_COLUMN_2_STATE_LOWER_NIBBLE = 10'd162;
parameter CURSOR_ROW_2_COLUMN_2_STATE_NIBBLE_DELAY = 10'd163;
parameter BYTE_DELAY_ROW_2_COLUMN_2 = 10'd164;
parameter DISPLAY_i_Nice_STATE_UPPER_NIBBLE = 10'd165;
parameter DISPLAY_i_Nice_STATE_LOWER_NIBBLE = 10'd166;
parameter DISPLAY_i_Nice_STATE_NIBBLE_DELAY = 10'd167;
parameter BYTE_DELAY_i_Nice = 10'd168;
parameter CURSOR_ROW_2_COLUMN_3_STATE_UPPER_NIBBLE = 10'd169;
parameter CURSOR_ROW_2_COLUMN_3_STATE_LOWER_NIBBLE = 10'd170;
parameter CURSOR_ROW_2_COLUMN_3_STATE_NIBBLE_DELAY = 10'd171;
parameter BYTE_DELAY_ROW_2_COLUMN_3 = 10'd172;
parameter DISPLAY_c_Nice_STATE_UPPER_NIBBLE = 10'd173;
parameter DISPLAY_c_Nice_STATE_LOWER_NIBBLE = 10'd174;
parameter DISPLAY_c_Nice_STATE_NIBBLE_DELAY = 10'd175;
parameter BYTE_DELAY_c_Nice = 10'd176;
parameter CURSOR_ROW_2_COLUMN_4_STATE_UPPER_NIBBLE = 10'd177;
parameter CURSOR_ROW_2_COLUMN_4_STATE_LOWER_NIBBLE = 10'd178;
parameter CURSOR_ROW_2_COLUMN_4_STATE_NIBBLE_DELAY = 10'd179;
parameter BYTE_DELAY_ROW_2_COLUMN_4 = 10'd180;
parameter DISPLAY_e_Nice_STATE_UPPER_NIBBLE = 10'd181;
parameter DISPLAY_e_Nice_STATE_LOWER_NIBBLE = 10'd182;
parameter DISPLAY_e_Nice_STATE_NIBBLE_DELAY = 10'd183;
parameter BYTE_DELAY_e_Nice = 10'd184;
parameter CURSOR_ROW_2_COLUMN_5_STATE_UPPER_NIBBLE = 10'd185;
parameter CURSOR_ROW_2_COLUMN_5_STATE_LOWER_NIBBLE = 10'd186;
parameter CURSOR_ROW_2_COLUMN_5_STATE_NIBBLE_DELAY = 10'd187;
parameter BYTE_DELAY_ROW_2_COLUMN_5 = 10'd188;
parameter DISPLAY_SPACE_3_STATE_UPPER_NIBBLE = 10'd189;
parameter DISPLAY_SPACE_3_STATE_LOWER_NIBBLE = 10'd190;
parameter DISPLAY_SPACE_3_STATE_NIBBLE_DELAY = 10'd191;
parameter BYTE_DELAY_SPACE_3 = 10'd192;
parameter CURSOR_ROW_2_COLUMN_6_STATE_UPPER_NIBBLE = 10'd193;
parameter CURSOR_ROW_2_COLUMN_6_STATE_LOWER_NIBBLE = 10'd194;
parameter CURSOR_ROW_2_COLUMN_6_STATE_NIBBLE_DELAY = 10'd195;
parameter BYTE_DELAY_ROW_2_COLUMN_6 = 10'd196;
parameter DISPLAY_T_To_STATE_UPPER_NIBBLE = 10'd197;
parameter DISPLAY_T_To_STATE_LOWER_NIBBLE = 10'd198;
parameter DISPLAY_T_To_STATE_NIBBLE_DELAY = 10'd199;
parameter BYTE_DELAY_T_To = 10'd200;
parameter CURSOR_ROW_2_COLUMN_7_STATE_UPPER_NIBBLE = 10'd201;
parameter CURSOR_ROW_2_COLUMN_7_STATE_LOWER_NIBBLE = 10'd202;
parameter CURSOR_ROW_2_COLUMN_7_STATE_NIBBLE_DELAY = 10'd203;
parameter BYTE_DELAY_ROW_2_COLUMN_7 = 10'd204;
parameter DISPLAY_o_To_STATE_UPPER_NIBBLE = 10'd205;
parameter DISPLAY_o_To_STATE_LOWER_NIBBLE = 10'd206;
parameter DISPLAY_o_To_STATE_NIBBLE_DELAY = 10'd207;
parameter BYTE_DELAY_o_To = 10'd208;
parameter CURSOR_ROW_2_COLUMN_8_STATE_UPPER_NIBBLE = 10'd209;
parameter CURSOR_ROW_2_COLUMN_8_STATE_LOWER_NIBBLE = 10'd210;
parameter CURSOR_ROW_2_COLUMN_8_STATE_NIBBLE_DELAY = 10'd211;
parameter BYTE_DELAY_ROW_2_COLUMN_8 = 10'd212;
parameter DISPLAY_SPACE_4_STATE_UPPER_NIBBLE = 10'd213;
parameter DISPLAY_SPACE_4_STATE_LOWER_NIBBLE = 10'd214;
parameter DISPLAY_SPACE_4_STATE_NIBBLE_DELAY = 10'd215;
parameter BYTE_DELAY_SPACE_4 = 10'd216;
parameter CURSOR_ROW_2_COLUMN_9_STATE_UPPER_NIBBLE = 10'd217;
parameter CURSOR_ROW_2_COLUMN_9_STATE_LOWER_NIBBLE = 10'd218;
parameter CURSOR_ROW_2_COLUMN_9_STATE_NIBBLE_DELAY = 10'd219;
parameter BYTE_DELAY_ROW_2_COLUMN_9 = 10'd220;
parameter DISPLAY_S_See_STATE_UPPER_NIBBLE = 10'd221;
parameter DISPLAY_S_See_STATE_LOWER_NIBBLE = 10'd222;
parameter DISPLAY_S_See_STATE_NIBBLE_DELAY = 10'd223;
parameter BYTE_DELAY_S_See = 10'd224;
parameter CURSOR_ROW_2_COLUMN_10_STATE_UPPER_NIBBLE = 10'd225;
parameter CURSOR_ROW_2_COLUMN_10_STATE_LOWER_NIBBLE = 10'd226;
parameter CURSOR_ROW_2_COLUMN_10_STATE_NIBBLE_DELAY = 10'd227;
parameter BYTE_DELAY_ROW_2_COLUMN_10 = 10'd228;
parameter DISPLAY_e_See_STATE_UPPER_NIBBLE = 10'd229;
parameter DISPLAY_e_See_STATE_LOWER_NIBBLE = 10'd230;
parameter DISPLAY_e_See_STATE_NIBBLE_DELAY = 10'd231;
parameter BYTE_DELAY_e_See = 10'd232;
parameter CURSOR_ROW_2_COLUMN_11_STATE_UPPER_NIBBLE = 10'd233;
parameter CURSOR_ROW_2_COLUMN_11_STATE_LOWER_NIBBLE = 10'd234;
parameter CURSOR_ROW_2_COLUMN_11_STATE_NIBBLE_DELAY = 10'd235;
parameter BYTE_DELAY_ROW_2_COLUMN_11 = 10'd236;
parameter DISPLAY_e_again_See_STATE_UPPER_NIBBLE = 10'd237;
parameter DISPLAY_e_again_See_STATE_LOWER_NIBBLE = 10'd238;
parameter DISPLAY_e_again_See_STATE_NIBBLE_DELAY = 10'd239;
parameter BYTE_DELAY_e_again_See = 10'd240;
parameter CURSOR_ROW_2_COLUMN_12_STATE_UPPER_NIBBLE = 10'd241;
parameter CURSOR_ROW_2_COLUMN_12_STATE_LOWER_NIBBLE = 10'd242;
parameter CURSOR_ROW_2_COLUMN_12_STATE_NIBBLE_DELAY = 10'd243;
parameter BYTE_DELAY_ROW_2_COLUMN_12 = 10'd244;
parameter DISPLAY_SPACE_5_STATE_UPPER_NIBBLE = 10'd245;
parameter DISPLAY_SPACE_5_STATE_LOWER_NIBBLE = 10'd246;
parameter DISPLAY_SPACE_5_STATE_NIBBLE_DELAY = 10'd247;
parameter BYTE_DELAY_SPACE_5 = 10'd248;
parameter CURSOR_ROW_2_COLUMN_13_STATE_UPPER_NIBBLE = 10'd249;
parameter CURSOR_ROW_2_COLUMN_13_STATE_LOWER_NIBBLE = 10'd250;
parameter CURSOR_ROW_2_COLUMN_13_STATE_NIBBLE_DELAY = 10'd251;
parameter BYTE_DELAY_ROW_2_COLUMN_13 = 10'd252;
parameter DISPLAY_Y_You_EM_STATE_UPPER_NIBBLE = 10'd253;
parameter DISPLAY_Y_You_EM_STATE_LOWER_NIBBLE = 10'd254;
parameter DISPLAY_Y_You_EM_STATE_NIBBLE_DELAY = 10'd255;
parameter BYTE_DELAY_Y_You_EM = 10'd256;
parameter CURSOR_ROW_2_COLUMN_14_STATE_UPPER_NIBBLE = 10'd257;
parameter CURSOR_ROW_2_COLUMN_14_STATE_LOWER_NIBBLE = 10'd258;
parameter CURSOR_ROW_2_COLUMN_14_STATE_NIBBLE_DELAY = 10'd259;
parameter BYTE_DELAY_ROW_2_COLUMN_14 = 10'd260;
parameter DISPLAY_o_You_EM_STATE_UPPER_NIBBLE = 10'd261;
parameter DISPLAY_o_You_EM_STATE_LOWER_NIBBLE = 10'd262;
parameter DISPLAY_o_You_EM_STATE_NIBBLE_DELAY = 10'd263;
parameter BYTE_DELAY_o_You_EM = 10'd264;
parameter CURSOR_ROW_2_COLUMN_15_STATE_UPPER_NIBBLE = 10'd265;
parameter CURSOR_ROW_2_COLUMN_15_STATE_LOWER_NIBBLE = 10'd266;
parameter CURSOR_ROW_2_COLUMN_15_STATE_NIBBLE_DELAY = 10'd267;
parameter BYTE_DELAY_ROW_2_COLUMN_15 = 10'd268;
parameter DISPLAY_u_You_EM_STATE_UPPER_NIBBLE = 10'd269;
parameter DISPLAY_u_You_EM_STATE_LOWER_NIBBLE = 10'd270;
parameter DISPLAY_u_You_EM_STATE_NIBBLE_DELAY = 10'd271;
parameter BYTE_DELAY_u_You_EM = 10'd272;
parameter CURSOR_ROW_2_COLUMN_16_STATE_UPPER_NIBBLE = 10'd273;
parameter CURSOR_ROW_2_COLUMN_16_STATE_LOWER_NIBBLE = 10'd274;
parameter CURSOR_ROW_2_COLUMN_16_STATE_NIBBLE_DELAY = 10'd275;
parameter BYTE_DELAY_ROW_2_COLUMN_16 = 10'd276;
parameter DISPLAY_EM_You_EM_STATE_UPPER_NIBBLE = 10'd277;
parameter DISPLAY_EM_You_EM_STATE_LOWER_NIBBLE = 10'd278;
parameter DISPLAY_EM_You_EM_STATE_NIBBLE_DELAY = 10'd279;
parameter BYTE_DELAY_EM_You_EM = 10'd280;

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
parameter CURSOR_ROW_1_COLUMN_7_SCREEN_2_STATE_UPPER_NIBBLE = 10'd25;
parameter CURSOR_ROW_1_COLUMN_7_SCREEN_2_STATE_LOWER_NIBBLE = 10'd26;
parameter CURSOR_ROW_1_COLUMN_7_SCREEN_2_STATE_NIBBLE_DELAY = 10'd27;
parameter BYTE_DELAY_ROW_1_COLUMN_7_SCREEN_2 = 10'd28;
parameter DISPLAY_R_RMIT_STATE_UPPER_NIBBLE = 10'd29;
parameter DISPLAY_R_RMIT_STATE_LOWER_NIBBLE = 10'd30;
parameter DISPLAY_R_RMIT_STATE_NIBBLE_DELAY = 10'd31;
parameter BYTE_DELAY_R_RMIT = 10'd32;
parameter CURSOR_ROW_1_COLUMN_8_SCREEN_2_STATE_UPPER_NIBBLE = 10'd33;
parameter CURSOR_ROW_1_COLUMN_8_SCREEN_2_STATE_LOWER_NIBBLE = 10'd34;
parameter CURSOR_ROW_1_COLUMN_8_SCREEN_2_STATE_NIBBLE_DELAY = 10'd35;
parameter BYTE_DELAY_ROW_1_COLUMN_8_SCREEN_2 = 10'd36;
parameter DISPLAY_M_RMIT_STATE_UPPER_NIBBLE = 10'd37;
parameter DISPLAY_M_RMIT_STATE_LOWER_NIBBLE = 10'd38;
parameter DISPLAY_M_RMIT_STATE_NIBBLE_DELAY = 10'd39;
parameter BYTE_DELAY_M_RMIT = 10'd40;
parameter CURSOR_ROW_1_COLUMN_9_SCREEN_2_STATE_UPPER_NIBBLE = 10'd41;
parameter CURSOR_ROW_1_COLUMN_9_SCREEN_2_STATE_LOWER_NIBBLE = 10'd42;
parameter CURSOR_ROW_1_COLUMN_9_SCREEN_2_STATE_NIBBLE_DELAY = 10'd43;
parameter BYTE_DELAY_ROW_1_COLUMN_9_SCREEN_2 = 10'd44;
parameter DISPLAY_I_RMIT_STATE_UPPER_NIBBLE = 10'd45;
parameter DISPLAY_I_RMIT_STATE_LOWER_NIBBLE = 10'd46;
parameter DISPLAY_I_RMIT_STATE_NIBBLE_DELAY = 10'd47;
parameter BYTE_DELAY_I_RMIT = 10'd48;
parameter CURSOR_ROW_1_COLUMN_10_SCREEN_2_STATE_UPPER_NIBBLE = 10'd49;
parameter CURSOR_ROW_1_COLUMN_10_SCREEN_2_STATE_LOWER_NIBBLE = 10'd50;
parameter CURSOR_ROW_1_COLUMN_10_SCREEN_2_STATE_NIBBLE_DELAY = 10'd51;
parameter BYTE_DELAY_ROW_1_COLUMN_10_SCREEN_2 = 10'd52;
parameter DISPLAY_T_RMIT_STATE_UPPER_NIBBLE = 10'd53;
parameter DISPLAY_T_RMIT_STATE_LOWER_NIBBLE = 10'd54;
parameter DISPLAY_T_RMIT_STATE_NIBBLE_DELAY = 10'd55;
parameter BYTE_DELAY_T_RMIT = 10'd56;
parameter CURSOR_ROW_2_COLUMN_7_SCREEN_2_STATE_UPPER_NIBBLE = 10'd57;
parameter CURSOR_ROW_2_COLUMN_7_SCREEN_2_STATE_LOWER_NIBBLE = 10'd58;
parameter CURSOR_ROW_2_COLUMN_7_SCREEN_2_STATE_NIBBLE_DELAY = 10'd59;
parameter BYTE_DELAY_ROW_2_COLUMN_7_SCREEN_2 = 10'd60;
parameter DISPLAY_2_FIRST_2022_STATE_UPPER_NIBBLE = 10'd61;
parameter DISPLAY_2_FIRST_2022_STATE_LOWER_NIBBLE = 10'd62;
parameter DISPLAY_2_FIRST_2022_STATE_NIBBLE_DELAY = 10'd63;
parameter BYTE_DELAY_2_FIRST_2022 = 10'd64;
parameter CURSOR_ROW_2_COLUMN_8_SCREEN_2_STATE_UPPER_NIBBLE = 10'd65;
parameter CURSOR_ROW_2_COLUMN_8_SCREEN_2_STATE_LOWER_NIBBLE = 10'd66;
parameter CURSOR_ROW_2_COLUMN_8_SCREEN_2_STATE_NIBBLE_DELAY = 10'd67;
parameter BYTE_DELAY_ROW_2_COLUMN_8_SCREEN_2 = 10'd68;
parameter DISPLAY_0_2022_STATE_UPPER_NIBBLE = 10'd69;
parameter DISPLAY_0_2022_STATE_LOWER_NIBBLE = 10'd70;
parameter DISPLAY_0_2022_STATE_NIBBLE_DELAY = 10'd71;
parameter BYTE_DELAY_0_2022 = 10'd72;
parameter CURSOR_ROW_2_COLUMN_9_SCREEN_2_STATE_UPPER_NIBBLE = 10'd73;
parameter CURSOR_ROW_2_COLUMN_9_SCREEN_2_STATE_LOWER_NIBBLE = 10'd74;
parameter CURSOR_ROW_2_COLUMN_9_SCREEN_2_STATE_NIBBLE_DELAY = 10'd75;
parameter BYTE_DELAY_ROW_2_COLUMN_9_SCREEN_2 = 10'd76;
parameter DISPLAY_2_SECOND_2022_STATE_UPPER_NIBBLE = 10'd77;
parameter DISPLAY_2_SECOND_2022_STATE_LOWER_NIBBLE = 10'd78;
parameter DISPLAY_2_SECOND_2022_STATE_NIBBLE_DELAY = 10'd79;
parameter BYTE_DELAY_2_SECOND_2022 = 10'd80;
parameter CURSOR_ROW_2_COLUMN_10_SCREEN_2_STATE_UPPER_NIBBLE = 10'd81;
parameter CURSOR_ROW_2_COLUMN_10_SCREEN_2_STATE_LOWER_NIBBLE = 10'd82;
parameter CURSOR_ROW_2_COLUMN_10_SCREEN_2_STATE_NIBBLE_DELAY = 10'd83;
parameter BYTE_DELAY_ROW_2_COLUMN_10_SCREEN_2 = 10'd84;
parameter DISPLAY_2_THIRD_2022_STATE_UPPER_NIBBLE = 10'd85;
parameter DISPLAY_2_THIRD_2022_STATE_LOWER_NIBBLE = 10'd86;
parameter DISPLAY_2_THIRD_2022_STATE_NIBBLE_DELAY = 10'd87;
parameter BYTE_DELAY_2_THIRD_2022 = 10'd88;

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
parameter CURSOR_ROW_1_COLUMN_5_SCREEN_3_STATE_UPPER_NIBBLE = 10'd25;
parameter CURSOR_ROW_1_COLUMN_5_SCREEN_3_STATE_LOWER_NIBBLE = 10'd26;
parameter CURSOR_ROW_1_COLUMN_5_SCREEN_3_STATE_NIBBLE_DELAY = 10'd27;
parameter BYTE_DELAY_ROW_1_COLUMN_5_SCREEN_3 = 10'd28;
parameter DISPLAY_E_E_mc_2_STATE_UPPER_NIBBLE = 10'd29;
parameter DISPLAY_E_E_mc_2_STATE_LOWER_NIBBLE = 10'd30;
parameter DISPLAY_E_E_mc_2_STATE_NIBBLE_DELAY = 10'd31;
parameter BYTE_DELAY_E_E_mc_2 = 10'd32;
parameter CURSOR_ROW_1_COLUMN_7_SCREEN_3_STATE_UPPER_NIBBLE = 10'd33;
parameter CURSOR_ROW_1_COLUMN_7_SCREEN_3_STATE_LOWER_NIBBLE = 10'd34;
parameter CURSOR_ROW_1_COLUMN_7_SCREEN_3_STATE_NIBBLE_DELAY = 10'd35;
parameter BYTE_DELAY_ROW_1_COLUMN_7_SCREEN_3 = 10'd36;
parameter DISPLAY_ES_E_mc_2_STATE_UPPER_NIBBLE = 10'd37;
parameter DISPLAY_ES_E_mc_2_STATE_LOWER_NIBBLE = 10'd38;
parameter DISPLAY_ES_E_mc_2_STATE_NIBBLE_DELAY = 10'd39;
parameter BYTE_DELAY_ES_E_mc_2 = 10'd40;
parameter CURSOR_ROW_1_COLUMN_9_SCREEN_3_STATE_UPPER_NIBBLE = 10'd41;
parameter CURSOR_ROW_1_COLUMN_9_SCREEN_3_STATE_LOWER_NIBBLE = 10'd42;
parameter CURSOR_ROW_1_COLUMN_9_SCREEN_3_STATE_NIBBLE_DELAY = 10'd43;
parameter BYTE_DELAY_ROW_1_COLUMN_9_SCREEN_3 = 10'd44;
parameter DISPLAY_m_E_mc_2_STATE_UPPER_NIBBLE = 10'd45;
parameter DISPLAY_m_E_mc_2_STATE_LOWER_NIBBLE = 10'd46;
parameter DISPLAY_m_E_mc_2_STATE_NIBBLE_DELAY = 10'd47;
parameter BYTE_DELAY_m_E_mc_2 = 10'd48;
parameter CURSOR_ROW_1_COLUMN_10_SCREEN_3_STATE_UPPER_NIBBLE = 10'd49;
parameter CURSOR_ROW_1_COLUMN_10_SCREEN_3_STATE_LOWER_NIBBLE = 10'd50;
parameter CURSOR_ROW_1_COLUMN_10_SCREEN_3_STATE_NIBBLE_DELAY = 10'd51;
parameter BYTE_DELAY_ROW_1_COLUMN_10_SCREEN_3 = 10'd52;
parameter DISPLAY_c_E_mc_2_STATE_UPPER_NIBBLE = 10'd53;
parameter DISPLAY_c_E_mc_2_STATE_LOWER_NIBBLE = 10'd54;
parameter DISPLAY_c_E_mc_2_STATE_NIBBLE_DELAY = 10'd55;
parameter BYTE_DELAY_c_E_mc_2 = 10'd56;
parameter CURSOR_ROW_1_COLUMN_11_SCREEN_3_STATE_UPPER_NIBBLE = 10'd57;
parameter CURSOR_ROW_1_COLUMN_11_SCREEN_3_STATE_LOWER_NIBBLE = 10'd58;
parameter CURSOR_ROW_1_COLUMN_11_SCREEN_3_STATE_NIBBLE_DELAY = 10'd59;
parameter BYTE_DELAY_ROW_1_COLUMN_11_SCREEN_3 = 10'd60;
parameter DISPLAY_EF_E_mc_2_STATE_UPPER_NIBBLE = 10'd61;
parameter DISPLAY_EF_E_mc_2_STATE_LOWER_NIBBLE = 10'd62;
parameter DISPLAY_EF_E_mc_2_STATE_NIBBLE_DELAY = 10'd63;
parameter BYTE_DELAY_EF_E_mc_2 = 10'd64;
parameter CURSOR_ROW_1_COLUMN_12_SCREEN_3_STATE_UPPER_NIBBLE = 10'd65;
parameter CURSOR_ROW_1_COLUMN_12_SCREEN_3_STATE_LOWER_NIBBLE = 10'd66;
parameter CURSOR_ROW_1_COLUMN_12_SCREEN_3_STATE_NIBBLE_DELAY = 10'd67;
parameter BYTE_DELAY_ROW_1_COLUMN_12_SCREEN_3 = 10'd68;
parameter DISPLAY_2_E_mc_2_STATE_UPPER_NIBBLE = 10'd69;
parameter DISPLAY_2_E_mc_2_STATE_LOWER_NIBBLE = 10'd70;
parameter DISPLAY_2_E_mc_2_STATE_NIBBLE_DELAY = 10'd71;
parameter BYTE_DELAY_2_E_mc_2 = 10'd72;

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
parameter CURSOR_ROW_1_COLUMN_5_SCREEN_4_STATE_UPPER_NIBBLE = 10'd25;
parameter CURSOR_ROW_1_COLUMN_5_SCREEN_4_STATE_LOWER_NIBBLE = 10'd26;
parameter CURSOR_ROW_1_COLUMN_5_SCREEN_4_STATE_NIBBLE_DELAY = 10'd27;
parameter BYTE_DELAY_ROW_1_COLUMN_5_SCREEN_4 = 10'd28;
parameter DISPLAY_H_HD_STATE_UPPER_NIBBLE = 10'd29;
parameter DISPLAY_H_HD_STATE_LOWER_NIBBLE = 10'd30;
parameter DISPLAY_H_HD_STATE_NIBBLE_DELAY = 10'd31;
parameter BYTE_DELAY_H_HD = 10'd32;
parameter CURSOR_ROW_1_COLUMN_6_SCREEN_4_STATE_UPPER_NIBBLE = 10'd33;
parameter CURSOR_ROW_1_COLUMN_6_SCREEN_4_STATE_LOWER_NIBBLE = 10'd34;
parameter CURSOR_ROW_1_COLUMN_6_SCREEN_4_STATE_NIBBLE_DELAY = 10'd35;
parameter BYTE_DELAY_ROW_1_COLUMN_6_SCREEN_4 = 10'd36;
parameter DISPLAY_D_HD_STATE_UPPER_NIBBLE = 10'd37;
parameter DISPLAY_D_HD_STATE_LOWER_NIBBLE = 10'd38;
parameter DISPLAY_D_HD_STATE_NIBBLE_DELAY = 10'd39;
parameter BYTE_DELAY_D_HD = 10'd40;
parameter CURSOR_ROW_1_COLUMN_8_SCREEN_4_STATE_UPPER_NIBBLE = 10'd41;
parameter CURSOR_ROW_1_COLUMN_8_SCREEN_4_STATE_LOWER_NIBBLE = 10'd42;
parameter CURSOR_ROW_1_COLUMN_8_SCREEN_4_STATE_NIBBLE_DELAY = 10'd43;
parameter BYTE_DELAY_ROW_1_COLUMN_8_SCREEN_4 = 10'd44;
parameter DISPLAY_o_or_STATE_UPPER_NIBBLE = 10'd45;
parameter DISPLAY_o_or_STATE_LOWER_NIBBLE = 10'd46;
parameter DISPLAY_o_or_STATE_NIBBLE_DELAY = 10'd47;
parameter BYTE_DELAY_o_or = 10'd48;
parameter CURSOR_ROW_1_COLUMN_9_SCREEN_4_STATE_UPPER_NIBBLE = 10'd49;
parameter CURSOR_ROW_1_COLUMN_9_SCREEN_4_STATE_LOWER_NIBBLE = 10'd50;
parameter CURSOR_ROW_1_COLUMN_9_SCREEN_4_STATE_NIBBLE_DELAY = 10'd51;
parameter BYTE_DELAY_ROW_1_COLUMN_9_SCREEN_4 = 10'd52;
parameter DISPLAY_r_or_STATE_UPPER_NIBBLE = 10'd53;
parameter DISPLAY_r_or_STATE_LOWER_NIBBLE = 10'd54;
parameter DISPLAY_r_or_STATE_NIBBLE_DELAY = 10'd55;
parameter BYTE_DELAY_r_or = 10'd56;
parameter CURSOR_ROW_1_COLUMN_11_SCREEN_4_STATE_UPPER_NIBBLE = 10'd57;
parameter CURSOR_ROW_1_COLUMN_11_SCREEN_4_STATE_LOWER_NIBBLE = 10'd58;
parameter CURSOR_ROW_1_COLUMN_11_SCREEN_4_STATE_NIBBLE_DELAY = 10'd59;
parameter BYTE_DELAY_ROW_1_COLUMN_11_SCREEN_4 = 10'd60;
parameter DISPLAY_N_FIRST_NN_STATE_UPPER_NIBBLE = 10'd61;
parameter DISPLAY_N_FIRST_NN_STATE_LOWER_NIBBLE = 10'd62;
parameter DISPLAY_N_FIRST_NN_STATE_NIBBLE_DELAY = 10'd63;
parameter BYTE_DELAY_N_FIRST_NN = 10'd64;
parameter CURSOR_ROW_1_COLUMN_12_SCREEN_4_STATE_UPPER_NIBBLE = 10'd65;
parameter CURSOR_ROW_1_COLUMN_12_SCREEN_4_STATE_LOWER_NIBBLE = 10'd66;
parameter CURSOR_ROW_1_COLUMN_12_SCREEN_4_STATE_NIBBLE_DELAY = 10'd67;
parameter BYTE_DELAY_ROW_1_COLUMN_12_SCREEN_4 = 10'd68;
parameter DISPLAY_N_SECOND_NN_STATE_UPPER_NIBBLE = 10'd69;
parameter DISPLAY_N_SECOND_NN_STATE_LOWER_NIBBLE = 10'd70;
parameter DISPLAY_N_SECOND_NN_STATE_NIBBLE_DELAY = 10'd71;
parameter BYTE_DELAY_N_SECOND_NN = 10'd72;

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

CURSOR_ROW_1_COLUMN_1_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_1_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_1_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_1:
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

CURSOR_ROW_1_COLUMN_2_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_2_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_2_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_2:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_1_COLUMN_3_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_3_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_3_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_3:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_1_COLUMN_4_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_4_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_4_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_4:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_1_COLUMN_5_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_5_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_5_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_5:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_1_COLUMN_6_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_6_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_6_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_6:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_1_COLUMN_7_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_7_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_7_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_7:
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

CURSOR_ROW_1_COLUMN_8_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_8_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0111;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_ROW_1_COLUMN_8_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_8:
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

CURSOR_ROW_1_COLUMN_9_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_9_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_9_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_9:
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

CURSOR_ROW_1_COLUMN_10_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_10_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_10_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_10:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_1_COLUMN_11_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_11_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1010;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_ROW_1_COLUMN_11_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_11:
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

CURSOR_ROW_1_COLUMN_12_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_12_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1011;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_ROW_1_COLUMN_12_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_12:
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

CURSOR_ROW_1_COLUMN_13_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_13_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_13_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_13:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_1_COLUMN_14_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_14_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_14_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_14:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_1_COLUMN_15_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_15_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_15_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_15:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_1_COLUMN_16_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_16_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_16_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_16:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_2_COLUMN_1_STATE_UPPER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_1_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_1_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_2_COLUMN_1:
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

CURSOR_ROW_2_COLUMN_2_STATE_UPPER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_2_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_2_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_2_COLUMN_2:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_2_COLUMN_3_STATE_UPPER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_3_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_3_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_2_COLUMN_3:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_2_COLUMN_4_STATE_UPPER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_4_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_4_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_2_COLUMN_4:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_2_COLUMN_5_STATE_UPPER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_5_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_5_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_2_COLUMN_5:
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

CURSOR_ROW_2_COLUMN_6_STATE_UPPER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_6_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_6_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_2_COLUMN_6:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_2_COLUMN_7_STATE_UPPER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_7_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_7_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_2_COLUMN_7:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_2_COLUMN_8_STATE_UPPER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_8_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0111;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_ROW_2_COLUMN_8_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_2_COLUMN_8:
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

CURSOR_ROW_2_COLUMN_9_STATE_UPPER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_9_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_9_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_2_COLUMN_9:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_2_COLUMN_10_STATE_UPPER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_10_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_10_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_2_COLUMN_10:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_2_COLUMN_11_STATE_UPPER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_11_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1010;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_ROW_2_COLUMN_11_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_2_COLUMN_11:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_2_COLUMN_12_STATE_UPPER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_12_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1011;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_ROW_2_COLUMN_12_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_2_COLUMN_12:
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

CURSOR_ROW_2_COLUMN_13_STATE_UPPER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_13_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_13_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_2_COLUMN_13:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_2_COLUMN_14_STATE_UPPER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_14_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_14_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_2_COLUMN_14:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_2_COLUMN_15_STATE_UPPER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_15_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_15_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_2_COLUMN_15:
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
lcd_rs <= 1'b1;
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

CURSOR_ROW_2_COLUMN_16_STATE_UPPER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_16_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_16_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_2_COLUMN_16:
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

CURSOR_ROW_1_COLUMN_7_SCREEN_2_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_7_SCREEN_2_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_7_SCREEN_2_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_7_SCREEN_2:
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

DISPLAY_R_RMIT_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b1;
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

DISPLAY_R_RMIT_STATE_LOWER_NIBBLE:
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

DISPLAY_R_RMIT_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_R_RMIT:
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

CURSOR_ROW_1_COLUMN_8_SCREEN_2_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_8_SCREEN_2_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0111;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_ROW_1_COLUMN_8_SCREEN_2_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_8_SCREEN_2:
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

DISPLAY_M_RMIT_STATE_UPPER_NIBBLE:
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

DISPLAY_M_RMIT_STATE_LOWER_NIBBLE:
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

DISPLAY_M_RMIT_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_M_RMIT:
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

CURSOR_ROW_1_COLUMN_9_SCREEN_2_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_9_SCREEN_2_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_9_SCREEN_2_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_9_SCREEN_2:
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

DISPLAY_I_RMIT_STATE_UPPER_NIBBLE:
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

DISPLAY_I_RMIT_STATE_LOWER_NIBBLE:
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

DISPLAY_I_RMIT_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_I_RMIT:
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

CURSOR_ROW_1_COLUMN_10_SCREEN_2_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_10_SCREEN_2_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_10_SCREEN_2_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_10_SCREEN_2:
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

DISPLAY_T_RMIT_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b1;
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

DISPLAY_T_RMIT_STATE_LOWER_NIBBLE :
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

DISPLAY_T_RMIT_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_T_RMIT:
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

CURSOR_ROW_2_COLUMN_7_SCREEN_2_STATE_UPPER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_7_SCREEN_2_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_7_SCREEN_2_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_2_COLUMN_7_SCREEN_2:
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

DISPLAY_2_FIRST_2022_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b1;
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

DISPLAY_2_FIRST_2022_STATE_LOWER_NIBBLE:
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

DISPLAY_2_FIRST_2022_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_2_FIRST_2022:
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

CURSOR_ROW_2_COLUMN_8_SCREEN_2_STATE_UPPER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_8_SCREEN_2_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0111;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_ROW_2_COLUMN_8_SCREEN_2_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_2_COLUMN_8_SCREEN_2:
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

DISPLAY_0_2022_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b1;
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

DISPLAY_0_2022_STATE_LOWER_NIBBLE:
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

DISPLAY_0_2022_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_0_2022:
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

CURSOR_ROW_2_COLUMN_9_SCREEN_2_STATE_UPPER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_9_SCREEN_2_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_9_SCREEN_2_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_2_COLUMN_9_SCREEN_2:
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

DISPLAY_2_SECOND_2022_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b1;
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

DISPLAY_2_SECOND_2022_STATE_LOWER_NIBBLE:
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

DISPLAY_2_SECOND_2022_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_2_SECOND_2022:
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

CURSOR_ROW_2_COLUMN_10_SCREEN_2_STATE_UPPER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_10_SCREEN_2_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_2_COLUMN_10_SCREEN_2_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_2_COLUMN_10_SCREEN_2:
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

DISPLAY_2_THIRD_2022_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b1;
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

DISPLAY_2_THIRD_2022_STATE_LOWER_NIBBLE:
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

DISPLAY_2_THIRD_2022_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_2_THIRD_2022:
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

CURSOR_ROW_1_COLUMN_5_SCREEN_3_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_5_SCREEN_3_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_5_SCREEN_3_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_5_SCREEN_3:
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

DISPLAY_E_E_mc_2_STATE_UPPER_NIBBLE:
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

DISPLAY_E_E_mc_2_STATE_LOWER_NIBBLE:
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

DISPLAY_E_E_mc_2_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_E_E_mc_2:
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

CURSOR_ROW_1_COLUMN_7_SCREEN_3_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_7_SCREEN_3_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_7_SCREEN_3_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_7_SCREEN_3:
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

DISPLAY_ES_E_mc_2_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b1;
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

DISPLAY_ES_E_mc_2_STATE_LOWER_NIBBLE:
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

DISPLAY_ES_E_mc_2_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ES_E_mc_2:
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

CURSOR_ROW_1_COLUMN_9_SCREEN_3_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_9_SCREEN_3_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_9_SCREEN_3_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_9_SCREEN_3:
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

DISPLAY_m_E_mc_2_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b1;
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

DISPLAY_m_E_mc_2_STATE_LOWER_NIBBLE:
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

DISPLAY_m_E_mc_2_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_m_E_mc_2:
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

CURSOR_ROW_1_COLUMN_10_SCREEN_3_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_10_SCREEN_3_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_10_SCREEN_3_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_10_SCREEN_3:
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

DISPLAY_c_E_mc_2_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b1;
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

DISPLAY_c_E_mc_2_STATE_LOWER_NIBBLE:
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

DISPLAY_c_E_mc_2_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_c_E_mc_2:
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

CURSOR_ROW_1_COLUMN_11_SCREEN_3_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_11_SCREEN_3_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1010;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_ROW_1_COLUMN_11_SCREEN_3_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_11_SCREEN_3:
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

DISPLAY_EF_E_mc_2_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b1;
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

DISPLAY_EF_E_mc_2_STATE_LOWER_NIBBLE:
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

DISPLAY_EF_E_mc_2_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_EF_E_mc_2:
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

CURSOR_ROW_1_COLUMN_12_SCREEN_3_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_12_SCREEN_3_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1011;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_ROW_1_COLUMN_12_SCREEN_3_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_12_SCREEN_3:
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

DISPLAY_2_E_mc_2_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b1;
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

DISPLAY_2_E_mc_2_STATE_LOWER_NIBBLE:
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

DISPLAY_2_E_mc_2_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_2_E_mc_2:
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

CURSOR_ROW_1_COLUMN_5_SCREEN_4_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_5_SCREEN_4_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_5_SCREEN_4_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_5_SCREEN_4:
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

DISPLAY_H_HD_STATE_UPPER_NIBBLE:
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

DISPLAY_H_HD_STATE_LOWER_NIBBLE:
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

DISPLAY_H_HD_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_H_HD:
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

CURSOR_ROW_1_COLUMN_6_SCREEN_4_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_6_SCREEN_4_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_6_SCREEN_4_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_6_SCREEN_4:
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

DISPLAY_D_HD_STATE_UPPER_NIBBLE:
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

DISPLAY_D_HD_STATE_LOWER_NIBBLE:
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

DISPLAY_D_HD_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_D_HD:
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

CURSOR_ROW_1_COLUMN_8_SCREEN_4_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_8_SCREEN_4_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b0111;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_ROW_1_COLUMN_8_SCREEN_4_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_8_SCREEN_4:
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

DISPLAY_o_or_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b1;
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

DISPLAY_o_or_STATE_LOWER_NIBBLE:
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

DISPLAY_o_or_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_o_or:
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

CURSOR_ROW_1_COLUMN_9_SCREEN_4_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_9_SCREEN_4_STATE_LOWER_NIBBLE:
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

CURSOR_ROW_1_COLUMN_9_SCREEN_4_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_9_SCREEN_4:
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

DISPLAY_r_or_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b1;
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

DISPLAY_r_or_STATE_LOWER_NIBBLE:
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

DISPLAY_r_or_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_r_or:
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

CURSOR_ROW_1_COLUMN_11_SCREEN_4_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_11_SCREEN_4_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1010;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_ROW_1_COLUMN_11_SCREEN_4_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_11_SCREEN_4:
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

DISPLAY_N_FIRST_NN_STATE_UPPER_NIBBLE:
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

DISPLAY_N_FIRST_NN_STATE_LOWER_NIBBLE:
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

DISPLAY_N_FIRST_NN_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_N_FIRST_NN:
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

CURSOR_ROW_1_COLUMN_12_SCREEN_4_STATE_UPPER_NIBBLE:
begin
lcd_en <= 1'b1;
lcd_rs <= 1'b0;
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

CURSOR_ROW_1_COLUMN_12_SCREEN_4_STATE_LOWER_NIBBLE:
begin
lcd_en <= 1'b0;
if (counter == delay_1_us)
begin
lcd_en <= 1'b1;
lcd_command_data <= 4'b1011;
counter <= 25'd0;
state <= state + 10'd1;
end
else
begin
counter <= counter + 25'd1;
end
end

CURSOR_ROW_1_COLUMN_12_SCREEN_4_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_ROW_1_COLUMN_12_SCREEN_4:
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

DISPLAY_N_SECOND_NN_STATE_UPPER_NIBBLE:
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

DISPLAY_N_SECOND_NN_STATE_LOWER_NIBBLE:
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

DISPLAY_N_SECOND_NN_STATE_NIBBLE_DELAY:
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

BYTE_DELAY_N_SECOND_NN:
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
