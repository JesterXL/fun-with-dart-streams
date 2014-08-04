import 'dart:core';
import 'dart:async';
import 'dart:html' as html;
import 'com/jessewarden/funwithstreams/funwithstreamslib.dart';
import 'package:observe/observe.dart';
import 'package:stagexl/stagexl.dart';
import 'tpdemo.dart';

void main()
{
	print("main");
//	testGameLoop();
//	testBattleUtilsGetRandomNumber();
//	testGameLoopPauseResume();
//	testGameLoopStreams();
	
//	testAsyncExpand();
//	testPipe();
//	testAsyncListen();
//	testFuture();
//	testFutureStream();
//	testBattleTimer();
//	testBasicStreamsNoClasses();
//	testBasicController();
//	testObservableList();
//	testFutureWithDataAndStream();
	
//	testActionResult();
	
//	testInitiative();
//	testTexturePacker();
	testingLockeSprite();
}

void testingLockeSprite()
{
	Stage stage = new Stage(html.querySelector('#stage'), webGL: true);
	RenderLoop renderLoop = new RenderLoop();
	ResourceManager resourceManager = new ResourceManager();
	
	 renderLoop.addStage(stage);
	 
	 LockeSprite locke = new LockeSprite(resourceManager);
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
	   .catchError((e) => print(e));
}


void testTexturePacker()
{
	Stage stage = new Stage(html.querySelector('#stage'), webGL: true);
    RenderLoop renderLoop = new RenderLoop();
    ResourceManager resourceManager = new ResourceManager();
    
	 renderLoop.addStage(stage);
     
     resourceManager = new ResourceManager()
       ..addTextureAtlas('locke', '../design/spritesheets/texturepacker/locke.json', TextureAtlasFormat.JSONARRAY);
     
     resourceManager.load()
       .then((_) => stage.addChild(new TexturePackerDemo(resourceManager, stage)))
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
	initiative.stream.listen((InitiativeEvent event)
	{
		print("event type: " + event.type.toString());
	}).onError((error)
	{
		print("error: $error");
		loop.pause();
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

void testBasicController()
{
//	List myList = new List();
//	StreamController controller = new StreamController();
//	controller.stream.listen((_)
//	{
//		print("data: $_");
//	});
//	controller.add("sup");
	
	List myList = new List();
    	
    Stream myStream = new Stream.fromIterable(myList);
    StreamController controller = new StreamController();
	controller.stream.listen((_)
	{
		print("stream listen, data: $_");
	});
    controller.addStream(myStream)
    .then((_)
    {
    	print("ready");
//    	controller.add("sup");
    	myList.add("new value");
    })
    .catchError((error)
    {
    	print("some error");
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

void testFutureStream()
{
	Future mine = new Future.value(3);
	var stream = new Stream.fromFuture(mine);
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

class SampleTicker extends Ticker
{
	void tick(num time)
	{
		print("time: $time");
	}
}

