part of funwithstreamslib;

class BattleTimerBar extends DisplayObjectContainer
{
	Shape bar;
	Shape green;
	Shape back;
	num _percentage = 1;
	bool percentageDirty = false;
	
	num get percentage => _percentage;
	void set percentage(num value)
	{
		if(value == null)
		{
			value = 0;
		}
		value.clamp(0, 1);
		_percentage = value;
		percentageDirty = true;
	}
	
	BattleTimerBar()
	{
		init();
	}
	
	void init()
	{
		back = new Shape();
		back.graphics.rect(0,  0,  100,  20);
		back.graphics.fillColor(Color.Blue);
		addChild(back);
		
		green = new Shape();
		green.graphics.rect(0, 0, 100, 20);
		green.graphics.fillColor(Color.Yellow);
		addChild(green);
		
		bar = new Shape();
		bar.graphics.rect(0, 0, 100, 20);
		bar.x = 1;
		bar.y = 1;
		bar.graphics.strokeColor(Color.Black, 2);
		addChild(bar);
	}
	
	void render(RenderState renderState)
	{
		super.render(renderState);
		if(percentageDirty)
		{
			percentageDirty = false;
			green.width = 100 * _percentage;
		}
	}
}