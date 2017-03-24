FuchsiaCity_h: ; 0x18ba7 to 0x18bd4 (45 bytes) (bank=6) (id=7)
	db OVERWORLD
	db FUCHSIA_CITY_HEIGHT, FUCHSIA_CITY_WIDTH
	dw FuchsiaCityBlocks, FuchsiaCityTextPointers, FuchsiaCityScript
	db NORTH | WEST
	NORTH_MAP_CONNECTION ROUTE_10, ROUTE_10_WIDTH, ROUTE_10_HEIGHT, 6, 0, 10, Route10Blocks
	WEST_MAP_CONNECTION ROUTE_20, ROUTE_20_WIDTH, 5, 0, 9, Route20Blocks, FUCHSIA_CITY_WIDTH
	dw FuchsiaCityObject
