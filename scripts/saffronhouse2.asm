SaffronHouse2Script: ; 1de3c (7:5e3c)
	jp EnableAutoTextBoxDrawing

SaffronHouse2TextPointers: ; 1de3f (7:5e3f)
	dw SaffronHouse2Text1

SaffronHouse2Text1: ; 1de41 (7:5e41)
	TX_ASM
	ld a, [wSaffronHouse2Flags]
	bit 0, a
	jr nz, .asm_9e72b ; 0x1de47
	ld hl, TM29PreReceiveText
	call PrintText
	lb bc, TM_29, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, ReceivedTM29Text
	call PrintText
	ld hl, wSaffronHouse2Flags
	set 0, [hl]
	jr .asm_fe4e1 ; 0x1de62
.BagFull
	ld hl, TM29NoRoomText
	call PrintText
	jr .asm_fe4e1 ; 0x1de6a
.asm_9e72b ; 0x1de6c
	ld hl, TM29ExplanationText
	call PrintText
.asm_fe4e1 ; 0x1de72
	jp TextScriptEnd

TM29PreReceiveText: ; 1de75 (7:5e75)
	TX_FAR _TM29PreReceiveText
	db "@"

ReceivedTM29Text: ; 1de7a (7:5e7a)
	TX_FAR _ReceivedTM29Text
	db $0B, "@"

TM29ExplanationText: ; 1de80 (7:5e80)
	TX_FAR _TM29ExplanationText
	db "@"

TM29NoRoomText: ; 1de85 (7:5e85)
	TX_FAR _TM29NoRoomText
	db "@"
