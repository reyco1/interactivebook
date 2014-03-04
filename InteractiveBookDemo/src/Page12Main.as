package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.reyco1.display.SmartSprite;
	import com.reyco1.media.audio.CoreSound;
	import com.reyco1.media.audio.CueableSound;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.SoundTransform;
	import flash.utils.setTimeout;

	public class Page12Main extends SmartSprite
	{
		private var main:Page12_mc;

		private var pageSound:CueableSound;
		private var nextArrow:NextArrow;

		private var instructions:CoreSound;

		private var incrementation:Number = 0;

		public function Page12Main()
		{
			TweenPlugin.activate([FramePlugin]);

		}

		override protected function onAdded():void
		{
			main = new Page12_mc();
			addChild(main);

			pageSound = new CueableSound(new PageSound12());
			pageSound.addCuePoint(12000, moveIndicator, [5]);
			pageSound.onComplete = playInstructions;
			pageSound.play();

		}

		public function playInstructions():void
		{
			setTimeout(function():void
			{

				instructions = new CoreSound(new InstructionsSound12());
				instructions.onComplete = activateInteractivity;
				instructions.play(0, 0, new SoundTransform(.5));

			}, 1000);

		}

		private function mouseDownHandler(event:MouseEvent):void
		{

			// play guitar sound, add 1 to number of times strum of guitar
			incrementation++
			new GuitarSound().play(0, 0, new SoundTransform(.1));
			main.frog.frogInside.play();

			checkNumberofClicks();

		}

		private function activateInteractivity():void
		{

			main.frog.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);

			main.frog.buttonMode = true;

		}

		private function checkNumberofClicks():void
		{

			//if 4 clicks
			if (incrementation == 4)
			{

				//next arrow
				showNextArrow();

			}

		}

		private function showNextArrow():void
		{

			if (!nextArrow)
			{

				removeEventListener(Event.ENTER_FRAME, checkNumberofClicks);

				main.frog.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);

				main.frog.buttonMode = false;

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

		protected function _onArrowClick(event:Event):void
		{
			TweenMax.to(nextArrow, .5, {ease: Back.easeIn, x: 1200, onComplete: _nextPage});
		}

		private function _nextPage():void
		{

			removeChild(main);
			removeChild(nextArrow);
			pageSound.clear();
			instructions.clear();

			pageSound = null;
			main = null;
			nextArrow = null;
			instructions = null;

			dispatchEvent(new Event(InteractiveBookDemoMain.PAGE_COMPLETE));
		}

		public function moveIndicator(frameNum:int):void
		{
			TweenMax.to(main.highlight, 0.2, {frame: frameNum});
		}

	}
}
