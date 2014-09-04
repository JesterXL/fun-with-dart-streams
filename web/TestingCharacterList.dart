import 'dart:core';
import 'dart:async';
import 'dart:html' as html;
import 'com/jessewarden/funwithstreams/funwithstreamslib.dart';
import 'package:observe/observe.dart';
import 'package:stagexl/stagexl.dart';

class TestingCharacterList
{

	Stage stage;
	
	Future createMenu()
	{
		return new Future(()
		{
			Completer complete = new Completer();
			ObservableList<MenuItem> items = new ObservableList<MenuItem>();
			items.add(new MenuItem("Fight"));
			items.add(new MenuItem("Magic"));
			items.add(new MenuItem("Items"));
			
			Menu menu = new Menu(300, 280, items);
		    stage.addChild(menu);
		    menu.x = 20;
		    menu.y = 20;
		    menu.stream.listen((String itemName)
			{
		    	complete.complete(itemName);
			});
		    return complete.future;
		});
	}

	void init()
	{
		stage = new Stage(html.querySelector('#stage'), webGL: false);
	//    stage.scaleMode = StageScaleMode.SHOW_ALL;
	//    stage.align = StageAlign.NONE;
		RenderLoop renderLoop = new RenderLoop();
		renderLoop.addStage(stage);
		
		StreamController _menuStreamController = new StreamController();
		Stream menuStream = _menuStreamController.stream;
		menuStream.listen((_)
		{
			return createMenu();
		});
		
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
		monsters.add(new Monster());
		monsters.add(new Monster());
		monsters.add(new Monster());
		
		Initiative initiative = new Initiative(loop.stream, players, monsters);
		initiative.stream.where((InitiativeEvent event)
		{
			return event.type == InitiativeEvent.CHARACTER_READY;
		})
		.listen((InitiativeEvent event)
		{
			
		});
		
		ResourceManager resourceManager = new ResourceManager();
		CharacterList characterList = new CharacterList(initiative, resourceManager);
	    stage.addChild(characterList);
	    
	    Shape fadeShapeScreen = new Shape();
	    fadeShapeScreen.graphics.rect(0, 0, 480, 420);
	    fadeShapeScreen.graphics.fillColor(Color.Black);
	    stage.addChild(fadeShapeScreen);
	    
	    resourceManager.addBitmapData("battleTintTop", "design/battle-tint-top.png");
	    resourceManager.addBitmapData("battleTintBottom", "design/battle-tint-bottom.png");
	    
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
	//		soundChannel.on("completeEvent").listen((_)
	//		{
	//			print("um...");
	//		});
	//		print("engine: " + SoundMixer.engine);
	//		WebAudioApiMixer.audioContext.onComplete.listen((_)
	//		{
	//			print("sup");
	//		});
			// can't find out why the above don't work.
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