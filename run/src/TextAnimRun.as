package
{
	import caurina.transitions.Tweener;
	
	import components.Btn;
	import components.BtnGroup;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flupie.textanim.TextAnim;
	import flupie.textanim.TextAnimBlock;
	
	public class TextAnimRun extends Sprite
	{
		public static const MARGIN_X:Number = 10;
		public static const MARGIN_Y:Number = 10;
		
		public var txtContainer:TextContainer;
		public var anim:TextAnim;
		
		public var menuBreak:BtnGroup;
		public var menuAnim:BtnGroup;
		public var btnStart:Btn;
		public var btnVisibility:Btn;
		
		public function TextAnimRun()
		{
			stage.scaleMode = "noScale";
			stage.align = "TL";
			
			txtContainer = new TextContainer();
			addChild(txtContainer);
			
			TextAnim.debug = true;
			anim = new TextAnim(txtContainer.txt);
			anim.effects = fxScale;
			
			createMenuBreak();
			createMenuAnim();
			createBtnStart();
			createBtnVisibility();
			
			stage.addEventListener(Event.RESIZE, resizeHandler);
			resizeHandler();
		}
		
		public function createMenuBreak():void
		{
			menuBreak = new BtnGroup();
			addChild(menuBreak);
			menuBreak.title.setText("Break Mode");
			var btnLetters:Btn = menuBreak.addBtn();
			btnLetters.setLabel("LETTERS");
			btnLetters.onClick = function():void {
				anim.breakMode = TextAnim.BREAK_IN_LETTERS;
			}
				
			var btnWords:Btn = menuBreak.addBtn();
			btnWords.setLabel("WORDS");
			btnWords.onClick = function():void {
				anim.breakMode = TextAnim.BREAK_IN_WORDS;
			}
				
			var btnLines:Btn = menuBreak.addBtn();
			btnLines.setLabel("LINES");
			btnLines.onClick = function():void {
				anim.breakMode = TextAnim.BREAK_IN_LINES;
			}
				
			menuBreak.selectBtn(btnLetters);
		}
		
		public function createMenuAnim():void
		{
			menuAnim = new BtnGroup();
			addChild(menuAnim);
			menuAnim.title.setText("Anim Mode");
			
			var btnToRight:Btn = menuAnim.addBtn();
			btnToRight.setLabel("TO RIGHT");
			btnToRight.onClick = function ():void {
				anim.animMode = TextAnim.ANIM_TO_RIGHT;
			}
				
			var btnToLeft:Btn = menuAnim.addBtn();
			btnToLeft.setLabel("TO LEFT");
			btnToLeft.onClick = function ():void {
				anim.animMode = TextAnim.ANIM_TO_LEFT;
			}
				
			var btnToEdges:Btn = menuAnim.addBtn();
			btnToEdges.setLabel("TO EDGES");
			btnToEdges.onClick = function ():void {
				anim.animMode = TextAnim.ANIM_TO_EDGES;
			}
				
			var btnToCenter:Btn = menuAnim.addBtn();
			btnToCenter.setLabel("TO CENTER");
			btnToCenter.onClick = function ():void {
				anim.animMode = TextAnim.ANIM_TO_CENTER;
			}
				
			var btnRandom:Btn = menuAnim.addBtn();
			btnRandom.setLabel("RANDOM");
			btnRandom.onClick = function ():void {
				anim.animMode = TextAnim.ANIM_RANDOM;
			}
			
			menuAnim.selectBtn(btnToRight);
		}
		
		public function createBtnStart():void
		{
			btnStart = new Btn();
			btnStart.setLabel("Start!");
			addChild(btnStart);
			btnStart.onClick = function():void {
				anim.start();
			}
		}
		
		public function createBtnVisibility():void
		{
			btnVisibility = new Btn();
			addChild(btnVisibility);
			btnVisibility.setLabel("Toggle Visibility");
			btnVisibility.onClick = function():void {
				anim.blocksVisible = !anim.blocksVisible;
			}
		}

		public function fxScale(block:TextAnimBlock):void
		{
			block.scaleX = block.scaleY = 0;
			Tweener.addTween(block, {scaleX:1, scaleY:1, time:1, transition:"linear"});
		}
		
		public function resizeHandler(e:*=null):void
		{
			txtContainer.x = stage.stageWidth/2 - txtContainer.width/2;
			txtContainer.y = stage.stageHeight/2 - txtContainer.height/2;
			
			if (menuBreak) {
				menuBreak.x = MARGIN_X;
				menuBreak.y = MARGIN_Y;
			}
			
			if (menuAnim) {
				menuAnim.x = MARGIN_X;
				menuAnim.y = menuBreak.height + MARGIN_Y*2;
			}
			
			if (btnStart) {
				btnStart.x = stage.stageWidth/2;
				btnStart.y = stage.stageHeight - (btnStart.height/2 + MARGIN_Y);
			}
			
			if (btnVisibility) {
				btnVisibility.x = btnVisibility.width/2 + MARGIN_X;
				btnVisibility.y = stage.stageHeight - (btnVisibility.height/2 + MARGIN_Y);
			}
		}
		

	}
}