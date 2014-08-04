part of funwithstreamslib;

class LockeSprite extends SpriteSheet
{
	
	
	LockeSprite(ResourceManager resourceManager)
	{
		this.resourceManager = resourceManager;
		resourceManager.addTextureAtlas('locke', '../design/spritesheets/texturepacker/locke.json', TextureAtlasFormat.JSONARRAY);
		
        List<String> idleSouth = new List<String>();
        idleSouth.add("locke_1");
        cycles["idleSouth"] = idleSouth;
        
        List<String> idleWest = new List<String>();
        idleWest.add("locke_7");
        cycles["idleWest"] = idleWest;
        
        List<String> readyWest = new List<String>();
        readyWest.add("locke_13");
        cycles["readyWest"] = readyWest;
        
        List<String> castingWest = new List<String>();
        castingWest.add("locke_25");
        castingWest.add("locke_29");
        cycles["castingWest"] = castingWest;
        
        resourceManager.load()
       	   .then((_) => init())
       	   .catchError((e) => print(e));
	}
	
	void init()
	{
		_textureAtlas = resourceManager.getTextureAtlas('locke');
		idle();
	}
	
	void idle()
	{
		currentCycle = cycles["idleWest"];
	}
}