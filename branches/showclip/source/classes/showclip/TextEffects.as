package showclip
{
	import flupie.textanim.TextAnimBlock;
	import caurina.transitions.Tweener;

	public class TextEffects
	{
	
		public static function alphaIn(block:TextAnimBlock)
		{
			block.alpha = 0;
			Tweener.addTween(block, {alpha:1, time:1, transition:"easeoutquart"});
		}
	
	}

}