module mem_bgm #(
    parameter ADDR_WIDTH = 10
) (
    input  wire clk,
    input  wire rstn,
    input  wire [ADDR_WIDTH-1:0] addr_in,
    output wire  [31:0] data_out
);

    integer i;
        
    localparam DEPTH = 600;
    reg [31:0] rom [0:DEPTH-1];
    
    initial begin
        rom[0] = {16'd659, 16'd107};
        rom[1] = {16'd0, 16'd35};
        rom[2] = {16'd659, 16'd107};
        rom[3] = {16'd0, 16'd178};
        rom[4] = {16'd659, 16'd107};
        rom[5] = {16'd0, 16'd178};
        rom[6] = {16'd523, 16'd107};
        rom[7] = {16'd0, 16'd35};
        rom[8] = {16'd659, 16'd106};
        rom[9] = {16'd0, 16'd179};
        rom[10] = {16'd784, 16'd106};
        rom[11] = {16'd0, 16'd1035};
        rom[12] = {16'd523, 16'd107};
        rom[13] = {16'd0, 16'd321};
        rom[14] = {16'd392, 16'd107};
        rom[15] = {16'd0, 16'd321};
        rom[16] = {16'd330, 16'd107};
        rom[17] = {16'd0, 16'd321};
        rom[18] = {16'd440, 16'd107};
        rom[19] = {16'd0, 16'd178};
        rom[20] = {16'd494, 16'd107};
        rom[21] = {16'd0, 16'd178};
        rom[22] = {16'd466, 16'd107};
        rom[23] = {16'd0, 16'd35};
        rom[24] = {16'd440, 16'd107};
        rom[25] = {16'd0, 16'd178};
        rom[26] = {16'd392, 16'd107};
        rom[27] = {16'd0, 16'd106};
        rom[28] = {16'd659, 16'd107};
        rom[29] = {16'd0, 16'd71};
        rom[30] = {16'd784, 16'd107};
        rom[31] = {16'd0, 16'd72};
        rom[32] = {16'd880, 16'd106};
        rom[33] = {16'd0, 16'd179};
        rom[34] = {16'd698, 16'd106};
        rom[35] = {16'd0, 16'd37};
        rom[36] = {16'd784, 16'd106};
        rom[37] = {16'd0, 16'd178};
        rom[38] = {16'd659, 16'd107};
        rom[39] = {16'd0, 16'd178};
        rom[40] = {16'd523, 16'd107};
        rom[41] = {16'd0, 16'd35};
        rom[42] = {16'd587, 16'd107};
        rom[43] = {16'd0, 16'd35};
        rom[44] = {16'd494, 16'd107};
        rom[45] = {16'd0, 16'd321};
        rom[46] = {16'd523, 16'd107};
        rom[47] = {16'd0, 16'd321};
        rom[48] = {16'd392, 16'd107};
        rom[49] = {16'd0, 16'd321};
        rom[50] = {16'd330, 16'd107};
        rom[51] = {16'd0, 16'd321};
        rom[52] = {16'd440, 16'd107};
        rom[53] = {16'd0, 16'd178};
        rom[54] = {16'd494, 16'd107};
        rom[55] = {16'd0, 16'd178};
        rom[56] = {16'd466, 16'd107};
        rom[57] = {16'd0, 16'd35};
        rom[58] = {16'd440, 16'd107};
        rom[59] = {16'd0, 16'd178};
        rom[60] = {16'd392, 16'd106};
        rom[61] = {16'd0, 16'd107};
        rom[62] = {16'd659, 16'd107};
        rom[63] = {16'd0, 16'd71};
        rom[64] = {16'd784, 16'd107};
        rom[65] = {16'd0, 16'd72};
        rom[66] = {16'd880, 16'd106};
        rom[67] = {16'd0, 16'd179};
        rom[68] = {16'd698, 16'd106};
        rom[69] = {16'd0, 16'd37};
        rom[70] = {16'd784, 16'd106};
        rom[71] = {16'd0, 16'd178};
        rom[72] = {16'd659, 16'd107};
        rom[73] = {16'd0, 16'd178};
        rom[74] = {16'd523, 16'd107};
        rom[75] = {16'd0, 16'd35};
        rom[76] = {16'd587, 16'd107};
        rom[77] = {16'd0, 16'd35};
        rom[78] = {16'd494, 16'd107};
        rom[79] = {16'd0, 16'd607};
        rom[80] = {16'd784, 16'd107};
        rom[81] = {16'd0, 16'd35};
        rom[82] = {16'd740, 16'd107};
        rom[83] = {16'd0, 16'd35};
        rom[84] = {16'd698, 16'd107};
        rom[85] = {16'd0, 16'd35};
        rom[86] = {16'd622, 16'd107};
        rom[87] = {16'd0, 16'd178};
        rom[88] = {16'd659, 16'd107};
        rom[89] = {16'd0, 16'd178};
        rom[90] = {16'd415, 16'd107};
        rom[91] = {16'd0, 16'd35};
        rom[92] = {16'd440, 16'd107};
        rom[93] = {16'd0, 16'd35};
        rom[94] = {16'd523, 16'd106};
        rom[95] = {16'd0, 16'd179};
        rom[96] = {16'd440, 16'd106};
        rom[97] = {16'd0, 16'd37};
        rom[98] = {16'd523, 16'd106};
        rom[99] = {16'd0, 16'd37};
        rom[100] = {16'd587, 16'd106};
        rom[101] = {16'd0, 16'd322};
        rom[102] = {16'd784, 16'd106};
        rom[103] = {16'd0, 16'd35};
        rom[104] = {16'd740, 16'd107};
        rom[105] = {16'd0, 16'd35};
        rom[106] = {16'd698, 16'd107};
        rom[107] = {16'd0, 16'd35};
        rom[108] = {16'd622, 16'd107};
        rom[109] = {16'd0, 16'd178};
        rom[110] = {16'd659, 16'd107};
        rom[111] = {16'd0, 16'd178};
        rom[112] = {16'd1047, 16'd107};
        rom[113] = {16'd0, 16'd178};
        rom[114] = {16'd1047, 16'd107};
        rom[115] = {16'd0, 16'd35};
        rom[116] = {16'd1047, 16'd107};
        rom[117] = {16'd0, 16'd750};
        rom[118] = {16'd784, 16'd107};
        rom[119] = {16'd0, 16'd35};
        rom[120] = {16'd740, 16'd107};
        rom[121] = {16'd0, 16'd35};
        rom[122] = {16'd698, 16'd107};
        rom[123] = {16'd0, 16'd35};
        rom[124] = {16'd622, 16'd107};
        rom[125] = {16'd0, 16'd178};
        rom[126] = {16'd659, 16'd107};
        rom[127] = {16'd0, 16'd178};
        rom[128] = {16'd415, 16'd107};
        rom[129] = {16'd0, 16'd35};
        rom[130] = {16'd440, 16'd107};
        rom[131] = {16'd0, 16'd35};
        rom[132] = {16'd523, 16'd106};
        rom[133] = {16'd0, 16'd179};
        rom[134] = {16'd440, 16'd106};
        rom[135] = {16'd0, 16'd37};
        rom[136] = {16'd523, 16'd106};
        rom[137] = {16'd0, 16'd37};
        rom[138] = {16'd587, 16'd106};
        rom[139] = {16'd0, 16'd322};
        rom[140] = {16'd622, 16'd106};
        rom[141] = {16'd0, 16'd321};
        rom[142] = {16'd587, 16'd107};
        rom[143] = {16'd0, 16'd321};
        rom[144] = {16'd523, 16'd107};
        rom[145] = {16'd0, 16'd1321};
        rom[146] = {16'd784, 16'd107};
        rom[147] = {16'd0, 16'd35};
        rom[148] = {16'd740, 16'd107};
        rom[149] = {16'd0, 16'd35};
        rom[150] = {16'd698, 16'd107};
        rom[151] = {16'd0, 16'd35};
        rom[152] = {16'd622, 16'd107};
        rom[153] = {16'd0, 16'd178};
        rom[154] = {16'd659, 16'd106};
        rom[155] = {16'd0, 16'd179};
        rom[156] = {16'd415, 16'd106};
        rom[157] = {16'd0, 16'd37};
        rom[158] = {16'd440, 16'd106};
        rom[159] = {16'd0, 16'd37};
        rom[160] = {16'd523, 16'd106};
        rom[161] = {16'd0, 16'd179};
        rom[162] = {16'd440, 16'd106};
        rom[163] = {16'd0, 16'd35};
        rom[164] = {16'd523, 16'd107};
        rom[165] = {16'd0, 16'd35};
        rom[166] = {16'd587, 16'd107};
        rom[167] = {16'd0, 16'd321};
        rom[168] = {16'd784, 16'd107};
        rom[169] = {16'd0, 16'd35};
        rom[170] = {16'd740, 16'd107};
        rom[171] = {16'd0, 16'd35};
        rom[172] = {16'd698, 16'd107};
        rom[173] = {16'd0, 16'd35};
        rom[174] = {16'd622, 16'd107};
        rom[175] = {16'd0, 16'd178};
        rom[176] = {16'd659, 16'd107};
        rom[177] = {16'd0, 16'd178};
        rom[178] = {16'd1047, 16'd107};
        rom[179] = {16'd0, 16'd178};
        rom[180] = {16'd1047, 16'd107};
        rom[181] = {16'd0, 16'd35};
        rom[182] = {16'd1047, 16'd107};
        rom[183] = {16'd0, 16'd750};
        rom[184] = {16'd784, 16'd107};
        rom[185] = {16'd0, 16'd35};
        rom[186] = {16'd740, 16'd106};
        rom[187] = {16'd0, 16'd37};
        rom[188] = {16'd698, 16'd107};
        rom[189] = {16'd0, 16'd35};
        rom[190] = {16'd622, 16'd106};
        rom[191] = {16'd0, 16'd179};
        rom[192] = {16'd659, 16'd106};
        rom[193] = {16'd0, 16'd179};
        rom[194] = {16'd415, 16'd106};
        rom[195] = {16'd0, 16'd37};
        rom[196] = {16'd440, 16'd106};
        rom[197] = {16'd0, 16'd37};
        rom[198] = {16'd523, 16'd106};
        rom[199] = {16'd0, 16'd178};
        rom[200] = {16'd440, 16'd107};
        rom[201] = {16'd0, 16'd35};
        rom[202] = {16'd523, 16'd107};
        rom[203] = {16'd0, 16'd35};
        rom[204] = {16'd587, 16'd107};
        rom[205] = {16'd0, 16'd321};
        rom[206] = {16'd622, 16'd107};
        rom[207] = {16'd0, 16'd321};
        rom[208] = {16'd587, 16'd107};
        rom[209] = {16'd0, 16'd321};
        rom[210] = {16'd523, 16'd107};
        rom[211] = {16'd0, 16'd1035};
        rom[212] = {16'd523, 16'd107};
        rom[213] = {16'd0, 16'd35};
        rom[214] = {16'd523, 16'd107};
        rom[215] = {16'd0, 16'd178};
        rom[216] = {16'd523, 16'd106};
        rom[217] = {16'd0, 16'd179};
        rom[218] = {16'd523, 16'd106};
        rom[219] = {16'd0, 16'd37};
        rom[220] = {16'd587, 16'd106};
        rom[221] = {16'd0, 16'd179};
        rom[222] = {16'd659, 16'd106};
        rom[223] = {16'd0, 16'd35};
        rom[224] = {16'd523, 16'd107};
        rom[225] = {16'd0, 16'd178};
        rom[226] = {16'd440, 16'd107};
        rom[227] = {16'd0, 16'd35};
        rom[228] = {16'd392, 16'd107};
        rom[229] = {16'd0, 16'd464};
        rom[230] = {16'd523, 16'd107};
        rom[231] = {16'd0, 16'd35};
        rom[232] = {16'd523, 16'd107};
        rom[233] = {16'd0, 16'd178};
        rom[234] = {16'd523, 16'd107};
        rom[235] = {16'd0, 16'd178};
        rom[236] = {16'd523, 16'd107};
        rom[237] = {16'd0, 16'd35};
        rom[238] = {16'd587, 16'd107};
        rom[239] = {16'd0, 16'd35};
        rom[240] = {16'd659, 16'd107};
        rom[241] = {16'd0, 16'd1178};
        rom[242] = {16'd523, 16'd106};
        rom[243] = {16'd0, 16'd37};
        rom[244] = {16'd523, 16'd106};
        rom[245] = {16'd0, 16'd179};
        rom[246] = {16'd523, 16'd106};
        rom[247] = {16'd0, 16'd179};
        rom[248] = {16'd523, 16'd106};
        rom[249] = {16'd0, 16'd35};
        rom[250] = {16'd587, 16'd107};
        rom[251] = {16'd0, 16'd178};
        rom[252] = {16'd659, 16'd107};
        rom[253] = {16'd0, 16'd35};
        rom[254] = {16'd523, 16'd107};
        rom[255] = {16'd0, 16'd178};
        rom[256] = {16'd440, 16'd107};
        rom[257] = {16'd0, 16'd35};
        rom[258] = {16'd392, 16'd107};
        rom[259] = {16'd0, 16'd464};
        rom[260] = {16'd659, 16'd107};
        rom[261] = {16'd0, 16'd35};
        rom[262] = {16'd659, 16'd107};
        rom[263] = {16'd0, 16'd178};
        rom[264] = {16'd659, 16'd107};
        rom[265] = {16'd0, 16'd178};
        rom[266] = {16'd523, 16'd107};
        rom[267] = {16'd0, 16'd35};
        rom[268] = {16'd659, 16'd107};
        rom[269] = {16'd0, 16'd178};
        rom[270] = {16'd784, 16'd107};
        rom[271] = {16'd0, 16'd1035};
        rom[272] = {16'd523, 16'd106};
        rom[273] = {16'd0, 16'd322};
        rom[274] = {16'd392, 16'd106};
        rom[275] = {16'd0, 16'd321};
        rom[276] = {16'd330, 16'd107};
        rom[277] = {16'd0, 16'd321};
        rom[278] = {16'd440, 16'd107};
        rom[279] = {16'd0, 16'd178};
        rom[280] = {16'd494, 16'd107};
        rom[281] = {16'd0, 16'd178};
        rom[282] = {16'd466, 16'd107};
        rom[283] = {16'd0, 16'd35};
        rom[284] = {16'd440, 16'd107};
        rom[285] = {16'd0, 16'd178};
        rom[286] = {16'd392, 16'd107};
        rom[287] = {16'd0, 16'd106};
        rom[288] = {16'd659, 16'd107};
        rom[289] = {16'd0, 16'd72};
        rom[290] = {16'd784, 16'd106};
        rom[291] = {16'd0, 16'd72};
        rom[292] = {16'd880, 16'd107};
        rom[293] = {16'd0, 16'd178};
        rom[294] = {16'd698, 16'd107};
        rom[295] = {16'd0, 16'd35};
        rom[296] = {16'd784, 16'd107};
        rom[297] = {16'd0, 16'd178};
        rom[298] = {16'd659, 16'd106};
        rom[299] = {16'd0, 16'd179};
        rom[300] = {16'd523, 16'd106};
        rom[301] = {16'd0, 16'd37};
        rom[302] = {16'd587, 16'd106};
        rom[303] = {16'd0, 16'd37};
        rom[304] = {16'd494, 16'd106};
        rom[305] = {16'd0, 16'd321};
        rom[306] = {16'd523, 16'd107};
        rom[307] = {16'd0, 16'd321};
        rom[308] = {16'd392, 16'd107};
        rom[309] = {16'd0, 16'd321};
        rom[310] = {16'd330, 16'd107};
        rom[311] = {16'd0, 16'd321};
        rom[312] = {16'd440, 16'd107};
        rom[313] = {16'd0, 16'd178};
        rom[314] = {16'd494, 16'd107};
        rom[315] = {16'd0, 16'd178};
        rom[316] = {16'd466, 16'd107};
        rom[317] = {16'd0, 16'd35};
        rom[318] = {16'd440, 16'd107};
        rom[319] = {16'd0, 16'd178};
        rom[320] = {16'd392, 16'd107};
        rom[321] = {16'd0, 16'd106};
        rom[322] = {16'd659, 16'd107};
        rom[323] = {16'd0, 16'd72};
        rom[324] = {16'd784, 16'd106};
        rom[325] = {16'd0, 16'd72};
        rom[326] = {16'd880, 16'd107};
        rom[327] = {16'd0, 16'd178};
        rom[328] = {16'd698, 16'd106};
        rom[329] = {16'd0, 16'd37};
        rom[330] = {16'd784, 16'd106};
        rom[331] = {16'd0, 16'd179};
        rom[332] = {16'd659, 16'd106};
        rom[333] = {16'd0, 16'd179};
        rom[334] = {16'd523, 16'd106};
        rom[335] = {16'd0, 16'd37};
        rom[336] = {16'd587, 16'd106};
        rom[337] = {16'd0, 16'd37};
        rom[338] = {16'd494, 16'd106};
        rom[339] = {16'd0, 16'd321};
        rom[340] = {16'd659, 16'd107};
        rom[341] = {16'd0, 16'd35};
        rom[342] = {16'd523, 16'd107};
        rom[343] = {16'd0, 16'd178};
        rom[344] = {16'd392, 16'd107};
        rom[345] = {16'd0, 16'd321};
        rom[346] = {16'd415, 16'd107};
        rom[347] = {16'd0, 16'd178};
        rom[348] = {16'd440, 16'd107};
        rom[349] = {16'd0, 16'd35};
        rom[350] = {16'd698, 16'd107};
        rom[351] = {16'd0, 16'd178};
        rom[352] = {16'd698, 16'd107};
        rom[353] = {16'd0, 16'd35};
        rom[354] = {16'd440, 16'd107};
        rom[355] = {16'd0, 16'd464};
        rom[356] = {16'd494, 16'd107};
        rom[357] = {16'd0, 16'd106};
        rom[358] = {16'd880, 16'd107};
        rom[359] = {16'd0, 16'd72};
        rom[360] = {16'd880, 16'd106};
        rom[361] = {16'd0, 16'd72};
        rom[362] = {16'd880, 16'd106};
        rom[363] = {16'd0, 16'd107};
        rom[364] = {16'd784, 16'd107};
        rom[365] = {16'd0, 16'd71};
        rom[366] = {16'd698, 16'd107};
        rom[367] = {16'd0, 16'd72};
        rom[368] = {16'd659, 16'd106};
        rom[369] = {16'd0, 16'd37};
        rom[370] = {16'd523, 16'd106};
        rom[371] = {16'd0, 16'd178};
        rom[372] = {16'd440, 16'd107};
        rom[373] = {16'd0, 16'd35};
        rom[374] = {16'd392, 16'd107};
        rom[375] = {16'd0, 16'd464};
        rom[376] = {16'd659, 16'd107};
        rom[377] = {16'd0, 16'd35};
        rom[378] = {16'd523, 16'd107};
        rom[379] = {16'd0, 16'd178};
        rom[380] = {16'd392, 16'd107};
        rom[381] = {16'd0, 16'd321};
        rom[382] = {16'd415, 16'd107};
        rom[383] = {16'd0, 16'd178};
        rom[384] = {16'd440, 16'd107};
        rom[385] = {16'd0, 16'd35};
        rom[386] = {16'd698, 16'd107};
        rom[387] = {16'd0, 16'd178};
        rom[388] = {16'd698, 16'd107};
        rom[389] = {16'd0, 16'd35};
        rom[390] = {16'd440, 16'd107};
        rom[391] = {16'd0, 16'd464};
        rom[392] = {16'd494, 16'd106};
        rom[393] = {16'd0, 16'd37};
        rom[394] = {16'd698, 16'd107};
        rom[395] = {16'd0, 16'd178};
        rom[396] = {16'd698, 16'd106};
        rom[397] = {16'd0, 16'd37};
        rom[398] = {16'd698, 16'd106};
        rom[399] = {16'd0, 16'd107};
        rom[400] = {16'd659, 16'd107};
        rom[401] = {16'd0, 16'd71};
        rom[402] = {16'd587, 16'd107};
        rom[403] = {16'd0, 16'd71};
        rom[404] = {16'd523, 16'd107};
        rom[405] = {16'd0, 16'd1035};
        rom[406] = {16'd659, 16'd107};
        rom[407] = {16'd0, 16'd35};
        rom[408] = {16'd523, 16'd107};
        rom[409] = {16'd0, 16'd178};
        rom[410] = {16'd392, 16'd107};
        rom[411] = {16'd0, 16'd321};
        rom[412] = {16'd415, 16'd107};
        rom[413] = {16'd0, 16'd178};
        rom[414] = {16'd440, 16'd107};
        rom[415] = {16'd0, 16'd35};
        rom[416] = {16'd698, 16'd107};
        rom[417] = {16'd0, 16'd178};
        rom[418] = {16'd698, 16'd107};
        rom[419] = {16'd0, 16'd35};
        rom[420] = {16'd440, 16'd107};
        rom[421] = {16'd0, 16'd464};
        rom[422] = {16'd494, 16'd106};
        rom[423] = {16'd0, 16'd107};
        rom[424] = {16'd880, 16'd107};
        rom[425] = {16'd0, 16'd71};
        rom[426] = {16'd880, 16'd107};
        rom[427] = {16'd0, 16'd72};
        rom[428] = {16'd880, 16'd106};
        rom[429] = {16'd0, 16'd107};
        rom[430] = {16'd784, 16'd107};
        rom[431] = {16'd0, 16'd71};
        rom[432] = {16'd698, 16'd107};
        rom[433] = {16'd0, 16'd71};
        rom[434] = {16'd659, 16'd107};
        rom[435] = {16'd0, 16'd35};
        rom[436] = {16'd523, 16'd107};
        rom[437] = {16'd0, 16'd178};
        rom[438] = {16'd440, 16'd107};
        rom[439] = {16'd0, 16'd35};
        rom[440] = {16'd392, 16'd107};
        rom[441] = {16'd0, 16'd464};
        rom[442] = {16'd659, 16'd107};
        rom[443] = {16'd0, 16'd35};
        rom[444] = {16'd523, 16'd107};
        rom[445] = {16'd0, 16'd178};
        rom[446] = {16'd392, 16'd107};
        rom[447] = {16'd0, 16'd321};
        rom[448] = {16'd415, 16'd107};
        rom[449] = {16'd0, 16'd178};
        rom[450] = {16'd440, 16'd107};
        rom[451] = {16'd0, 16'd35};
        rom[452] = {16'd698, 16'd106};
        rom[453] = {16'd0, 16'd179};
        rom[454] = {16'd698, 16'd106};
        rom[455] = {16'd0, 16'd37};
        rom[456] = {16'd440, 16'd106};
        rom[457] = {16'd0, 16'd465};
        rom[458] = {16'd494, 16'd106};
        rom[459] = {16'd0, 16'd35};
        rom[460] = {16'd698, 16'd107};
        rom[461] = {16'd0, 16'd178};
        rom[462] = {16'd698, 16'd107};
        rom[463] = {16'd0, 16'd35};
        rom[464] = {16'd698, 16'd107};
        rom[465] = {16'd0, 16'd107};
        rom[466] = {16'd659, 16'd107};
        rom[467] = {16'd0, 16'd71};
        rom[468] = {16'd587, 16'd107};
        rom[469] = {16'd0, 16'd71};
        rom[470] = {16'd523, 16'd107};
        rom[471] = {16'd0, 16'd1035};
        rom[472] = {16'd523, 16'd107};
        rom[473] = {16'd0, 16'd35};
        rom[474] = {16'd523, 16'd107};
        rom[475] = {16'd0, 16'd178};
        rom[476] = {16'd523, 16'd107};
        rom[477] = {16'd0, 16'd178};
        rom[478] = {16'd523, 16'd107};
        rom[479] = {16'd0, 16'd35};
        rom[480] = {16'd587, 16'd107};
        rom[481] = {16'd0, 16'd178};
        rom[482] = {16'd659, 16'd106};
        rom[483] = {16'd0, 16'd37};
        rom[484] = {16'd523, 16'd107};
        rom[485] = {16'd0, 16'd178};
        rom[486] = {16'd440, 16'd106};
        rom[487] = {16'd0, 16'd37};
        rom[488] = {16'd392, 16'd106};
        rom[489] = {16'd0, 16'd465};
        rom[490] = {16'd523, 16'd106};
        rom[491] = {16'd0, 16'd35};
        rom[492] = {16'd523, 16'd107};
        rom[493] = {16'd0, 16'd178};
        rom[494] = {16'd523, 16'd107};
        rom[495] = {16'd0, 16'd178};
        rom[496] = {16'd523, 16'd107};
        rom[497] = {16'd0, 16'd35};
        rom[498] = {16'd587, 16'd107};
        rom[499] = {16'd0, 16'd35};
        rom[500] = {16'd659, 16'd107};
        rom[501] = {16'd0, 16'd1178};
        rom[502] = {16'd523, 16'd107};
        rom[503] = {16'd0, 16'd35};
        rom[504] = {16'd523, 16'd107};
        rom[505] = {16'd0, 16'd178};
        rom[506] = {16'd523, 16'd107};
        rom[507] = {16'd0, 16'd178};
        rom[508] = {16'd523, 16'd106};
        rom[509] = {16'd0, 16'd37};
        rom[510] = {16'd587, 16'd106};
        rom[511] = {16'd0, 16'd179};
        rom[512] = {16'd659, 16'd106};
        rom[513] = {16'd0, 16'd37};
        rom[514] = {16'd523, 16'd106};
        rom[515] = {16'd0, 16'd179};
        rom[516] = {16'd440, 16'd106};
        rom[517] = {16'd0, 16'd35};
        rom[518] = {16'd392, 16'd107};
        rom[519] = {16'd0, 16'd464};
        rom[520] = {16'd659, 16'd107};
        rom[521] = {16'd0, 16'd35};
        rom[522] = {16'd659, 16'd107};
        rom[523] = {16'd0, 16'd178};
        rom[524] = {16'd659, 16'd107};
        rom[525] = {16'd0, 16'd178};
        rom[526] = {16'd523, 16'd107};
        rom[527] = {16'd0, 16'd35};
        rom[528] = {16'd659, 16'd107};
        rom[529] = {16'd0, 16'd178};
        rom[530] = {16'd784, 16'd107};
        rom[531] = {16'd0, 16'd1035};
        rom[532] = {16'd659, 16'd107};
        rom[533] = {16'd0, 16'd35};
        rom[534] = {16'd523, 16'd106};
        rom[535] = {16'd0, 16'd179};
        rom[536] = {16'd392, 16'd106};
        rom[537] = {16'd0, 16'd322};
        rom[538] = {16'd415, 16'd106};
        rom[539] = {16'd0, 16'd179};
        rom[540] = {16'd440, 16'd106};
        rom[541] = {16'd0, 16'd35};
        rom[542] = {16'd698, 16'd107};
        rom[543] = {16'd0, 16'd178};
        rom[544] = {16'd698, 16'd107};
        rom[545] = {16'd0, 16'd35};
        rom[546] = {16'd440, 16'd107};
        rom[547] = {16'd0, 16'd464};
        rom[548] = {16'd494, 16'd107};
        rom[549] = {16'd0, 16'd107};
        rom[550] = {16'd880, 16'd106};
        rom[551] = {16'd0, 16'd72};
        rom[552] = {16'd880, 16'd107};
        rom[553] = {16'd0, 16'd71};
        rom[554] = {16'd880, 16'd107};
        rom[555] = {16'd0, 16'd107};
        rom[556] = {16'd784, 16'd106};
        rom[557] = {16'd0, 16'd72};
        rom[558] = {16'd698, 16'd107};
        rom[559] = {16'd0, 16'd71};
        rom[560] = {16'd659, 16'd107};
        rom[561] = {16'd0, 16'd35};
        rom[562] = {16'd523, 16'd107};
        rom[563] = {16'd0, 16'd178};
        rom[564] = {16'd440, 16'd107};
        rom[565] = {16'd0, 16'd35};
        rom[566] = {16'd392, 16'd107};
        rom[567] = {16'd0, 16'd464};
        rom[568] = {16'd659, 16'd107};
        rom[569] = {16'd0, 16'd35};
        rom[570] = {16'd523, 16'd107};
        rom[571] = {16'd0, 16'd178};
        rom[572] = {16'd392, 16'd106};
        rom[573] = {16'd0, 16'd322};
        rom[574] = {16'd415, 16'd106};
        rom[575] = {16'd0, 16'd178};
        rom[576] = {16'd440, 16'd107};
        rom[577] = {16'd0, 16'd35};
        rom[578] = {16'd698, 16'd107};
        rom[579] = {16'd0, 16'd178};
        rom[580] = {16'd698, 16'd107};
        rom[581] = {16'd0, 16'd35};
        rom[582] = {16'd440, 16'd107};
        rom[583] = {16'd0, 16'd464};
        rom[584] = {16'd494, 16'd107};
        rom[585] = {16'd0, 16'd35};
        rom[586] = {16'd698, 16'd107};
        rom[587] = {16'd0, 16'd178};
        rom[588] = {16'd698, 16'd107};
        rom[589] = {16'd0, 16'd35};
        rom[590] = {16'd698, 16'd107};
        rom[591] = {16'd0, 16'd107};
        rom[592] = {16'd659, 16'd106};
        rom[593] = {16'd0, 16'd72};
        rom[594] = {16'd587, 16'd106};
        rom[595] = {16'd0, 16'd72};
        rom[596] = {16'd0, 16'd0};
    end
        
    assign data_out = rstn ? rom[addr_in] : 32'd0;
endmodule

module mem_sfx_item #(
    parameter ADDR_WIDTH = 8
) (
    input  wire clk,
    input  wire rstn,
    input  wire [ADDR_WIDTH-1:0] addr_in,
    output wire  [31:0] data_out
);

    integer i;
        
    localparam DEPTH = 180;
    reg [31:0] rom [0:DEPTH-1];
    
    initial begin
        rom[0] = {16'd988,  16'd60};
        rom[1] = {16'd1319, 16'd60};
        rom[3] = {16'd0,    16'd30};
    end
    
    assign data_out = rstn ? rom[addr_in] : 32'd0;

endmodule

module mem_sfx_debuf #(
    parameter ADDR_WIDTH = 8
) (
    input  wire clk,
    input  wire rstn,
    input  wire [ADDR_WIDTH-1:0] addr_in,
    output wire  [31:0] data_out
);

    integer i;
        
    localparam DEPTH = 180;
    reg [31:0] rom [0:DEPTH-1];
    initial begin
        rom[0] = {16'd330,  16'd60};
        rom[1] = {16'd220, 16'd60};
        rom[2] = {16'd110, 16'd60};
        rom[3] = {16'd0,    16'd30};
    end
    
    assign data_out = rstn ? rom[addr_in] : 32'd0;

endmodule

module mem_jump #(
    parameter ADDR_WIDTH = 8
) (
    input  wire clk,
    input  wire rstn,
    input  wire [ADDR_WIDTH-1:0] addr_in,
    output wire  [31:0] data_out
);

    integer i;
        
    localparam DEPTH = 180;
    reg [31:0] rom [0:DEPTH-1];
    
    initial begin
        rom[0] = {16'd330, 16'd50};
        rom[1] = {16'd370, 16'd50};
        rom[2] = {16'd415, 16'd50};
        rom[3] = {16'd466, 16'd50};
        rom[4] = {16'd523, 16'd50};
        rom[5] = {16'd587, 16'd50};
    end
    
    assign data_out = rstn ? rom[addr_in] : 32'd0;

endmodule

module piezo_player #(
    parameter integer CLK_FREQ   = 500000000,
    parameter integer ADDR_WIDTH = 10
)(
    input  wire clk,
    input  wire rstn,

    output reg  [ADDR_WIDTH-1:0] mem_addr,
    input  wire [31:0] mem_data_in,

    output reg piezo_out
);

    wire [15:0] freq_hz     = mem_data_in[31:16];
    wire [15:0] duration_ms = mem_data_in[15:0];

    // ----------------- ms tick generator ----------------
    localparam integer CLK_PER_MS = CLK_FREQ / 1000;

    reg [31:0] ms_div;
    reg        ms_tick;

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            ms_div  <= 0;
            ms_tick <= 0;
        end else begin
            if (ms_div >= CLK_PER_MS-1) begin
                ms_div  <= 0;
                ms_tick <= 1;
            end else begin
                ms_div  <= ms_div + 1;
                ms_tick <= 0;
            end
        end
    end

    // ---------------- tone generator ---------------------
    reg [31:0] half_period;
    reg [31:0] tone_cnt;
    reg        tone_sq;

    always @(*) begin
        if (freq_hz == 0)
            half_period = 32'd0;
        else
            half_period = CLK_FREQ / (freq_hz * 2);
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            tone_cnt  <= 0;
            tone_sq   <= 0;
            piezo_out <= 0;
        end else begin
            if (half_period == 0) begin
                tone_cnt  <= 0;
                tone_sq   <= 0;
                piezo_out <= 0;
            end else begin
                if (tone_cnt >= half_period - 1) begin
                    tone_cnt <= 0;
                    tone_sq  <= ~tone_sq;
                end else begin
                    tone_cnt <= tone_cnt + 1;
                end

                piezo_out <= tone_sq;
            end
        end
    end

    // ---------------- duration / mem_addr control --------
    reg [31:0] dur_cnt;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            dur_cnt  <= 0;
            mem_addr <= 0;
        end else begin
            if (!duration_ms) begin
                dur_cnt  <= 0;
                mem_addr <= 0;
            end else if (ms_tick) begin
                if (dur_cnt >= duration_ms) begin
                    mem_addr <= mem_addr + 1;
                    dur_cnt  <= 0;
                end else begin
                    dur_cnt <= dur_cnt + 1;
                end
            end
        end
    end

endmodule


module bgm #(
    parameter integer CLK_FREQ   = 50000000,
    parameter integer ADDR_WIDTH = 10
)(
    input wire clk,
    input wire play,
    output wire piezo
);

    wire [ADDR_WIDTH-1:0] bram_addr;
    wire [31:0] bram_data;
    reg rstn = 0;

    mem_bgm #(.ADDR_WIDTH(ADDR_WIDTH)) mem_if (
        .clk(clk),
        .rstn(rstn),
        .addr_in(bram_addr),
        .data_out(bram_data)
    );

    piezo_player #(
        .CLK_FREQ(CLK_FREQ),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) player (
        .clk(clk),
        .rstn(rstn),
        .mem_addr(bram_addr),
        .mem_data_in(bram_data),
        .piezo_out(piezo)
    );

    always @(*) begin
        rstn <= play;
    end

endmodule

module sfx_item #(
    parameter integer CLK_FREQ   = 50000000,
    parameter integer ADDR_WIDTH = 8
)(
    input wire clk,
    input wire play,
    output wire piezo
);

    wire [ADDR_WIDTH-1:0] bram_addr;
    wire [31:0] bram_data;
    reg rstn = 0;

    mem_sfx_item #(.ADDR_WIDTH(ADDR_WIDTH)) mem_if (
        .clk(clk),
        .rstn(rstn),
        .addr_in(bram_addr),
        .data_out(bram_data)
    );

    piezo_player #(
        .CLK_FREQ(CLK_FREQ),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) player (
        .clk(clk),
        .rstn(rstn),
        .mem_addr(bram_addr),
        .mem_data_in(bram_data),
        .piezo_out(piezo)
    );

    always @(*) begin
        rstn <= play;
    end

endmodule

module sfx_debuf #(
    parameter integer CLK_FREQ   = 50000000,
    parameter integer ADDR_WIDTH = 8
)(
    input wire clk,
    input wire play,
    output wire piezo
);

    wire [ADDR_WIDTH-1:0] bram_addr;
    wire [31:0] bram_data;
    reg rstn = 0;

    mem_sfx_debuf #(.ADDR_WIDTH(ADDR_WIDTH)) mem_if (
        .clk(clk),
        .rstn(rstn),
        .addr_in(bram_addr),
        .data_out(bram_data)
    );

    piezo_player #(
        .CLK_FREQ(CLK_FREQ),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) player (
        .clk(clk),
        .rstn(rstn),
        .mem_addr(bram_addr),
        .mem_data_in(bram_data),
        .piezo_out(piezo)
    );

    always @(*) begin
        rstn <= play;
    end

endmodule

module sfx_jump #(
    parameter integer CLK_FREQ   = 50000000,
    parameter integer ADDR_WIDTH = 8
)(
    input wire clk,
    input wire play,
    output wire piezo
);

    wire [ADDR_WIDTH-1:0] bram_addr;
    wire [31:0] bram_data;
    reg rstn = 0;

    mem_jump #(.ADDR_WIDTH(ADDR_WIDTH)) mem_if (
        .clk(clk),
        .rstn(rstn),
        .addr_in(bram_addr),
        .data_out(bram_data)
    );

    piezo_player #(
        .CLK_FREQ(CLK_FREQ),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) player (
        .clk(clk),
        .rstn(rstn),
        .mem_addr(bram_addr),
        .mem_data_in(bram_data),
        .piezo_out(piezo)
    );

    always @(*) begin
        rstn <= play;
    end

endmodule

module audio #(
    parameter integer CLK_FREQ   = 50000000,
    parameter integer ADDR_WIDTH = 8
)(
    input wire clk,
    input wire [3:0] state, // [bgm, item, debuf, jump]
    output wire piezo
);

    wire music;
    bgm #(CLK_FREQ) b1(.clk(clk), .play(state[3]), .piezo(music));
    
    wire out1;
    wire item_p;
    pulse_stretch #(CLK_FREQ, 180) p1(clk, state[2], item_p);
    sfx_item #(CLK_FREQ) b2(.clk(clk), .play(item_p), .piezo(out1));
    
    wire out2;
    wire debuff_p;
    pulse_stretch #(CLK_FREQ, 180) p2(clk, state[1], debuff_p);
    sfx_debuf #(CLK_FREQ) b3(.clk(clk), .play(debuff_p), .piezo(out2));
    
    wire out3;
    sfx_jump #(CLK_FREQ) b4(.clk(clk), .play(state[0]), .piezo(out3));
    
    wire sfx;
    assign sfx = out1 | out2 | out3;
    assign piezo = sfx ? sfx : music;
endmodule
