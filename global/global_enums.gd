extends Node

enum Pocket { 
	TL, 
	BL, 
	TR, 
	BR, 
	TC, 
	BC,
	SPAWNED
} 

enum BallType{
	NORMAL = 0, 
	EXPLOSION,
	POCKET
}

enum BallAvailability{
	AVAILABLE,
	UNAVAILABLE,
	UNDISCOVERED
}

enum LoadAnim {
	FADE,
	SPECIAL
}

enum Destination {
	NEXT,
	MAIN_MENU,
	LEVEL_SELECT
}
