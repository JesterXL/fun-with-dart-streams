part of funwithstreamslib;

class Menu extends DisplayObjectContainer
{
	
	num _width;
	num _height;
	ObservableList<MenuItem> _menuItems;
	Sprite _items;
	
	Menu(num this._width, num this._height, ObservableList<MenuItem> this._menuItems)
	{
		init();
	}
	
	void init()
	{
		Shape border = new Shape();
    	border.graphics.rectRound(0, 0, _width, _height, 6, 6);
    	border.graphics.fillColor(Color.Blue);
    	border.graphics.strokeColor(Color.White, 4);
    	addChild(border);
    	
    	_items = new Sprite();
    	addChild(_items);
    	num startX = 24;
    	num startY = 0;
    	_menuItems.forEach((MenuItem item)
		{
			// create name
			TextField nameField = new TextField();
			nameField.defaultTextFormat = new TextFormat('Final Fantasy VI SNESa', 36, Color.White);
			nameField.text = item.name;
			nameField.x = startX;
			nameField.y = startY;
			nameField.width = 200;
			nameField.height = 40;
			startY += 24;
			nameField.wordWrap = false;
			nameField.multiline = false;
			_items.addChild(nameField);
		});
    	
	}
	
	
	
	void render(RenderState renderState)
	{
		super.render(renderState);
	}
}