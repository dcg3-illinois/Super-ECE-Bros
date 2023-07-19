module small_mario_palette (
	input logic [3:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:15][11:0] palette = {
	{4'h9, 4'h9, 4'hF}, // 0
	{4'hB, 4'h3, 4'h2}, // 1
	{4'hE, 4'h9, 4'h2}, // 2
	{4'h6, 4'h6, 4'h0}, // 3
	{4'h9, 4'h9, 4'hF}, // 4
	{4'h9, 4'h9, 4'hF}, // 5
	{4'h6, 4'h6, 4'h0}, // 6
	{4'h6, 4'h6, 4'h0}, // 7
	{4'hE, 4'h9, 4'h2}, // 8 
	{4'hE, 4'h9, 4'h2}, // 9
	{4'h9, 4'h9, 4'hF}, // 10
	{4'h9, 4'h9, 4'hF}, // 11
	{4'h6, 4'h6, 4'h0}, // 12
	{4'h9, 4'h9, 4'hF}, // 13
	{4'hE, 4'h9, 4'h2}, // 14
	{4'hE, 4'h9, 4'h2}  // 15
};

assign {red, green, blue} = palette[index];

endmodule
