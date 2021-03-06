DayCareMScript:
	jp EnableAutoTextBoxDrawing

DayCareMTextPointers:
	dw DayCareMText1 ; Day Care Lady
	dw DayCareMText2 ; Day Care Man
	dw DayCareMText3 ; Day Care Helper

DayCareMText1: ; Day Care Lady
	TX_ASM
	call SaveScreenTilesToBuffer2
	ld a, [wDayCareInUse]
	bit 0, a
	jp nz, .daycareInUse
	ld hl, DayCareIntroText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ld hl, DayCareComeAgainText
	jp nz, .done
	ld a, [wPartyCount]
	dec a
	ld hl, DayCareOnlyHaveOneMonText
	jp z, .done
	ld hl, DayCareWhichMonText
	call PrintText
	xor a
	ld [wUpdateSpritesEnabled], a
	ld [wd07d], a
	ld [wMenuItemToSwap], a
	call DisplayPartyMenu
	push af
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadGBPal
	pop af
	ld hl, DayCareAllRightThenText
	jp c, .done
	callab Func_2171b
	ld hl, DayCareCantAcceptMonWithHMText
	jp c, .done
	xor a
	ld [wcc2b], a
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	ld hl, DayCareWillLookAfterMonText
	call PrintText
	ld hl, wDayCareInUse
	set 0, [hl]
	ld a, $3
	ld [wcf95], a
	call Func_3a68
	xor a
	ld [wcf95], a
	call RemovePokemon
	ld a, [wcf91]
	call PlayCry
	ld hl, DayCareComeSeeMeInAWhileText
	jp .done

.daycareInUse
	xor a
	ld hl, wDayCareMonName
	call GetPartyMonName
	ld a, $3
	ld [wcc49], a
	call LoadMonData
	callab CalcLevelFromExperience
	ld a, d
	cp MAX_LEVEL
	jr c, .skipCalcExp
	ld d, MAX_LEVEL
	callab CalcExperience
	ld hl, wDayCareMonExp
	ld a, [H_NUMTOPRINT]
	ld [hli], a
	ld a, [$ff97]
	ld [hli], a
	ld a, [$ff98]
	ld [hl], a
	ld d, MAX_LEVEL

.skipCalcExp
	xor a
	ld [wTrainerEngageDistance], a
	ld hl, wDayCareMonBoxLevel
	ld a, [hl]
	ld [wTrainerSpriteOffset], a
	cp d
	ld [hl], d
	ld hl, DayCareMonNeedsMoreTimeText
	jr z, .next
	ld a, [wTrainerSpriteOffset]
	ld b, a
	ld a, d
	sub b
	ld [wTrainerEngageDistance], a
	ld hl, DayCareMonHasGrownText

.next
	call PrintText
	ld a, [wPartyCount]
	cp PARTY_LENGTH
	ld hl, DayCareNoRoomForMonText
	jp z, .leaveMonInDayCare
	ld de, wTrainerFacingDirection
	xor a
	ld [de], a
	inc de
	ld [de], a
	ld hl, wTrainerScreenX
	ld a, $1
	ld [hli], a
	ld [hl], $0
	ld a, [wTrainerEngageDistance]
	inc a
	ld b, a
	ld c, $2
.calcPriceLoop
	push hl
	push de
	push bc
	predef AddBCDPredef
	pop bc
	pop de
	pop hl
	dec b
	jr nz, .calcPriceLoop
	ld hl, DayCareOweMoneyText
	call PrintText
	ld a, $13
	ld [wTextBoxID], a
	call DisplayTextBoxID
	call YesNoChoice
	ld hl, DayCareAllRightThenText
	ld a, [wCurrentMenuItem]
	and a
	jp nz, .leaveMonInDayCare
	ld hl, wTrainerFacingDirection
	ld [$ff9f], a
	ld a, [hli]
	ld [$ffa0], a
	ld a, [hl]
	ld [$ffa1], a
	call HasEnoughMoney
	jr nc, .enoughMoney
	ld hl, DayCareNotEnoughMoneyText
	jp .leaveMonInDayCare

.enoughMoney
	ld hl, wDayCareInUse
	res 0, [hl]
	xor a
	ld hl, wTrainerEngageDistance
	ld [hli], a
	inc hl
	ld de, wPlayerMoney + 2
	ld c, $3
	predef SubBCDPredef
	ld a, (SFX_02_5a - SFX_Headers_02) / 3
	call PlaySoundWaitForCurrent
	ld a, $13
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, DayCareHeresYourMonText
	call PrintText
	ld a, $2
	ld [wcf95], a
	call Func_3a68
	ld a, [wDayCareMonSpecies]
	ld [wcf91], a
	ld a, [wPartyCount]
	dec a
	push af
	ld bc, wPartyMon2 - wPartyMon1
	push bc
	ld hl, wPartyMon1Moves
	call AddNTimes
	ld d, h
	ld e, l
	ld a, $1
	ld [wHPBarMaxHP], a
	predef WriteMonMoves
	pop bc
	pop af

; set mon's HP to max
	ld hl, wPartyMon1HP
	call AddNTimes
	ld d, h
	ld e, l
	ld bc, wPartyMon1MaxHP - wPartyMon1HP
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld a, [wcf91]
	call PlayCry
	ld hl, DayCareGotMonBackText
	jr .done

.leaveMonInDayCare
	ld a, [wTrainerSpriteOffset]
	ld [wDayCareMonBoxLevel], a

.done
	call PrintText
	jp TextScriptEnd


DayCareMText2: ; Day Care Man
	TX_ASM
	call SaveScreenTilesToBuffer2
	ld a, [wDayCareInUse]
	bit 1, a
	jp nz, .daycareInUse
	ld hl, DayCareIntroText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ld hl, DayCareComeAgainText
	jp nz, .done
	ld a, [wPartyCount]
	dec a
	ld hl, DayCareOnlyHaveOneMonText
	jp z, .done
	ld hl, DayCareWhichMonText
	call PrintText
	xor a
	ld [wUpdateSpritesEnabled], a
	ld [wd07d], a
	ld [wMenuItemToSwap], a
	call DisplayPartyMenu
	push af
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadGBPal
	pop af
	ld hl, DayCareAllRightThenText
	jp c, .done
	callab Func_2171b
	ld hl, DayCareCantAcceptMonWithHMText
	jp c, .done
	xor a
	ld [wcc2b], a
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	ld hl, DayCareWillLookAfterMonText
	call PrintText
	ld hl, wDayCareInUse
	set 1, [hl]
	ld a, $4
	ld [wcf95], a
	call Func_3a68
	xor a
	ld [wcf95], a
	call RemovePokemon
	ld a, [wcf91]
	call PlayCry
	ld hl, DayCareComeSeeMeInAWhileText
	jp .done

.daycareInUse
	xor a
	ld hl, wDayCareMon2Name
	call GetPartyMonName
	ld a, $4
	ld [wcc49], a
	call LoadMonData
	callab CalcLevelFromExperience
	ld a, d
	cp MAX_LEVEL
	jr c, .skipCalcExp
	ld d, MAX_LEVEL
	callab CalcExperience
	ld hl, wDayCareMon2Exp
	ld a, [H_NUMTOPRINT]
	ld [hli], a
	ld a, [$ff97]
	ld [hli], a
	ld a, [$ff98]
	ld [hl], a
	ld d, MAX_LEVEL

.skipCalcExp
	xor a
	ld [wTrainerEngageDistance], a
	ld hl, wDayCareMon2BoxLevel
	ld a, [hl]
	ld [wTrainerSpriteOffset], a
	cp d
	ld [hl], d
	ld hl, DayCareMonNeedsMoreTimeText
	jr z, .next
	ld a, [wTrainerSpriteOffset]
	ld b, a
	ld a, d
	sub b
	ld [wTrainerEngageDistance], a
	ld hl, DayCareMonHasGrownText

.next
	call PrintText
	ld a, [wPartyCount]
	cp PARTY_LENGTH
	ld hl, DayCareNoRoomForMonText
	jp z, .leaveMonInDayCare
	ld de, wTrainerFacingDirection
	xor a
	ld [de], a
	inc de
	ld [de], a
	ld hl, wTrainerScreenX
	ld a, $1
	ld [hli], a
	ld [hl], $0
	ld a, [wTrainerEngageDistance]
	inc a
	ld b, a
	ld c, $2
.calcPriceLoop
	push hl
	push de
	push bc
	predef AddBCDPredef
	pop bc
	pop de
	pop hl
	dec b
	jr nz, .calcPriceLoop
	ld hl, DayCareOweMoneyText
	call PrintText
	ld a, $13
	ld [wTextBoxID], a
	call DisplayTextBoxID
	call YesNoChoice
	ld hl, DayCareAllRightThenText
	ld a, [wCurrentMenuItem]
	and a
	jp nz, .leaveMonInDayCare
	ld hl, wTrainerFacingDirection
	ld [$ff9f], a
	ld a, [hli]
	ld [$ffa0], a
	ld a, [hl]
	ld [$ffa1], a
	call HasEnoughMoney
	jr nc, .enoughMoney
	ld hl, DayCareNotEnoughMoneyText
	jp .leaveMonInDayCare

.enoughMoney
	ld hl, wDayCareInUse
	res 1, [hl]
	xor a
	ld hl, wTrainerEngageDistance
	ld [hli], a
	inc hl
	ld de, wPlayerMoney + 2
	ld c, $3
	predef SubBCDPredef
	ld a, (SFX_02_5a - SFX_Headers_02) / 3
	call PlaySoundWaitForCurrent
	ld a, $13
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, DayCareHeresYourMonText
	call PrintText
	ld a, $5
	ld [wcf95], a
	call Func_3a68
	ld a, [wDayCareMon2Species]
	ld [wcf91], a
	ld a, [wPartyCount]
	dec a
	push af
	ld bc, wPartyMon2 - wPartyMon1
	push bc
	ld hl, wPartyMon1Moves
	call AddNTimes
	ld d, h
	ld e, l
	ld a, $1
	ld [wHPBarMaxHP], a
	predef WriteMonMoves
	pop bc
	pop af

; set mon's HP to max
	ld hl, wPartyMon1HP
	call AddNTimes
	ld d, h
	ld e, l
	ld bc, wPartyMon1MaxHP - wPartyMon1HP
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld a, [wcf91]
	call PlayCry
	ld hl, DayCareGotMonBackText2
	jr .done

.leaveMonInDayCare
	ld a, [wTrainerSpriteOffset]
	ld [wDayCareMon2BoxLevel], a

.done
	call PrintText
	jp TextScriptEnd



DayCareMText3: ; Breeder
	TX_ASM
	callba DayCareBreederScript
	jp TextScriptEnd



DayCareIntroText:
	TX_FAR _DayCareIntroText
	db "@"

DayCareWhichMonText:
	TX_FAR _DayCareWhichMonText
	db "@"

DayCareWillLookAfterMonText:
	TX_FAR _DayCareWillLookAfterMonText
	db "@"

DayCareComeSeeMeInAWhileText:
	TX_FAR _DayCareComeSeeMeInAWhileText
	db "@"

DayCareMonHasGrownText:
	TX_FAR _DayCareMonHasGrownText
	db "@"

DayCareOweMoneyText:
	TX_FAR _DayCareOweMoneyText
	db "@"

DayCareGotMonBackText:
	TX_FAR _DayCareGotMonBackText
	db "@"

DayCareGotMonBackText2:
	TX_FAR _DayCareGotMonBackText2
	db "@"

DayCareMonNeedsMoreTimeText:
	TX_FAR _DayCareMonNeedsMoreTimeText
	db "@"

DayCareAllRightThenText:
	TX_FAR _DayCareAllRightThenText
DayCareComeAgainText:
	TX_FAR _DayCareComeAgainText
	db "@"

DayCareNoRoomForMonText:
	TX_FAR _DayCareNoRoomForMonText
	db "@"

DayCareOnlyHaveOneMonText:
	TX_FAR _DayCareOnlyHaveOneMonText
	db "@"

DayCareCantAcceptMonWithHMText:
	TX_FAR _DayCareCantAcceptMonWithHMText
	db "@"

DayCareHeresYourMonText:
	TX_FAR _DayCareHeresYourMonText
	db "@"

DayCareNotEnoughMoneyText:
	TX_FAR _DayCareNotEnoughMoneyText
	db "@"
