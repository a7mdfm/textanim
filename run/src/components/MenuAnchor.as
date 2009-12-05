package components
{
	import flash.display.Sprite;
	
	import flupie.textanim.TextAnim;

	public class MenuAnchor extends Sprite
	{
		public var menuAnchorX:BtnGroup;
		public var menuAnchorY:BtnGroup;
		public var textAnim:TextAnim;
		
		public function MenuAnchor()
		{
			super();
			createMenuAnchorX();
			createMenuAnchorY();
		}
		
		public function createMenuAnchorX():void
		{
			menuAnchorX	= new BtnGroup();
			menuAnchorX.title.setText("Anchor X");
			addChild(menuAnchorX);
			var btnLeft:Btn = menuAnchorX.addBtn();
			btnLeft.setLabel("LEFT");
			btnLeft.onClick = function():void {
				textAnim.anchorX = TextAnim.ANCHOR_LEFT;
			}
			var btnCenter:Btn = menuAnchorX.addBtn();
			btnCenter.setLabel("CENTER");
			btnCenter.onClick = function():void {
				textAnim.anchorX = TextAnim.ANCHOR_CENTER;
			}
			var btnRight:Btn = menuAnchorX.addBtn();
			btnRight.setLabel("RIGHT");
			btnRight.onClick = function():void {
				textAnim.anchorX = TextAnim.ANCHOR_RIGHT;
			}
			menuAnchorX.selectBtn(btnCenter);
		}
		
		public function createMenuAnchorY():void
		{
			menuAnchorY	= new BtnGroup();
			menuAnchorY.title.setText("Anchor Y");
			addChild(menuAnchorY);
			var btnTop:Btn = menuAnchorY.addBtn();
			btnTop.setLabel("TOP");
			btnTop.onClick = function():void {
				textAnim.anchorY = TextAnim.ANCHOR_TOP;
			}
			var btnCenter:Btn = menuAnchorY.addBtn();
			btnCenter.setLabel("CENTER");
			btnCenter.onClick = function():void {
				textAnim.anchorY = TextAnim.ANCHOR_CENTER;
			}
			var btnBottom:Btn = menuAnchorY.addBtn();
			btnBottom.setLabel("BOTTOM");
			btnBottom.onClick = function():void {
				textAnim.anchorY = TextAnim.ANCHOR_BOTTOM;
			}
			menuAnchorY.selectBtn(btnCenter);
			menuAnchorY.x = menuAnchorX.width + 3;
		}
		
	}
}