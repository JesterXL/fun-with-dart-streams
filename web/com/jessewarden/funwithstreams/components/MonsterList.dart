part of funwithstreamslib;

class MonsterList extends DisplayObjectContainer
{
	
	Initiative initiative;
	ResourceManager resourceManager;
	Stage stage;
	RenderLoop renderLoop;
	
	TextDropper _textDropper;
	
	MonsterList({Initiative this.initiative,
				ResourceManager this.resourceManager,
				Stage this.stage,
				RenderLoop this.renderLoop})
	{
		resourceManager.load().then((_)
		{
			init();
		});
	}
	
	void init()
	{
        _textDropper = new TextDropper(stage, renderLoop);
        
		num startXMonster = 0;
        num startYMonster = 120;
        // flying can be higher...
        
        // range: 280x172
        
        num startXName = 16;
        num startYName = 318;
		
		initiative.monsters.forEach((Monster monster)
		{
			// create name
			TextField nameField = new TextField();
			nameField.defaultTextFormat = new TextFormat('Final Fantasy VI SNESa', 36, Color.Black);
			nameField.text = monster.monsterType;
			nameField.x = startXName;
			nameField.y = startYName - 40 + 15;
			nameField.width = 200;
            nameField.height = 40;
            startYName += 24;
            nameField.wordWrap = false;
            nameField.multiline = false;
            addChild(nameField);
			
	    	initiative.stream
        	.where((event)
        	{
	    		return event is InitiativeEvent &&
	    				event.type == InitiativeEvent.CHARACTER_READY;
        	})
        	.listen((event)
        	{
        		// TODO: AI here
        		print("monster ready: $event");
        	});
        	
        	// create sprite
        	Bitmap bitmap = new Bitmap(getBitmapForMonsterType(monster));
        	addChild(bitmap);
        	bitmap.x = startXMonster;
        	bitmap.y = startYMonster;
        	startXMonster += 16;
        	startYMonster += 36;
        	
        	monster.stream.listen((CharacterEvent event)
			{
				if(event.type == CharacterEvent.HIT_POINTS_CHANGED)
				{
					int color;
					if(event.changeAmount < 0)
					{
						color = Color.White;
					}
					else
					{
						color = Color.Green;
					}
					_textDropper.addTextDrop(bitmap, event.changeAmount, color: color);
				}
			});
		});
	}
	
	BitmapData getBitmapForMonsterType(Monster monster)
	{
		switch(monster.monsterType)
		{
			case Monster.TYPE_LEAFER:
				return resourceManager.getBitmapData(Monster.TYPE_LEAFER);
		}
		return null;
	}
	
//	void render(RenderState renderState)
//	{
//		super.render(renderState);
//	}
}
