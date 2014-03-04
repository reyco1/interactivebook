package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.ThrowPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.reyco1.display.SmartSprite;
	import com.reyco1.media.audio.CueableSound;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;

	public class Page5Main extends SmartSprite
	{
		private var main:Page5_mc;

		private var pageSound:CueableSound;
		private var nextArrow:NextArrow;

		private var _timeOut:uint;

		public function Page5Main()
		{
			TweenPlugin.activate([FramePlugin]);
			TweenPlugin.activate([ThrowPropsPlugin]);

		}

		override protected function onAdded():void
		{
			main = new Page5_mc();
			addChild(main);
			main.turtle.buttonMode = true;
			main.turtle.mouseChildren = false;
			main.turtle.addEventListener(MouseEvent.CLICK, _onTurtleClick, false, 0, true);

			pageSound = new CueableSound(new PageSound5());
			pageSound.onComplete = showNextArrow;
			pageSound.addCuePoint(7500, moveIndicator, [5]);
			pageSound.play();

		}

		protected function _onTurtleClick(event:MouseEvent):void
		{

			main.turtle.gotoAndPlay(2);
			main.turtle.mouseEnabled = false;
			main.circle.visible = false;
			new Whipping().play(0, 0, new SoundTransform(.2));

		}

		private function showNextArrow():void
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

		protected function _onArrowClick(event:Event):void
		{
			TweenMax.to(nextArrow, .5, {ease: Back.easeIn, x: 1200, onComplete: _nextPage});
		}

		private function _nextPage():void
		{

			removeChild(main);
			removeChild(nextArrow);
			pageSound.clear();

			pageSound = null;
			main = null;
			nextArrow = null;

			dispatchEvent(new Event(InteractiveBookDemoMain.PAGE_COMPLETE));
		}

		public function moveIndicator(frameNum:int):void
		{
			TweenMax.to(main.highlight, 0.2, {frame: frameNum});
		}

	}
}
