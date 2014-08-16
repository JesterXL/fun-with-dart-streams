part of funwithstreamslib;

class CursorFocusManager
{
	Stage _stage;
	ResourceManager _resourceManager;
	Bitmap _cursorBitmap;
	
	
	CursorFocusManager(Stage this._stage, ResourceManager this._resourceManager)
	{
		init();
	}
	
	void init()
	{
		if(_resourceManager.containsBitmapData('cursor') == false)
		{
			_resourceManager.addBitmapData('cursor', '../design/cursor.png');
		}
		_resourceManager.load()
		.then((_)
		{
			_cursorBitmap = new Bitmap(_resourceManager.getBitmapData('cursor'));
			_stage.addChild(_cursorBitmap);
		});
	}
	
	
	ObservableList<DisplayObject> targets = new ObservableList<DisplayObject>();
	
	int _selectedIndex = -1;
	
	int get selectedIndex => _selectedIndex;
	void set selectedIndex(int newValue)
	{
		_selectedIndex = newValue;
		_selectCurrentElement();
	}
	
	void _selectCurrentElement()
	{
		_cursorBitmap.visible = false;
		
		if(_selectedIndex < 0)
		{
			return;
		}
		
		if(targets.length < 1)
		{
			return;
		}
		
		DisplayObject target = targets[_selectedIndex];
		_cursorBitmap.visible = true;
		Point point = target.localToGlobal(new Point(target.x, target.y));
		_cursorBitmap.x = point.x - 2;
		_cursorBitmap.y = point.y + target.height / 2 - _cursorBitmap.height / 2;
	}
	
	void nextTarget()
	{
		if(targets.length < 2)
		{
			return;
		}
		
		if(_selectedIndex + 1 < targets.length)
		{
			_selectedIndex++;
		}
		else
		{
			_selectedIndex = 0;
		}
		_selectCurrentElement();
	}
	
	void previousTarget()
	{
		if(targets.length < 2)
		{
			return;
		}
		
		if(_selectedIndex - 1 > -1)
		{
			_selectedIndex--;
		}
		else
		{
			_selectedIndex = targets.length - 1;
		}
		_selectCurrentElement();
	}
	
	
	
}