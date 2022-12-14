
`timescale 1ns / 1ps
`default_nettype none

module note_selector(
  input wire clk,
  input wire rst,
  input wire [7:0] r_val, //ribbon
  input wire [7:0] k_val, //keybard

  output logic [23:0] addr

  );


  always_ff @(posedge clk) begin

    if (rst) begin
      addr <= 32'h00_002C00;
    end

    else if (r_val == 0) begin
      addr <= 32'h00_002C00;
    end 

    else begin
      if (k_val == 8'h3C) begin //a
        addr <= 32'h00_002C00 + (r_val * 11264);
      end

      else if (k_val == 8'h3B) begin //am
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168);
      end

      else if (k_val == 8'h3A) begin //a7
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 2);
      end

      else if (k_val == 8'h44) begin //b
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 3);
      end

      else if (k_val == 8'h4B) begin //bm
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 4);
      end

      else if (k_val == 8'h49) begin //b7
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 5);
      end

      else if (k_val == 8'h1D) begin //bb
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 6);
      end

      else if (k_val == 8'h1B) begin //bbm
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 7);
      end

      else if (k_val == 8'h22) begin //bb7
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 8);
      end

      else if (k_val == 8'h2D) begin //c
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 9);
      end

      else if (k_val == 8'h2B) begin //cm
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 10);
      end

      else if (k_val == 8'h2A) begin //c7
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 11);
      end

      else if (k_val == 8'h35) begin //d
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 12);
      end

      else if (k_val == 8'h33) begin //dm
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 13);
      end

      else if (k_val == 8'h31) begin //d7
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 14);
      end

      else if (k_val == 8'h43) begin //e
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 15);
      end

      else if (k_val == 8'h42) begin //em
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 16);
      end

      else if (k_val == 8'h41) begin //e7
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 17);
      end

      else if (k_val == 8'h15) begin //eb
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 18);
      end

      else if (k_val == 8'h1C) begin //ebm
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 19);
      end

      else if (k_val == 8'h1A) begin //eb7
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 20);
      end

      else if (k_val == 8'h24) begin //f
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 21);
      end

      else if (k_val == 8'h23) begin //fm
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 22);
      end

      else if (k_val == 8'h21) begin //f7
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 23);
      end

      else if (k_val == 8'h2C) begin //g
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 24);
      end

      else if (k_val == 8'h34) begin //gm
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 25);
      end

      else if (k_val == 8'h32) begin //g7
        addr <= 32'h00_002C00 + (r_val * 11264) + (135168 * 26);
      end


    end

  end
  

endmodule




`default_nettype wire