LavenderTown_h: ; 0x44000 to 0x4402d (45 bytes) (bank=11) (id=4)
	db OVERWORLD
	db LAVENDER_TOWN_HEIGHT, LAVENDER_TOWN_WIDTH
	dw LavenderTownBlocks, LavenderTownTextPointers, LavenderTownScript
	db NORTH | SOUTH | EAST
	NORTH_MAP_CONNECTION ROUTE_2, ROUTE_2_WIDTH, ROUTE_2_HEIGHT, 0, 0, 10, Route2Blocks
	SOUTH_MAP_CONNECTION ROUTE_6, ROUTE_6_WIDTH, 0, 0, 10, Route6Blocks, LAVENDER_TOWN_WIDTH, LAVENDER_TOWN_HEIGHT
	EAST_MAP_CONNECTION ROUTE_22, ROUTE_22_WIDTH, 0, 0, 9, Route22Blocks, LAVENDER_TOWN_WIDTH
	dw LavenderTownObject
