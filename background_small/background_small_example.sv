module background_small_example (
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY,
	input logic blank,
	input logic [9:0] MarioX, MarioY, MarioXS, MarioYS,
	input logic [9:0] GoombaX, GoombaY, GoombaXS, GoombaYS,
	input logic reverse, reverse_g,
	output logic [3:0] red, green, blue
);

logic [16:0] rom_address;
logic [7:0] mario_addr, goom_addr;
logic [3:0] rom_q, mario_q, goom_q;
logic [3:0] bkg_red, bkg_green, bkg_blue, m_red, m_green, m_blue, g_red, g_green, g_blue;
//logic [3:0] R, G, B;
logic drawMario;
logic [9:0] M_OffsetX, M_OffsetY, G_OffsetX, G_OffsetY;
logic [8:0] collide;
logic drawBlue;

logic negedge_vga_clk;

// read from ROM on negedge, set pixel on posedge
assign negedge_vga_clk = ~vga_clk;

// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
// this will stretch out the sprite across the entire screen
assign rom_address = ((DrawX * 320) / 640) + (((DrawY * 240) / 480) * 320);

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
	
	collide = DrawX[9:5] + 20 * DrawY[9:5];
end

always_ff @ (posedge vga_clk) begin
	red <= 4'h0;
	green <= 4'h0;
	blue <= 4'h0;
	drawMario <= 1'b0;
	if (blank) begin
		//draw mario as red for now
		if ((DrawX >= MarioX - MarioXS) &&
       (DrawX <= MarioX + MarioXS) &&
       (DrawY >= MarioY - MarioYS) &&
       (DrawY <= MarioY + MarioYS) && 
		{m_red, m_green, m_blue} !== {4'h9, 4'h9, 4'hF}) begin
			red <= m_red;
			green <= m_green;
			blue <= m_blue;
		end
		else if ((DrawX >= GoombaX - GoombaXS) &&
       (DrawX <= GoombaX + GoombaXS) &&
       (DrawY >= GoombaY - GoombaYS) &&
       (DrawY <= GoombaY + GoombaYS) && 
		{g_red, g_green, g_blue} !== {4'h9, 4'h9, 4'hF}) begin
			red <= g_red;
			green <= g_green;
			blue <= g_blue;
		end
		else begin
			red <= bkg_red;
			green <= bkg_green;
			blue <= bkg_blue;
		end
	end
end


/////////////////////////// Background Drawing
background_small_rom background_small_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

background_small_palette background_small_palette (
	.index (rom_q),
	.red   (bkg_red),
	.green (bkg_green),
	.blue  (bkg_blue)
);


/////////////////////////// Mario Drawing
Cain_rom sm_rom (
	.clock   (negedge_vga_clk),
	.address (mario_addr),
	.q       (mario_q)
);

Cain_palette sm_palette (
	.index (mario_q),
	.red   (m_red),
	.green (m_green),
	.blue  (m_blue)
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

endmodule
