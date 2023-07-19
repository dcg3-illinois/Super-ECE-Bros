module TitleScreen_rom (
	input logic clock,
	input logic [13:0] address,
	output logic [1:0] q
);

logic [1:0] memory [0:15487] /* synthesis ram_init_file = "./TitleScreen/TitleScreen.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
