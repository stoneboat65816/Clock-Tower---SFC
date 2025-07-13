//##disable title kurokku tawaa##
org $808C9B
	db $99
org $808CA0
	db $99
org $808CA5
	db $99

org $C035D8
	JML dma_opening
	
org $81815E
	JML dma_clock_map
	
org $C032C3
	JML dma_original_clock_map
	
org $C03226
	JML dma_clock_map2
	
org $C032EA
	JML dma_bg3_set
	
org $C0363D	//"cleared"
	LDA #(hajimari_clear)
	STA $4302
	SEP #$20
	LDA #$80
	STA $2115
	LDA #$01
	STA $4300
	LDA #$18
	STA $4301
	LDA #$10
	STA $4305
	LDA.b #(hajimari_clear)>>16
	STA $4304
	LDA #$01
	STA $420B
	REP #$20
	PLA
	CLC
	ADC #$0020
	STA $2116
	SEP #$20
	LDA #$10
	STA $4305
	LDA #$01
	STA $420B
	
org $C038C9
	LDA #$001A
	LDX #$4010
	JSL soku_dma
	LDA #$001A
	LDX #$0184
	JSL soku_map_dma
	RTS
	
org $C038DE
	LDA #$001B
	LDX #$4010
	JSL soku_dma
	LDA #$001B
	LDX #$0184
	JSL soku_map_dma
	RTS
	
org $C038F3
	LDA #$001C
	LDX #$4010
	JSL soku_dma
	LDA #$001C
	LDX #$0184
	JSL soku_map_dma
	RTS
	
org $C036B3
	LDA #$7FE0		//aoiro
	
org $C03927
	JML opening3rd
	
org $C03964
	JML opening4th
	
org $C039BF
	JML opening5th
    
org $C10355     //papa memo
    JML papa_memo
	
org $C1036C	//tegami bg3 settei
	JML tegamibg3settei
	
org $C1041D
	JML dma_tegamiset
	
org $C103AE
	LDA #$000E		//memo timer
	
org $C10507
	JML ending_G
	
org $C03DF1
	JML dma_tairyoku
	
org $C01037
	JML hp_display