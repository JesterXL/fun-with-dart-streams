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
        
		num startY = 0;
		initiative.players.forEach((Player player)
		{
			BattleTimerBar bar = new BattleTimerBar();
	    	addChild(bar);
	    	bar.y = startY;
	    	startY += 40;
	    	
	    	BattleTimer timer = new BattleTimer(initiative.gameLoopStream, BattleTimer.MODE_CHARACTER);
        	timer.start();
        	timer.stream
        	.where((BattleTimerEvent event)
        	{
        		return event.type == BattleTimerEvent.PROGRESS;
        	})
        	.listen((BattleTimerEvent event)
        	{
        		bar.percentage = event.percentage;
        	});
		});
		
		initiative.stream.where((InitiativeEvent event)
		{
	
		});
	}
	
//	void render(RenderState renderState)
//	{
//		super.render(renderState);
//	}
}
