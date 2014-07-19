part of funwithstreamslib;

class BattleTimerEvent
{
	static const String STARTED = "started";
	static const String PAUSED = "paused";
	static const String RESET = "reset";
	static const String PROGRESS = "progress";
	static const String COMPLETE = "complete";
	
	String type;
	BattleTimer target;
	
	BattleTimerEvent(this.type, this.target)
	{
	}
}