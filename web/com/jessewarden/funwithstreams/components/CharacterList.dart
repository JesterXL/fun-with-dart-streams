part of funwithstreamslib;

class CharacterList extends DisplayObjectContainer
{
	
	Initiative initiative;
	
	CharacterList(this.initiative)
	{
		init();
	}
	
	void init()
	{
		initiative.players.forEach((Player player)
		{
			BattleTimerBar bar = new BattleTimerBar();
	    	addChild(bar);
	    	
//	    	BattleTimer timer = new BattleTimer(gameLoop.stream, BattleTimer.MODE_CHARACTER);
//	    	gameLoop.start();
//	    	timer.start();
//	    	timer.stream
//	    	.where((BattleTimerEvent event)
//	    	{
//	    		return event.type == BattleTimerEvent.PROGRESS;
//	    	})
//	    	.listen((BattleTimerEvent event)
//	    	{
//	    		bar.percentage = event.percentage;
//	    	});
		});
		
		initiative.stream.where((InitiativeEvent event)
		{
	
		});
	}
	
	void render(RenderState renderState)
	{
		super.render(renderState);
//		if(percentageDirty)
//		{
//			percentageDirty = false;
//			green.width = 100 * _percentage;
//		}
	}
}
