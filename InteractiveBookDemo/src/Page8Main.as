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

	public class Page8Main extends SmartSprite
	{
		private var main:Page8_mc;

		private var pageSound:CueableSound;
		private var nextArrow:NextArrow;

		private var _timeOut:uint;
		private var instructions:CoreSound;

		private var cookie_InitialXY:Point;

		public function Page8Main()
		{
			TweenPlugin.activate([FramePlugin]);

		}

		override protected function onAdded():void
		{
			main = new Page8_mc();
			main.container.joseRunning.alpha = 0;
			addChild(main);

			cookie_InitialXY = new Point(304, 252);

			pageSound = new CueableSound(new PageSound8());
			pageSound.addCuePoint(11500, moveIndicator, [5]);
			pageSound.onComplete = playInstructions;
			pageSound.play();

		}

		protected function checkThirdTime():void
		{

			showNextArrow();

		}

		public function playInstructions():void
		{
			setTimeout(function():void
			{

				instructions = new CoreSound(new InstructionsSound8());
				instructions.onComplete = activateInteractivity;
				instructions.play(0, 0, new SoundTransform(.5));

			}, 1000);

		}

		private function mouseDownHandler(event:MouseEvent):void
		{
			main.container.cookies8.startDrag(true);
			//ExternalInterface.call('console.log', "start drag");
		}

		private function mouseUpHandler(event:MouseEvent):void
		{
			main.container.cookies8.stopDrag();
			cookiesReturn();

			//ExternalInterface.call('console.log', "start drag");

		}

		private function activateInteractivity():void
		{

			addEventListener(Event.ENTER_FRAME, checkLadyPosition);
			//_timeOut = setTimeout(showNextArrow, 10000);

			TweenMax.to(main.container.lady8.lady8_inside, .5, {x: 180, y: 0, yoyo: true, repeat: 5, repeatDelay: 1.75, onComplete: checkThirdTime})

			main.container.cookies8.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);

			main.container.cookies8.buttonMode = true;

			main.container.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);

			main.container.buttonMode = true;

		}

		private function cookiesReturn():void
		{
			main.container.cookies8.x = cookie_InitialXY.x
			main.container.cookies8.y = cookie_InitialXY.y

			main.container.cookies8.stopDrag();

		}

		protected function checkLadyPosition(event:Event):void
		{

			//if lady is  at the window
			if (main.container.lady8.lady8_inside.x == 0 && main.container.lady8.lady8_inside.y == 0)
			{

				//cookies are not draggable, back to initial position
				cookiesReturn();

					//ExternalInterface.call('console.log', "cookies are draggable");

			}

			if (main.container.cookies8.x > 204 && main.container.cookies8.x < 400 && main.container.cookies8.y > 332 && main.container.cookies8.y < 505)
			{
				new Whipping().play(0, 0, new SoundTransform(.1));
				main.container.cookies8.stopDrag();
				
				TweenMax.killTweensOf(main.container.lady8.lady8_inside);
				removeEventListener(Event.ENTER_FRAME, checkLadyPosition);
				main.container.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				main.container.cookies8.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				main.container.buttonMode = false
				main.container.cookies8.buttonMode = false;

				TweenMax.to(main.container.cookies8, .5, {x: 308, y: 447, scaleX: 1.1, scaleY: 1.1, ease: Bounce.easeOut, onComplete:function():void
				{
					setTimeout(function():void
					{	
						TweenMax.to(main.container.joseRunning, 1, {alpha:1})
						TweenMax.to(main.container.cookies8, 1, {alpha:0})
						TweenMax.to(main.container.joseSitting, 1, {alpha:0, onComplete:showNextArrow});
					}, 1000);
				}});
			}

		}

		private function showNextArrow():void
		{

			if (!nextArrow)
			{
				

				cookiesReturn();

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
			TweenMax.to(nextArrow, .5, {alpha: 0, ease: Back.easeIn, x: 815, onComplete: _nextPage});
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
			TweenMax.to(main.container.highlight, 0.2, {frame: frameNum});
		}

	}
}
