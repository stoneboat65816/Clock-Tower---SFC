org $F00000
transfer_font:
	LDA #$C0DF
	LDX #$BE43
	JSL $818024
	LDA #$C030
	LDX #$4243
	JSL $818024
	PHB
	LDA #$29B0
	LDX #$0000
	LDY #$4243
	MVN $F1, $7F
	PLB
	RTL
	
txt_shori:
	JSR clear_tairyoku
	LDA #$FF
	STA {text_flag}
	LDA $6D00,x		//read txt
	CMP #$FF
	BNE +
	JML $C027B7
+
	CMP #$20
	BCS +
	JMP _5
+
	CMP #$FE
	BNE +
	JMP line_shori
+
    CMP #$FD
    BNE +
    JSR clear_tileset
    INX
+
	REP #$20
	LDA $6D00,x
	JSR _27FB
	STA {save_a}
	PHX
	TAX
	LDA width_table,x
	AND #$00FF
	STA {width}
	PLX
	LDA #$7F00
	STA $7E0011
	PHX
	LDX $66
	LDA #$6A50		//tileset buffer
	STA $0211
	LDA {save_a}
	ASL #6
	CLC 
	ADC #$4243
	STA $7E0010
	PHY
	JSR draw_tile
	PLY
	LDX $6E
	LDA $7F0213		//tile size
	AND #$00FF
	CMP #$0040
	BCC +
	LDA $000CEE
	STA $6B10,x
	INC
	STA $6B50,x
	INC
	STA $6B12,x
	INC
	STA $6B52,x
	LDA $000CEE
	CLC
	ADC #$0002
	STA $000CEE
	INX #2
	STX $6E
	BRA _2
+
	LDA $000CEE
	STA $6B10,x
	INC
	STA $6B50,x
_2:
	PLX
	LDA $66
	CLC
	ADC #$0004
	STA $66
	TXA
	INC
	STA $023F
	SEP #$20
	INC $64
	LDA $64
	CMP #$01
	BCS +
_5:
	INX
	JMP txt_shori
	LDA #$03
	STA $0140
+
	LDX $66
	REP #$20
	STZ $0211,x
	PLB
	LDA $6E
	STA $0CF0
	LDA $64
	BEQ +
	LDA $0CEA
	STA $0CEC
	LDA $7F6A34		//tile num
	ASL #3
	CLC
	ADC #$6400
	CLC
	ADC $7F6A36		//base line
	STA $0CEA
	STA $0CEC
	JML $C027DF
+
	JML $C0260C
	
_27FB:
	STA $6C
	AND #$00FF
	SEC
	SBC #$0020
	RTS
	
clear_buffer:
	PHB
	PHP
	PHX
	REP #$30
	PEA $7F7F
	PLB #2
	LDX #$0000
-
	STZ $6A30,x
	INX #2
	CPX #$0600
	BNE -
	LDA #$0000
	STA $7E0010
	PLX
	PLP
	PLB
	RTS
	
draw_tile:
	PHY
	PHX
	PHP
	LDA {shift}
	BEQ new_tile
	CMP #$0008
	BCC draw
	TAX
	AND #$0007
	STA {shift}
	TXA
	LSR
	LSR
	LSR
	TAY
	TXA
	AND #$00F8
	ASL
	ASL
	TAX
	DEX
	DEX
_1:
	PHY
	LDY #$0010
-	
	LDA $6A70,x
	STA $6A50,x
	DEX
	DEX
	DEY
	BNE -
	JSR update_tile_num
	LDA {fixed_dma_vram}
	CLC
	ADC #$0010
	STA {fixed_dma_vram}
	PLY
	DEY
	BNE _1
	LDX #$0000
	LDY #$0010
-	
	STZ $6A70,x
	STZ $6A90,x
	STZ $6AB0,x
	STZ $6AD0,x
	STZ $6AF0,x
	INX #2
	DEY
	BNE -
	BRA draw	
new_tile:
	LDX #$0000
	LDY #$0010
-
	STZ $6A50,x
	STZ $6A70,x
	STZ $6A90,x
	STZ $6AB0,x
	STZ $6AD0,x
	STZ $6AF0,x
	INX
	INX
	DEY
	BNE -
draw:
	LDA {shift}
	AND #$00F8
	ASL
	ASL
	STA {save_x}
	TAX
	LDY #$0000
-
	LDA [$10],y
	BEQ +
	JSR shift_pixel
	LDA $6A50,x
	ORA {left_byte}
	STA $6A50,x
	LDA $6A70,x
	ORA {right_byte}
	STA $6A70,x
+
	INX #2
	INY #2
	CPY #$0010
	BNE -
	LDX {save_x}
-
	LDA [$10],y
	BEQ +
	JSR shift_pixel
	LDA $6A60,x
	ORA {left_byte}
	STA $6A60,x
	LDA $6A80,x
	ORA {right_byte}
	STA $6A80,x
+
	INX #2
	INY #2
	CPY #$0020
	BNE -	
	LDX {save_x}
-
	LDA [$10],y
	JSR shift_pixel
	LDA $6A70,x
	ORA {left_byte}
	STA $6A70,x
	LDA $6A90,x
	ORA {right_byte}
	STA $6A90,x
	INX
	INX
	INY
	INY
	CPY #$0030
	BNE -	
	LDX {save_x}
-
	LDA [$10],y
	JSR shift_pixel
	LDA $6A80,x
	ORA {left_byte}
	STA $6A80,x
	LDA $6AA0,x
	ORA {right_byte}
	STA $6AA0,x
	INX
	INX
	INY
	INY
	CPY #$0040
	BNE -	
	LDA {width}
	CLC
	ADC {shift}
	STA {shift}
	AND #$00F8
	ASL #2
	CLC
	ADC #$0020
	PHX
	LDX $66
	STA $0213
	PLX
+	
	PLP
	PLX
	PLY
	RTS
	
shift_pixel:
	PHX
	PHA
	XBA
	AND #$FF00
	STA {buffer1}
	PLA
	AND #$FF00
	STA {buffer2}
	LDA {shift}
	AND #$0007
	TAX
	BEQ +
-
	LSR {buffer1}
	LSR {buffer2}
	DEX
	BNE -
+
	LDA {buffer1}
	XBA
	AND #$00FF
	STA {left_byte}
	LDA {buffer2}
	AND #$FF00
	ORA {left_byte}
	STA {left_byte}
	LDA {buffer1}
	AND #$00FF
	STA {right_byte}
	LDA {buffer2}
	XBA
	AND #$FF00
	ORA {right_byte}
	STA {right_byte}
	PLX
	RTS
	
update_tile_num:
	LDA {tile_num}
	INC #2
	STA {tile_num}
	RTS
	
line_shori:
	REP #$20
	INC {line}
	STZ {shift}
	STZ {width}
	STZ {tile_num}
	LDA {base_line}
	CLC
	ADC #$0200
	STA {base_line}
	LDA {line}
	ASL #7
	STA $6E
	LDA #$2EC0
	STA $000CEE
	LDA {line}
	ASL #7
//	STA $000CF2
	LDA {line}
	ASL #6
	CLC
//	ADC #$7F66
//	STA $000CF4
	SEP #$20
	INX
	JMP txt_shori
	
nmi_map_dma:
	REP #$20
	LDA {map_dma_flag}
	BNE +
	SEP #$20
	LDA $C2
	ROR #2
	REP #$20
	JML $80D29B
+
	SEP #$20
	LDA #$81
	STA $2115	
	REP #$20
	LDA #$0000
	STA {map_dma_flag}
	LDA $0CF4
	STA $2116
	LDX $0CF2
	LDA $7F6B10,x
	STA $2118
	LDA $7F6B50,x
	STA $2118
	LDA $7F0213
	CMP #$0040
	BCC +	
	LDA $0CF4
	INC
	STA $2116
	LDA $7F6B12,x
	STA $2118
	LDA $7F6B52,x
	STA $2118
	INX #2
	STX $0CF2
	LDA $0CF4
	INC
	STA $0CF4
+
	SEP #$20
	LDA $C2
	ROR #2
	REP #$20
	JML $80D29B
	
rewrite_map_dma:
	LDA $0CF4
	STA $2116
	LDA {map_dma_flag}
	BNE +
	JML $C029CF
+
	LDA #$0000
	STA {map_dma_flag}
	SEP #$20
	LDA #$81
	STA $2115
	REP #$20
	LDA $0CF4
	STA $2116
	LDX $0CF2
	LDA $7F6B10,x
	STA $2118
	LDA $7F6B50,x
	STA $2118
	LDA $7F0213
	CMP #$0040
	BCC +	
	LDA $0CF4
	INC
	STA $2116
	LDA $7F6B12,x
	STA $2118
	LDA $7F6B52,x
	STA $2118
	INX #2
	STX $0CF2
	LDA $0CF4
	INC
	STA $0CF4
+
	JML $C02A31
	
dma_opening:
	CPX #$0D37
	BEQ +
	REP #$20
	STZ $0133
	STZ $0135
	STZ $0137
	JML $C035E3
+
	LDX #$1801
	STX $4300
	LDX #$0400
	STX $4305
	LDX #$1B00
	STX $2116
	LDX #(clock)
	STX $4302
	LDA.b #(clock)>>16
	STA $4304
	LDA #$80
	STA $2115
	LDA #$01
	STA $420B
	REP #$20
	LDA #$FFFF
	STA {opening_flag}
	STZ $0133
	STZ $0135
	STZ $0137
	JML $C035E3
	
dma_clock_map:
	LDA {opening_flag}
	BNE +
	LDA #$8000
	STA $4302
	JML $818164
+
	LDA #$0000
	STA {opening_flag}
	LDX #$1801
	STX $4300
	LDX #(clock_map)
	STX $4302
	LDX #$0780
	STX $4305
	LDX #$6000
	STX $2116
	SEP #$20
	LDA #$80
	STA $2115
	LDA.b #(clock_map)>>16
	STA $4304
	LDA #$01
	STA $420B
	REP #$20
	LDX #$0000
-
	LDA $05E0,x
	STA $0620,x
	INX #2
	CPX #$0020
	BNE -
	SEP #$20
	LDA #$FF
	STA $0164	
	JML $81818E
	
write_clock_color:
	CPX #$8C34
	BEQ +
	LDA $0000,y
	STA $70
	JML $818C84
+
	PHX
	LDX #$0000
-
	LDA $05E0,x
	STA $0620,x
	INX #2
	CPX #$0020
	BNE -
	PLX
	SEP #$20
	LDA #$FF
	STA $0164
	REP #$20
	LDA $0000,y
	STA $70
	JML $818C84
	
dma_original_clock_map:
	LDX #$1801
	STX $4300
	LDX #(clock2_map)
	STX $4302
	LDX #$0780
	STX $4305
	LDX #$6000
	STX $2116
	SEP #$20
	LDA #$80
	STA $2115
	LDA.b #(clock2_map)>>16
	STA $4304
	LDA #$01
	STA $420B
	REP #$20
	JSL $80DB4B
	JML $C032C7
	
dma_clock_map2:
	STX $2116
	LDX #$1801
	STX $4300
	LDX #(clock_map)
	STX $4302
	LDX #$0780
	STX $4305
	SEP #$20
	LDA #$80
	STA $2115
	LDA.b #(clock_map)>>16
	STA $4304
	LDA #$01
	STA $420B
	
	LDX #$0000
	STX $2116
	LDX #$1801
	STX $4300
	LDX #(clock2)
	STX $4302
	LDX #$3A00
	STX $4305
	SEP #$20
	LDA #$80
	STA $2115
	LDA.b #(clock2)>>16
	STA $4304
	LDA #$01
	STA $420B
	STA $0164		//pal
	REP #$20
	LDX #$0000
-
	LDA $05E0,x
	STA $0620,x
	INX #2
	CPX #$0020
	BNE -
	JML $C0322A
	
dma_bg3_set:
	LDA #$1801
	STA $4300
	LDA #(hajimari_set)
	STA $4302
	LDA #$0C00
	STA $4305
	LDA #$4010
	STA $2116
	SEP #$20
	LDA #$80
	STA $2115
	LDA.b #(hajimari_set)>>16
	STA $4304
	LDA #$01
	STA $420B
	
	LDX #$7800
	STX $2116
	LDX #(hajimari_map)
	STX $4302
	LDA.b #(hajimari_map)>>16
	STA $4304
	LDX #$1000
	STX $4305
	LDA #$01
	STA $420B	
	REP #$20
	JML $C032EE
	
hajimari_clear:
	dw $2048, $204A, $204C, $204E, $2050, $2052, $2054, $2056
	dw $2049, $204B, $204D, $204F, $2051, $2053, $2055, $2057
	
soku_dma:
	PHB
	PHA
	JSR clear_buffer
	JSR clear_opening_bg3tile
	TXA
	STA {fixed_dma_vram}
	SEP #$20
	LDA #$F2
	PHA
	PLB
	REP #$20
	PLA
	ASL
	TAX
	LDA $C20010,x		//ptr
	TAY
	PLB
	LDA #$00F2
	JSR fixed_dma
	RTL
	
fixed_dma:
	PHB
	PHP
	SEP #$20
	STA $6A
	STY $68
	LDA #$80
	STA $2115
	LDA #$18
	STA $4301
	LDA #$01
	STA $4300
	LDA #$7F
	STA $4304
	STA $7E0012
	PHA
	PLB
-
	LDA [$68]
	CMP #$FF
	BEQ end_fixed_dma
	CMP #$20
	BCS +
	CMP #$0D
	BNE _3
	JSR fixed_dma_line
_3:
	REP #$20
	INC $68
	SEP #$20
	BRA -
+
	REP #$20
	LDA [$68]
	AND #$00FF
	SEC
	SBC #$0020
	STA {save_a}
	TAX
	LDA width_table,x
	AND #$00FF
	STA {width}
	LDA {save_a}
	ASL #6
	CLC
	ADC #$4243
	STA $7E0010
	LDA #$6A50
	STA $004302
	LDA {shift}
	BEQ +
	CMP #$0008
	BEQ +
	LDA #$0040
	BRA write_size
+
	LDA #$0020
write_size:
	STA {fixed_dma_size}
	JSR draw_tile
	LDA {fixed_dma_size}
	STA $004305
	LDA {fixed_dma_vram}
	STA $002116
	SEP #$20
	LDA #$01
	STA $00420B
	REP #$20
	INC $68
	SEP #$20
	JMP -	
end_fixed_dma:
	STZ {line}
	JSR clear_buffer
	PLP
	PLB
	RTS
	
soku_map_dma:
	PHB
	PHA
	TXA
	STA $7F6A36	//base line
	STA {fixed_dma_vram}
	JSR clear_7e8000
	LDA #$2002		//map starting ID
	STA $7F6A50
	PLA
	ASL
	TAX
	LDA $C20010,x		//ptr
	TAY
	SEP #$20
	LDA #$F2
	STA $6A
	STY $68
	LDA #$7F
	PHA
	PLB	
	REP #$20
-
	LDA [$68]
	AND #$00FF
	CMP #$00FF
	BNE +
	PLB
	JSR write_fixmap_2vram
	RTL
+
	CMP #$0020
	BCS +
	CMP #$000D
	BNE _4
	JSR write_fixmap_2vram
	JSR fixed_map_line
_4:
	INC $68
	BRA -
+
	SEC
	SBC #$0020
	STA {save_a}
	TAX
	LDA width_table,x
	AND #$00FF
	CLC
	ADC {total_width}
	STA {total_width}
	INC $68
	BRL -
	
clear_7e8000:
	PHB
	LDA #$0000
	STA $7E8000
	LDA #$07FF
	LDX #$8000
	LDY #$8001
	MVN $7E, $7E
	PLB
	RTS
	
write_fixmap_2vram:
	LDA $7F6A3E		
	STA $004204
	SEP #$20
	LDA #$08
	STA $004206
	REP #$20
	NOP #5
	LDA $004214
	TAY
	LDA $004216
	BEQ +
	INY
+
	LDA $7F6A4E	//line
	ASL #7
	CLC
	ADC $7F6A36 //base line
	STA $7F6A3A
	TAX
	LDA $7F6A50
-
	STA $7E8000,x
	INC
	STA $7E8040,x
	INC
	INX #2
	DEY
	BNE -	
	LDA #$1801
	STA $004300
	LDA #$0800
	STA $004305
	LDA #$7800
	STA $002116
	LDA #$8000
	STA $004302
	SEP #$20
	LDA #$80
	STA $002115
	LDA #$7E
	STA $004304
	LDA #$01
	STA $00420B
	REP #$20
	RTS
	
fixed_dma_line:
	REP #$20
	INC {line}
	STZ {width}
	STZ {shift}
	STZ {tile_num}
	STZ {total_width}
	LDA {line}
	ASL #9
	CLC
	ADC #$4010
	STA {fixed_dma_vram}
	RTS
	
fixed_map_line:
	STZ {width}
	STZ {shift}
	STZ {tile_num}
	STZ {total_width}	
	INC {line}
	LDA {line}
	ASL #6
	CLC
	ADC #$2002
	STA $7F6A50
	RTS
	
opening3rd:
	LDA #$0011
	LDX #$4010
	JSL soku_dma
	LDA #$0011
	LDX #$0182
	JSL soku_map_dma
	JML $C03945
	
clear_opening_bg3tile:
	LDA #$1801
	STA $004300
	LDA #(blank)
	STA $004302
	LDA #$0C00
	STA $004305
	LDA #$4000
	STA $002116
	SEP #$20
	LDA.b #(blank)>>16
	STA $004304
	LDA #$80
	STA $002115
	LDA #$01
	STA $00420B
	REP #$20
	RTS
	
opening4th:
	LDA #$0013
	LDX #$4010
	JSL soku_dma
	LDA #$0013
	LDX #$0158
	JSL soku_map_dma
	JML $C039A0
	
opening5th:
	LDA #$0018
	LDX #$4010
	JSL soku_dma
	LDA #$0018
	LDX #$03C4
	JSL soku_map_dma
	JML $C039DD
	
fetch_kaiwa:
	PHB 
	PHA
	SEP #$20
	LDA $7F0046		//bank C2
	PHA
	PLB
	REP #$20
	PLA		//kaiwa ID
	ASL
	CLC
	ADC $7F0044
	TAY
	JSR clear_buffer
	LDA $0000,y
	TAY
	PLB
	SEP #$20
	LDA #$F2		//new kaiwa bank
	REP #$20
	JSL write_txt_2buffer
	RTL
	
write_txt_2buffer:
	STA $60
	JSL $C025F2
	BEQ +
	JMP end_write_txt_2buffer
+
	LDA #$0000
	STA $7FCA43
	SEP #$20
	LDA $60		//txt bank
	STA $0CE9
	STY $0CE7
	REP #$20
	TXA
	BEQ +
	STA $7F023B
	LDA #$0000
	//STA $7F0239       //txt color
+
	LDA #$0001
	STA $7F0140
	SEP #$20
	PHB
	LDX #$0000
	LDA $0CE9  //txt bank C2
	PHA
	PLB
-
	LDA $0000,y		//text string
	CMP #$FF
	BEQ _2520
	CMP #$00
	BEQ _250B
	CMP #$20
	BCC _251D
_250B:
	STA $7F6D00,x
	INX
_251D:
	INY
	BRA -
_2520:
	STA $7F6D00,x
	PLB
	REP #$20
	STZ $0CF8
	LDA #$0000
	STA $7F0233
	STA $7F023F
	LDA #$2E80		//tilemap starting value
	STA $0CEE
	STZ $0CF0
	LDA #$6400		//tile vram pos
	STA $0CEA
	STZ $0CF2
	LDA #$7F66		//tilemap pos
	STA $0CF4
	LDA #$0000
	STA $7F4241
	LDA #$0001
	STA $7F023D
	LDA $7F0239
	ASL
    TAX
	JSR (recolor,x)
end_write_txt_2buffer:
    RTL
recolor:
    dw color00
    dw color01
    dw color02
    dw color03
    
color00:
    LDX #(col_data0)
    JSR writecol
    RTS
color01:
    LDX #(col_data1)
    JSR writecol
    RTS
color02:
    LDX #(col_data2)
    JSR writecol
    RTS
color03:
    LDX #(col_data3)
    JSR writecol
    RTS

writecol:
    LDY #$05B8
    LDA #$0005
    PHB
    MVN (col_data1>>16), $00
    PLB
    LDA $7E0164
    INC
    STA $7E0164
    RTS
    
col_data0:
    dw $76B4, $3D67, $FFFF
col_data1:
    dw $76B4, $3D67, $0FFF
col_data2:
    dw $76B4, $3D67, $03E0
col_data3:
    dw $76B4, $3D67, $76B4

dma_tilemap:
	LDA $0CF4
	STA $2116
	SEP #$20
	LDA #$81
	STA $2115
	LDX $0CF2
	REP #$20
//	LDA $0CF6
//	BNE _29F0
	LDA $7F6B10,x
	STA $2118
	LDA $7F6B50,x
	STA $2118
	BRA _2A18
_29F0:
	LDA $7F6B10,x
	STA $2118
	LDA $7F6B50,x
	STA $2118
	LDA $0CF4
	INC
	STA $0CF4
	STA $2116
	LDA $7F6B12,x
	STA $2118
	LDA $7F6B52,x
	STA $2118
	INX #2
_2A18:
	INX #2
	STX $0CF2
	LDA $0CF4
	INC
	STA $0CF4
	JML $C02A31

line2_shori:
	CMP #$FF
	BNE +
	JML $C029B8
+
	CMP #$FE
	BNE +
	REP #$20
	LDA #$7FA6
	STA $0CF4
	LDA #$0080
	STA $0CF2
	JML $C028CF	
+
    CMP #$FD
    BNE +
    REP #$20
    LDA #$001F
    STA $05A0
    INC $68
    JML $C028CF	
 +
	JML $C028A6

clear_txt:
	LDA #$1801
	STA $4300
	LDA #(blank)
	STA $4302
	SEP #$20
	LDA #$80
	STA $2115
	LDA.b #(blank)>>16
	STA $4304
	REP #$20
	LDA $0CF8
	DEC
	ASL
	TAY
	LDA $8ACD,y
	STA $2116
	PHA
	SEP #$20
	LDA #$52
	STA $4305
	LDA #$01
	STA $420B
	REP #$20
	PLA
	CLC
	ADC #$0020
	STA $2116
	SEP #$20
	LDA #$52
	STA $4305
	LDA #$01
	STA $420B
	JML $C026E5
    
clear_tileset:
    PHX
    PHP
    REP #$30
    LDA #$1801
    STA $004300
    LDA #(blank)
    STA $004302
    LDA #$6400
    STA $002116
    LDA #$0600
    STA $004305
    SEP #$20
    LDA.b #(blank)>>16
    STA $004304
    LDA #$80
    STA $002115
    STA $002100
    LDA #$01
    STA $00420B
    LDA $0100
    STA $002100
    LDX #$0000
    TXA
-
    STA $6A30,x
    INX #2
    CPX #$0020
    BNE -
    PLP
    PLX
    RTS
   
write_color:
    LDA [$68]
    AND #$00FF
    STA $7F0239
    ASL
    TAX
    JSR (recolor,x)
    JML $C029A4

papa_memo:
	LDX #$0000
-
	LDA tegami_map,x
	STA $7E2000,x
	INX #2
	CPX #$2000
	BNE -

	LDA #$1400
	STA $2116
	LDA #$1801
	STA $4300
	LDA #$3600
	STA $4305
	LDA #(tegami_set)
	STA $4302
	SEP #$20
	LDA.b #(tegami_set)>>16
	STA $4304
	LDA #$80
	STA $2114
	LDA #$01
	STA $420B
	LDA #$01
	STA $210C
	REP #$20
	LDA #$7800
	STA $2116
	LDA #(tegami_blank)
	STA $4302
	LDA #$1000
	STA $4305
	SEP #$20
	LDA.b #(tegami_blank>>16)
	STA $4304
	LDA #$01
	STA $420B
	REP #$20
    JML $C10369
	
tegamibg3settei:
	SEP #$20
	LDA #$05
	STA $012C
	LDA #$01
	STA $210C
	LDX #$0000
	LDY #$000F
	JML $C10379
	
dma_tegamiset:
	LDA $7F0016
	TAX
	INC $00,x
	JSL $80E0BE
	LDA $7F0016
	TAX
	LDA $00,x
	CMP #$0160
	BNE +
	LDA #$1801
	STA $4300
	LDA #$1400
	STA $2116
	LDA #(tegami_set2)
	STA $4302
	LDA #$0800
	STA $4305
	SEP #$20
	LDA.b #(tegami_set2>>16)
	STA $4304
	LDA #$80
	STA $2115
	LDA #$01
	STA $420B
	REP #$20
	JML $C103F4
+
	CMP #$01F0
	BNE +
	LDA #$1801
	STA $4300
	LDA #$1800
	STA $2116
	LDA #(tegami_set3)
	STA $4302
	LDA #$0800
	STA $4305
	SEP #$20
	LDA.b #(tegami_set3>>16)
	STA $4304
	LDA #$80
	STA $2115
	LDA #$01
	STA $420B
	REP #$20
	JML $C103F4
+
	CMP #$0210
	BNE +
	LDA #$1801
	STA $4300
	LDA #$1C00
	STA $2116
	LDA #(tegami_set4)
	STA $4302
	LDA #$0200
	STA $4305
	SEP #$20
	LDA.b #(tegami_set4>>16)
	STA $4304
	LDA #$80
	STA $2115
	LDA #$01
	STA $420B
	REP #$20
+
	JML $C103F4	
	
ending_G:
	LDA #$0030
	LDX #$4010
	JSL soku_dma
	LDA #$0030
	LDX #$0184
	JSL soku_map_dma
	JSR _04CF
	JSR _02E3
	STZ $013B
	STZ $013D
	SEP #$20
	LDA #$03
	STA $2121
	LDA #$BB
	STA $2122
	STA $2122
	LDA #$7A
	STA $0109
	LDA #$04
	STA $012C
	LDX #$0000
	LDY #$000F
	REP #$20
	LDA #$0002
	JSL $80DC76  //fade speed
	LDX #$0150	//timer
-
	JSL $80E0BE
	DEX
	BNE -
	JML $C105BB
	
_02E3:
	LDX #$8AFF
	JSL $80D95B
	STZ $0133
	STZ $0137
	STZ $013B
	STZ $0135
	STZ $0139
	STZ $013D
	RTS
	
_04CF:
	LDX #$8307
	LDY #$05A0
	LDA #$0005
	PHB
	MVN $00,$80
	PLB
	INC $0164
	RTS
	
nmi_dma:
	LDA $0129
	STA $2129
	LDA {dma_trigger}
	BEQ +
	REP #$20
	LDA #$0000
	STA {dma_trigger}
	LDA #$1801
	STA $4300
	LDA {dma_vram}
	STA $2116
	LDA {dma_adr}
	STA $4302
	LDA {dma_size}
	STA $4305
	SEP #$20
	LDA {dma_bank}
	STA $4304
	LDA #$80
	STA $2115
	LDA #$01
	STA $420B
+
	JML $80D235
	
dma_tairyoku:
	LDA {ending_flag}
	CMP #$FFFF
	BEQ +
	LDX #$5000
	JSL $818024
	LDX #$0000
-
	LDA tairyoku_map,x
	STA $7FFF00,x
	INX #2
	CPX #$0060
	BNE -	
	LDA #$1801
	STA $4370
	LDA #$5020
	STA $2116
	LDA #(tairyoku_set)
	STA $4372
	LDA #$0200
	STA $4375
	SEP #$20
	LDA.b #(tairyoku_set>>16)
	STA $4374
	LDA #$80
	STA $2115
	LDA #$80
	STA $420B
	REP #$20
+
	JML $C03DF8
	
hp_display:
	JSR kaifuku
	LDA {display_flag}
	BNE +
	BRA _kage
+
	LDA {text_flag}
	BEQ +
_kage:
	LDA #$0000
	STA {dma_trigger}
	LDX #$0000
-
	STA $7FFF00,x
	INX #2
	CPX #$0060
	BNE -
	JSL $C025F7
	JML $C0103B	
+
	LDX #$0000
-
	LDA tairyoku_map,x
	STA $7FFF00,x
	INX #2
	CPX #$0060
	BNE -
	JSR write_hp
	LDA #$0001
	STA {dma_trigger}
	LDA #$7FB5
	STA {dma_vram}
	LDA #$0060
	STA {dma_size}
	LDA #$FF00
	STA {dma_adr}
	LDA #$007F
	STA {dma_bank}
	JSL $C025F7
	JML $C0103B
	
clear_text_pos:
	LDY #$7F66	//text clear pos
	REP #$20
	LDX #$0004
	PHX
	PHY
	LDA #$0000
	STA {text_flag}
	LDX #$25C5
	LDA #$0052  
	JML $C02584
	
write_hp:
	LDX #$0000
	LDA $0BF9
	CMP #$000A
	BCS +
	JSR write_1keta
	RTS
+
	CMP #$0064
	BCS +
	JSR hex2dec
	JSR write_1keta
	LDA $4216
	JSR write_2keta
	RTS
+
	CMP #$0065
	BCS +
	JSR hex2dec
	PHA
	LDA $4216
	JSR write_3keta
	PLA
	JSR hex2dec
	JSR write_1keta
	LDA $4216
	JSR write_2keta
	RTS	
+
	LDA #$0064
	STA $0BF9
	RTS
	
hex2dec:
	STA $4204
	SEP #$20
	LDA #$0A
	STA $4206
	REP #$20
	NOP #5
	LDA $4214
	RTS
	
write_1keta:
	ASL
	CLC
	ADC #$2810
	STA $7FFF0C
	INC
	STA $7FFF4C
	RTS
write_2keta:
	ASL
	CLC
	ADC #$2810
	STA $7FFF0E
	INC
	STA $7FFF4E	
	RTS
write_3keta:
	ASL
	CLC
	ADC #$2810
	STA $7FFF10
	INC
	STA $7FFF50	
	RTS
write_4keta:
	ASL
	CLC
	ADC #$2810
	STA $7FFF12
	INC
	STA $7FFF52
	RTS
	
first_screen:
	LDA {option}
	BNE _6
	LDA #$DEAD
	STA {option}
	LDA #$00E0
	STA {timer}
	JSR display_first_screen
	SEP #$20
	LDA #$05
	STA {fade_spd}
	STA {fade_spd}+1
	JSR fadein
	JSR taiki
	SEP #$20
	LDA #$48
	STA {oam_xpos}
	STA {oam_xpos}+1
	LDA #$24
	STA {oam_ypos}
	JSR fadeout
	STZ $0100
	LDA #$08
	STA {fade_spd}
	STA {fade_spd}+1
	JSR display_second_screen
	JSR fadein
-
	JSR wait_end_vblank
	JSR wait_vblank
	JSR polling_input
	JSR write_pointer_oam
	JSR pointer_xpos_hosei
	JSR pointer_ypos_hosei
	JSR dma_oam
	JSR kettei
	LDA {ichigime}+1
	BEQ -
	JSR fadeout
_6:
	SEP #$20
	PLA
	STA $0121
	JML $80DC1F
	
display_first_screen:
	PHP
	LDA #$1801
	STA $4300
	LDA #(intro_set)
	STA $4302
	LDA #$0000
	STA $2116
	LDA #$1600
	STA $4305
	SEP #$20
	LDA #$80
	STA $2115
	STA $2100
	LDA.b #(intro_set>>16)
	STA $4304
	LDA #$01
	STA $420B	
	LDX #(intro_map)
	STX $4302
	LDX #$0800
	STX $4305
	LDX #$6000
	STX $2116
	LDA.b #(intro_map>>16)
	STA $4304
	LDA #$01
	STA $420B	
	STZ $2121
	LDX #$0000
-
	LDA intro_col,x
	STA $2122
	LDA intro_col+1,x
	STA $2122
	INX #2
	CPX #$0020
	BNE -
	PLP
	RTS
	
wait_vblank:
	PHP
	SEP #$20
-
	LDA $4212
	BIT #$80
	BEQ -
	PLP
	RTS
	
wait_end_vblank:
	PHP
	SEP #$20
-
	LDA $4212
	BIT #$80
	BNE -
	PLP
	RTS
	
fadein:
	JSR wait_end_vblank
	JSR wait_vblank
	LDA {fade_spd}
	DEC
	STA {fade_spd}
	BNE fadein
	LDA {fade_spd}+1
	STA {fade_spd}
	LDA $0100
	INC
	STA $0100
	CMP #$0F
	BNE fadein
	RTS
	
taiki:
	SEP #$20
	JSR wait_end_vblank
	JSR wait_vblank
	REP #$20
	LDA {timer}
	DEC
	STA {timer}
	BNE taiki
	RTS
	
fadeout:
	JSR wait_end_vblank
	JSR wait_vblank
	LDA {fade_spd}
	DEC
	STA {fade_spd}
	BNE fadeout
	LDA {fade_spd}+1
	STA {fade_spd}
	LDA $0100
	DEC
	STA $0100
	BNE fadeout
	LDA #$80
	STA $0100
	STA $2100
	RTS
	
display_second_screen:
	LDX #$1801
	STX $4300
	LDX #(display_set)
	STX $4302
	LDX #$0000
	STX $2116
	LDX #$0800
	STX $4305
	LDA #$80
	STA $2115
	LDA.b #(display_set>>16)
	STA $4304
	LDA #$01
	STA $420B
	
	LDX #(display_map)
	STX $4302
	LDX #$0800
	STX $4305
	LDX #$6000
	STX $2116
	LDA #$01
	STA $420B
	
	STZ $2121
	LDX #$0000
	PHX
-
	LDA display_col,x
	STA $2122
	LDA display_col+1,x
	STA $2122
	INX #2
	CPX #$0010
	BNE -
	PLX
	LDA #$80
	STA $2121
-
	LDA pointer_col,x
	STA $2122
	LDA pointer_col+1,x
	STA $2122
	INX #2
	CPX #$0020
	BNE -	
	LDA #$01
	STA $2101
	LDX #(pointer_set)
	STX $4302
	LDX #$0200
	STX $4305
	LDX #$2000
	STX $2116
	LDA.b #(pointer_set>>16)
	STA $4304
	LDA #$01
	STA $420B	
	RTS
	
dma_oam:
	PHP
	SEP #$10
	REP #$20
	LDA #$0400
	STA $4300
	LDA #$0180
	STA $4302
	LDX #$7E
	STX $4304
	LDA #$0220
	STA $4305
	STZ $2102
	LDX #$80
	STX $2115
	LDX #$01
	STX $420B
	PLP
	RTS
	
write_pointer_oam:
	LDX #$0000
-
	LDA pointer_oam,x
	CLC
	ADC {oam_xpos}
	STA $0180,x
	LDA pointer_oam+1,x
	CLC
	ADC {oam_ypos}
	STA $0181,x
	LDA pointer_oam+2,x
	STA $0182,x
	LDA pointer_oam+3,x
	STA $0183,x
	INX #4
	CPX #$0010
	BNE -
	RTS
	
pointer_oam:
	db $00, $00, $00, $20
	db $00, $08, $01, $20
	db $08, $00, $02, $20
	db $08, $08, $03, $20
	
pointer_xpos_hosei:
	LDA {fade_spd}
	DEC
	STA {fade_spd}
	BNE +
	LDA {fade_spd}+1
	STA {fade_spd}
	LDA #$00
	XBA
	LDA {oam_ypos}+1
	TAX
	LDA xpos_hosei,x
	CLC
	ADC {oam_xpos}+1
	STA {oam_xpos}
	LDA {oam_ypos}+1
	INC
	STA {oam_ypos}+1
	CMP #$04
	BCC +
	LDA #$00
	STA {oam_ypos}+1
+
	RTS
	
xpos_hosei:
	db $00, $02, $00, $FE
	
polling_input:
	PHP
	SEP #$20
-
	LDA $4212
	AND #$01
	BNE -
	REP #$20
	LDA $4218
	STA {pad3}
	AND #$000F
	BEQ +
	LDA {pad6}
	STA {pad3}
+
	LDA {pad3}
	EOR {pad6}
	AND {pad3}
	STA {pad4}
	STA {pad5}
	LDA {pad3}
	BEQ +
	CMP {pad6}
	BNE +
	LDA {pad7}
	DEC 
	STA {pad7}
	BNE end_pad_shori
	LDA {pad3}
	STA {pad5}
	LDA {pad2}
	STA {pad7}
	BRA end_pad_shori
+
	LDA {pad1}
	STA {pad7}
end_pad_shori:
	LDA {pad3}
	STA {pad6}
	PLP
	RTS
	
pointer_ypos_hosei:
	PHP
	SEP #$30
	LDA {pad5}+1
	CMP #$04
	BNE +
-
	JSR write_ypos_hosei
	PLP
	RTS
+
	CMP #$08
	BEQ -
	PLP
	RTS
	
write_ypos_hosei:
	LDA {ichigime}
	TAX
	EOR #$01
	STA {ichigime}
	LDA ypos_hosei,x
	CLC
	ADC {oam_ypos}
	STA {oam_ypos}
	RTS
	
ypos_hosei:
	db $10, $F0
	
kettei:
	LDA {pad5}
	CMP #$80
	BNE +
	LDA {oam_ypos}
	CMP #$24
	BNE _7
	LDA #$FF
	STA {display_flag}
_7:
	LDA #$FF
	STA {ichigime}+1
+
	RTS
	
fusetsu:
	LDA $010D
	CMP #$2200
	BEQ +
	LDA $7FCF4B
	RTL
+
	LDA #$0000
	STA $7FCF4B
	RTL
	
kaifuku:
	LDA $010D
	CMP #$2800
	BNE +
	LDA #$0064
	STA $0BF9
+
	RTS
	
oikakeruna:
	LDA $010D
	CMP #$2100
	BNE +
	LDA #$0000
	STA $7FCF51
-
	JML $C05706
+
	LDA $7FCF51
	BEQ -
	DEC
	STA $7FCF51
	BRA -
	
clear_tairyoku:
	PHP
	REP #$20
	LDA #$0001
	STA {dma_trigger}
	LDA #$7FB5
	STA {dma_vram}
	LDA #$0060
	STA {dma_size}
	LDA #(blank)
	STA {dma_adr}
	LDA #$00F1
	STA {dma_bank}
	PLP
	RTS
	
dma_defaultfont:
	LDA #$FFFF
	STA {ending_flag}
	LDA #$5000
	STA $2116
	LDA #$1801
	STA $4300
	LDA #(defaultfont_set)
	STA $4302
	LDA #$0800
	STA $4305
	SEP #$20
	LDA #$80
	STA $2100
	STA $2115
	LDA.b #(defaultfont_set>>16)
	STA $4304
	LDA #$01
	STA $420B
	PHB
	LDA #$80
	PHA
	PLB
	JML $C041D4