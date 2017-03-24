Route1_h: ; 0x1c0c3 to 0x1c0e5 (34 bytes) (bank=7) (id=12)
	db OVERWORLD
	db ROUTE_1_HEIGHT, ROUTE_1_WIDTH
	dw Route1Blocks, Route1TextPointers, Route1Script
	db NORTH | SOUTH
	NORTH_MAP_CONNECTION ROUTE_4, ROUTE_4_WIDTH, ROUTE_4_HEIGHT, 0, 0, 13, Route4Blocks
	SOUTH_MAP_CONNECTION CERULEAN_CITY, CERULEAN_CITY_WIDTH, -3, 2, 16, CeruleanCityBlocks, ROUTE_1_WIDTH, ROUTE_1_HEIGHT
	dw Route1Object
