part of funwithstreamslib;

class Attack
{
	bool isPhysicalAttack = true;
	bool isMagicalAttack = false;
	bool targetHasClearStatus = false;
	bool protectedFromWound = false;
	bool attackMissesDeathProtectedTargets = false;
	bool attackCanBeBlockedByStamina = true;
	bool spellUnblockable = false;
	bool targetHasSleepStatus = false;
	bool targetHasPetrifyStatus = false;
	bool targetHasFreezeStatus = false;
	bool targetHasStopStatus = false;
	bool backOfTarget = false;
	int hitRate = 180; // TODO: need weapon's info, this is where hitRate comes from
	bool targetHasImageStatus = false;
	int magicBlock = null;
	String specialAttackType = null;
	int targetStamina = null;
}