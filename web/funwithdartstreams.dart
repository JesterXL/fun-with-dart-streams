import 'dart:core';
import 'dart:async';
import 'dart:html';
import 'com/jessewarden/funwithstreams/funwithstreamslib.dart';
import 'package:observe/observe.dart';
import 'package:stagexl/stagexl.dart';
import 'package:stream_ext/stream_ext.dart';
import 'TestingCharacterList.dart';

void main()
{
	print("main");
//	testGameLoop();
//	testBattleUtilsGetRandomNumber();
//	testGameLoopPauseResume();
//	testGameLoopStreams();
//	testPipe();
	
//	testAsyncExpand();
//	testPipe();
//	testAsyncListen();
//	testFuture();
//	testFutureStream();
//	testBattleTimer();
//	testBasicStreamsNoClasses();
//	testBasicController();
//	testStreamExt();
//	testObservableList();
//	testFutureWithDataAndStream();
	
//	testActionResult();
	
//	testInitiative();
//	testingLockeSprite();
//	testCharacterList();
	testCursorManager();
	
//	testMenu();
}

void testCursorManager()
{
	CanvasElement canvas = querySelector('#stage');
	canvas.context2D.imageSmoothingEnabled = true;
	Stage stage = new Stage(canvas, webGL: false);
	RenderLoop renderLoop = new RenderLoop();
	renderLoop.addStage(stage);
	ResourceManager resourceManager = new ResourceManager();
	GameLoop loop = new GameLoop();
    loop.start();
    
    ObservableList<MenuItem> items = new ObservableList<MenuItem>();
	items.add(new MenuItem("Uno"));
	items.add(new MenuItem("Dos"));
	items.add(new MenuItem("Tres"));
	
	Menu menu = new Menu(300, 280, items);
    stage.addChild(menu);
    menu.x = 20;
    menu.y = 20;
    
    CursorFocusManager manager = new CursorFocusManager(stage, resourceManager);
    resourceManager.load()
    .then((_)
    {
    	manager.targets.clear();
    	menu.hitAreas.forEach((DisplayObject item)
		{
			manager.targets.add(item);
		});
         manager.selectedIndex = 0;
    });
    
    stage.onKeyDown.listen((KeyboardEvent event)
	{
    	switch(event.keyCode)
    	{
    		case 38:
    			manager.previousTarget();
    			break;
    		
    		case 40:
    			manager.nextTarget();
    			break;
    	}
	});
    
    stage.focus = stage;
   
}

void testMenu()
{
	CanvasElement canvas = querySelector('#stage');
	canvas.context2D.imageSmoothingEnabled = true;
	Stage stage = new Stage(canvas, webGL: false);
	RenderLoop renderLoop = new RenderLoop();
	renderLoop.addStage(stage);
	
	Shape fadeShapeScreen = new Shape();
    fadeShapeScreen.graphics.rect(0, 0, 480, 420);
    fadeShapeScreen.graphics.fillColor(Color.Black);
    stage.addChild(fadeShapeScreen);
//   
//	Shape border = new Shape();
//	border.graphics.rectRound(0, 0, 300, 280, 6, 6);
//	border.graphics.fillColor(Color.Blue);
//	border.graphics.strokeColor(Color.White, 4);
//	stage.addChild(border);
//	border.x = 20;
//	border.y = 20;
	
	GameLoop loop = new GameLoop();
	loop.start();
	
	ObservableList<MenuItem> items = new ObservableList<MenuItem>();
	items.add(new MenuItem("Uno"));
	items.add(new MenuItem("Dos"));
	items.add(new MenuItem("Tres"));
	
	Menu menu = new Menu(300, 280, items);
    stage.addChild(menu);
    menu.x = 20;
    menu.y = 20;
    
    new Future.delayed(new Duration(seconds: 1), ()
	{
		items.add(new MenuItem("Quatro"));
		return new Future.delayed(new Duration(seconds: 3), ()
		{
			return true;
		});
	}).then((_)
	{
		items.removeAt(1);
	});
	
}

void testCharacterList()
{
	new TestingCharacterList();
}


void testingLockeSprite()
{
	Stage stage = new Stage(html.querySelector('#stage'), webGL: true);
    stage.scaleMode = StageScaleMode.SHOW_ALL;
    stage.align = StageAlign.NONE;
    
	RenderLoop renderLoop = new RenderLoop();
	ResourceManager resourceManager = new ResourceManager();
	
	 renderLoop.addStage(stage);
	 Juggler juggler = renderLoop.juggler;
	 
	 LockeSprite locke = new LockeSprite(resourceManager);
	 locke.x = 100;
	 locke.y = 50;
	 resourceManager.load()
		.then((_)
		{
			stage.addChild(locke);
			return locke.init();
		})
		.then((_)
		{
			return new Future.delayed(new Duration(seconds: 1), ()
			{
				locke.castingWest();
			});
		})
		.then((_)
		{
			return new Future.delayed(new Duration(seconds: 1), ()
			{
				locke.castSpellWest();
			});
		})
		.then((_)
		{
			return new Future.delayed(new Duration(seconds: 1), ()
			{
				locke.attackWest();
				
				var ac = new AnimationChain();
                ac.add(new Tween(locke, 0.5, TransitionFunction.linear)..animate.x.to(20));
                ac.add(new Tween(locke, 0.5, TransitionFunction.linear)..animate.x.to(100));
                juggler.add(ac);
                
               
			});
		})
		.then((_)
		{
			return new Future.delayed(new Duration(seconds: 1), ()
			{
				locke.idleWest();
			});
		})
		.catchError((e) => print(e));
}

void testInitiative()
{
	GameLoop loop = new GameLoop();
	loop.start();
	
	ObservableList<Player> players = new ObservableList<Player>();
	players.add(new Player());
	players.add(new Player());
	players.add(new Player());
	
	ObservableList<Monster> monsters = new ObservableList<Monster>();
	monsters.add(new Monster());
	monsters.add(new Monster());
	monsters.add(new Monster());
	
	Initiative initiative = new Initiative(loop.stream, players, monsters);
	initiative.init()
	.then((_)
	{
		print("then...");
		initiative.stream.listen((InitiativeEvent event)
    	{
    		print("event type: " + event.type.toString());
    	}).onError((error)
    	{
    		print("error: $error");
    		loop.pause();
    	});
	});
}

void testActionResult()
{
	ActionResult result = new ActionResult();
	print("result.hit: " + result.hit.toString());
}

void testFutureWithDataAndStream()
{
	List myList;
	List getList()
	{
		myList = new List();
		myList.add(1);
		myList.add(2);
		myList.add(3);
		return myList;
	}
	Future test = new Future(getList);
	test.then((_)
	{
		print("value: $_");
	});
	test.then((_)
	{
		print("naw man: $_");
	});
	
	Stream stream = new Stream.fromFuture(test);
	stream.listen((_)
	{
		print("ok, in stream: $_");
	});
	
	
}

void testObservableList()
{
	ObservableList list = new ObservableList();
//	list.add("uno");
//	list.add("dos");
	list.listChanges.listen((List<ListChangeRecord> listRecords)
	{
		print("data: $listRecords");
	});
	list.add("test");
	list.add("cow");
}

void testStreamExt()
{
	StreamController controller1 = new StreamController.broadcast();
	StreamController controller2 = new StreamController.broadcast();

	Stream merged  = StreamExt.merge(controller1.stream, controller2.stream);
    merged.listen((_)
	{
		print("merged listen: $_");
	});
    
    controller1.add("sup on 1");
    controller2.add("yo on 2");
}

void testBasicController()
{
	StreamController firstController = new StreamController();
	StreamController controller = new StreamController();
	
	print("first");
	controller.addStream(firstController.stream)
	.then((_)
	{
		print("second");
	});
	
	controller.stream.listen((_)
	{
		print("listen: $_");
	});
	
	new Future.delayed(new Duration(seconds: 1), ()
	{
		firstController.add("sup");
	});

	new Future.delayed(new Duration(seconds: 2), ()
	{
		controller.add("second sup");
	});

}

void testBasicStreamsNoClasses()
{
	print("testBasicStreamsNoClasses");
	List playerList = new List();
	playerList.add("first player");
	List monsterList = new List();
	monsterList.add("first monster");
	StreamController playersController = new StreamController.broadcast();
	StreamController controller;
	playersController.addStream(new Stream.fromIterable(playerList))
	.then((_)
	{
		print("added");
		controller = new StreamController.broadcast();
		return controller.addStream(playersController.stream);
	})
	.then((_)
	{
		print("ok, ready");
		controller.stream.listen((data)
	    {
			print("data: $data");
	    });
		playersController.add("test");
	});
//	playersController.add("sup cow moo");
	
}


void testBattleTimer()
{
	// setup the Stage and RenderLoop
	var canvas = html.querySelector('#stage');
	var stage = new Stage(canvas);
	var renderLoop = new RenderLoop();
	renderLoop.addStage(stage);
	
	BattleTimerBar bar = new BattleTimerBar();
	stage.addChild(bar);
	
	GameLoop gameLoop = new GameLoop();
	BattleTimer timer = new BattleTimer(gameLoop.stream, BattleTimer.MODE_CHARACTER);
	gameLoop.start();
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
}

class TestSink extends EventSink
{
	EventSink _outputSink;
	TestSink(this._outputSink);
	
	void add(data)
	{
		_outputSink.add(data);
	}
	
	void addError(e, [st]) => _outputSink.addError(e, st);
	void close() => _outputSink.close();
}

// Stream.periodic(Duration period, [Function T computation(int computationCount)])

void testFutureStream()
{
	Future mine = new Future.value(3);
	Future list = new Future.value([1, 2, 3]);
	Stream stream = new Stream.fromFuture(mine).asBroadcastStream();
	Stream listStream = new Stream.fromFuture(list).asBroadcastStream();
	stream.listen((value)
	{
		print("value: $value");
	});
}

void testFuture()
{
	Future mine = new Future.value(3);
	mine.then((value)
	{
		print("value: $value");
	});
	
	mine.then((value2)
	{
		print("value2: $value2");
	});
}

void testAsyncListen()
{
	Stream stream = new Stream.fromIterable([1, 2, 3, 4]);
	StreamController controller = new StreamController();
	controller.addStream(stream).then((_)
	{
		print("value: $_");
		controller.add(5);
		controller.stream.listen((_)
    	{
    		print("no really value: $_");
    	});
	});
	
	
}

void testPipe()
{
	Stream stream1 = new Stream.fromIterable([1, 2, 3, 4]);
	StreamController controller1 = new StreamController();
	
	print("sup");
	Stream stream2 = new Stream.fromIterable(["a", "b", "c", "d"]);
	StreamController controller = new StreamController();
	controller.stream.listen((_)
	{
		print("go: $_");
	});
	controller.addStream(stream1)
	.then((_)
	{
		return controller.addStream(stream2);
	})
	.then((_)
	{
		controller.add("cow");
	})
	.then((_)
	{
		controller1.add("moo");
	});
	
	/*
	Stream stream = new Stream.fromIterable([1, 2, 3]).asBroadcastStream();
	StreamController con = new StreamController.broadcast();
	stream.pipe(con).then((_)
	{
		print("pipe is done?");
	});
	*/
	
}

void testAsyncExpand()
{
	Stream stream1 = new Stream.fromIterable([1, 2, 3, 4]);
	Stream stream2 = new Stream.fromIterable(["a", "b", "c", "d"]);
	Stream stream3 = stream1.asyncExpand((streamValue)
	{
		return new Stream.fromIterable([streamValue]);
	});
	stream3.listen((somevalue)
	{
		print(somevalue);
	});
}

void testGameLoop()
{
	GameLoop gameLoop = new GameLoop();
  gameLoop.stream.listen((GameLoopEvent event)
  {
    print("event: " + event.type);
  });
	gameLoop.start();
	new Future.delayed(new Duration(milliseconds: 300), ()
	{
		gameLoop.pause();
	});
}

void testGameLoopPauseResume()
{
	GameLoop gameLoop = new GameLoop();
	gameLoop.stream.listen((GameLoopEvent event)
	{
		print("type: " + event.type);
	});
	gameLoop.start();
	
	new Future.delayed(new Duration(seconds: 1), ()
	{
		print("pausing gameloop...");
		gameLoop.pause();
		return new Future.delayed(new Duration(seconds: 1));
	})
	.then((_)
	{
		print("... then restarting.");
		gameLoop.start();
		return new Future.delayed(new Duration(milliseconds: 500));
	})
	.then((_)
	{
		print("... and stopping again.");
		gameLoop.pause();
	});
}

void testGameLoopStreams()
{
	GameLoop gameLoop = new GameLoop();
  StreamSubscription tickStreamSub;
	tickStreamSub = gameLoop.stream.listen((GameLoopEvent event)
	{
		print("time in stream: $event.time");
//		tickStreamSub.pause();
//		new Future.delayed(new Duration(seconds: 1), ()
//    	{
//    		print("resuming gameloop from sub...");
//    		tickStreamSub.resume();
//    	});
		
		tickStreamSub.pause(new Future.delayed(new Duration(milliseconds: 500), ()
		{
			print("delayed Future completed, should resume...");
		}));
	});
	gameLoop.start();
}

void testBattleUtilsGetRandomNumber()
{
	print("0, 1");
	print(BattleUtils.getRandomNumberFromRange(0, 1));
	print(BattleUtils.getRandomNumberFromRange(0, 1));
	print(BattleUtils.getRandomNumberFromRange(0, 1));
	print(BattleUtils.getRandomNumberFromRange(0, 1));
	print(BattleUtils.getRandomNumberFromRange(0, 1));
	
	print("1, 2");
	print(BattleUtils.getRandomNumberFromRange(1, 2));
	print(BattleUtils.getRandomNumberFromRange(1, 2));
	print(BattleUtils.getRandomNumberFromRange(1, 2));
	print(BattleUtils.getRandomNumberFromRange(1, 2));
	print(BattleUtils.getRandomNumberFromRange(1, 2));
    	
	print("1, 3");
	print(BattleUtils.getRandomNumberFromRange(1, 3));
	print(BattleUtils.getRandomNumberFromRange(1, 3));
	print(BattleUtils.getRandomNumberFromRange(1, 3));
	print(BattleUtils.getRandomNumberFromRange(1, 3));
	print(BattleUtils.getRandomNumberFromRange(1, 3));
}
