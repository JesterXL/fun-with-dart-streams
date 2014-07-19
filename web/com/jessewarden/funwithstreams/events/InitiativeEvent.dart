part of funwithstreamslib;

class InitiativeEvent
{
	static const String CHARACTER_READY = "characterReady";
	static const String PAUSED = "paused";
	
	String type;
	Character character;
	
	InitiativeEvent(this.type, this.character)
	{
	}
}