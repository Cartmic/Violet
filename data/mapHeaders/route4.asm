Route4_h: ; 0x54390 to 0x543b2 (34 bytes) (id=15)
	db OVERWORLD
	db ROUTE_4_HEIGHT, ROUTE_4_WIDTH
	dw Route4Blocks, Route4TextPointers, Route4Script
	db NORTH | SOUTH | EAST
	NORTH_MAP_CONNECTION ROUTE_5, ROUTE_5_WIDTH, ROUTE_5_HEIGHT, 35, 0, 10, Route5Blocks
	SOUTH_MAP_CONNECTION ROUTE_1, ROUTE_1_WIDTH, 0, 0, 10, Route1Blocks, ROUTE_4_WIDTH, ROUTE_4_HEIGHT
	EAST_MAP_CONNECTION CINNABAR_ISLAND, CINNABAR_ISLAND_WIDTH, 0, 0, 9, CinnabarIslandBlocks, ROUTE_4_WIDTH
	dw Route4Object
