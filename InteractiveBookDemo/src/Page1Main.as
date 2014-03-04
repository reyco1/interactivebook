package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.reyco1.display.SmartSprite;
	import com.reyco1.media.audio.CoreSound;
	import com.reyco1.media.audio.CueableSound;
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.media.SoundTransform;
	import flash.utils.setTimeout;
	
	import Box2D.Common.Math.b2Vec2;

	public class Page1Main extends SmartSprite
	{
		private var main:Main;

		private var pageSound:CueableSound;
		private var instructions:CoreSound;
		private var phy:PhysInjector;
		private var nextArrow:NextArrow;
		private var boxXLimit:Number = 720;
		private var boxYLimit:Number = 409;
		private var locked:Boolean = false;
		private var meowHasPlayed:Boolean = false;

		public function Page1Main()
		{
			TweenPlugin.activate([FramePlugin]);

		}

		override protected function onAdded():void
		{
			main = new Main();
			addChild(main);

			pageSound = new CueableSound(new PageSound1a());
			pageSound.onComplete = playNextSound
			pageSound.play();

			main.w1.alpha = main.w2.alpha = main.w3.alpha = main.w4.alpha = 0;
		}

		private function playNextSound():void
		{

			pageSound.clear();

			pageSound = new CueableSound(new PageSound());
			pageSound.onComplete = playInstructions;
			pageSound.addCuePoint(0, moveIndicator, [5]);
			pageSound.addCuePoint(5000, moveIndicator, [10]);
			pageSound.play();

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
			phy = null;
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
				instructions = new CoreSound(new InstructionsSound());
				instructions.onComplete = activatePhysics;
				instructions.play(0, 0, new SoundTransform(2));

				main.box1.filters = [new GlowFilter()]
				main.box2.filters = [new GlowFilter()]
				main.box3.filters = [new GlowFilter()]

			}, 1000);

		}

		private function activatePhysics():void
		{
			main.box1.filters = [];
			main.box2.filters = [];
			main.box3.filters = [];

			main.highlight.visible = false;

			phy = new PhysInjector(this.stage, new b2Vec2(0, 60), true);
			phy.injectPhysics(main.box1, PhysInjector.SQUARE);
			phy.injectPhysics(main.box2, PhysInjector.SQUARE);
			phy.injectPhysics(main.box3, PhysInjector.SQUARE);

			phy.injectPhysics(main.w1, PhysInjector.SQUARE, new PhysicsProperties({isDynamic: false}));
			phy.injectPhysics(main.w2, PhysInjector.SQUARE, new PhysicsProperties({isDynamic: false}));
			phy.injectPhysics(main.w3, PhysInjector.SQUARE, new PhysicsProperties({isDynamic: false}));
			phy.injectPhysics(main.w4, PhysInjector.SQUARE, new PhysicsProperties({isDynamic: false}));

			startRender();
		}

		override protected function onRender():void
		{
			phy.update();

			if (main.box1.x < 308 || main.box1.x > 480 || main.box1.y < 409)
			{

				if (!meowHasPlayed)
				{
					meowHasPlayed = true;
					new Meow().play(0, 0, new SoundTransform(.5));
					main.tail.play();
				}
			}

			if (main.box1.x > boxXLimit && main.box2.x > boxXLimit && main.box3.x > boxXLimit && main.box1.y > boxYLimit && main.box2.y > boxYLimit && main.box3.y > boxYLimit)
			{

				phy.allowDrag = false;

				if (!locked)
				{
					locked = true;
					showNextArrow();
				}
			}

		}
	}
}
