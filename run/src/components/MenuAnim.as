package components
{
	import flupie.textanim.TextAnim;
	import flupie.textanim.TextAnimMode;
	
	public class MenuAnim extends BtnGroup
	{
		public var textAnim:TextAnim;
		
		public function MenuAnim()
		{
			super();
			
			title.setText("Anim Mode");
			
			var btnToRight:Btn = addBtn();
			btnToRight.setLabel("TO RIGHT");
			btnToRight.onClick = function ():void {
				textAnim.mode = TextAnimMode.FIRST_LAST;
			}
				
			var btnToLeft:Btn = addBtn();
			btnToLeft.setLabel("TO LEFT");
			btnToLeft.onClick = function ():void {
				textAnim.mode = TextAnimMode.LAST_FIRST;
			}
				
			var btnToEdges:Btn = addBtn();
			btnToEdges.setLabel("TO EDGES");
			btnToEdges.onClick = function ():void {
				textAnim.mode = TextAnimMode.CENTER_EDGES;
			}
				
			var btnToCenter:Btn = addBtn();
			btnToCenter.setLabel("TO CENTER");
			btnToCenter.onClick = function ():void {
				textAnim.mode = TextAnimMode.EDGES_CENTER;
			}
				
			var btnRandom:Btn = addBtn();
			btnRandom.setLabel("RANDOM");
			btnRandom.onClick = function ():void {
				textAnim.mode = TextAnimMode.RANDOM;
			}
			
			selectBtn(btnToRight);
		}
		
	}
}