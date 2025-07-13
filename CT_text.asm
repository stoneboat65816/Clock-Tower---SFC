org $C02BCF 
	LDA #$6F40	//avatar pos
	
org $C024A9
	JML transfer_font
	
org $808ADB
	dw $FFFF		//txt color
	
org $808AD5
	dw $FFFF
	
org $C00BE6
	JSL fetch_kaiwa
org $C02709
	JML txt_shori

org $C0075A
    JSL fetch_kaiwa
    
org $C01478
    JSL fetch_kaiwa     //item

org $C029C9
	JML dma_tilemap
org $C0289F
	JML line2_shori
	
org $C02692
	JML clear_txt
org $008ACD
	dw $7F66		//text clear pos
	dw $7FA6
org $C02574
	JML clear_text_pos
      
org $C0298E
    JML write_color
	
org $C041CD
	JML dma_defaultfont