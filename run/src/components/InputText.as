package components
{
	public class InputText extends InputTextView
	{
		public var title:Title;
		public var btn:Btn;
		
		public function InputText()
		{
			super();
			
			title = new Title();
			addChild(title);
			
			btn = new Btn();
			addChild(btn);
			btn.height = btn.height/2;
			
			txt.y = title.height;
			btn.y = txt.x + txt.height + btn.height/2;
			btn.x = txt.width - btn.width/2 - 1;
			
			txt.border = true;
			txt.borderColor = 0x000000;	
			
			text = "";		
			
		}
		
		public function set text(val:String):void
		{
			txt.htmlText = val;
			txt.scrollV = txt.maxScrollV;
		}
		
		public function get text():String
		{
			return txt.htmlText;
		}
		
		
		
		
		
	}
}