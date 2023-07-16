
module carry4(
  input   wire    [3:0]   p   ,
  input   wire    [3:0]   g   ,
  input   wire            cin ,
  output  wire    [3:1]   c   ,
  output  wire            P   ,
  output  wire            G   
);

  assign  {c[1]} = (cin & p[0]) | g[0] ;
  assign  {c[2]} = (cin & p[0] & p[1]) | (g[0] & p[1]) | g[1] ;
  assign  {c[3]} = (cin & p[0] & p[1] & p[2]) | (g[0] & p[1] & p[2]) | (g[1] & p[2]) | g[2] ;

  assign  P =  p[0] & p[1] & p[2] & p[3] ;
  assign  G = (g[0] & p[1] & p[2] & p[3]) | (g[1] & p[2] & p[3]) | (g[2] & p[3]) | g[3] ;

endmodule

module single_adder(
  input   wire  a   ,
  input   wire  b   ,
  input   wire  cin ,
  output  wire  s
);

  assign s = (a & b & cin) | (a & ~b & ~cin) | (~a & b & ~cin) | (~a & ~b & cin) ;

endmodule

