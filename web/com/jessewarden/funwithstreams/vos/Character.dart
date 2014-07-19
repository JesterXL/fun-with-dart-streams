part of funwithstreamslib;

class Character
{
	static const int ROW_FRONT = 0;
	static const int ROW_BACK = 1;
	
	int speed;	
	int strength;
	int stamina;
	int magicBlock;
	int vigor;
	String battleState;
	int row = ROW_FRONT;
	int defense;
	int magicalDefense;
	bool dead = false;
	int level = 1;
	
	int _hitPoints = 0;
	
	int get hitPoints => _hitPoints;
	void set hitPoints(int newValue)
	{
		if(_hitPoints != newValue)
		{
			_hitPoints = newValue;
			_hitPointsController.add(new CharacterEvent(CharacterEvent.HIT_POINTS_CHANGED, this));
		}
	}
	
	StreamController<CharacterEvent> _hitPointsController;
	Stream<CharacterEvent> hitPointsStream;
	
	Character()
	{
		_hitPointsController = new StreamController();
		hitPointsStream = _hitPointsController.stream;
	}
	
	
}