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

	public class Page9Main extends SmartSprite
	{
		private var main:Page9_mc;

		private var pageSound:CueableSound;
		private var nextArrow:NextArrow;

		private var _timeOut:uint;

		public function Page9Main()
		{
			TweenPlugin.activate([FramePlugin]);

		}

		override protected function onAdded():void
		{
			main = new Page9_mc();
			addChild(main);
			main.turtle.visible = false;
			main.boat.turtle.buttonMode = true;
			main.boat.turtle.mouseChildren = false;
			main.boat.turtle.addEventListener(MouseEvent.CLICK, _onTurtleClick, false, 0, true);

			pageSound = new CueableSound(new PageSound9());
			pageSound.onComplete = showNextArrow;
			//pageSound.addCuePoint(0, moveIndicator, [5]);
			pageSound.play();

		}

		private function showNextArrow():void
		{

			main.boat.turtle.removeEventListener(MouseEvent.CLICK, _onTurtleClick);

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

		protected function _onTurtleClick(event:MouseEvent):void
		{

			TweenMax.to(main.turtle, .5, {autoAlpha: 1});
			main.turtle.gotoAndPlay(2);
			main.boat.circle.visible = false;
			main.boat.turtle.visible = false;
			new Whipping().play(0, 0, new SoundTransform(.2));

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
