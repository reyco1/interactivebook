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

	public class Page14Main extends SmartSprite
	{
		private var main:Page14_mc;

		private var pageSound:CueableSound;
		private var nextArrow:NextArrow;

		private var instructions:CoreSound;

		

		public function Page14Main()
		{
			TweenPlugin.activate([FramePlugin]);

		}

		override protected function onAdded():void
		{
			main = new Page14_mc();
			addChild(main);

			pageSound = new CueableSound(new PageSound14());
			pageSound.addCuePoint(12000, moveIndicator, [5]);
			pageSound.onComplete = playInstructions;
			pageSound.play();

		}

		public function playInstructions():void
		{
			setTimeout(function():void
			{

				instructions = new CoreSound(new InstructionsSound14());
				instructions.onComplete = activateInteractivity;
				instructions.play(0, 0, new SoundTransform(.5));

			}, 1000);

		}

		private function africaMouseDownHandler(event:MouseEvent):void
		{
			main.africa.play();
		}
		
		private function chinaMouseDownHandler(event:MouseEvent):void
		{
			main.china.play();
		}
		
		private function indiaMouseDownHandler(event:MouseEvent):void
		{
			main.india.play();
		}
		
		private function egyptMouseDownHandler(event:MouseEvent):void
		{
			main.egypt.play();
		}

		
		
		
		private function activateInteractivity():void
		{

			main.africa.addEventListener(MouseEvent.MOUSE_DOWN, africaMouseDownHandler);
			main.africa.buttonMode = true;
			
			main.china.addEventListener(MouseEvent.MOUSE_DOWN, chinaMouseDownHandler);
			main.china.buttonMode = true;
			
			main.india.addEventListener(MouseEvent.MOUSE_DOWN, indiaMouseDownHandler);
			main.india.buttonMode = true;
			
			main.egypt.addEventListener(MouseEvent.MOUSE_DOWN, egyptMouseDownHandler);
			main.egypt.buttonMode = true;

		}

		

		private function showNextArrow():void
		{

			if (!nextArrow)
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
