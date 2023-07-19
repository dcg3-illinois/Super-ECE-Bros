//FSM for Mario
//Moore FSM
//Dedicated to Mario's moving graphics
module mario_fsm (   input logic    Clk, Reset, frame_clk,							
				input logic[7:0]    keycode0, keycode1, 
				input logic [9:0]	MarioX, MarioY, MarioSizeX, MarioSizeY,
				input logic [10:0] x_offset,
				output logic		xdir, ydir, in_air, walking,// xidr: 1 is right, 0 is left
												// ydir: 1 is up, 0 is down
				output logic [4:0] walking_frame,
				output logic [19:0] x_Velocity, y_Velocity);

    enum logic [4:0] {  Idle, Restart,
					Run_Right, 
					Run_Left, 
					Jump, JumpLeft, JumpRight,
               Fall, FallRight, FallLeft
           }   State, Next_state;   // Internal state logic
    
    //////////////////////////// Declare keycodes and movement params ////////////////////////////	
    parameter UP = 8'h0D;
    parameter DOWN = 8'h22;
    parameter LEFT = 8'h04;
    parameter RIGHT = 8'h07;
    parameter JUMP_INIT_VEL = 20'h0C000;
    parameter Y_ACCEL = 20'h00800;
    parameter X_ACCEL = 20'h00400;
    parameter X_DECEL = 20'h01000;
    parameter MAX_X_VEL = 20'h04000;
    parameter MAX_Y_VEL = 20'h04000;
    parameter SQUAT_VEL = 20'h02000;

	//////////////////////////////////// Declare variables ////////////////////////////////////	
	logic [19:0] y_Vel, x_Vel, y_Vel_Collider, x_Vel_Collider, map_l, map_r, map_l_vel, map_r_vel;
	// 0 left, 1 right, 0 down, 1 up
	logic xd, yd;
	logic collide_tl, collide_tr, collide_bl, collide_br;
    logic collide_llu, collide_lld, collide_rrd, collide_rru, collide_ru, collide_rd, collide_lu, collide_ld;
	// Store which block Mario's perimeters are in
	logic [10:0]	TopLeftBlock, TopRightBlock, BottomLeftBlock, BottomRightBlock, LeftUpBlock, LeftDownBlock, RightUpBlock, RightDownBlock, RRDBlock, RRUBlock, LLUBlock, LLDBlock; //9?
	logic [9:0] l_pix, r_pix, b_pix, t_pix, l_pix_vel, r_pix_vel, b_pix_vel, t_pix_vel; //left, right, bottom, top
    logic [4:0] from_top_y_overlap, from_left_x_overlap, from_bottom_y_overlap, from_right_x_overlap;
	 logic [7:0] k0, k1;

	//////////////////////////////////// Detect collisions ////////////////////////////////////
	always_comb begin
		// if mario is moving right, we add velocity to his position
		// note that this is his pixel on the screen, not map
        l_pix = MarioX - MarioSizeX;
        r_pix = MarioX + MarioSizeX;
        t_pix = MarioY - MarioSizeY;
        b_pix = MarioY + MarioSizeY;
        
        if(xd) begin
            l_pix_vel = MarioX - MarioSizeX + x_Vel_Collider[19:12];
            r_pix_vel = MarioX + MarioSizeX + x_Vel_Collider[19:12];
        end
        // else we want to subtract velocity to his position
        else begin
            l_pix_vel = MarioX - MarioSizeX - x_Vel_Collider[19:12];
            r_pix_vel = MarioX + MarioSizeX - x_Vel_Collider[19:12];
        end

        // if mario is moving up, we subtract velocity from his height
        if(yd) begin
            t_pix_vel = MarioY - MarioSizeY - y_Vel_Collider[19:12];
            b_pix_vel = MarioY + MarioSizeY - y_Vel_Collider[19:12];
        end
        // else we want to add velocity to his height
        else begin
            t_pix_vel = MarioY - MarioSizeY + y_Vel_Collider[19:12];
            b_pix_vel = MarioY + MarioSizeY + y_Vel_Collider[19:12];
        end
        
        // calculate Mario's X and Y overlaps
        from_left_x_overlap = r_pix[4:0];
        from_top_y_overlap = b_pix[4:0];
        from_right_x_overlap = 5'b11111 - l_pix[4:0]; //31 - [0,31]
        from_bottom_y_overlap = 5'b11111 - t_pix[4:0]; //31 - [0,31]
		  
		  
		map_l = l_pix + x_offset;
		map_r = r_pix + x_offset;
        map_r_vel = r_pix_vel + x_offset;
        map_l_vel = l_pix_vel + x_offset;
		// divide position by 32 to get block
		TopLeftBlock = map_l_vel[10:5] + (80 * t_pix_vel[9:5]);
		TopRightBlock = map_r_vel[10:5] + (80 * t_pix_vel[9:5]);
		BottomLeftBlock = map_l_vel[10:5] + (80 * b_pix_vel[9:5]);
		BottomRightBlock = map_r_vel[10:5] + (80 * b_pix_vel[9:5]);
        LLUBlock = map_l_vel[10:5] + (80 * t_pix[9:5]);
        LeftUpBlock = map_l[10:5] + (80 * t_pix_vel[9:5]);
		RRUBlock = map_r_vel[10:5] + (80 * t_pix[9:5]);
        RightUpBlock = map_r[10:5] + (80 * t_pix_vel[9:5]);
		LLDBlock = map_l_vel[10:5] + (80 * b_pix[9:5]);
        LeftDownBlock = map_l[10:5] + (80 * b_pix_vel[9:5]);
		RRDBlock = map_r_vel[10:5] + (80 * b_pix[9:5]);
        RightDownBlock = map_r[10:5] + (80 * b_pix_vel[9:5]);
	end
	///////////////////////////// Drive some outputs //////////////////////////////////////////
	assign x_Velocity = x_Vel;
	assign y_Velocity = y_Vel;
	assign xdir = xd;
	assign ydir = yd;
	assign k1 = keycode1;
	assign k0 = keycode0;
   
	//////////////////////////////////// Move to the next state ////////////////////////////////////
	always_ff @ (posedge frame_clk)
	begin
		if (Reset) 
			State <= Idle;
		else 
			State <= Next_state;
	end

	//////////////////////////////////// Determine next state ////////////////////////////////////
       always_comb begin
		// Default next state is staying at current state
		Next_state = State;
        //Default Control Signals
		
	    // Assign next state
        unique case (State)
            ////////// IDLE //////////
            Idle : begin
                // if not colliding in the downward direction
				if(!collide_ld && !collide_rd) begin
					Next_state = Fall;
                end
                // else if we want to jump
                else if (k0 == UP || k1 == UP) begin
                    Next_state = Jump;
                end
                // if not colliding and want to go left
                else if (k0 == LEFT || k1 == LEFT && !collide_llu) begin
                    Next_state = Run_Left;
                end
                
                // if not colliding and want to go right
                else if (k0 == RIGHT || k1 == RIGHT && !collide_rru) begin
                    Next_state = Run_Right;
                end
            end

            ////////// RUN RIGHT //////////		
			Run_Right : begin
                // if not colliding in the downward direction
                if(!collide_bl && !collide_br) begin
                    Next_state = Fall;
                end
                // if we want to jump
                else if (k0 == UP || k1 == UP) begin
                    if(k0 == RIGHT || k1 == RIGHT && !collide_rru)
                        Next_state = JumpRight;
                    else
                        Next_state = Jump;
                end
                // if we collide on the right
                else if (collide_rru) begin
                    Next_state = Idle;
                end
                
                // if we want to go left
                else if (k0 == LEFT || k1 == LEFT && x_Vel == 20'h0) begin
                    Next_state = Run_Left;
                end
            end
			

            ////////// RUN LEFT //////////	
            Run_Left : begin
				// if not colliding in the downward direction
                if(!collide_bl && !collide_br) begin
                    Next_state = Fall;
                end
                // if we want to jump
                else if (k0 == UP || k1 == UP) begin
                    if(k0 == LEFT || k1 == LEFT && !collide_llu)
                        Next_state = JumpLeft;
                    else
                        Next_state = Jump;
                end
                // colldiing on the left
				else if (collide_llu) begin
                    Next_state = Idle;
                end
                
                // if we want to go right
                else if (k0 == RIGHT || k1 == RIGHT && x_Vel == 20'h0) begin
                    Next_state = Run_Right;
                end
            end
            

            
            ////////// JUMP //////////	
            Jump :  begin
				// if we collide on the top or reach peak of our jump
                // if we collide on the right side
                if(collide_lu || collide_ru || y_Vel == 20'h0) begin
                        Next_state = Fall;
                end
                // else we are still jumping
                else begin
                   if(keycode0 == RIGHT || keycode1 == RIGHT && !collide_rru)
                       Next_state = JumpRight;
                   else if(keycode0 == LEFT || keycode1 == LEFT && !collide_llu)
                       Next_state = JumpLeft;
                   else
                        Next_state = Jump;
                end
            end

            JumpRight : begin
                if(collide_ru || collide_lu || y_Vel == 0) begin //(collide_tr && (MarioY > (rightside_ty | 10'b0000011111)) && ((MarioY - (rightside_ty | 10'b0000011111)) > MarioSizeY)) || y_Vel == 0) begin
                    Next_state = FallRight;
				end
                else if(collide_rru || collide_rrd) begin
                    Next_state = Jump;
				end
                else if(x_Vel == 0 && (k0 == LEFT || k1 == LEFT))
                    Next_state = JumpLeft;
            end

            JumpLeft : begin
                if(collide_ru || collide_lu || y_Vel == 0) begin //(collide_tr && (MarioY > (rightside_ty | 10'b0000011111)) && ((MarioY - (rightside_ty | 10'b0000011111)) > MarioSizeY)) || y_Vel == 0) begin
                    Next_state = FallLeft;
				end
                else if(collide_llu || collide_lld) begin
                    Next_state = Jump;
				end
                else if(x_Vel == 0 && (k0 == RIGHT || k1 == RIGHT))
                    Next_state = JumpRight;
            end
             

            ////////// FALLING //////////	
            Fall : begin
                // land straight down
                if (collide_ld || collide_rd) begin
                        Next_state = Idle;
                end
                else if(k0 == RIGHT || k1 == RIGHT) begin
                    if(collide_rru || collide_rrd) begin
                        Next_state = Fall;
                    end
                    else begin
                        Next_state = FallRight;
                    end
                end
                else if(k0 == LEFT || k1 == LEFT) begin
                    if(collide_llu || collide_lld) begin
                        Next_state = Fall;
                    end
                    else begin
                        Next_state = FallLeft;
                    end
                end        
            end

            FallRight : begin
                if(collide_rru || collide_rrd && !collide_ld) begin
                    Next_state = Fall;
                end
                else if(collide_rd || collide_ld) begin
                    Next_state = Run_Right;
                end
                else if(x_Vel == 0 && (k0 == LEFT || k1 == LEFT))
                    Next_state = FallLeft;
            end

            FallLeft : begin
                if(collide_llu || collide_lld && !collide_rd) begin
                    Next_state = Fall;
                end
                else if(collide_rd || collide_ld) begin
                    Next_state = Run_Left;
                end
                else if(x_Vel == 0 && (k0 == RIGHT || k1 == RIGHT))
                    Next_state = FallRight;
            end


            default : Next_state = Idle;
        endcase
   end

   always_ff @ (posedge frame_clk) begin
		///////////////////// ASSIGN CONTROL SIGNALS /////////////////////	
		case (State)

            ////////// IDLE //////////
            Idle : begin
                // set y direction to down and x vel to 0
				walking <= 0;
				walking_frame <= 0;
                yd <= 0;
                x_Vel <= 0;
                x_Vel_Collider <= 0;
				in_air <= 0;
				y_Vel <= 0;
				y_Vel_Collider <= 20'h01000;
                if(k0 == UP || k1 == UP) begin
                    y_Vel <= JUMP_INIT_VEL;
                    y_Vel_Collider <= JUMP_INIT_VEL;
                    yd <= 1;
                end
            end

            ////////// RUN RIGHT //////////
			Run_Right : begin
                if(x_Vel == 0)
					walking <= 0;
				else
					walking <= 1;
				walking_frame <= walking_frame + 1;
				yd <= 0;
                xd <= 1;
                y_Vel <= 0;
                y_Vel_Collider <= 20'h01000;
				in_air <= 0;

                if(k0 == RIGHT || k1 == RIGHT && x_Vel < MAX_X_VEL) begin
                    x_Vel <= x_Vel + X_ACCEL;
                    x_Vel_Collider <= x_Vel_Collider + X_ACCEL;
                end
                else if(k0 == RIGHT || k1 == RIGHT && x_Vel >= MAX_X_VEL) begin
                    x_Vel <= MAX_X_VEL;
                    x_Vel_Collider <= MAX_X_VEL;
                end
                else if(k0 != RIGHT && k1 != RIGHT && x_Vel > 0) begin
                    x_Vel <= x_Vel - X_ACCEL;
                    x_Vel_Collider <= x_Vel_Collider - X_ACCEL;
                end
                // we want the next state to remember we're colliding
                if(collide_rru) begin
                    x_Vel_Collider <= 20'h02000;
                end
					 
				if(k0 == UP || k1 == UP) begin
                    y_Vel <= JUMP_INIT_VEL;
                    y_Vel_Collider <= JUMP_INIT_VEL;
                    yd <= 1;
                end
			end

            ////////// RUN LEFT //////////
			Run_Left : begin
				if(x_Vel == 0)
					walking <= 0;
				else
					walking <= 1;
					walking_frame <= walking_frame + 1;
                yd <= 0;
                xd <= 0;
                y_Vel <= 0;
                y_Vel_Collider <= 20'h01000;
				in_air <= 0;

                if(k0 == LEFT || k1 == LEFT && x_Vel < MAX_X_VEL) begin
                    x_Vel <= x_Vel + X_ACCEL;
                    x_Vel_Collider <= x_Vel_Collider + X_ACCEL;
                end
                else if(k0 == LEFT || k1 == LEFT && x_Vel >= MAX_X_VEL) begin
                    x_Vel <= MAX_X_VEL;
                    x_Vel_Collider <= MAX_X_VEL;
                end
                else if(k0 != LEFT && k1 != LEFT && x_Vel > 0) begin
                    x_Vel <= x_Vel - X_ACCEL;
                    x_Vel_Collider <= x_Vel_Collider - X_ACCEL;
                end

                // we want the next state to remember we're colliding
                if(collide_llu) begin
                    x_Vel_Collider <= 20'h02000;
                end

				if(k0 == UP || k1 == UP) begin
                    y_Vel <= JUMP_INIT_VEL;
                    y_Vel_Collider <= JUMP_INIT_VEL;
                    yd <= 1;
                end
			end
			
            /////// JUMP /////////
            Jump : begin
                yd <= 1;
                x_Vel <= 0;
                in_air <= 1;
				walking <= 0;
                    
                if(collide_lu || collide_ru || y_Vel == 20'h0) begin
                    y_Vel <= 0;
                    y_Vel_Collider <= 0;
                    yd <= 0;
                end
                // else we are still jumping
                else begin
                    y_Vel <= y_Vel - Y_ACCEL;
                    y_Vel_Collider <= y_Vel_Collider - Y_ACCEL;
                end
                
            end

            JumpRight : begin
				walking <= 0;
                yd <= 1;
                xd <= 1;
				in_air <= 1;
                // x_Vel <= 20'h04000;

                if(k0 == RIGHT || k1 == RIGHT && x_Vel < MAX_X_VEL) begin
                    x_Vel <= x_Vel + X_ACCEL;
                    x_Vel_Collider <= x_Vel_Collider + X_ACCEL;
                end
                else if(k0 == RIGHT || k1 == RIGHT && x_Vel >= MAX_X_VEL) begin
                    x_Vel <= MAX_X_VEL;
                    x_Vel_Collider <= MAX_X_VEL;
                end
                else if(k0 != RIGHT && k1 != RIGHT && x_Vel > 0) begin
                    x_Vel <= x_Vel - X_ACCEL;
                    x_Vel_Collider <= x_Vel_Collider - X_ACCEL;
                end

                // if we collide on top
                if(collide_lu || collide_ru || y_Vel == 0) begin 
                    y_Vel <= 0;
                    y_Vel_Collider <= 0;
                    yd <= 0;
				end
                else if(collide_rru || collide_rrd) begin
                    x_Vel <= 0;
                    x_Vel_Collider <= 20'h02000;
                    y_Vel <= y_Vel - Y_ACCEL;
                    y_Vel_Collider <= y_Vel_Collider - Y_ACCEL;
					end
                else begin
                    y_Vel <= y_Vel - Y_ACCEL;
                    y_Vel_Collider <= y_Vel_Collider - Y_ACCEL;
                end    
            end

            JumpLeft : begin
                walking <= 0;
				yd <= 1;
                xd <= 0;
				in_air <= 1;
                // x_Vel <= 20'h04000;

                //horizontal logic
                if(k0 == LEFT || k1 == LEFT && x_Vel < MAX_X_VEL) begin
                    x_Vel <= x_Vel + X_ACCEL;
                    x_Vel_Collider <= x_Vel_Collider + X_ACCEL;
                end
                else if(k0 == LEFT || k1 == LEFT && x_Vel >= MAX_X_VEL) begin
                    x_Vel <= MAX_X_VEL;
                    x_Vel_Collider <= MAX_X_VEL;
                end
                else if(k0 != LEFT && k1 != LEFT && x_Vel > 0) begin
                    x_Vel <= x_Vel - X_ACCEL;
                    x_Vel_Collider <= x_Vel_Collider - X_ACCEL;
                end

                if(collide_lu || collide_ru || y_Vel == 0) begin //|| (collide_tr && (MarioY > (rightside_ty | 10'b0000011111)) && ((MarioY - (rightside_ty | 10'b0000011111)) > MarioSizeY))) begin
                    y_Vel <= 0;
                    y_Vel_Collider <= 0;
                    yd <= 0;
					end
                else if(collide_llu || collide_lld) begin
                    x_Vel <= 0;
                    x_Vel_Collider <= 20'h02000;
                    y_Vel <= y_Vel - Y_ACCEL;
                    y_Vel_Collider <= y_Vel_Collider - Y_ACCEL;
					end
                else begin
                    y_Vel <= y_Vel - Y_ACCEL;
                    y_Vel_Collider <= y_Vel_Collider - Y_ACCEL;
                end
					 
            end
            /////// FALL /////////
            Fall : begin
                walking <= 0;
				yd <= 0;
                x_Vel <= 0;
				in_air <= 1;
				if (collide_ld || collide_rd) begin
					y_Vel <= 0;
					y_Vel_Collider[19:12] <= (b_pix_vel & 10'b1111100000) - (MarioY + MarioSizeY);
				end
                else if (y_Vel >= MAX_Y_VEL) begin
                    y_Vel <= MAX_Y_VEL;
                    y_Vel_Collider <= MAX_Y_VEL;
                end
                else begin
                    y_Vel <= y_Vel + Y_ACCEL;
                    y_Vel_Collider <= y_Vel_Collider + Y_ACCEL;
                end 
            end

            FallRight : begin
                walking <= 0;
				xd <= 1;
                yd <= 0;
                // x_Vel <= 20'h04000;
                // x_Vel_Collider <= 20'h04000;
                in_air <= 1;

                if(k0 == RIGHT || k1 == RIGHT && x_Vel < MAX_X_VEL) begin
                    x_Vel <= x_Vel + X_ACCEL;
                    x_Vel_Collider <= x_Vel_Collider + X_ACCEL;
                end
                else if(k0 == RIGHT || k1 == RIGHT && x_Vel >= MAX_X_VEL) begin
                    x_Vel <= MAX_X_VEL;
                    x_Vel_Collider <= MAX_X_VEL;
                end
                else if(k0 != RIGHT && k1 != RIGHT && x_Vel > 0) begin
                    x_Vel <= x_Vel - X_ACCEL;
                    x_Vel_Collider <= x_Vel_Collider - X_ACCEL;
                end

                if(collide_rru || collide_rrd && !collide_ld) begin
                    x_Vel <= 0;
                    x_Vel_Collider <= 20'h02000;
                    if (y_Vel >= MAX_Y_VEL) begin
                        y_Vel <= MAX_Y_VEL;
                        y_Vel_Collider <= MAX_Y_VEL;
                    end
                    else begin
                        y_Vel <= y_Vel + Y_ACCEL;
                        y_Vel_Collider <= y_Vel_Collider + Y_ACCEL;
                    end
                end
                else if(collide_ld || collide_rd) begin
                    y_Vel <= 0;
					y_Vel_Collider <= 20'h02000;
                end
                else begin
                    if (y_Vel >= MAX_Y_VEL) begin
                        y_Vel <= MAX_Y_VEL;
                        y_Vel_Collider <= MAX_Y_VEL;
                    end
                    else begin
                        y_Vel <= y_Vel + Y_ACCEL;
                        y_Vel_Collider <= y_Vel_Collider + Y_ACCEL;
                    end
                end
            end

            FallLeft : begin
                walking <= 0;
				xd <= 0;
                yd <= 0;
                // x_Vel <= 20'h04000;
                in_air <= 1;

                //horizontal logic
                if(k0 == LEFT || k1 == LEFT && x_Vel < MAX_X_VEL) begin
                    x_Vel <= x_Vel + X_ACCEL;
                    x_Vel_Collider <= x_Vel_Collider + X_ACCEL;
                end
                else if(k0 == LEFT || k1 == LEFT && x_Vel >= MAX_X_VEL) begin
                    x_Vel <= MAX_X_VEL;
                    x_Vel_Collider <= MAX_X_VEL;
                end
                else if(k0 != LEFT && k1 != LEFT && x_Vel > 0) begin
                    x_Vel <= x_Vel - X_ACCEL;
                    x_Vel_Collider <= x_Vel_Collider - X_ACCEL;
                end


                if(collide_llu || collide_lld && !collide_rd) begin
                    x_Vel <= 0;
                    x_Vel_Collider <= 20'h02000;
                    if (y_Vel >= MAX_Y_VEL) begin
                        y_Vel <= MAX_Y_VEL;
                        y_Vel_Collider <= MAX_Y_VEL;
                    end
                    else begin
                        y_Vel <= y_Vel + Y_ACCEL;
                        y_Vel_Collider <= y_Vel_Collider + Y_ACCEL;
                    end
                end
                else if(collide_ld || collide_rd) begin
                    y_Vel <= 0;
					y_Vel_Collider <= 20'h02000;
                end
                else begin
                    if (y_Vel >= MAX_Y_VEL) begin
                        y_Vel <= MAX_Y_VEL;
                        y_Vel_Collider <= MAX_Y_VEL;
                    end
                    else begin
                        y_Vel <= y_Vel + Y_ACCEL;
                        y_Vel_Collider <= y_Vel_Collider + Y_ACCEL;
                    end
                end
            end

			default : ;
		endcase
	end 

    //////////////////////////////////// Instantiate Collider ROMs ////////////////////////////////////
    world1_1_collider_rom top_angle_collision_rom(.clock(Clk),
                        .address1(TopLeftBlock),
                        .address2(TopRightBlock),
                        .q1(collide_tl),
                        .q2(collide_tr));
    world1_1_collider_rom bottom_angle_collision_rom(.clock(Clk),
                        .address1(BottomLeftBlock),
                        .address2(BottomRightBlock),
                        .q1(collide_bl),
                        .q2(collide_br));
    world1_1_collider_rom top_collision_rom(.clock(Clk),
                        .address1(LeftUpBlock),
                        .address2(RightUpBlock),
                        .q1(collide_lu),
                        .q2(collide_ru));
    world1_1_collider_rom bottom_collision_rom(.clock(Clk),
                        .address1(LeftDownBlock),
                        .address2(RightDownBlock),
                        .q1(collide_ld),
                        .q2(collide_rd));
    world1_1_collider_rom right_collision_rom(.clock(Clk),
                        .address1(RRUBlock),
                        .address2(RRDBlock),
                        .q1(collide_rru),
                        .q2(collide_rrd));
    world1_1_collider_rom left_collision_rom(.clock(Clk),
                        .address1(LLUBlock),
                        .address2(LLDBlock),
                        .q1(collide_llu),
                        .q2(collide_lld));
	
endmodule
