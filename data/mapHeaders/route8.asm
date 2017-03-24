Route8_h: ; 0x5812d to 0x5814f (34 bytes) (id=19)
	db OVERWORLD
	db ROUTE_8_HEIGHT, ROUTE_8_WIDTH
	dw Route8Blocks, Route8TextPointers, Route8Script
	db WEST | EAST
	WEST_MAP_CONNECTION CERULEAN_CITY, CERULEAN_CITY_WIDTH, -3, 1, 15, CeruleanCityBlocks, ROUTE_8_WIDTH
	EAST_MAP_CONNECTION ROUTE_2, ROUTE_2_WIDTH, 0, 0, 9, Route2Blocks, ROUTE_8_WIDTH
	dw Route8Object
