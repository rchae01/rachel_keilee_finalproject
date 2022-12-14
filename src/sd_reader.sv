`default_nettype none
`timescale 1ns / 1ps

 module sd_reader(input wire clk_100mhz, 
                    input wire sd_cd,
                    input wire btnr, // replace w/ your system reset
                    
            		    input wire [31:0] addr, //from keyboard
            		  
            		    inout wire [3:0] sd_dat, 
                       
                    output logic [7:0] led,
                    output logic sd_reset, 
                    output logic sd_sck, 
                    output logic sd_cmd,

		                output logic aud_sd,
                    output logic aud_pwm,
                    output logic [11:0] counter2,
                    output logic [11:0] counter1

                    );
    
    logic reset;            // assign to your system reset
    assign reset = btnr;    // if yours isn't btnr
    
    assign sd_dat[2:1] = 2'b11;
    assign sd_reset = 0;
    logic [3:0] wait3;
    
    // generate 25 mhz clock for sd_controller 
    logic clk_25mhz;
    divider clocks(.clk_in(clk_100mhz), .sd_clk(clk_25mhz));
   
    // sd_controller inputs
    logic rd;                   // read enable
    logic wr;                   // write enable
    logic [7:0] din;            // data to sd card
    logic [31:0] addr1;          // starting address for read/write operation
    
    // sd_controller outputs
    logic ready;                // high when ready for new read/write operation
    logic [7:0] dout;           // data from sd card
    logic byte_available;       // high when byte available for read
    logic ready_for_next_byte;  // high when ready for new byte to be written

    logic ready2;                // high when ready for new read/write operation
    logic [7:0] dout2;           // data from sd card
    logic byte_available2;       // high when byte available for read
    logic ready_for_next_byte2;  // high when ready for new byte to be written
   
    //assign addr = 32'h0000_0000;
 
    // handles reading from the SD card
    sd_controller sd(.reset(reset), .clk(clk_25mhz), .cs(sd_dat[3]), .mosi(sd_cmd), 
                     .miso(sd_dat[0]), .sclk(sd_sck), .ready(ready), .address(addr1),
                     .rd(rd), .dout(dout), .byte_available(byte_available),
                     .wr(wr), .din(din), .ready_for_next_byte(ready_for_next_byte)); 
    /*
    sd_controller sd2(.reset(reset), .clk(clk_25mhz), .cs(sd_dat[3]), .mosi(sd_cmd), 
                     .miso(sd_dat[0]), .sclk(sd_sck), .ready(ready2), .address((addr1 + 11264)),
                     .rd(rd), .dout(dout2), .byte_available(byte_available2),
                     .wr(wr), .din(din), .ready_for_next_byte(ready_for_next_byte2)); 
    */


    // check for rising edge of byte_available

    logic byte_check;
    logic old_byte;



    always_ff @(posedge clk_100mhz) begin
	    old_byte <= byte_available;
	    if (reset) begin
          byte_check <= 0;
      end else begin
          if (byte_available && ~old_byte) begin
	           byte_check <= 1;
	        end else begin
	           byte_check <= 0;
	        end
      end
    end
 
    // sd card reading logic
   
    //logic [31:0] counter1; //keeps up with when we need new addr
    //logic [31:0] counter2; //keeps up with how many sectors we've read
    logic [7:0] new_byte;
    logic [7:0] last_byte;
    //logic once;

    always_ff @(posedge clk_100mhz) begin
      if (reset) begin
        counter1 <= 0;
        counter2 <= 0;
        addr1 <= addr;
        rd <= 1;
        //once <= 0;
      end 

      if (ready && data_count <= 1536) begin	  
    	  //increase counter by 512 at the end of every sector 172 times??
    	  rd <= 1;
      end 
      if (rd && (counter2 < 22)) begin
    	  if (byte_check) begin
    	    if (counter1 == 511) begin
              addr1 <= addr1 + 512;
      	      counter1 <= 0;
      	      counter2 <= counter2 + 1;
              rd <= 0;
          end else begin
      	      counter1 <= counter1 + 1;
          end
          //led[7:0] <= dout;
          new_byte <= dout;
        end
      end

      if (counter2 == 22) begin
        rd <= 0;
        counter2 <= 0;
        counter1 <= 0; 
        addr1 <= addr;       
      end
    end
    
    // fifo instantiation

    logic full;
    logic empty;
    logic [7:0] fifo_out;
    logic fifo_wr;
    
    logic fifo_rd;
    logic [10:0] data_count;

    logic [11:0] fifo_counter; //needs to count up to 2268

    fifo_generator_0 fifo (.clk(clk_100mhz), .srst(reset), .din(new_byte), .wr_en(fifo_wr), .rd_en(fifo_rd), .dout(fifo_out), .full(full), .empty(empty), .data_count(data_count));
      
    always_ff @(posedge clk_100mhz) begin
       if (reset) begin
         //fifo_wr <= 0;
         fifo_rd <= 0;
	       fifo_counter <= 0;
       end
       fifo_wr <= (dout == 0) ? 0 : byte_check;
       fifo_counter <= (fifo_counter == 2268 ? 0 : fifo_counter + 1);
       fifo_rd <= (fifo_counter == 2268 ? 1 : 0); 
    end

    // audio assignments

    logic PWM_out;

    audio_PWM audio (.clk(clk_100mhz), .reset(reset), .music_data(fifo_out), .PWM_out(PWM_out));

    assign aud_sd = 1'b1;
    assign aud_pwm = PWM_out ? 1'bZ : 1'b0;
    
endmodule
`default_nettype wire
