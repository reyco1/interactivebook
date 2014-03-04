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
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.utils.setTimeout;

	public class Page3Main extends SmartSprite
	{
		private var main:Page3_mc;

		private var pageSound:CueableSound;
		private var instructions:CoreSound;
		private var nextArrow:NextArrow;
		private var dragArrow:DragArrow;

		private var bounds:Rectangle = new Rectangle(-1092, 0, 1092, 0);

		public function Page3Main()
		{
			TweenPlugin.activate([FramePlugin]);
			TweenPlugin.activate([ThrowPropsPlugin]);
		}

		override protected function onAdded():void
		{
			main = new Page3_mc();
			addChild(main);

			pageSound = new CueableSound(new PageSound3());
			pageSound.onComplete = playInstructions

			pageSound.addCuePoint(11000, moveIndicator, [5]);
			pageSound.addCuePoint(13500, closeEyes);
			pageSound.play();

		}

		private function closeEyes():void
		{

			main.container.jose.josebody.head.eyes.play();
			//main.container.jose.josebody.josebody_3.play();

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
			instructions.clear();

			instructions = null;
			pageSound = null;
			main = null;
			nextArrow = null;

			stage.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);

			dispatchEvent(new Event(InteractiveBookDemoMain.PAGE_COMPLETE));
		}

		public function moveIndicator(frameNum:int):void
		{
			TweenMax.to(main.highlight, 0.2, {frame: frameNum});
		}

		public function playInstructions():void
		{
			setTimeout(function():void
			{

				instructions = new CoreSound(new InstructionsSound3());
				instructions.onComplete = activatePan;
				instructions.play(0, 0, new SoundTransform(.5));

			}, 1000);

		}

		private function activatePan():void
		{

			stage.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp, false, 0, true);

			addEventListener(Event.ENTER_FRAME, _onEnterFrame, false, 0, true);

			dragArrow = new DragArrow();
			dragArrow.alpha = 0;
			dragArrow.x = 982;
			dragArrow.y = 280;
			TweenMax.to(dragArrow, .5, {alpha: 1});
			main.addChild(dragArrow);

		}

		protected function _onMouseUp(event:MouseEvent):void
		{
			main.stopDrag();
		}

		protected function _onMouseDown(event:MouseEvent):void
		{
			main.startDrag(false, bounds);
		}

		protected function _onEnterFrame(e:Event):void
		{

			if (main.x < -900)
			{

				removeEventListener(Event.ENTER_FRAME, _onEnterFrame);

				showCoqui();
			}

		}

		private function showCoqui():void
		{
			new PopSound().play(0, 0, new SoundTransform(.2));
			TweenMax.to(main.container.bush4.coqui, .5, {y: -172, ease: Back.easeOut});
			MovieClip(main.container.bush4.coqui).buttonMode = true;
			MovieClip(main.container.bush4.coqui).addEventListener(MouseEvent.CLICK, _onCoquiClick, false, 0, true);
			main.container.bush4.coqui.gotoAndPlay(2);

		}

		private function _onCoquiClick(e:MouseEvent = null):void
		{
			MovieClip(main.container.bush4.coqui).buttonMode = false;
			MovieClip(main.container.bush4.coqui).removeEventListener(MouseEvent.CLICK, _onCoquiClick);

			//circle disspears
			main.container.bush4.coqui.gotoAndPlay("disappear");

			showNextArrow();
		}

	}
}
