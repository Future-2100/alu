
module carry64(
  input   wire    [63:0]  p   ,
  input   wire    [63:0]  g   ,
  input   wire            cin ,
  output  wire    [63:0]  c   ,
  output  wire            P   ,
  output  wire            G   
);

  assign  c[0] = cin ;
  wire  [15:0]  P_1 ;
  wire  [15:0]  G_1 ;
  wire  [3:0]   P_2 ;
  wire  [3:0]   G_2 ;

  genvar i;
  generate
    for(i=0; i<16; i=i+1) begin
      carry4 carry4_inst(
        .p  (p[i*4+3:i*4]) ,
        .g  (g[i*4+3:i*4]) ,
        .cin(c[i*4]) ,
        .c  (c[i*4+3:i*4+1]) ,
        .P  (P_1[i]) ,
        .G  (G_1[i]) 
      );
    end
  endgenerate

  generate
    for(i=0; i<4; i=i+1) begin
      carry4 carry4_inst(
        .p  (P_1[i*4+3:i*4]) ,
        .g  (G_1[i*4+3:i*4]) ,
        .cin(c[i*16] ) ,
        .c  ({c[i*16+12],c[i*16+8],c[i*16+4]}) ,
        .P  (P_2[i]  ) ,
        .G  (G_2[i]  ) 
      );
    end
  endgenerate

  carry4 carry4_inst(
    .p  (P_2)  ,
    .g  (G_2)  ,
    .cin(c[0]) ,
    .c  ({c[48],c[32],c[16]})  ,
    .P  (P  )  ,
    .G  (G  )  
  );

endmodule

