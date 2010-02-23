package com.gabriellaet
{	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.text.*;
	import flash.utils.getTimer;
	import flash.display.Shape;
	
	public class FPS extends Sprite
	{
		private var output:TextField;
		private var lastTime:Number;
		private var frames:Number;
		private var counter:int;
		private var graph:Shape;
		
		public function FPS()
		{
			var css:StyleSheet = new StyleSheet();
			css.parseCSS("p{ font-family:Helvetica; font-font-size:12px; font-weight:bold; }");
			
			output = new TextField();
			output.y = 4;
			output.autoSize = TextFieldAutoSize.LEFT;
			output.styleSheet = css;
			output.blendMode = 'invert';
			
			graph = new Shape( );
			graph.graphics.lineStyle( 1 );
			graph.graphics.moveTo( 0, 10 );
			graph.y = 10;
			
			graphics.lineStyle( 1 , 0x0, .2);
			graphics.beginFill( 0xFFFFFF );
			graphics.drawRect( 0, 20, 100, 60 );
			graphics.endFill();
			
			frames = 0;
			counter = 0;
			lastTime = getTimer();
			
			addChild(output);
			addChild(graph);
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			super();
		}
		
		private function update(e:Event):void
		{
			frames++;
			var now:Number = getTimer();
			if (now - lastTime >= 1000)
			{
				if( frames <= 20 ){
					graph.graphics.lineStyle( 1, 0xFF0000 );
				}else{
					graph.graphics.lineStyle( 1 );
				}
				
				if( counter >= 100 ){
					counter = 0;
					graph.graphics.clear( );
					graph.graphics.lineStyle( 1 );
					graph.graphics.moveTo( 0, 10 );
				}
				
				graph.graphics.lineTo( counter, Math.min( 70, ( 60 / frames ) * 10 ) );
				
				var memory:String = Number(System.totalMemory/1024/1024).toFixed(1)+"MB";
				output.htmlText = "<p>"+String(frames)+"fps / "+String(memory)+"</p>";
				frames = 0; lastTime = now;				
				
				counter += 5;
			}
		
		}

	}
}