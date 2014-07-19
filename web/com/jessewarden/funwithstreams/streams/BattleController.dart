part of funwithstreamslib;

class BattleController
{
	Initiative initiative;
	Map battleResults = new Map();
	bool battleOver = false;
	StreamController<BattleControllerEvent> _streamController;
    Stream<BattleControllerEvent> battleStream;
	
	BattleController()
	{
	}
	
	
	bool resolveActionResult(dynamic actionResult)
	{
		if(battleOver)
		{
			return false;
		}
		
		if(actionResult.hit)
		{
			// TODO: 2 arrays is dumb, plus 1 character could
			// have multiple damages; change data structure man...
//			actionResult.targets.forEach((Character character)
//			{
//				
//			})
//			forEach((Character character)
//			{
//				
//			});
			
			battleResults.remove(actionResult);
			if(actionResult.attacker is Monster)
			{
				// TODO: figure out why this was commented out in Lua
				// resume()
			}
			else
			{
				charactersReady.remove(actionResult.attacker);
				// TODO: figure out why this was commented out in Lua
				// resume()
			}
		}
		return true;
	}
	
	void onBattleResults(Character attacker,
    		                     List<Character> targets,
    		                     String attackType,
    		                     bool hit,
    		                     bool criticalHit,
    		                     List<int> damages)
	{
		_streamController.add(new BattleControllerEvent(BattleControllerEvent.ACTION_RESULT, 
														this, 
														actionResult: new ActionResult(attacker,
																						targets,
					            														attackType,
					            														hit,
					            														criticalHit,
					            														damages)));
	}
	
	bool attack(dynamic attacker, List<Character> targets, String attackType)
	{
		if(battleOver)
		{
			return false;
		}
		
		assert(attacker != null);
		assert(targets != null);
		assert(targets.length > 0);
		
		if(charactersReady.contains(attacker) == false)
		{
			throw "BattleController::attack, unknown attacker, he's not in our ready list.";
		}
		
		// TODO: handle multiple targets, this is hardcoded to 1
		Character target = targets[1];
		
		Attack attack = new Attack();
		attack.magicBlock = target.magicBlock;
		attack.specialAttackType = attackType;
		attack.targetStamina = target.stamina;
		
		HitResult hitResult = BattleUtils.getHit(attack);
		int damage = 0;
		bool criticalHit = false;
		if(hitResult.hit)
		{
			int battlePower = 28; // TODO: need weapon info, battle power comes from it
			
			bool equippedWithGauntlet = false; // TODO: is the character?
			bool equippedWithOffering = false; // TODO: is the character? 
			bool standardFightAttack = true;  // TODO: is the character?
			bool genjiGloveEquipped = false;  // TODO: is the character?
			bool oneOrZeroWeapons = true;  // TODO: is the character?
			
			damage = BattleUtils.getCharacterPhysicalDamageStep1(attacker.vigor,
																battlePower,
																attacker.level,
																equippedWithGauntlet,
																equippedWithOffering,
																standardFightAttack,
																genjiGloveEquipped,
																oneOrZeroWeapons);
			
			bool isMagicalAttacker = false;
			bool isPhysicalAttack = true;
			bool isMagicalAttack = false;
			bool equippedWithAtlasArmlet = false;
			bool equippedWith1HeroRing = false;
			bool equippedWith2HeroRings = false;
			bool equippedWith1Earring = false;
			bool equippedWith2Earrings = false;
			damage = BattleUtils.getCharacterDamageStep2(damage, 
															isMagicalAttacker,
															isPhysicalAttack,
															isMagicalAttack,
															equippedWithAtlasArmlet,
															equippedWith1HeroRing,
															equippedWith2HeroRings,
															equippedWith1Earring,
															equippedWith2Earrings);
			
			criticalHit = BattleUtils.getCriticalHit();
			
			bool hasMorphStatus = false;
			bool hasBerserkStatus = false;
			damage = BattleUtils.getDamageMultipliers(damage,
														hasMorphStatus,
														hasBerserkStatus,
														criticalHit);
			
			// TODO: need armor of target so we can calculate defense 
			int defense = attacker.defense; // 16
			int magicalDefense = attacker.magicalDefense; // 0
//			isPhysicalAttack, 
//			 isMagicalAttack,
			bool targetHasSafeStatus = false;
			bool targetHasShellStatus = false;
			bool targetDefending = false;
			bool targetIsInBackRow = false;
			bool targetHasMorphStatus = false;
			bool targetIsSelf = false;
			bool targetIsCharacter = false;
			bool attackerIsCharacter = true;
			damage = BattleUtils.getDamageModifications(damage,
														defense,
														magicalDefense,
														attack.isPhysicalAttack,
														attack.isMagicalAttack,
														targetHasSafeStatus,
														targetHasShellStatus,
														targetDefending,
														targetIsInBackRow,
														targetHasMorphStatus,
														targetIsSelf,
														targetIsCharacter,
														attackerIsCharacter);
			
			// damage, hittingTargetsBack, isPhysicalAttack)
			bool hittingTargetsBack = false;
			damage = BattleUtils.getDamageMultiplierStep7(damage, 
															hittingTargetsBack,
															attack.isPhysicalAttack);
			if(damage > 9999)
			{
				throw "What, 9000!?!";
			}
			
			List<int> damages = new List<int>(damage);
			assert(targets != null);
			assert(targets.length > 0);
			
			onBattleResults(attacker, targets, attackType, hitResult.hit, criticalHit, damages);
		}
		return true;
	}

	bool defend(Character character)
	{
		if(battleOver)
		{
			return false;
		}
		
		if(charactersReady.contains(character) == false)
		{
			throw "unknown attacker; he's not in our charactersReady list.";
		}
		
		character.battleState = BattleState.DEFENDING;
		charactersReady.remove(character);
		resume();
		return true;
	}
	
	bool changeRow(Character character)
	{
		if(battleOver)
		{
			return false;
		}
		
		if(charactersReady.contains(character) == false)
		{
			throw "unknown character; he's not in our charactersReady list.";
		}
        			
		if(character.row == Character.ROW_FRONT)
		{
			character.row = Character.ROW_BACK;
		}
		else
		{
			character.row = Character.ROW_FRONT;
		}
		charactersReady.remove(character);
		resume();
		return true;
	}
	
	bool useItem(Character attacker, List<Character> targets, dynamic item)
	{
		if(battleOver)
		{
			return false;
		}
		
		if(charactersReady.contains(attacker) == false)
		{
			throw "unknown character; he's not in our charactersReady list.";
		}
		
		// TODO: apply item
		attacker.battleState = BattleState.NORMAL;
		charactersReady.remove(attacker);
		resume();
		return true;
	}
	
	bool run(Character character)
	{
		if(battleOver)
		{
			return false;
		}
		
		if(charactersReady.contains(character) == false)
		{
			throw "unknown character; he's not in our charactersReady list.";
		}
		
		character.battleState = BattleState.RUNNING;
		charactersReady.remove(character);
		resume();
		return true;
	}
	
	Player getRandomPlayerForMonster()
	{
		if(players != null && players.length > 0)
		{
			int index = new Random().nextInt(players.length - 1);
			return players[index];
		}
		else
		{
			return null;
		}
	}
	
	void handleMonsterReady(Monster monster)
	{
		// TODO: allow multiple targets
		Player monstersTarget = getRandomPlayerForMonster();
		Attack attack = new Attack();
		attack.hitRate = 180; // TODO: need monster's info, this is where hitRate comes from
		attack.magicBlock = monster.magicBlock;
		attack.targetStamina = monstersTarget.stamina;
		
		// TODO: some monsters have special attacks
		// TODO: remove image status on target if it's removed via HitResult
		HitResult hitResult = BattleUtils.getHit(attack);
		int damage = 0;
		bool criticalHit = false;
		if(hitResult.hit)
		{
			// TODO: what is monster power?
			int monstersBattlePower = 16;
			damage = BattleUtils.getMonsterPhysicalDamageStep1(monstersTarget.level, 
																monstersBattlePower,
																monstersTarget.vigor);
			criticalHit = BattleUtils.getCriticalHit();
			// TODO: expose Character's status
			bool hasMorphStatus = false;
			bool hasBerserkStatus = false;
			damage = BattleUtils.getDamageMultipliers(damage, 
														hasMorphStatus, 
														hasBerserkStatus,
														criticalHit);
			int defense = monstersTarget.defense; // 16
			int magicalDefense = monstersTarget.magicalDefense; // 0
//				isPhysicalAttack, 
//				isMagicalAttack,
			bool targetHasSafeStatus = false;
			bool targetHasShellStatus = false;
			bool targetDefending = false;
			bool targetIsInBackRow = false;
			bool targetHasMorphStatus = false;
			bool targetIsSelf = false;
			bool targetIsCharacter = false;
			bool attackerIsCharacter = true;
			damage = BattleUtils.getDamageModifications(damage,
														defense,
														magicalDefense,
														attack.isPhysicalAttack,
														attack.isMagicalAttack,
														targetHasSafeStatus,
														targetHasShellStatus,
														targetDefending,
														targetIsInBackRow,
														targetHasMorphStatus,
														targetIsSelf,
														targetIsCharacter,
														attackerIsCharacter);
			bool hittingTargetsBack = false;
			damage = BattleUtils.getDamageMultiplierStep7(damage,
															hittingTargetsBack,
															attack.isPhysicalAttack);
		}
		pause();
		List<Character> targets = [monstersTarget];
		List<int> damages = [damage];
		onBattleResults(monster,
						targets,
						AttackTypes.ATTACK,
						hitResult.hit,
						criticalHit,
						damages);
	}
	
	void handlePlayerReady(Player player)
	{
		pause();
		charactersReady.add(player);
		// this allows the menu to come up for a particular
        // character so they can choose an action
		_streamController.add(new BattleControllerEvent(BattleControllerEvent.CHARACTER_READY, this, character: player));
	}
	
	void onCharacterReady(Character character)
	{
		if(character is Monster)
		{
			handleMonsterReady(character);
		}
		else if(character is Player)
		{
			handlePlayerReady(character);
		}
	}
	
	
}
