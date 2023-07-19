module screenfsm (   input logic    Clk, Reset,							
				input logic[15:0]    keycode, 
				input logic [10:0] x_offset,
				output logic play, DJ);

    enum logic [2:0] {  TitleScreen, Game, End
           }   State, Next_state;   // Internal state logic

   
	//////////////////////////////////// Move to the next state ////////////////////////////////////
	always_ff @ (posedge Reset or posedge Clk)
	begin
		if (Reset) 
			State <= TitleScreen;
		else 
			State <= Next_state;
	end

	//////////////////////////////////// Determine next state ////////////////////////////////////
   always_comb begin

		Next_state = State;

        unique case (State)
				TitleScreen : begin
					play = 1'b0;
					DJ = 1'b0;
					if(keycode[15:8] == 8'h28 || keycode[7:0] == 8'h28)
						Next_state = Game;
				end
				
				Game : begin
					if(x_offset[10:1] >= 980)
						Next_state = End;
					else
						Next_state = Game;
					play = 1'b1;
					DJ = 1'b0;
				end
				
				End : begin
					Next_state = End;
					play = 1'b0;
					DJ = 1'b1;
				end
				
            default : Next_state = TitleScreen;
        endcase	  
   end 

	
endmodule
