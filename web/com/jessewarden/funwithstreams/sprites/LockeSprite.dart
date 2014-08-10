part of funwithstreamslib;

class LockeSprite extends SpriteSheet
{
	
	
	LockeSprite(ResourceManager resourceManager)
	{
		this.resourceManager = resourceManager;
		if(resourceManager.containsTextureAtlas('locke') == false)
		{
			resourceManager.addTextureAtlas('locke', '../design/spritesheets/texturepacker/locke.json', TextureAtlasFormat.JSONARRAY);
		}
		
        getAnimationList("idleSouth")
        ..add("locke_1");
        
        getAnimationList("idleWest")
        ..add("locke_7");
        
        getAnimationList("readyWest")
        ..add("locke_13");
        
        getAnimationList("castingWest")
        ..add("locke_25")
        ..add("locke_29");
        
        getAnimationList("castSpellWest")
        ..add("locke_33");
        
        getAnimationList("attackWest")
        ..add("locke_22");
	}
	
	List<String> getAnimationList(String name)
	{
		List<String> list = new List<String>();
		cycles[name] = list;
		return list;
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
		frameTime = 0.2;
		currentCycle = cycles["castingWest"];
	}
	
	void castSpellWest()
	{
		currentCycle = cycles["castSpellWest"];
	}
	
	void attackWest()
	{
		currentCycle = cycles["attackWest"];
	}
}