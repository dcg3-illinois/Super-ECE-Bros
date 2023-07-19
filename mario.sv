module  mario( input Reset, frame_clk, play, DJ,
					input [15:0] keycode,
               output [9:0]  MarioX, MarioY, MarioXS, MarioYS,
					output [10:0] x_offset,
					output reverse, in_air, walking,
					output logic [4:0] walking_frame);
    
   logic [9:0] Mario_X_Pos, Mario_X_Vel, Mario_Y_Pos, Mario_Y_Vel, Mario_XSize, Mario_YSize;
	logic [10:0] offset;
	logic xdir, ydir;
	int counter = 0;
	int frame_counter = 0;
	logic [19:0] VelocityY, VelocityX;
	int frame_rate = 416667;
	int frame_rate_o2 = 208333;
	logic out_60hz = 0;
	int count_60hz = 0;
//	logic walking;
//	logic [4:0] walking_frame;

    parameter [9:0] Mario_X_Center=160;  // Center position on the X axis
    parameter [9:0] Mario_Y_Center=399;  // Center position on the Y axis
    parameter [9:0] Mario_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Mario_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Mario_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Mario_Y_Max=415;     // Bottommost point for Mario to go
    parameter [9:0] Mario_X_Step=1;      // Step size on the X axis
    parameter [9:0] Mario_Y_Step=1;      // Step size on the Y axis

   assign Mario_XSize = 10'b0000010000;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	assign Mario_YSize = 10'b0000010000;
	assign x_offset = offset;
	
	//create a clock that goes according to frames
	always_ff @ (posedge Reset or posedge frame_clk) begin
		if(Reset) begin
			count_60hz <= 0;
			out_60hz <= 0;
		end
		else begin
			if(count_60hz < frame_rate_o2)
				count_60hz <= count_60hz + 1;
			else begin
				count_60hz <= 0;
				out_60hz <= ~out_60hz;
			end
		end
	end
   
   	// do stuff on the pixel clock
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Mario
        if (Reset)  // Asynchronous Reset
        begin 
			Mario_Y_Pos <= Mario_Y_Center;
			Mario_X_Pos <= Mario_X_Center;
			offset <= 0;
        end
		else begin //when youre not on the rising edge of reset, or basically just on the frame_clk
			if(play && !DJ) begin
				frame_counter <= frame_counter + 1;
				
				if(frame_counter == frame_rate) begin
					if(xdir) begin
						if(Mario_X_Pos + VelocityX[19:12] >= 320) begin
							Mario_X_Pos <= 319;
							offset <= offset + VelocityX[19:12];
						end
						else begin
							Mario_X_Pos <= Mario_X_Pos + VelocityX[19:12];
						end
					end
					else begin
						if ((Mario_X_Pos - Mario_XSize - VelocityX[19:12]) < 0 ||
						(Mario_X_Pos - Mario_XSize - VelocityX[19:12]) >= 639)
							Mario_X_Pos <= 0 + Mario_XSize;
						else
							Mario_X_Pos <= Mario_X_Pos - VelocityX[19:12];
					end
					if(ydir)
						Mario_Y_Pos <= Mario_Y_Pos - VelocityY[19:12];
					else
						Mario_Y_Pos <= Mario_Y_Pos + VelocityY[19:12];

					frame_counter <= 0;
				end
			end
		end		
    end
       
    assign MarioX = Mario_X_Pos;
    assign MarioY = Mario_Y_Pos;
    assign MarioXS = Mario_XSize;
	 assign MarioYS = Mario_YSize;
	 assign reverse = ~xdir;

mario_fsm mfsm( .Clk(frame_clk), .Reset, .frame_clk(out_60hz), 
								.keycode0(keycode[15:8]), .keycode1(keycode[7:0]), 
								.MarioX(Mario_X_Pos), .MarioY(Mario_Y_Pos), .x_offset(offset),
								.MarioSizeX(Mario_XSize), .MarioSizeY(Mario_YSize),	
								.xdir, .ydir, .in_air, .walking, .walking_frame,// xidr: 1 is right, 0 is left
												  // ydir: 1 is up, 0 is down
								.x_Velocity(VelocityX), .y_Velocity(VelocityY));

endmodule
