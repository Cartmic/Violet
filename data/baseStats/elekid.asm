ElekidBaseStats: ; 3916e (e:516e)
db DEX_ELEKID ; pokedex id
db 45 ; base hp
db 63 ; base attack
db 37 ; base defense
db 95 ; base speed
db 65 ; base special
db ELECTRIC ; species type 1
db ELECTRIC ; species type 2
db 45 ; catch rate
db 156 ; base exp yield
INCBIN "pic/bmon/elekid.pic",0,1 ; 66, sprite dimensions
dw ElekidPicFront
dw ElekidPicBack
; attacks known at lvl 0
db QUICK_ATTACK
db LEER
db 0
db 0
db 0 ; growth rate
; learnset
db %10110001
db %01000011
db %10001111
db %11110001
db %11000111
db %00111000
db %01100010
db BANK(ElekidPicFront)
