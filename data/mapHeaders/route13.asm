Route13_h: ; 0x5480c to 0x5482e (34 bytes) (id=24)
	db OVERWORLD
	db ROUTE_13_HEIGHT, ROUTE_13_WIDTH
	dw Route13Blocks, Route13TextPointers, Route13Script
	db SOUTH | EAST
	SOUTH_MAP_CONNECTION ROUTE_12, ROUTE_12_WIDTH, 0, 0, 10, Route12Blocks, ROUTE_13_WIDTH, ROUTE_13_HEIGHT
	EAST_MAP_CONNECTION CERULEAN_CITY, CERULEAN_CITY_WIDTH, -3, 1, 15, CeruleanCityBlocks, ROUTE_13_WIDTH
	dw Route13Object
