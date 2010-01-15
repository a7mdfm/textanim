package components
{
	import flupie.textanim.TextAnim;
	
	public class MenuBreak extends BtnGroup
	{
		public var textAnim:TextAnim;
		
		public function MenuBreak()
		{
			super();

			title.setText("Break Mode");
			var btnLetters:Btn = addBtn();
			btnLetters.setLabel("CHARS");
			btnLetters.onClick = function():void {
				textAnim.breakMode = TextAnim.BREAK_IN_CHARS;
			}
				
			var btnWords:Btn = addBtn();
			btnWords.setLabel("WORDS");
			btnWords.onClick = function():void {
				textAnim.breakMode = TextAnim.BREAK_IN_WORDS;
			}
				
			var btnLines:Btn = addBtn();
			btnLines.setLabel("LINES");
			btnLines.onClick = function():void {
				textAnim.breakMode = TextAnim.BREAK_IN_LINES;
			}
				
			selectBtn(btnLetters);
		}
		
	}
}