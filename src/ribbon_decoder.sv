
`timescale 1ns / 1ps
`default_nettype none

module ribbon_decoder(
  input wire clk,
  input wire rst,
  input wire d_out,

  output logic clk2,
  output logic d_in,
  output logic cs,
  output logic [7:0] val_out

  );

  always_ff @(posedge clk) begin
    if (clk_count == 499) begin
      clk_count <= 0;
      clk2 <= ~clk2;
    end else begin
      clk_count <= clk_count + 1;
    end
  end

  // send on falling edge, read on rising edge;

  logic [9:0] count;
  logic [9:0] d_count;
  logic [9:0] clk_count;
  logic [9:0] val;
  logic [4:0] d_in_all = 5'b10011;
  logic [2:0] state;
  logic last_clk2;


  //sending signals

  always_ff @(posedge clk) begin

    if (rst) begin
      cs <= 1;
      count <= 0;
      d_count <= 0;
      state <= 0;
    end

    else if ((last_clk2 == 1) && (clk2 == 0)) begin // falling edge

      if (count < 5) begin
        cs <= 0;
        d_in <= d_in_all[count];
      end

      if (count == 20) begin
        count <= 0;
        cs <= 1;
      end else begin
        count <= count + 1;
      end

    end


  //receiving signals

    else if ((last_clk2 == 0) && (clk2 == 1)) begin //rising edge
  
      if (state == 0) begin
        if (d_out == 0) state <= 1;
        d_count <= 0;
      end

      else if (state == 1) begin
        if (d_count < 10) begin
          val[9-d_count] <= d_out;
          d_count <= d_count + 1;
        end

        if (count == 20) begin
          state <= 0;

          if (val < 85) begin
            val_out <= 0;
          end else if (val < 171) begin
            val_out <= 1;
          end else if (val < 256) begin
            val_out <= 2;
          end else if (val < 341) begin
            val_out <= 3;
          end else if (val < 427) begin
            val_out <= 4;
          end else if (val < 512) begin
            val_out <= 5;
          end else if (val < 597) begin
            val_out <= 6;
          end else if (val < 683) begin
            val_out <= 7;
          end else if (val < 768) begin
            val_out <= 8;
          end else if (val < 853) begin
            val_out <= 9;
          end else if (val < 939) begin
            val_out <= 10;
          end else begin
            val_out <= 11;
          end


        end
      end

    end

    last_clk2 <= clk2;

  end
  

endmodule




`default_nettype wire