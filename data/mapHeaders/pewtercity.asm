PewterCity_h: ; 0x18554 to 0x18576 (34 bytes) (bank=6) (id=2)
	db OVERWORLD
	db PEWTER_CITY_HEIGHT, PEWTER_CITY_WIDTH
	dw PewterCityBlocks, PewterCityTextPointers, PewterCityScript
	db NORTH | SOUTH
	NORTH_MAP_CONNECTION ROUTE_6, ROUTE_6_WIDTH, ROUTE_6_HEIGHT, 5, 0, 10, Route6Blocks
	SOUTH_MAP_CONNECTION ROUTE_21, ROUTE_21_WIDTH, 5, 0, 10, Route21Blocks, PEWTER_CITY_WIDTH, PEWTER_CITY_HEIGHT
	dw PewterCityObject

	db $0
