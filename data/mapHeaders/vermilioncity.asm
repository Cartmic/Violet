VermilionCity_h: ; 0x18998 to 0x189ba (34 bytes) (bank=6) (id=5)
	db OVERWORLD
	db VERMILION_CITY_HEIGHT, VERMILION_CITY_WIDTH
	dw VermilionCityBlocks, VermilionCityTextPointers, VermilionCityScript
	db NORTH
	NORTH_MAP_CONNECTION ROUTE_14, ROUTE_14_WIDTH, ROUTE_14_HEIGHT, 3, 0, 10, Route14Blocks
	dw VermilionCityObject
