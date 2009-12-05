package components
{
	import flupie.textanim.TextAnim;
	
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
				textAnim.animMode = TextAnim.ANIM_TO_RIGHT;
			}
				
			var btnToLeft:Btn = addBtn();
			btnToLeft.setLabel("TO LEFT");
			btnToLeft.onClick = function ():void {
				textAnim.animMode = TextAnim.ANIM_TO_LEFT;
			}
				
			var btnToEdges:Btn = addBtn();
			btnToEdges.setLabel("TO EDGES");
			btnToEdges.onClick = function ():void {
				textAnim.animMode = TextAnim.ANIM_TO_EDGES;
			}
				
			var btnToCenter:Btn = addBtn();
			btnToCenter.setLabel("TO CENTER");
			btnToCenter.onClick = function ():void {
				textAnim.animMode = TextAnim.ANIM_TO_CENTER;
			}
				
			var btnRandom:Btn = addBtn();
			btnRandom.setLabel("RANDOM");
			btnRandom.onClick = function ():void {
				textAnim.animMode = TextAnim.ANIM_RANDOM;
			}
			
			selectBtn(btnToRight);
		}
		
	}
}