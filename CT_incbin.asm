org $F10000
font:
	incbin "Font/font1.bin"

	
width_table:
	db $06, $07, $07, $07, $07, $07, $07, $07
	db $04, $07, $07, $07, $08, $07, $07, $07
	db $07, $07, $07, $07, $07, $07, $08, $07
	db $07, $07, $07, $07, $07, $06, $06, $06
	db $06, $06, $07, $04, $05, $07, $04, $08
	db $07, $07, $07, $07, $06, $06, $06, $07
	db $07, $09, $06, $07, $07, $07, $07, $07
	db $07, $07, $07, $07, $07, $07, $07, $07
	
	db $07, $07, $07, $07, $07, $07, $07, $06
	db $06, $06, $06, $06, $06, $06, $06, $06
	db $06, $06, $04, $04, $04, $05, $04, $07
	db $07, $07, $07, $07, $07, $07, $07, $07
	db $07, $07, $07, $07, $07, $07, $07, $07
	db $07, $07, $07, $07, $07, $08, $08, $08
	db $07, $07, $07, $07, $07, $07, $07, $07
	db $04, $04, $04, $07, $07, $08, $04, $08
	
	db $04, $04, $07, $06, $04, $06, $06, $07
	db $06, $06, $06, $06, $06, $09, $04, $05
	db $06, $07, $06, $07, $07, $07, $07, $07
	db $06, $06, $06

blank:
	
org $F30000
clock:
	incbin "Opening/clock_set.bin"
clock_map:
	incbin "Opening/clock_map.bin"
clock2_map:
	incbin "Opening/clock2_map.bin"
clock2:
	incbin "Opening/clock2_set.bin"
hajimari_set:
	incbin "Opening/hajimari_set.bin"
hajimari_map:
	incbin "Opening/hajimari_map.bin"

org $F40000	
tegami_set:
	incbin "Opening/tegami_set.bin"
tegami_set2:
	incbin "Opening/tegami_set2.bin"
tegami_set3:
	incbin "Opening/tegami_set3.bin"
tegami_set4:
	incbin "Opening/tegami_set4.bin"
tegami_blank:
	incbin "Opening/tegami_blank_map.bin"
tegami_map:
	incbin "Opening/tegami_map.bin"
tairyoku_set:
	incbin "Opening/tairyoku_set.bin"
tairyoku_map:
	incbin "Opening/tairyoku_map.bin"
	
org $F50000
intro_set:
	incbin "Opening/intro_set.bin"
intro_map:
	incbin "Opening/intro_map.bin"
intro_col:
	incbin "Opening/intro_col.bin"
display_set:
	incbin "Opening/display_set.bin"
display_map:
	incbin "Opening/display_map.bin"
display_col:
	incbin "Opening/display_col.bin"
pointer_set:
	incbin "Opening/pointer_set.bin"
pointer_col:
	incbin "Opening/pointer_col.bin"
defaultfont_set:
	incbin "Font/defaultfont_set.bin"
