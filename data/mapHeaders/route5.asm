Route5_h: ; 0x54581 to 0x545a3 (34 bytes) (id=16)
	db OVERWORLD
	db ROUTE_5_HEIGHT, ROUTE_5_WIDTH
	dw Route5Blocks, Route5TextPointers, Route5Script
	db NORTH | SOUTH
	NORTH_MAP_CONNECTION CERULEAN_CITY, CERULEAN_CITY_WIDTH, CERULEAN_CITY_HEIGHT, -3, 2, CERULEAN_CITY_WIDTH-4, CeruleanCityBlocks
	SOUTH_MAP_CONNECTION ROUTE_4, ROUTE_4_WIDTH, -3, 32, 13, Route4Blocks, ROUTE_5_WIDTH, ROUTE_5_HEIGHT
	dw Route5Object
