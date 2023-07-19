module background_small_rom (
	input logic clock,
	input logic [16:0] address,
	output logic [3:0] q
);

(* ram_init_file = "./background_small/background_small.mif" *) reg [3:0] memory [0:76799];

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule