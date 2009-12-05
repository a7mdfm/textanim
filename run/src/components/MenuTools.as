package components
{
	import flupie.textanim.TextAnim;
	import flupie.textanim.TextAnimTools;

	public class MenuTools extends BtnGroup
	{
		public var textAnim:TextAnim;
		
		public function MenuTools()
		{
			super();
			
			title.setText("Tools");
			
			var btn1:Btn = addBtn();
			btn1.setLabel("Normal");
			btn1.onClick = function():void {
				TextAnimTools.toVector(textAnim);
			}
			var btn2:Btn = addBtn();
			btn2.setLabel("Bitmap");
			btn2.onClick = function():void {
				TextAnimTools.toBitmap(textAnim);
			}
			var btn3:Btn = addBtn();
			btn3.setLabel("Pattern");
			btn3.onClick = function():void {
				TextAnimTools.setPattern(textAnim, new Pattern1());
			}
			var btn4:Btn = addBtn();
			btn4.setLabel("Gradient");
			btn4.onClick = function():void {
				TextAnimTools.setGradientLinear(textAnim, [0xFF0000, 0x000000]);
			}
			
			selectBtn(btn1);
		}
		
	}
}