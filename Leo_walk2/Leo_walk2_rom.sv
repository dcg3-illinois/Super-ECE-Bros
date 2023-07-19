module Leo_walk2_rom (
	input logic clock,
	input logic [7:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:255] /* synthesis ram_init_file = "./Leo_walk2/Leo_walk2.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
