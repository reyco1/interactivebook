package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.ThrowPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.reyco1.display.SmartSprite;
	import com.reyco1.media.audio.CoreSound;
	import com.reyco1.media.audio.CueableSound;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class Page11Main extends SmartSprite
	{
		private var main:Page11_mc;

		private var pageSound:CueableSound;
		private var nextArrow:NextArrow;

		private var _timeOut:uint;

		public function Page11Main()
		{
			TweenPlugin.activate([FramePlugin]);

		}

		override protected function onAdded():void
		{
			main = new Page11_mc();
			addChild(main);

			main.light.alpha = 0;

			pageSound = new CueableSound(new PageSound11());
			pageSound.onComplete = showNextArrow;
			pageSound.addCuePoint(19500, moveIndicator, [5]);

			//aninate lightbulb at cue point
			pageSound.addCuePoint(31000, pageSound.pause);
			pageSound.addCuePoint(31000, enableLightBulb);
			new PopSound().play(0, 0, new SoundTransform(.1));

			pageSound.play();

		}

		private function enableLightBulb():void
		{
			TweenMax.to(main.light, .5, {alpha: 1});
			main.light.buttonMode = true;
			main.light.addEventListener(MouseEvent.CLICK, lightBulb, false, 0, true);
		}

		private function lightBulb(e:MouseEvent):void
		{
			main.light.gotoAndStop(2);
			main.light.removeEventListener(MouseEvent.CLICK, lightBulb);
			pageSound.resume();
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
