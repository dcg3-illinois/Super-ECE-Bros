module  goomba( input Reset, frame_clk,
               output [9:0]  GoombaX, GoombaY, GoombaXS, GoombaYS,
					output reverse_g);
    
   logic [9:0] Goomba_X_Pos, Goomba_X_Motion, Goomba_Y_Pos, Goomba_Y_Motion, Goomba_XSize, Goomba_YSize;
	logic rev;
	int counter = 0;
	int frame_counter = 0;
	int frame_rate = 416667;

    parameter [9:0] Goomba_X_Center=280;  // Center position on the X axis
    parameter [9:0] Goomba_Y_Center=399;  // Center position on the Y axis
    parameter [9:0] Goomba_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Goomba_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Goomba_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Goomba_Y_Max=415;     // Bottommost point for Goomba to go
    parameter [9:0] Goomba_X_Step=1;      // Step size on the X axis
    parameter [9:0] Goomba_Y_Step=1;      // Step size on the Y axis
	 parameter [9:0] G_dist = 160;

   assign Goomba_XSize = 10'b0000010000;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	assign Goomba_YSize = 10'b0000010000;
	assign reverse = rev;
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Goomba
        if (Reset)  // Asynchronous Reset
        begin 
         Goomba_Y_Motion <= 10'd0; //Goomba_Y_Step;
			Goomba_X_Motion <= 10'd1; //Goomba_X_Step;
			Goomba_Y_Pos <= Goomba_Y_Center;
			Goomba_X_Pos <= Goomba_X_Center;
			rev <= 1'b0;
        end
		else begin //when youre not on the rising edge of reset, or basically just on the frame_clk
			Goomba_Y_Motion <= 10'd0; //Goomba_Y_Step;
			
			frame_counter <= frame_counter + 1;
			
			if(frame_counter === frame_rate) begin
				Goomba_X_Pos <= (Goomba_X_Pos + Goomba_X_Motion);
				frame_counter <= 0;
				counter <= counter + 1;
			end
			
			if(counter === G_dist) begin
				if(Goomba_X_Motion === 1) begin
					Goomba_X_Motion <= -1;
				end
				else begin
					Goomba_X_Motion <= 1;
				end
				counter <= 0;
			end

		end		
    end
       
    assign GoombaX = Goomba_X_Pos;
   
    assign GoombaY = Goomba_Y_Pos;
   
    assign GoombaXS = Goomba_XSize;

	assign GoombaYS = Goomba_YSize;
    

endmodule
