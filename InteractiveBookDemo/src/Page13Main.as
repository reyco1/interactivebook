package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.ThrowPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.reyco1.display.SmartSprite;
	import com.reyco1.media.audio.CoreSound;
	import com.reyco1.media.audio.CueableSound;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class Page13Main extends SmartSprite
	{
		private var main:Page13_mc;

		private var pageSound:CueableSound;
		private var nextArrow:NextArrow;

		private var _timeOut:uint;
		private var instructions:CoreSound;
		private var joseOrigPosition:Point;
		private var tries:int;

		public function Page13Main()
		{
			TweenPlugin.activate([FramePlugin]);

		}

		override protected function onAdded():void
		{
			main = new Page13_mc();
			addChild(main);

			TweenMax.to(MovieClip(main.plane), 5, {x: -875});

			pageSound = new CueableSound(new PageSound13());
			pageSound.onComplete = playInstructions;
			pageSound.play();

		}

		public function playInstructions():void
		{
			setTimeout(function():void
			{

				instructions = new CoreSound(new InstructionsSound13());
				instructions.onComplete = activateInteractivity;
				instructions.play(0, 0, new SoundTransform(.5));

			}, 1000);

		}

		private function activateInteractivity():void
		{
			MovieClip(main.plane).buttonMode = true;
			MovieClip(main.plane).addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown, false, 0, true);

			setTimeout(showNextArrow, 15000);

		}

		protected function _onMouseDown(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, _onStageMouseUp, false, 0, true);
			MovieClip(main.plane).startDrag(false, new Rectangle(-875, 0, 594, 0));

			MovieClip(main.plane).gotoAndPlay(2);
		}

		protected function _onStageMouseUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onStageMouseUp);
			MovieClip(main.plane).stopDrag();
			MovieClip(main.plane).gotoAndStop(1);
		}

		private function showNextArrow():void
		{

			if (!nextArrow)
			{

				try
				{
					stage.removeEventListener(MouseEvent.MOUSE_UP, _onStageMouseUp);
				}
				catch (e:Error)
				{
				}

				MovieClip(main.plane).removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);

				MovieClip(main.plane).buttonMode = false;

				MovieClip(main.plane).stopDrag();

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
