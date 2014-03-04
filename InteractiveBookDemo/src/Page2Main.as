package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Linear;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.reyco1.display.SmartSprite;
	import com.reyco1.media.audio.CoreSound;
	import com.reyco1.media.audio.CueableSound;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	import flash.utils.setTimeout;

	public class Page2Main extends SmartSprite
	{
		private var main:Page2_mc;

		private var pageSound:CueableSound;
		private var instructions:CoreSound;
		private var nextArrow:NextArrow;
		private var pictureIndex:int = 0;
		private var tailTween:TweenMax;

		public function Page2Main()
		{
			TweenPlugin.activate([FramePlugin]);

		}

		override protected function onAdded():void
		{
			main = new Page2_mc();
			addChild(main);

			pageSound = new CueableSound(new PageSound2());
			pageSound.onComplete = playInstructions
			pageSound.addCuePoint(8500, moveIndicator, [5]);
			pageSound.play();
			
			tailTween = TweenMax.to(main.tail, 2, {frame:main.tail.totalFrames, yoyo:true, repeat:-1, ease:Linear.easeNone});
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
			stage.removeEventListener(MouseEvent.CLICK, _onClick);
		}

		private function _nextPage():void
		{
			if(tailTween)
			{
				tailTween.kill();
				tailTween = null;
			}
			
			
			removeChild(main);
			removeChild(nextArrow);
			pageSound.clear();
			instructions.clear();

			instructions = null;
			pageSound = null;
			main = null;
			nextArrow = null;

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
				instructions = new CoreSound(new InstructionsSound2());
				instructions.onComplete = activatePhotos;

				instructions.play(0, 0, new SoundTransform(.5));

			}, 1000);

		}

		private function activatePhotos():void
		{
			stage.addEventListener(MouseEvent.CLICK, _onClick, false, 0, true);

			setTimeout(function():void
			{

				showNextArrow();

			}, 10000);

		}

		protected function _onClick(event:MouseEvent):void
		{

			pictureIndex++;

			if (pictureIndex < 4)
				main.sparkles.gotoAndPlay(1);

			if (pictureIndex == 1)
				main.photo1.play();
			else if (pictureIndex == 2)
				main.photo2.play();
			else if (pictureIndex == 3)
			{

				main.photo3.play();
				showNextArrow();
			}
		}

	}
}
