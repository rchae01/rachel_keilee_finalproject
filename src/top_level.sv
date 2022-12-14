`timescale 1ns / 1ps
`default_nettype none

module top_level(
  input wire clk, //clock @ 100 mhz
  input wire btnc, //btnc (used for reset)
  input wire btnu,
  input wire btnr,
  input wire d_out,
  input wire [15:0] sw,

  input wire ps2_clk,
  input wire ps2_data,



  input wire sd_cd,
  inout wire [3:0] sd_dat,

  output logic sd_reset,
  output logic sd_sck,
  output logic sd_cmd,

  output logic aud_pwm,
  output logic aud_sd,



  output logic d_in,
  output logic cs,
  output logic clk2,

  output logic [15:0] led, //just here for the funs

  output logic ca, cb, cc, cd, ce, cf, cg,
  output logic [7:0] an

  );


  logic [7:0] r_val;

  logic [1:0] ps2b_c;
  logic [1:0] ps2b_d;
  logic [7:0] ps2_code;
  logic ps2_valid;
  logic [7:0] k_val;

  logic [7:0] r_val_s;
  logic r_valid;

  logic [31:0] addr;
  logic [31:0] addr_send;

  logic [31:0] count_time;

  logic [11:0] counter2;
  logic [11:0] counter1;



  always_ff @(posedge clk)begin
    ps2b_c[0] <= ps2_clk;
    ps2b_d[0] <= ps2_data;
    ps2b_c[1] <= ps2b_c[0];
    ps2b_d[1] <= ps2b_d[0];
  end

  ribbon_decoder2 r_decoder(.clk(clk),
                            .rst(btnc),
                            .d_out(d_out),
                            .clk2(clk2),
                            .d_in(d_in),
                            .cs(cs),
                            .val_out(r_val));

  ribbon_stabilizer r_stabilizer(.clk(clk2),
                                  .rst(btnc),
                                  .r_val(r_val),
                                  .r_val_s(r_val_s));

  ps2_decoder k_decoder(.clk_in(clk),
                            .rst_in(btnc),
                            .ps_data_in(ps2b_d[1]),
                            .ps_clk_in(ps2b_c[1]),
                            .code_out(ps2_code),
                            .code_valid_out(ps2_valid));

  always_ff @(posedge clk) begin
    if (btnc) begin
      k_val <= 0;
      count_time <= 0;
    end

    else if ((ps2_valid) && (ps2_code != 8'hF0)) begin
      k_val <= ps2_code;
    end
  end


  note_selector n_selector(.clk(clk),
                            .rst(btnc),
                            .r_val(r_val_s),
                            .k_val(k_val),
                            .addr(addr));
  
  logic [31:0] gap;

  /*
  always_ff @(posedge clk) begin
    if (sw == 0) begin
      gap <= 0;
    end else if (sw == 1) begin
      gap <= 11264;
    end

    led[15:8] = gap;
  end
  */

  sd_reader2 sd(.clk_100mhz(clk),
                .sd_cd(sd_cd),
                .btnr(btnr),
                .addr(addr),
                .sw(sw[15:0]),
                .sd_dat(sd_dat),
                .led(led[7:0]),
                .sd_reset(sd_reset),
                .sd_sck(sd_sck),
                .sd_cmd(sd_cmd),
                .aud_sd(aud_sd),
                .aud_pwm(aud_pwm),
                .counter2(counter2),
                .counter1(counter1));

  logic [31:0] stuff;

  always_comb begin
    if (btnu)begin
      stuff = {counter1, counter2};
    end else begin
      stuff = addr;
    end
  end

  seven_segment_controller mssc(.clk_in(clk),
                                 .rst_in(btnc),
                                 .val_in(stuff),
                                 .cat_out({cg, cf, ce, cd, cc, cb, ca}),
                                 .an_out(an));





endmodule




`default_nettype wire
