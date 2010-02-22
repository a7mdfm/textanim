package components
{
	import flupie.textanim.TextAnim;
	import flupie.textanim.TextAnimSplit;
	
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
				textAnim.split = TextAnimSplit.CHARS;
			}
				
			var btnWords:Btn = addBtn();
			btnWords.setLabel("WORDS");
			btnWords.onClick = function():void {
				textAnim.split = TextAnimSplit.WORDS;
			}
				
			var btnLines:Btn = addBtn();
			btnLines.setLabel("LINES");
			btnLines.onClick = function():void {
				textAnim.split = TextAnimSplit.LINES;
			}
				
			selectBtn(btnLetters);
		}
		
	}
}