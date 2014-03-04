package
{
	import com.greensock.TweenMax;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.reyco1.display.SmartSprite;
	
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	
	public class AbstreactPage extends SmartSprite
	{
		private var nextArrow:NextArrow;
		
		public function AbstreactPage()
		{
			super();
			TweenPlugin.activate([FramePlugin]);			
		}
		
		protected function showNextArrow( _onArrowClick:Function ):void
		{
			nextArrow = new NextArrow();
			addChild(nextArrow);
			nextArrow.alpha = 0;
			nextArrow.x = 935;
			nextArrow.y = 430;
			nextArrow.buttonMode = true;
			
			nextArrow.addEventListener(MouseEvent.CLICK, _onArrowClick, false, 0, true);
			nextArrow.gotoAndStop(1);
			TweenMax.to(nextArrow, .5, {x: 975, alpha: 1});
			TweenMax.to(nextArrow, 0.75, {frame:30, delay:0.5});
			new SwipeSound().play(0, 0, new SoundTransform(.1));
		}
	}
}