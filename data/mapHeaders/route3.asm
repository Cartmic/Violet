Route3_h: ; 0x541e6 to 0x54208 (34 bytes) (id=14)
	db OVERWORLD
	db ROUTE_3_HEIGHT, ROUTE_3_WIDTH
	dw Route3Blocks, Route3TextPointers, Route3Script
	db NORTH | WEST
	NORTH_MAP_CONNECTION ROUTE_4, ROUTE_4_WIDTH, ROUTE_4_HEIGHT, 20, 0, 13, Route4Blocks
	WEST_MAP_CONNECTION PEWTER_CITY, PEWTER_CITY_WIDTH, -3, 1, 15, PewterCityBlocks, ROUTE_3_WIDTH
	dw Route3Object
