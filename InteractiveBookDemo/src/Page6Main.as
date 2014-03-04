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
	import com.reyco1.util.MathUtil;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class Page6Main extends SmartSprite
	{
		private var main:Page6_mc;

		private var pageSound:CueableSound;
		private var nextArrow:NextArrow;

		private var _timeOut:uint;
		private var instructions:CoreSound;

		private var _cursorController:MouseCursor;

		private var _rect:Rectangle = new Rectangle(792, 395, 88, 88);

		private var _flavorCount:int = 0;
		
		private var lidsTimer:Timer;
		private var reopenTimer:uint;

		public function Page6Main()
		{
			TweenPlugin.activate([FramePlugin]);
			TweenPlugin.activate([ThrowPropsPlugin]);
			
		}

		override protected function onAdded():void
		{
			main = new Page6_mc();
			addChild(main);

			main.container.circle.alpha = 0;
			
			main.container.lids.visible = false;

			pageSound = new CueableSound(new PageSound6());
			pageSound.onComplete = playInstructions;
			pageSound.addCuePoint(7000, moveIndicator, [5]);
			pageSound.play();
			
			lidsTimer = new Timer( MathUtil.random(6, 2) * 1000 ); trace(lidsTimer.delay)
			lidsTimer.addEventListener(TimerEvent.TIMER, handleLidsTimerComplete);
			lidsTimer.start()
		}
		
		protected function handleLidsTimerComplete(event:TimerEvent):void
		{
			main.container.lids.visible = true;
			
			reopenTimer = setTimeout( function():void
			{
				main.container.lids.visible = false;
				lidsTimer.reset();
				lidsTimer.delay = MathUtil.random(6, 2) * 1000;
				trace(lidsTimer.delay)
				lidsTimer.start();
			}, 250);
		}
		
		public function playInstructions():void
		{
			setTimeout(function():void
			{
				TweenMax.to(main.container.circle, .5, {delay: 3, alpha: 1});
				instructions = new CoreSound(new InstructionsSound6());
				
				instructions.onComplete = activateInteractivity;
				instructions.play(0, 0, new SoundTransform(.5));
				main.container.hilite.play();

			}, 1000);

		}

		private function activateInteractivity():void
		{
			_cursorController = new MouseCursor(main.container.syrup);

			main.container.orange.buttonMode = true;
			main.container.red.buttonMode = true;
			main.container.green.buttonMode = true;
			main.container.blue.buttonMode = true;

			main.container.orange.addEventListener(MouseEvent.MOUSE_DOWN, _onSyrupSelected, false, 0, true);
			main.container.red.addEventListener(MouseEvent.MOUSE_DOWN, _onSyrupSelected, false, 0, true);
			main.container.green.addEventListener(MouseEvent.MOUSE_DOWN, _onSyrupSelected, false, 0, true);
			main.container.blue.addEventListener(MouseEvent.MOUSE_DOWN, _onSyrupSelected, false, 0, true);

			main.container.hands.mouseChildren = false;
			stage.addEventListener(MouseEvent.MOUSE_UP, _onHandsMouseUp, false, 0, true);

			_timeOut = setTimeout(showNextArrow, 10000);

		}

		private function _onSyrupSelected(e:MouseEvent):void
		{

			main.container.syrup.gotoAndStop(MovieClip(e.target).name);
			_cursorController.show();
		}

		private function _onHandsMouseUp(e:MouseEvent):void
		{
			if (main.container.syrup.x > _rect.left && main.container.syrup.x < _rect.right && main.container.syrup.y > _rect.top && main.container.syrup.y < _rect.bottom)
			{
				clearTimeout(_timeOut);
				stage.removeEventListener(MouseEvent.MOUSE_UP, _onHandsMouseUp);

				TweenMax.to(main.container.syrup, .5, {rotation: 180, onComplete: _pourSyrup, onCompleteParams: [MovieClip(main.container.syrup).currentFrameLabel]});
				TweenMax.to(main.container.syrup, .5, {delay: 1, rotation: 0, onComplete: _reset});

			}

		}

		private function _pourSyrup(instanceName:String):void
		{

			_flavorCount++;

			var mc:MovieClip = MovieClip(main.container.hands.getChildByName(instanceName));

			MovieClip(main.container.hands).setChildIndex(mc, main.container.hands.numChildren - 1);

			mc.gotoAndPlay(2);

		}

		private function _reset():void
		{
			if (_flavorCount >= 4)
			{
				showNextArrow();
			}
			else
			{

				stage.addEventListener(MouseEvent.MOUSE_UP, _onHandsMouseUp, false, 0, true);
				_timeOut = setTimeout(showNextArrow, 10000);

			}

		}
		
		private function showNextArrow():void
		{
			if(lidsTimer)
			{
				lidsTimer.stop();
				lidsTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, handleLidsTimerComplete);
				lidsTimer = null;
				
				clearTimeout( reopenTimer );
			}
			
			TweenMax.to(main.container.circle, .5, {alpha: 0});
			
			TweenMax.to(main.container.hands, .5, {x: 808, y: 436});
			
			_cursorController.hide();
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onHandsMouseUp);
			
			main.container.orange.mouseEnabled = false;
			main.container.red.mouseEnabled = false;
			main.container.green.mouseEnabled = false;
			main.container.blue.mouseEnabled = false;
			
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
			_cursorController.clear();

			pageSound = null;
			main = null;
			nextArrow = null;
			instructions = null;
			_cursorController = null;

			dispatchEvent(new Event(InteractiveBookDemoMain.PAGE_COMPLETE));
		}

		public function moveIndicator(frameNum:int):void
		{
			TweenMax.to(main.highlight, 0.2, {frame: frameNum});
		}

	}
}
