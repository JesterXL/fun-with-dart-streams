part of funwithstreamslib;

class CursorFocusManagerEvent
{
	static const String SELECTED = "selected";
	static const String INDEX_CHANGED = "indexChanged";
	
	String type;
	
	CursorFocusManagerEvent(this.type)
	{
		
	}
	
}