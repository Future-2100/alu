module alu(
  input   wire  [63:0]    in1       ,
  input   wire  [63:0]    in2       ,
  input   wire  [2:0]     op        ,
  input   wire            in_valid  ,
  output  wire            in_ready  ,

  output  reg   [63:0]    res       ,
  output  reg             out_valid ,
  input   wire            out_ready ,
  input   wire            clk       ,
  input   wire            rstn      
);

  parameter  OP_ADD = 3'b000;
  parameter  OP_SUB = 3'b001;
  parameter  OP_XOR = 3'b010;

  parameter  OP_AND = 3'b110;
  parameter  OP_OR  = 3'b111;


  wire  [63:0]  adder_in1 = in1;
  wire  [63:0]  adder_in2 = ( op==OP_SUB ) ? (~in2) : in2;
  wire          cin = (op==OP_SUB);

  wire  [63:0]  p  =  adder_in1 | adder_in2 ;
  wire  [63:0]  g  =  adder_in1 & adder_in2 ;

  wire  [63:0]  c;
  wire  [63:0]  sum;

  carry64 carry64_inst(
    .p  (p),
    .g  (g),
    .cin(cin),
    .c  (c),
    .P  ( ),
    .G  ( )
  );

  wire  [63:0]  carry_in =  (op[2:1]==2'b01) ? 64'b0 : c ;

  genvar i;
  generate
    for(i=0; i<64; i=i+1) begin
      single_adder single_adder_inst(
        .a  (adder_in1[i]),
        .b  (adder_in2[i]),
        .cin(carry_in[i] ),
        .s  (sum[i]      )
      );
    end
  endgenerate

  wire  [63:0]  result = ( {64{(op[2]==1'b0)}} & sum )  |
                         ( {64{(op==OP_AND )}} & g   )  |
                         ( {64{(op==OP_OR  )}} & p   )  ;

  always@(posedge clk) begin
    if(!rstn)
      res <= 64'b0;
    else if(in_valid && in_ready)
      res <= result;
  end

  always@(posedge clk) begin
    if(!rstn)
      out_valid <= 1'b0;
    else if(in_valid && in_ready)
      out_valid <= 1'b1;
    else if(out_valid && out_ready)
      out_valid <= 1'b0;
  end

  assign in_ready = ~(out_valid & !out_ready) ;

endmodule



