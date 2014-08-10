part of funwithstreamslib;

class CharacterList extends DisplayObjectContainer
{
	
	Initiative initiative;
	ResourceManager resourceManager;
	
	CharacterList(this.initiative, this.resourceManager)
	{
		init();
	}
	
	void init()
	{
        
		num startXBar = 208;
		num startYBar = 316;
		
		num startXPlayer = 374;
        num startYPlayer = 174;
		
		initiative.players.forEach((Player player)
		{
			// create bar
			BattleTimerBar bar = new BattleTimerBar();
	    	addChild(bar);
	    	bar.x = startXBar;
	    	bar.y = startYBar;
	    	startYBar += 24;
	    	
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
        	
        	
        	// create sprite
        	SpriteSheet sheet = getSpriteSheetForPlayerCharacterType(player);
        	addChild(sheet);
        	sheet.init();
        	sheet.x = startXPlayer;
        	sheet.y = startYPlayer;
        	startXPlayer += 16;
        	startYPlayer += 36;
		});
		
		initiative.stream.where((InitiativeEvent event)
		{
	
		});
	}
	
	SpriteSheet getSpriteSheetForPlayerCharacterType(Player player)
	{
		switch(player.characterType)
		{
			case Player.LOCKE:
				return new LockeSprite(resourceManager);
			
			case Player.TERRA:
				return new LockeSprite(resourceManager);
				
			case Player.SETZER:
				return new LockeSprite(resourceManager);
		}
		return null;
	}
	
//	void render(RenderState renderState)
//	{
//		super.render(renderState);
//	}
}
