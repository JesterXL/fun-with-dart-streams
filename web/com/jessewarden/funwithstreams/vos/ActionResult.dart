part of funwithstreamslib;

class ActionResult
{
	Character attacker;
	List<Character> targets;
	String attackType;
	bool hit;
	bool criticalHit;
	List<int> damages;
	
	ActionResult(this.attacker,
					this.targets,
					this.attackType,
					this.hit,
					this.criticalHit,
					this.damages)
	{
	}
}