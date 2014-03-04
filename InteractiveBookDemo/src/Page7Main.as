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
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class Page7Main extends SmartSprite
	{
		private var main:Page7_mc;

		private var pageSound:CueableSound;
		private var nextArrow:NextArrow;

		private var _timeOut:uint;
		private var _timeOut2:uint;
		private var instructions:CoreSound;

		private var _cursorController:MouseCursor;

		private var _quenepasRect:Rectangle = new Rectangle(182, 363, 144, 40);
		private var _scaleRect:Rectangle = new Rectangle(491, 300, 100, 100);

		private var _dropCount:int = 0;
		private var _hasQuenepaInHand:Boolean;
		private var _droppedInBag:Boolean = false;

		public function Page7Main()
		{
			TweenPlugin.activate([FramePlugin]);
			TweenPlugin.activate([ThrowPropsPlugin]);

		}

		override protected function onAdded():void
		{
			main = new Page7_mc();
			addChild(main);

			main.circle.alpha = 0;

			pageSound = new CueableSound(new PageSound7());
			pageSound.onComplete = playInstructions;
			pageSound.addCuePoint(9000, moveIndicator, [5]);
			pageSound.play();
			
			main.hilite.visible = false;

		}

		public function playInstructions():void
		{
			setTimeout(function():void
			{

				instructions = new CoreSound(new InstructionsSound7());
				instructions.onComplete = activateInteractivity;
				instructions.play(0, 0, new SoundTransform(.5));
				main.hilite.visible = true;
			}, 1000);

		}

		private function activateInteractivity():void
		{
			main.hilite.visible = false;
			
			_cursorController = new MouseCursor(main.quenepa_cursor);

			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown, false, 0, true);

			_timeOut = setTimeout(showNextArrow, 10000);

		}

		protected function _onMouseDown(event:MouseEvent):void
		{
			clearTimeout(_timeOut);

			//IF within the quenepas crate
			if (main.mouseX > _quenepasRect.left && main.mouseX < _quenepasRect.right && main.mouseY > _quenepasRect.top && main.mouseY < _quenepasRect.bottom)
			{
				_hasQuenepaInHand = true;
				_cursorController.show();
			}
		}

		protected function _onMouseUp(event:MouseEvent):void
		{
			//IF within the scale drop area
			if (main.mouseX > _scaleRect.left && main.mouseX < _scaleRect.right && (main.mouseY > _scaleRect.top - 100) && main.mouseY < _scaleRect.bottom)
			{
				if (_hasQuenepaInHand)
					dropQuenepa();
			}

			_cursorController.hide();
			_timeOut = setTimeout(showNextArrow, 10000);

		}

		private function dropQuenepa():void
		{
			_dropCount++;

			if (_dropCount == 1)
			{
				new uno().play();
				main.scale.gotoAndPlay("onelb");
			}
			else if (_dropCount == 2)
			{
				new dos().play();
				main.scale.gotoAndPlay("twolb");
			}
			else if (_dropCount == 3)
			{
				new tres().play();
				main.scale.gotoAndPlay("threelb");
				enableBag();
			}

			_hasQuenepaInHand = false;

		}

		private function enableBag():void
		{

			TweenMax.to(main.circle, .5, {alpha: 1});
			TweenMax.to(main.circle, 2, {delay: .5, alpha: 0, scaleX: .79, scaleY: .79});

			main.circle.buttonMode = true;
			main.circle.mouseChildren = false;

			main.circle.addEventListener(MouseEvent.CLICK, _onBagClick, false, 0, true);

		}

		protected function _onBagClick(event:MouseEvent):void
		{
			_droppedInBag = true;
			main.scale.gotoAndPlay("drop");
			_timeOut2 = setTimeout(showNextArrow, 3000);
		}

		private function showNextArrow():void
		{
			trace("showNextArrow");

			if (!nextArrow)
			{

				clearTimeout(_timeOut);
				clearTimeout(_timeOut2);

				if (!_droppedInBag)
					main.scale.gotoAndPlay("drop");

				main.circle.buttonMode = false;
				main.circle.mouseEnabled = false;

				_cursorController.hide();

				try
				{
					stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
					stage.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
				}
				catch (e:Error)
				{
				}
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
