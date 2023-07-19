module super_ece_bros_rom (
	input logic clock,
	input logic [13:0] address,
	output logic [1:0] q
);

logic [1:0] memory [0:15487] /* synthesis ram_init_file = "./super_ece_bros/super_ece_bros.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
