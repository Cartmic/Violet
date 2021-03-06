DisplayTownMap:
	ld a, [hTilesetType]
	push af
	xor a
	ld [hTilesetType], a
	call LoadTownMap
	ld hl, wUpdateSpritesEnabled
	ld a, [hl]
	push af
	ld [hl], $ff
	push hl
	ld a, $1
	ld [hJoy7], a
	ld a, [W_CURMAP] ; W_CURMAP
	push af
	ld b, $0
	call DrawPlayerOrBirdSprite
	hlCoord 1, 0
	ld de, wcd6d
	call PlaceString
	ld hl, wOAMBuffer
	ld de, wTileMapBackup
	ld bc, $10
	call CopyData
	ld hl, vSprites + $40
	ld de, TownMapCursor
	lb bc, BANK(TownMapCursor), (TownMapCursorEnd - TownMapCursor) / $8
	call CopyVideoDataDouble
	xor a
	ld [wWhichTrade], a ; wWhichTrade
	pop af
	jr .enterLoop

.townMapLoop
	hlCoord 0, 0
	lb bc, 1, 20
	call ClearScreenArea
	ld hl, TownMapOrder
	ld a, [wWhichTrade]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]

.enterLoop:
	ld de, wHPBarMaxHP ; Town Map Coords
	call LoadTownMapEntry
	ld a, [de]
	push hl
	call TownMapCoordsToOAMCoords
	ld a, $4
	ld [wcd5b], a ; OAM Base Tile
	ld hl, wOAMBuffer + $10
	call WriteTownMapSpriteOAM
	pop hl
	ld de, wcd6d
.copyMapName
	ld a, [hli]
	ld [de], a
	inc de
	cp "@"
	jr nz, .copyMapName
	hlCoord 1, 0
	ld de, wcd6d
	call PlaceString
	ld hl, wOAMBuffer + $10
	ld de, wTileMapBackup + 16
	ld bc, $10
	call CopyData
.inputLoop
	call TownMapSpriteBlinkingAnimation
	call JoypadLowSensitivity
	ld a, [hJoy5]
	ld b, a
	and A_BUTTON | B_BUTTON | D_UP | D_DOWN
	jr z, .inputLoop
	ld a, (SFX_02_3c - SFX_Headers_02) / 3
	call PlaySound
	bit 6, b
	jr nz, .pressedUp
	bit 7, b
	jr nz, .pressedDown
	xor a
	ld [wTownMapSpriteBlinkingEnabled], a
	ld [hJoy7], a
	ld [wTownMapSpriteBlinkingCounter], a
	call ExitTownMap
	pop hl
	pop af
	ld [hl], a
	pop af
	ld [hTilesetType], a
	ret
.pressedUp
	ld a, [wWhichTrade]
	inc a
	cp TownMapOrderEnd - TownMapOrder ; number of list items + 1
	jr nz, .noOverflow
	xor a
.noOverflow
	ld [wWhichTrade], a
	jp .townMapLoop
.pressedDown
	ld a, [wWhichTrade]
	dec a
	cp $ff
	jr nz, .noUnderflow
	ld a, TownMapOrderEnd - TownMapOrder - 1 ; number of list items
.noUnderflow
	ld [wWhichTrade], a
	jp .townMapLoop

INCLUDE "data/town_map_order.asm"

TownMapCursor:
	INCBIN "gfx/town_map_cursor.1bpp"
TownMapCursorEnd:

LoadTownMap_Nest:
	ld a, [hTilesetType]
	push af
	xor a
	ld [hTilesetType], a
	call LoadTownMap
	ld hl, wUpdateSpritesEnabled
	ld a, [hl]
	push af
	ld [hl], $ff
	push hl
	call DisplayWildLocations
	call GetMonName
	hlCoord 1, 0
	call PlaceString
	ld h, b
	ld l, c
	ld de, MonsNestText
	call PlaceString
	call WaitForTextScrollButtonPress
	call ExitTownMap
	pop hl
	pop af
	ld [hl], a
	pop af
	ld [hTilesetType], a
	ret

MonsNestText:
	db "'s nest@"

LoadTownMap_Fly:
	ld a, [hTilesetType]
	push af
	xor a
	ld [hTilesetType], a
	call ClearSprites
	call LoadTownMap
	call LoadPlayerSpriteGraphics
	call LoadFontTilePatterns
	ld de, BirdSprite
	ld hl, vSprites + $40
	lb bc, BANK(BirdSprite), $c
	call CopyVideoData
	ld de, TownMapUpArrow
	ld hl, vChars1 + $6d0
	lb bc, BANK(TownMapUpArrow), (TownMapUpArrowEnd - TownMapUpArrow) / $8
	call CopyVideoDataDouble
	call BuildFlyLocationsList
	ld hl, wUpdateSpritesEnabled
	ld a, [hl]
	push af
	ld [hl], $ff
	push hl
	hlCoord 0, 0
	ld de, ToText
	call PlaceString
	ld a, [W_CURMAP]
	ld b, $0
	call DrawPlayerOrBirdSprite
	ld hl, wTrainerEngageDistance
	deCoord 18, 0

.townMapFlyLoop
	ld a, " "
	ld [de], a
	push hl
	push hl
	hlCoord 3, 0
	lb bc, 1, 15
	call ClearScreenArea
	pop hl
	ld a, [hl]
	ld b, $4
	call DrawPlayerOrBirdSprite
	hlCoord 3, 0
	ld de, wcd6d
	call PlaceString
	ld c, 15
	call DelayFrames
	hlCoord 18, 0
	ld [hl], "▲"
	hlCoord 19, 0
	ld [hl], "▼"
	pop hl
.inputLoop
	push hl
	call DelayFrame
	call JoypadLowSensitivity
	ld a, [hJoy5]
	ld b, a
	pop hl
	and A_BUTTON | B_BUTTON | D_UP | D_DOWN
	jr z, .inputLoop
	bit 0, b
	jr nz, .pressedA
	ld a, (SFX_02_3c - SFX_Headers_02) / 3
	call PlaySound
	bit 6, b
	jr nz, .pressedUp
	bit 7, b
	jr nz, .pressedDown
	jr .pressedB
.pressedA
	ld a, (SFX_02_3e - SFX_Headers_02) / 3
	call PlaySound
	ld a, [hl]
	ld [wDestinationMap], a
	ld hl, wd732
	set 3, [hl]
	inc hl
	set 7, [hl]
.pressedB
	xor a
	ld [wTownMapSpriteBlinkingEnabled], a
	call GBPalWhiteOutWithDelay3
	pop hl
	pop af
	ld [hl], a
	pop af
	ld [hTilesetType], a
	ret
.pressedUp
	deCoord 18, 0
	inc hl
	ld a, [hl]
	cp $ff
	jr z, .wrapToStartOfList
	cp $fe
	jr z, .pressedUp
	jp .townMapFlyLoop
.wrapToStartOfList
	ld hl, wTrainerEngageDistance
	jp .townMapFlyLoop
.pressedDown
	deCoord 19, 0
	dec hl
	ld a, [hl]
	cp $ff
	jr z, .wrapToEndOfList
	cp $fe
	jr z, .pressedDown
	jp .townMapFlyLoop
.wrapToEndOfList
	ld hl, wcd49
	jr .pressedDown

ToText:
	db "To@"

BuildFlyLocationsList:
	ld hl, wWhichTrade
	ld [hl], $ff
	inc hl
	ld a, [wKantoTownVisitedFlag]
	ld e, a
	ld a, [wKantoTownVisitedFlag + 1]
	ld d, a
	ld bc, SAFFRON_CITY + 1
.loop
	srl d
	rr e
	ld a, $fe
	jr nc, .notVisited
	ld a, b
.notVisited
	ld [hl], a
	inc hl
	inc b
	dec c
	jr nz, .loop
	ld [hl], $ff
	ret

TownMapUpArrow:
	INCBIN "gfx/up_arrow.1bpp"
TownMapUpArrowEnd:

LoadTownMap:
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call UpdateSprites
	hlCoord 0, 0
	ld b, $12
	ld c, $12
	call TextBoxBorder
	call DisableLCD
	ld hl, WorldMapTileGraphics
    ld de, vChars2
    ld bc, WorldMapTileGraphicsEnd - WorldMapTileGraphics
	ld a, BANK(WorldMapTileGraphics)
	call FarCopyData2
	ld hl, MonNestIcon
	ld de, vSprites + $40
	ld bc, MonNestIconEnd - MonNestIcon
	ld a, BANK(MonNestIcon)
	call FarCopyDataDouble
	
	ld hl, UncompressedMap
	ld de, wTileMap
	ld bc, UncompressedMapEnd - UncompressedMap
	call CopyData

	call EnableLCD
	ld b, $2
	call GoPAL_SET
	call Delay3
	call GBPalNormal
	xor a
	ld [wTownMapSpriteBlinkingCounter], a
	inc a
	ld [wTownMapSpriteBlinkingEnabled], a
	ret

UncompressedMap: ; Uses the Gen 2 format
    INCBIN "gfx/tilemaps/town_map.map"
UncompressedMapEnd:

ExitTownMap:
	xor a
	ld [wTownMapSpriteBlinkingEnabled], a
	call GBPalWhiteOut
	call ClearScreen
	call ClearSprites
	call LoadPlayerSpriteGraphics
	call LoadFontTilePatterns
    call ReloadMapData ; added
	call UpdateSprites
	jp GoPAL_SET_CF1C

DrawPlayerOrBirdSprite:
; a = map number
; b = OAM base tile
	push af
	ld a, b
	ld [wcd5b], a
	pop af
	ld de, wHPBarMaxHP
	call LoadTownMapEntry
	ld a, [de]
	push hl
	call TownMapCoordsToOAMCoords
	call WritePlayerOrBirdSpriteOAM
	pop hl
	ld de, wcd6d
.loop
	ld a, [hli]
	ld [de], a
	inc de
	cp "@"
	jr nz, .loop
	ld hl, wOAMBuffer
	ld de, wTileMapBackup
	ld bc, $a0
	jp CopyData

DisplayWildLocations:
	callba FindWildLocationsOfMon
	call ZeroOutDuplicatesInList
	ld hl, wOAMBuffer
	ld de, wBuffer
.loop
	ld a, [de]
	cp $ff
	jr z, .exitLoop
	and a
	jr z, .nextEntry
	push hl
	call LoadTownMapEntry
	pop hl
	ld a, [de]
	cp $19 ; Cerulean Cave's coordinates
	jr z, .nextEntry ; skip Cerulean Cave
	call TownMapCoordsToOAMCoords
	ld a, $4 ; nest icon tile no.
	ld [hli], a
	xor a
	ld [hli], a
.nextEntry
	inc de
	jr .loop
.exitLoop
	ld a, l
	and a
	jr nz, .drawPlayerSprite
	hlCoord 1, 7
	ld b, 2
	ld c, 15
	call TextBoxBorder
	hlCoord 2, 9
	ld de, AreaUnknownText
	call PlaceString
	jr .done
.drawPlayerSprite
	ld a, [W_CURMAP]
	ld b, $0
	call DrawPlayerOrBirdSprite
.done
	ld hl, wOAMBuffer
	ld de, wTileMapBackup
	ld bc, $a0
	jp CopyData

AreaUnknownText:
	db " Area unknown@"

TownMapCoordsToOAMCoords:
; in: lower nybble of a = x, upper nybble of a = y
; out: b and [hl] = (y * 8) + 24, c and [hl+1] = (x * 8) + 24
	push af
	and $f0
	srl a
	add 24
	ld b, a
	ld [hli], a
	pop af
	and $f
	swap a
	srl a
	add 24
	ld c, a
	ld [hli], a
	ret

WritePlayerOrBirdSpriteOAM:
	ld a, [wcd5b]
	and a
	ld hl, wOAMBuffer + $90
	jr z, WriteTownMapSpriteOAM
	ld hl, wOAMBuffer + $80

WriteTownMapSpriteOAM:
	push hl
	ld hl, $fcfc
	add hl, bc
	ld b, h
	ld c, l
	pop hl

WriteAsymmetricMonPartySpriteOAM:
; Writes 4 OAM blocks for a helix mon party sprite, since it does not have
; a vertical line of symmetry.
	ld de, $202
.loop
	push de
	push bc
.innerLoop
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, [wcd5b]
	ld [hli], a
	inc a
	ld [wcd5b], a
	xor a
	ld [hli], a
	inc d
	ld a, 8
	add c
	ld c, a
	dec e
	jr nz, .innerLoop
	pop bc
	pop de
	ld a, 8
	add b
	ld b, a
	dec d
	jr nz, .loop
	ret

WriteSymmetricMonPartySpriteOAM:
; Writes 4 OAM blocks for a mon party sprite other than a helix. All the
; sprites other than the helix one have a vertical line of symmetry which allows
; the X-flip OAM bit to be used so that only 2 rather than 4 tile patterns are
; needed.
	xor a
	ld [wcd5c], a
	lb de, 2, 2
.loop
	push de
	push bc
.innerLoop
	ld a, b
	ld [hli], a ; Y
	ld a, c
	ld [hli], a ; X
	ld a, [wcd5b]
	ld [hli], a ; tile
	ld a, [wcd5c]
	ld [hli], a ; attributes
	xor $20
	ld [wcd5c], a
	inc d
	ld a, 8
	add c
	ld c, a
	dec e
	jr nz, .innerLoop
	pop bc
	pop de
	push hl
	ld hl, wcd5b
	inc [hl]
	inc [hl]
	pop hl
	ld a, 8
	add b
	ld b, a
	dec d
	jr nz, .loop
	ret

ZeroOutDuplicatesInList:
; replace duplicate bytes in the list of wild pokemon locations with 0
	ld de, wHPBarMaxHP
.loop
	ld a, [de]
	inc de
	cp $ff
	ret z
	ld c, a
	ld l, e
	ld h, d
.zeroDuplicatesLoop
	ld a, [hl]
	cp $ff
	jr z, .loop
	cp c
	jr nz, .skipZeroing
	xor a
	ld [hl], a
.skipZeroing
	inc hl
	jr .zeroDuplicatesLoop

LoadTownMapEntry:
; in: a = map number
; out: lower nybble of [de] = x, upper nybble of [de] = y, hl = address of name
	cp REDS_HOUSE_1F
	jr c, .external
	ld bc, 4
	ld hl, InternalMapEntries
.loop
	cp [hl]
	jr c, .foundEntry
	jr z, .foundEntry ; works on exact entry too
	add hl, bc
	jr .loop
.foundEntry
	inc hl
	jr .readEntry
.external
	ld hl, ExternalMapEntries
	ld c, a
	ld b, $0
	add hl, bc
	add hl, bc
	add hl, bc
.readEntry
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

INCLUDE "data/town_map_entries.asm"

INCLUDE "text/map_names.asm"

MonNestIcon:
	INCBIN "gfx/mon_nest_icon.1bpp"
MonNestIconEnd:

TownMapSpriteBlinkingAnimation:
	ld a, [wTownMapSpriteBlinkingCounter]
	inc a
	cp 25
	jr z, .hideSprites
	cp 50
	jr nz, .done
; show sprites when the counter reaches 50
	ld hl, wTileMapBackup
	ld de, wOAMBuffer
	ld bc, $90
	call CopyData
	xor a
	jr .done
.hideSprites
	ld hl, wOAMBuffer
	ld b, $24
	ld de, $4
.hideSpritesLoop
	ld [hl], $a0
	add hl, de
	dec b
	jr nz, .hideSpritesLoop
	ld a, 25
.done
	ld [wTownMapSpriteBlinkingCounter], a
	jp DelayFrame
