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
	}
	
	Future init()
	{
		return new Future(()
		{
        	return resourceManager.load()
		       	   .then((_)
				   {
		        		print("init time: " + new DateTime.now().toString());
		        		_textureAtlas = resourceManager.getTextureAtlas('locke');
		        		idleWest();
				   })
		       	   .catchError((e) => print(e));
		});
	}
	
	void idleWest()
	{
		currentCycle = cycles["idleWest"];
	}
	
	void castingWest()
	{
		print("castingWest time: " + new DateTime.now().toString());
		currentCycle = cycles["castingWest"];
	}
}