part of funwithstreamslib;

class CharacterEvent
{
	static const HIT_POINTS_CHANGED = "hitPointsChanged";
	String type;
	Character target;
	
	CharacterEvent(this.type, this.target){}
}