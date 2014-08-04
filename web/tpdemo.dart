import 'package:stagexl/stagexl.dart';
import 'dart:async';

class TexturePackerDemo extends DisplayObjectContainer
{

  TextureAtlas _textureAtlas;
  ResourceManager resourceManager;
  Bitmap bitmap;
	Stage stage;
	int count;
	
	List<String> currentCycle;
	List<String> walkCycle;
	double time = 0.0;
	
  TexturePackerDemo(this.resourceManager, this.stage)
  {

    _textureAtlas = resourceManager.getTextureAtlas('locke');
    bitmap = new Bitmap();
    addChild(bitmap);
//    _showWalkAnimation();
    count = 0;
    walkCycle = new List<String>();
    currentCycle = walkCycle;
    walkCycle.add("locke_2");
    walkCycle.add("locke_1");
    walkCycle.add("locke_3");
    walkCycle.add("locke_1");
  }
  
  void render(RenderState renderState)
  {
	  super.render(renderState);
	  
	  if(currentCycle == null)
 	  {
 		  return;
 	  }
	  
	  time += renderState.deltaTime;
	  if(time < 0.2)
	  {
		  return;
	  }
	  else
	  {
		  time = 0.0;
	  }
 	  
 	  if(count < currentCycle.length - 1)
 	  {
 		  count++;
 	  }
 	  else
 	  {
 		  count = 0;
 	  }
	  BitmapData bitmapData = _textureAtlas.getBitmapData(currentCycle[count]);
      bitmap.bitmapData = bitmapData;
  }
}