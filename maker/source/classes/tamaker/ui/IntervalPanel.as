package tamaker.ui 
{
	import com.bit101.components.*;
	import flash.events.MouseEvent;
	
	public class IntervalPanel extends TAPanel 
	{
		public var slider:HSlider;
		public var defaultValue:String = "100";
		
		public function IntervalPanel()
		{
			super("interval (ms)");
			
			slider = new HSlider(panel, _lm, _tm);
			slider.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
			slider.width = 90;
			slider.value = 20;
			
			panel.setSize(width + _lm, height + _lm);
		}
		
		public function onMouseUp(e:MouseEvent):void
		{
			selected = String(slider.value);
		}
	}

}