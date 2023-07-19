module world1_1_collider_rom (
	input logic clock,
	input logic [10:0] address1,address2,
	output logic q1, q2
);

(* ram_init_file = "./world1_1_collider/world1_1_collider.mif" *) logic memory [0:1199];

always_ff @ (posedge clock) begin
	q1 <= memory[address1];
	q2 <= memory[address2];
end

endmodule
