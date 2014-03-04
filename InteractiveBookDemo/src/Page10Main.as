package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.plugins.FramePlugin;
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
	import flash.utils.setTimeout;

	public class Page10Main extends SmartSprite
	{
		private var main:Page10_mc;

		private var pageSound:CueableSound;
		private var nextArrow:NextArrow;

		private var _timeOut:uint;
		private var instructions:CoreSound;
		private var joseOrigPosition:Point;
		private var tries:int;
		
		private var frameNumbers:Array = 
			[
				{frame:30, 	SoundClass:uno},
				{frame:59, 	SoundClass:dos},
				{frame:87, 	SoundClass:tres},
				{frame:117, SoundClass:cuatro},
				{frame:147, SoundClass:cinco},
				{frame:175, SoundClass:seis},
				{frame:203, SoundClass:siete},
				{frame:236, SoundClass:ocho},
				{frame:264, SoundClass:nueve},
				{frame:287, SoundClass:diez},
			];
		
		private var currentFrameIndex:int	= 0;

		public function Page10Main()
		{
			TweenPlugin.activate([FramePlugin]);
		}

		override protected function onAdded():void
		{
			main = new Page10_mc();
			addChild(main);

			main.gotoAndPlay("stepA");

			pageSound = new CueableSound(new PageSound10());
			pageSound.onComplete = playInstructions;
			pageSound.addCuePoint(12500, gotoStepB);
			pageSound.onComplete = showNextArrow;
			pageSound.play();
		}
		
		private function gotoStepB():void
		{
			pageSound.pause();
			//moveIndicator(5);
			main.gotoAndPlay("stepB");
			playInstructions();
		}

		public function playInstructions():void
		{
			setTimeout(function():void
			{

				instructions = new CoreSound(new InstructionsSound10A());
				instructions.onComplete = activateInteractivity1;
				instructions.play(0, 0, new SoundTransform(.5));

			}, 1000);

		}

		private function activateInteractivity1():void
		{

			main.container.bagTop.buttonMode = true;

			main.container.bagTop.addEventListener(MouseEvent.CLICK, _onBagClick, false, 0, true);
		}

		private function _onBagClick(e:MouseEvent):void
		{
			main.container.bagTop.mouseEnabled = false;
			main.container.bagTop.mouseChildren = false;
			
			TweenMax.to(main.container.bagTop, 0.5, {frame:frameNumbers[currentFrameIndex].frame, onStart:function():void
			{
				var tempNumberSound:CoreSound = new CoreSound( new frameNumbers[currentFrameIndex].SoundClass() );
				tempNumberSound.onComplete = numberSoundComplete;
				tempNumberSound.play();
				
				new Whipping().play(0, 0, new SoundTransform(.1));
				new PopSound().play(0, 0, new SoundTransform(.1));
			}});
		}
		
		private function numberSoundComplete():void
		{
			main.container.bagTop.mouseEnabled  = true;
			main.container.bagTop.mouseChildren = true;
			
			currentFrameIndex++;
			
			if(currentFrameIndex == 10)
			{
				_onBagCloseFinish(null);
			}
		}				

		private function _onBagCloseFinish(e:Event):void
		{

			main.container.bagTop.buttonMode = false;

			new SwipeSound().play(0, 0, new SoundTransform(.1));

			instructions.clear();

			main.gotoAndPlay("stepC");

			main.container.bagTop.removeEventListener(MouseEvent.CLICK, _onBagClick);

			main.container.bagTop.removeEventListener("finish", _onBagCloseFinish);

			setTimeout(function():void
			{

				instructions = new CoreSound(new InstructionsSound10B());
				instructions.onComplete = activateInteractivity2;
				instructions.play(0, 0, new SoundTransform(.5));

			}, 1000);

		}

		private function activateInteractivity2():void
		{
			tries = 0;

			joseOrigPosition = new Point(main.stepC.jose.x, main.stepC.jose.y);

			main.stepC.jose.addEventListener(MouseEvent.MOUSE_DOWN, _onJoseMouseDown, false, 0, true);

			main.stepC.jose.buttonMode = true;
		}

		protected function _onJoseMouseDown(event:MouseEvent):void
		{

			MovieClip(main.stepC.jose).startDrag(false, new Rectangle(629, 263, 224, 91));
			stage.addEventListener(MouseEvent.MOUSE_UP, _onStageMouseUp, false, 0, true);
			TweenMax.killTweensOf(MovieClip(main.stepC.jose));

		}

		protected function _onStageMouseUp(event:MouseEvent):void
		{

			tries++;

			if (tries == 5)
			{

				//showNextArrow();
				moveIndicator(5);
				pageSound.resume();
			}
			else
			{

				stage.removeEventListener(MouseEvent.MOUSE_UP, _onStageMouseUp);

			}

			MovieClip(main.stepC.jose).stopDrag();

			TweenMax.to(MovieClip(main.stepC.jose), 2, {x: joseOrigPosition.x, y: joseOrigPosition.y, ease: Elastic.easeOut});

			new SwipeSound().play(0, 0, new SoundTransform(.1));

		}

		private function showNextArrow():void
		{

			if (!nextArrow)
			{

				main.stepC.jose.removeEventListener(MouseEvent.MOUSE_DOWN, _onJoseMouseDown);

				try
				{
					stage.removeEventListener(MouseEvent.MOUSE_UP, _onStageMouseUp);
				}
				catch (e:Error)
				{
				}
				
				MovieClip(main.stepC.jose).stopDrag();
				
				TweenMax.to(MovieClip(main.stepC.jose), 2, {x: joseOrigPosition.x, y: joseOrigPosition.y, ease: Elastic.easeOut});
				
				new SwipeSound().play(0, 0, new SoundTransform(.1));

				main.stepC.jose.buttonMode = false;

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
