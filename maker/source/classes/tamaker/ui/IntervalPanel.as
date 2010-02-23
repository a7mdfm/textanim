package tamaker.ui 
{
	import com.bit101.components.*;
	
	public class IntervalPanel extends TAPanel 
	{
		public var slider:HSlider;
		public var defaultValue:String = "100";
		
		public function IntervalPanel(onChange:Function)
		{
			super("interval (ms)");
			
			slider = new HSlider(panel, _lm, _tm, onChange);
			slider.width = 90;
			slider.value = 20;
			
			panel.setSize(width + _lm, height + _lm);
		}
	
	}

}

