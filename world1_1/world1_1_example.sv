module world1_1_example (
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY,
	input logic blank, play, in_air, walking,
	input logic [9:0] MarioX, MarioY, MarioXS, MarioYS,
	input logic [9:0] GoombaX, GoombaY, GoombaXS, GoombaYS,
	input logic [10:0] x_offset,
	input logic [15:0] keycodes,
	input logic reverse, reverse_g, DJ,
	input logic [4:0] walking_frame,
	output logic [3:0] red, green, blue
);

logic [18:0] rom_address;
logic [13:0] title_address, DJ_address;
logic [12:0] ft_address;
logic [7:0] mario_addr, goom_addr;
logic [3:0] rom_q, mario_q, mario_jq, mario_val, goom_q, leo_q, leo_jq, leo_w1, leo_w2, leo_f, leo_val;
logic [3:0] bkg_red, bkg_green, bkg_blue, m_red, m_green, m_blue, g_red, g_green, g_blue;
logic [3:0] t_red, t_green, t_blue, DJ_red, DJ_green, DJ_blue, ft_red, ft_green, ft_blue, l_red, l_green, l_blue;
logic drawMario;
logic [9:0] M_OffsetX, M_OffsetY, G_OffsetX, G_OffsetY, T_OffsetX, T_OffsetY, DJ_OffsetX, DJ_OffsetY, FT_OffsetX, FT_OffsetY;
logic [8:0] collide;
logic [1:0] mario_w1, mario_w2, seb_q, mario_f;
logic [3:0] DJ_q;
logic drawBlue, ft_q;
logic CainLeo; // Cain 0 Leo 1
int count = 0;

parameter titleX = 80;
parameter titleY = 80;
parameter ftX = 170;
parameter ftY = 300;
parameter DJX = 220;
parameter DJY = 90;
parameter LeoSelect = 8'h0F;
parameter CainSelect = 8'h06;

logic negedge_vga_clk;

// read from ROM on negedge, set pixel on posedge
assign negedge_vga_clk = ~vga_clk;


// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
// this will stretch out the sprite across the entire screen
assign rom_address = DrawX[9:1] + x_offset[10:1] + (DrawY[9:1]* 1280);

always_comb begin
	M_OffsetY = DrawY - MarioY + MarioYS;
	M_OffsetX = DrawX - MarioX + MarioXS;
	if(reverse === 1'b0) begin
		mario_addr = M_OffsetY[9:1] * 16 + M_OffsetX[9:1];
	end
	else begin
		mario_addr = M_OffsetY[9:1] * 16 + (15 - M_OffsetX[9:1]);
	end
	
	G_OffsetY = DrawY - GoombaY + GoombaYS;
	G_OffsetX = DrawX - GoombaX + GoombaXS;
	if(reverse_g === 1'b0) begin
		goom_addr = G_OffsetY[9:1] * 16 + G_OffsetX[9:1];
	end
	else begin
		goom_addr = G_OffsetY[9:1] * 16 + (15 - G_OffsetX[9:1]);
	end
	
	T_OffsetX = DrawX - titleX;
	T_OffsetY = DrawY - titleY;
	
	title_address = T_OffsetY[9:1] * 176 + T_OffsetX[9:1];
	
	DJ_OffsetX = DrawX - DJX;
	DJ_OffsetY = DrawY - DJY;
	
	DJ_address = DJ_OffsetY[9:1]*100 + DJ_OffsetX[9:1];
	
	FT_OffsetX = DrawX - ftX;
	FT_OffsetY = DrawY - ftY;
	
	ft_address = FT_OffsetY * 300 + FT_OffsetX;
	
	collide = DrawX[9:5] + 20 * DrawY[9:5];
	
	if(DJ) begin
		mario_val = mario_f;
		leo_val = leo_f;
	end
	else if(in_air) begin
		mario_val = mario_jq;
		leo_val = leo_jq;
	end
	else if(walking && walking_frame[4]) begin
		mario_val = mario_w1;
		leo_val = leo_w1;
	end
	else if(walking && !walking_frame[4]) begin
		mario_val = mario_w2;
		leo_val = leo_w2;
	end
	else begin
		mario_val = mario_q;
		leo_val = leo_q;
	end
end

always_ff @ (posedge vga_clk) begin	
	red <= 4'h0;
	green <= 4'h0;
	blue <= 4'h0;
	drawMario <= 1'b0;
	
	if(keycodes[15:8] == LeoSelect || keycodes[7:0] == LeoSelect) begin
		CainLeo <= 1;
	end
	else if(keycodes[15:8] == CainSelect || keycodes[7:0] == CainSelect) begin
		CainLeo <= 0;
	end
	
	if (blank) begin
		//draw mario as red for now
		if(!play && !DJ && (DrawX >= titleX) && (DrawX < titleX + 352) &&
			(DrawY >= titleY) && (DrawY < titleY + 176) && {t_red, t_green, t_blue} !== {4'h9, 4'h9, 4'hF}) begin
			red <= t_red;
			green <= t_green;
			blue <= t_blue;
		end
		
		else if(DJ && (DrawX >= DJX) && (DrawX < DJX + 200) && (DrawY >= DJY) &&
			(DrawY < DJY + 200)) begin
			red <= DJ_red;
			green <= DJ_green;
			blue <= DJ_blue;
		end
		else if(DJ && (DrawX >= ftX) && (DrawX < ftX + 300) && (DrawY >= ftY) &&
		(DrawY < ftY + 26) && {ft_red, ft_green, ft_blue} !== {4'h9, 4'h9, 4'hF}) begin
			red <= ft_red;
			green <= ft_green;
			blue <= ft_blue;
		end
		
		else if ((DrawX >= MarioX - MarioXS) &&
       (DrawX < MarioX + MarioXS) &&
       (DrawY >= MarioY - MarioYS) &&
       (DrawY < MarioY + MarioYS) && 
		{m_red, m_green, m_blue} !== {4'h9, 4'h9, 4'hF} && !CainLeo) begin		
				red <= m_red;
				green <= m_green;
				blue <= m_blue;
		end
		else if ((DrawX >= MarioX - MarioXS) &&
       (DrawX < MarioX + MarioXS) &&
       (DrawY >= MarioY - MarioYS) &&
       (DrawY < MarioY + MarioYS) && 
		{l_red, l_green, l_blue} !== {4'h9, 4'h9, 4'hF} && CainLeo) begin		
				red <= l_red;
				green <= l_green;
				blue <= l_blue;
		end
//		else if ((DrawX >= GoombaX - GoombaXS) &&
//       (DrawX < GoombaX + GoombaXS) &&
//       (DrawY >= GoombaY - GoombaYS) &&
//       (DrawY < GoombaY + GoombaYS) && 
//		{g_red, g_green, g_blue} !== {4'h9, 4'h9, 4'hF}) begin
//			red <= g_red;
//			green <= g_green;
//			blue <= g_blue;
//		end
		else begin
			red <= bkg_red;
			green <= bkg_green;
			blue <= bkg_blue;
		end
	end
end

edited_World_rom world1_1_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

edited_World_palette world1_1_palette (
	.index (rom_q),
	.red   (bkg_red),
	.green (bkg_green),
	.blue  (bkg_blue)
);


/////////////////////////// Cain Drawing
Cain_rom sm_rom (
	.clock   (negedge_vga_clk),
	.address (mario_addr),
	.q       (mario_q)
);

Cain_jump_rom mj_rom (
	.clock   (negedge_vga_clk),
	.address (mario_addr),
	.q       (mario_jq)
);

Cain_walk1_rom mw1_rom (
	.clock	(negedge_vga_clk),
	.address	(mario_addr),
	.q			(mario_w1)
);

Cain_walk2_rom mw2_rom (
	.clock	(negedge_vga_clk),
	.address	(mario_addr),
	.q			(mario_w2)
);

Cain_facing_rom cfr (
	.clock	(negedge_vga_clk),
	.address	(mario_addr),
	.q			(mario_f)
);

Cain_palette sm_palette (
	.index (mario_val),
	.red   (m_red),
	.green (m_green),
	.blue  (m_blue)
);

/////////////////////////// Leo Drawing
Leo_rom leo_rom (
	.clock   (negedge_vga_clk),
	.address (mario_addr),
	.q       (leo_q)
);

Leo_jump_rom lj_rom (
	.clock   (negedge_vga_clk),
	.address (mario_addr),
	.q       (leo_jq)
);

Leo_walk1_rom lw1_rom (
	.clock	(negedge_vga_clk),
	.address	(mario_addr),
	.q			(leo_w1)
);

Leo_walk2_rom lw2_rom (
	.clock	(negedge_vga_clk),
	.address	(mario_addr),
	.q			(leo_w2)
);

Leo_facing_rom lfr (
	.clock	(negedge_vga_clk),
	.address	(mario_addr),
	.q			(leo_f)
);

Leo_palette leo_palette (
	.index (leo_val),
	.red   (l_red),
	.green (l_green),
	.blue  (l_blue)
);


/////////////////////////// Goomba Drawing
goomba_right_rom goomba_right_rom (
	.clock   (negedge_vga_clk),
	.address (goom_addr),
	.q       (goom_q)
);

goomba_right_palette goomba_right_palette (
	.index (goom_q),
	.red   (g_red),
	.green (g_green),
	.blue  (g_blue)
);

/////////////////////////// Goomba Drawing
super_ece_bros_rom sebr (
	.clock   (negedge_vga_clk),
	.address (title_address),
	.q       (seb_q)
);

super_ece_bros_palette sebp (
	.index (seb_q),
	.red   (t_red),
	.green (t_green),
	.blue  (t_blue)
);

/////////////////////////// DJ Drawing
DJ_rom djr (
	.clock   (negedge_vga_clk),
	.address (DJ_address),
	.q       (DJ_q)
);

DJ_palette djp (
	.index (DJ_q),
	.red   (DJ_red),
	.green (DJ_green),
	.blue  (DJ_blue)
);

final_text_rom ftr (
	.clock   (negedge_vga_clk),
	.address (ft_address),
	.q       (ft_q)
);

final_text_palette ftp (
	.index (ft_q),
	.red   (ft_red),
	.green (ft_green),
	.blue  (ft_blue)
);

endmodule
