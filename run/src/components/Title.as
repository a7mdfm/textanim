package components
{
	import flash.text.TextFieldAutoSize;

	public class Title extends TitleView
	{
		public function Title()
		{
			super();
		}
		
		public function setText(str:String):void
		{
			title.text = str;
			title.autoSize = TextFieldAutoSize.LEFT;
		}
	}
}