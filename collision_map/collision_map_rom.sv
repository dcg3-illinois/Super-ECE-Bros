module collision_map_rom (
	input logic clock,
	input logic [8:0] address1,address2,
	output logic q1, q2
);

(* ram_init_file = "./collision_map/collision_map.mif" *) logic memory [0:299];

always_ff @ (posedge clock) begin
	q1 <= memory[address1];
	q2 <= memory[address2];
end

endmodule
