package
{
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	
	import components.Btn;
	import components.InputText;
	import components.MenuAnchor;
	import components.MenuAnim;
	import components.MenuBreak;
	import components.MenuTools;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flupie.textanim.TextAnim;
	import flupie.textanim.TextAnimBlock;
	import flupie.textanim.TextAnimEvent;
	import flupie.textanim.TextAnimMode;
	
	public class TextAnimRun extends Sprite
	{
		public static const MARGIN_X:Number = 10;
		public static const MARGIN_Y:Number = 10;
		
		public var txtContainer:TextContainer;
		public var anim:TextAnim;
		
		public var menuBreak:MenuBreak;
		public var menuAnim:MenuAnim;
		public var menuAnchor:MenuAnchor;
		public var menuTools:MenuTools;
		public var logo:FlupieLogoView;
		public var inputText:InputText;
		public var eventLog:InputText;
		public var btnStart:Btn;
		public var btnVisibility:Btn;
		
		public function TextAnimRun()
		{
			stage.scaleMode = "noScale";
			stage.align = "TL";
			
			
			ColorShortcuts.init();
			
			logo = new FlupieLogoView();
			addChild(logo);
			
			txtContainer = new TextContainer();
			addChild(txtContainer);
			
			//TextAnim.debug = true;
			/*
			anim = new TextAnim(txtContainer.txt);
			anim.effects = [fxScale, fxRotation];
			anim.time = 3500;
			anim.debug = true;
			*/
			anim = TextAnim.create(txtContainer.txt, [fxScale, fxRotation], {time:3500, debug:true});
			anim.start(3000);
			
			createMenus();
			createBtnStart();
			createBtnVisibility();
			createInputText();
			createEventLog();
			
			anim.addEventListener(TextAnimEvent.START, function(e:*):void {
				eventLog.text += <p>--------------------------</p>
				eventLog.text += <p>### START</p>
			});
			anim.addEventListener(TextAnimEvent.PROGRESS, function(e:*):void {
				eventLog.text += <p>progress</p>
			});
			anim.addEventListener(TextAnimEvent.COMPLETE, function(e:*):void {
				eventLog.text += <p>### COMPLETE</p>
				//anim.debug = !anim.debug;
			});
			
			stage.addEventListener(Event.RESIZE, resizeHandler);
			resizeHandler();
		}
		
		public function createMenus():void
		{
			menuAnchor = new MenuAnchor();
			addChild(menuAnchor);
			menuAnchor.textAnim = anim;
			
			menuBreak = new MenuBreak();
			addChild(menuBreak);
			menuBreak.textAnim = anim;
			
			menuAnim = new MenuAnim();
			addChild(menuAnim);
			menuAnim.textAnim = anim;
			
			menuTools = new MenuTools();
			addChild(menuTools);
			menuTools.textAnim = anim;
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
		
		public function createInputText():void
		{
			inputText = new InputText();
			inputText.txt.maxChars = 130;
			addChild(inputText);
			inputText.title.setText("Text to animate");
			inputText.btn.setLabel("UPDATE");
			inputText.btn.onClick = function():void {
				anim.text = inputText.txt.text;
			}
		}
		
		public function createEventLog():void
		{
			eventLog = new InputText();
			addChild(eventLog);
			eventLog.title.setText("Event log");
			eventLog.btn.setLabel("Clear");
			eventLog.btn.onClick = function():void {
				eventLog.text = "";
			}
			eventLog.txt.selectable = false;
		}

		public function fxScale(block:TextAnimBlock):void
		{
			block.scaleX = block.scaleY = 0;
			Tweener.addTween(block, {scaleX:1, scaleY:1, time:1, transition:"linear"});
		}
		
		public function fxRotation(block:TextAnimBlock):void
		{
			Tweener.addTween(block, {rotation:360, time:1, delay:1});
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
			
			if (menuAnchor) {
				menuAnchor.x = 150;
				menuAnchor.y = MARGIN_Y;
			}

			
			if (menuTools) {
				menuTools.x = stage.stageWidth - menuTools.width - MARGIN_X;
				menuTools.y = MARGIN_Y;
			}
			
			if (eventLog) {
				eventLog.x = stage.stageWidth - eventLog.width - MARGIN_X;
				eventLog.y = stage.stageHeight - eventLog.height - MARGIN_Y;
			}
			
			if (logo) {
				logo.x = stage.stageWidth/2;
				logo.y = MARGIN_Y + logo.height/2;
			}
			
			if (inputText) {
				inputText.x = stage.stageWidth - inputText.width - MARGIN_X;
				inputText.y = eventLog.y - inputText.height - MARGIN_Y;
			}
		}
		

	}
}