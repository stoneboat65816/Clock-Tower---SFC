arch snes.cpu
hirom
define	buffer1	$6A30
define	buffer2 $6A32
define	tile_num	$6A34
define	base_line	$6A36
define	map_dma_flag $7F6A38
define	fixed_dma_vram	$7F6A3A
define	fixed_dma_size		$7F6A3C
define	total_width				$6A3E
define	width		$6A40
define	shift		$6A42
define	tile_vram_size	$6A44
define	save_a		$6A46
define	save_x		$6A48
define	left_byte	$6A4A
define	right_byte	$6A4C
define	line					$6A4E


define	txt_pos		$023F
define	font_ptr	$10
define	pad1				$7FFFD0
define	pad2				$7FFFD2
define	pad3				$7FFFD4
define	pad4				$7FFFD6
define	pad5				$7FFFD8
define	pad6				$7FFFDA
define	pad7				$7FFFDC

define	dma_trigger	$7FFFE0
define	dma_vram	$7FFFE2
define	dma_size		$7FFFE4
define	dma_adr		$7FFFE6
define	dma_bank		$7FFFE8
define	text_flag			$7FFFEA
define	display_flag	$7FFFEC
define	option			$7FFFEE
define	fade_spd		$7FFFF0
define	timer				$7FFFF2
define	oam_xpos		$7FFFF4
define	oam_ypos		$7FFFF6
define	ichigime		$7FFFF8
define	ending_flag	$7FFFFA


define	opening_flag	$7FFFFE

	incsrc "CT_opening.asm"
    incsrc  "CT_vector.asm"
	incsrc  "CT_muteki.asm"
	incsrc "CT_text.asm"
	incsrc "CT_code.asm"
	incsrc "CT_incbin.asm"