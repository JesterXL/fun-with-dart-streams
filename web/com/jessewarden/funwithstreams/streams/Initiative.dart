part of funwithstreamslib;

class Initiative
{
	Stream<GameLoopEvent> _gameLoopStream;
	ObservableList<Player> _players;
	ObservableList<Monster> _monsters;
	List _battleTimers = new List();
    StreamController _streamController;
	
	ObservableList<Player> get players => _players;
	ObservableList<Monster> get monsters => _monsters;
	
	ObservableList<Character> charactersReady = new ObservableList<Character>();
	Stream<InitiativeEvent> stream;
	
    	
	Initiative(this._gameLoopStream, this._players, this._monsters)
	{
	}
	
	Future init()
	{
		return new Future(()
		{
			_streamController = new StreamController<InitiativeEvent>(onPause: onPause,
        															onResume: onResume);
			return new Future(()
			{
				print("fixin to add stream...");
				// TODO/FIXME: I think I want pipe, not addStream since it's not a true merge;
				// this'll never actually complete the future because the GameLoop continues to add events...
				//_streamController.addStream(_gameLoopStream)
				
				// TODO: HOW THE FUCK DO YOU MERGE STREAMS, OMG
				return _gameLoopStream.takeWhile(()
				{
					return true;
				})
				.then((_)
				{
					print("added stream, making a new broadcast one...");
					stream = _streamController.stream.asBroadcastStream();
	    			List participants = new List();
	    			participants.add(players);
	    			participants.add(monsters);
	    			participants.forEach((ObservableList list)
	    			{
	    				// listen for new changes
	    				list.listChanges.listen((List<ListChangeRecord> records)
	    				{
	    					addOrRemoveBattleTimerForCharacter(records, list);
	    				});
	    				
	    				// configure the participants in the battle we have now
	    				list.forEach(addBattleTimerForCharacter);
	    			});
	    			
	    			_streamController.add(new InitiativeEvent(InitiativeEvent.INITIALIZED));
	    			return true;
				});
			});
		});
	}
	
	void addBattleTimerForCharacter(Character character)
	{
		String mode = getModeBasedOnType(character);
		BattleTimer timer = new BattleTimer(_gameLoopStream, mode);
		StreamSubscription<BattleTimerEvent> timerSubscription = timer.stream.where((BattleTimerEvent event)
		{
			print("BattleTimer stream type: " + event.type.toString());
			return event.type == BattleTimerEvent.COMPLETE;
		})
		.listen((BattleTimerEvent event)
		{
			var matched = _battleTimers.firstWhere((object)
			{
				object.timer == event.target;
			});
			Character targetCharacter = _battleTimers[matched].character;
			charactersReady.add(targetCharacter);
			_streamController.add(new InitiativeEvent(InitiativeEvent.CHARACTER_READY,
														character: targetCharacter));
		});
		timer.speed = character.speed;
		if(character is Monster)
		{
			character.strength = BattleUtils.getRandomMonsterStrength();
		}
		
		StreamSubscription<CharacterEvent> characterSubscription = character.stream.listen((CharacterEvent event)
		{
			if(event.type == CharacterEvent.NO_LONGER_SWOON)
			{
				timer.reset();
			}
			
			if(event.target.hitPoints <= 0)
    		{
				timer.pause();
    		}
		});
		
		_battleTimers.add({
							"battleTimer": timer,
							"battleTimerSubscription": timerSubscription,
							"character": character,
							"characterSubscription": characterSubscription
		});
		
		timer.start();
	}
	
	String getModeBasedOnType(Character character)
	{
		if(character is Player)
		{
			return BattleTimer.MODE_CHARACTER;
		}
		else
		{
			return BattleTimer.MODE_MONSTER;
		}
	}
	
	void removeBattleTimerForCharacter(Character character)
	{
		var object = _battleTimers.firstWhere((object) 
		{
			return object.character == character;
		});
		object.timer.dispose();
		object.timerSubscription.cancel();
		object.characterSubscription.cancel();
		_battleTimers.remove(object);
	}
	
	void addOrRemoveBattleTimerForCharacter(List<ListChangeRecord> records, ObservableList<Character> list)
	{
		// data: [#<ListChangeRecord index: 0, removed: [], addedCount: 2>]
		records.forEach((ListChangeRecord record)
		{
			if(record.addedCount > 0)
			{
				for(int index = record.index; index < record.index + record.addedCount; index++)
				{
					addBattleTimerForCharacter(list.elementAt(index));
				}
			}
			if(record.removed.length > 0)
			{
				record.removed.forEach(addBattleTimerForCharacter);
			}
		});
	}
	
	void reset()
	{
		_battleTimers.forEach((object)
		{
			BattleTimer timer = object.timer;
			timer.reset();
			timer.start();
		});
	}
	
	void pause()
	{
		_battleTimers.forEach((object)
		{
			BattleTimer timer = object.timer;
			timer.pause();
		});
	}
	
	void start()
	{
		_battleTimers.forEach((object)
		{
			BattleTimer timer = object.timer;
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
		var hash = _battleTimers.firstWhere((object)
		{
			return object.character == character;
		});
		BattleTimer characterTimer = hash.timer;
		characterTimer.pause();
		bool allMonstersDead = monsters.every((Monster monster)
		{
			return monster.dead;
		});
		
		bool allPlayersDead = players.every((Player player)
		{
			return player.dead;
		});
		
		// TODO: handle Life 3
		if(allPlayersDead)
		{
			pause();
			_streamController.add(new InitiativeEvent(InitiativeEvent.LOST));
			return;
		}
		
		if(allMonstersDead)
		{
			pause();
			_streamController.add(new InitiativeEvent(InitiativeEvent.WON));
            return;
		}
	}
	
}