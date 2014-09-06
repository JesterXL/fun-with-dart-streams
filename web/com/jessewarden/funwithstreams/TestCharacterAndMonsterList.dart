part of funwithstreamslib;

class TestCharacterAndMonsterList
{
	
	Stage stage;
	RenderLoop renderLoop;
	ResourceManager resourceManager;
	CursorFocusManager cursorManager;
	
	TestCharacterAndMonsterList(this.stage, this.renderLoop, this.resourceManager, this.cursorManager)
	{
		init();
	}
	
	void init()
	{
		Shape border = new Shape();
		border.graphics.rect(0, 0, 480, 420);
		border.graphics.strokeColor(Color.Black);
		stage.addChild(border);
		
	    GameLoop loop = new GameLoop();
		loop.start();
		
		ObservableList<Player> players = new ObservableList<Player>();
		players.add(new Player(Player.LOCKE));
		players.add(new Player(Player.TERRA));
		players.add(new Player(Player.SETZER));
		
		ObservableList<Monster> monsters = new ObservableList<Monster>();
		monsters.add(new Monster(Monster.TYPE_LEAFER));
		monsters.add(new Monster(Monster.TYPE_LEAFER));
		monsters.add(new Monster(Monster.TYPE_LEAFER));
		
		Initiative initiative = new Initiative(loop.stream, players, monsters);
		initiative.stream.where((event)
		{
			return event is InitiativeEvent &&
					event.type == InitiativeEvent.CHARACTER_READY;
		})
		.listen((event)
		{
			print("character ready: $event");
		});
		
		CharacterList characterList = new CharacterList(initiative: initiative, 
														resourceManager: resourceManager,
														stage: stage,
														renderLoop: renderLoop);
	    stage.addChild(characterList);
	    
	    MonsterList monsterList = new MonsterList(initiative: initiative, 
														resourceManager: resourceManager,
														stage: stage,
														renderLoop: renderLoop);
	    stage.addChild(monsterList);
	    
	    Shape fadeShapeScreen = new Shape();
	    fadeShapeScreen.graphics.rect(0, 0, 480, 420);
	    fadeShapeScreen.graphics.fillColor(Color.Black);
	    stage.addChild(fadeShapeScreen);
	    
	    resourceManager.addBitmapData("battleTintTop", "design/battle-tint-top.png");
	    resourceManager.addBitmapData("battleTintBottom", "design/battle-tint-bottom.png");
	    //resourceManager.addBitmapData(Monster.TYPE_LEAFER, "design/spritesheets/monsters/" + Monster.TYPE_LEAFER + ".png");
	    resourceManager.addBitmapData("Leafer", "design/spritesheets/monsters/Leafer.png");
	    
		resourceManager.addSound("battleTheme", "audio/battle-theme.mp3");
		resourceManager.addSound("encounter", "audio/encounter.mp3");
		
		SoundTransform soundTransform = new SoundTransform(0.1);
		Bitmap topTint;
		Bitmap bottomTint;
		resourceManager.load()
		.then((_)
		{
			topTint = new Bitmap(resourceManager.getBitmapData("battleTintTop"));
			bottomTint = new Bitmap(resourceManager.getBitmapData("battleTintBottom"));
			stage.addChild(topTint);
			bottomTint.y = 94;
			stage.addChild(bottomTint);
			
			Sound sound = resourceManager.getSound("encounter");
			SoundChannel soundChannel = sound.play(false, soundTransform);
			num milliseconds = sound.length * 1000;
			return new Future.delayed(new Duration(milliseconds: milliseconds.ceil()), ()
			{
				return true;
			});
		})
		.then((_)
		{
			var sound = resourceManager.getSound("battleTheme");
	        var soundChannel = sound.play(true, soundTransform);
	        
	        
	        var tween = new Tween(fadeShapeScreen, 0.8, TransitionFunction.easeOutExponential);
	        tween.animate.alpha.to(0);
	        tween.onComplete = () => fadeShapeScreen.removeFromParent();
	        
	        const double TINT_FADE_TIME = 1.0;
	        
	        var topTintTween = new Tween(topTint, TINT_FADE_TIME, TransitionFunction.easeOutExponential);
	        topTintTween.animate.alpha.to(0);
	        topTintTween.animate.y.to(-200);
	        topTintTween.delay = 0.1;
	        topTintTween.onComplete = () => topTint.removeFromParent();
	        
	        var bottomTintTween = new Tween(bottomTint, TINT_FADE_TIME, TransitionFunction.easeOutExponential);
	        bottomTintTween.animate.alpha.to(0);
	        bottomTintTween.animate.y.to(294);
	        bottomTintTween.delay = 0.1;
	        bottomTintTween.onComplete = () => bottomTint.removeFromParent();
	        
	        stage.setChildIndex(fadeShapeScreen, stage.numChildren - 1);
	
	        renderLoop.juggler.addGroup([tween, topTintTween, bottomTintTween]);
		});
	}
}