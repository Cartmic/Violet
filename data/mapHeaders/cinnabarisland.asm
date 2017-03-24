CinnabarIsland_h: ; 0x1c000 to 0x1c022 (34 bytes) (bank=7) (id=8)
	db OVERWORLD
	db CINNABAR_ISLAND_HEIGHT, CINNABAR_ISLAND_WIDTH
	dw CinnabarIslandBlocks, CinnabarIslandTextPointers, CinnabarIslandScript
	db WEST | EAST
	WEST_MAP_CONNECTION ROUTE_4, ROUTE_4_WIDTH, 0, 0, 9, Route4Blocks, CINNABAR_ISLAND_WIDTH
	EAST_MAP_CONNECTION ROUTE_9, ROUTE_9_WIDTH, 0, 0, 9, Route9Blocks, CINNABAR_ISLAND_WIDTH
	dw CinnabarIslandObject
