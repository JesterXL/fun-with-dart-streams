part of funwithstreamslib;

class ActionResult
{
	Character attacker;
	List<Character> targets;
	String attackType;
	List<TargetHitResult> targetHitResults;
	
	ActionResult({
		Character this.attacker,
		List<Character> this.targets,
		String this.attackType,
		List<TargetHitResult> this.targetHitResults
	})
	{
	}
}