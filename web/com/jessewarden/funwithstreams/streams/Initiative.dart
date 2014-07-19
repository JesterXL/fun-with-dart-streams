part of funwithstreamslib;

class Initiative
{
	Stream<GameLoopEvent> gameLoopStream;
	List charactersReady = new List();
	List<Player> players = new List<Player>();
	List<Monster> monsters = new List<Monster>();
	Map<BattleTimer, Character> battleTimers = new Map<BattleTimer, Character>();
	
	StreamController<InitiativeEvent> _streamController;
	Stream<InitiativeEvent> stream;
    	
	Initiative(this.gameLoopStream, this.players, this.monsters)
	{
		init();
	}
	
	void init()
	{
		_streamController = new StreamController<InitiativeEvent>(onPause: onPause,
        															onResume: onResume);
		stream = _streamController.stream.asBroadcastStream();
		
		BattleTimer timer;
		players.forEach((Player player)
		{
			timer = new BattleTimer(gameLoopStream, BattleTimer.MODE_CHARACTER);
			timer.stream.where((BattleTimerEvent event)
			{
				return event.type == BattleTimerEvent.COMPLETE;
			})
			.listen((BattleTimerEvent event)
			{
				_streamController.add(new InitiativeEvent(InitiativeEvent.CHARACTER_READY,
															battleTimers[event.target]));
			});
			timer.speed = player.speed;
			
			player.hitPointsStream.listen((CharacterEvent event)
			{
				if(event.target.hitPoints <= 0)
        		{
					timer.pause();
        		}
			});
			
			battleTimers[timer] = player;
		});
		
		monsters.forEach((Monster monster)
		{
			timer = new BattleTimer(gameLoopStream, BattleTimer.MODE_MONSTER);
			timer.stream.where((BattleTimerEvent event)
			{
				return event.type == BattleTimerEvent.COMPLETE;
			})
			.listen((BattleTimerEvent event)
			{
				_streamController.add(new InitiativeEvent(InitiativeEvent.CHARACTER_READY,
                											battleTimers[event.target]));
			});
			timer.speed = monster.speed;
			
			monster.strength = BattleUtils.getRandomMonsterStrength();
			monster.hitPointsStream.listen((CharacterEvent event)
			{
				if(event.target.hitPoints <= 0)
				{
					timer.pause();
				}
			});
			
			battleTimers[timer] = monster;
		});
	}
	
	void reset()
	{
		battleTimers.forEach((BattleTimer timer, Character character)
		{
			timer.reset();
			timer.start();
		});
	}
	
	void pause()
	{
		battleTimers.forEach((BattleTimer timer, Character character)
		{
			timer.pause();
		});
	}
	
	void start()
	{
		battleTimers.forEach((BattleTimer timer, Character character)
		{
			timer.start();
		});
	}
	
	void onPause()
	{
		pause();
	}
	
	void onResume()
	{
		start();
	}
	
	void onDeath(Character character)
	{
//		BattleTimer characterTimer = battleTimers.keys.firstWhere((BattleTimer timer)
//		{
//			return battleTimers[timer] == character;
//		});
//		characterTimer.pause();
//		bool allMonstersDead = monsters.every((Monster monster)
//		{
//			return monster.dead;
//		});
//		
//		bool allPlayersDead = players.every((Player player)
//		{
//			return player.dead;
//		});
//		
//		// TODO: handle Life 3
//		if(allPlayersDead)
//		{
//			pause();
//			battleOver = true;
//			_streamController.add(new BattleControllerEvent(BattleControllerEvent.LOST, this));
//			return;
//		}
//		
//		if(allMonstersDead)
//		{
//			pause();
//			battleOver = true;
//			_streamController.add(new BattleControllerEvent(BattleControllerEvent.WON, this));
//            return;
//		}
	}
	
}