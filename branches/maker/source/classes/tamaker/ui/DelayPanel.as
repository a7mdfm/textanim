package tamaker.ui 
{
	import com.bit101.components.*;
	import flash.events.MouseEvent;
	
	public class DelayPanel extends TAPanel 
	{
		public var slider:HUISlider;
		public var defaultValue:String = "0";
		
		public function DelayPanel()
		{
			super("delay (ms)");
			
			slider = new HUISlider(panel, _lm, _tm);
			slider.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
			slider.width = 150;
			slider.value = 0;
			slider.maximum = 2000;
			
			panel.setSize(width - 70, height - 15);
		}
		
		public function onMouseUp(e:MouseEvent):void
		{
			selected = String(slider.value);
		}
	}

}