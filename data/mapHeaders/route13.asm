Route13_h: ; 0x5480c to 0x5482e (34 bytes) (id=24)
	db OVERWORLD
	db ROUTE_13_HEIGHT, ROUTE_13_WIDTH
	dw Route13Blocks, Route13TextPointers, Route13Script
	db NORTH | WEST
	NORTH_MAP_CONNECTION ROUTE_12, ROUTE_12_WIDTH, ROUTE_12_HEIGHT, 13, 0, 10, Route12Blocks
	WEST_MAP_CONNECTION ROUTE_14, ROUTE_14_WIDTH, 0, 0, 12, Route14Blocks, ROUTE_13_WIDTH
	dw Route13Object
