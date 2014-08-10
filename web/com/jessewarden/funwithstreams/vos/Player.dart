part of funwithstreamslib;

class Player extends Character
{
	static const String LOCKE = "Locke";
	static const String TERRA = "Terra";
	static const String SETZER = "Setzer";
	
	String _characterType;
	
	String get characterType => _characterType;
	
	Player(String this._characterType)
	{
	}
}