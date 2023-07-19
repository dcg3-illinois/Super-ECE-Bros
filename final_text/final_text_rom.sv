module final_text_rom (
	input logic clock,
	input logic [12:0] address,
	output logic [0:0] q
);

logic [0:0] memory [0:7799] /* synthesis ram_init_file = "./final_text/final_text.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
