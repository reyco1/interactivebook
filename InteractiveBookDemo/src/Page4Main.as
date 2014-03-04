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
	import flash.events.TransformGestureEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	
	public class Page4Main extends SmartSprite
	{
		private var main:Page4_mc;
		
		private var pageSound:CueableSound;
		private var instructions:CoreSound;
		private var nextArrow:NextArrow;
		private var swipeCount:int;
		private var blockSwipe:Boolean;
		
		private var _timeOut:uint;
		
		public function Page4Main()
		{
			TweenPlugin.activate([FramePlugin]);
			TweenPlugin.activate([ThrowPropsPlugin]);
			
			swipeCount= 0;
		}
		
		override protected function onAdded():void
		{
			main = new Page4_mc();
			addChild( main );
			
			
			
			pageSound = new CueableSound( new PageSound4() );
			pageSound.onComplete = playInstructions
			
			pageSound.addCuePoint( 6000, moveIndicator, [5] );
			pageSound.addCuePoint( 21000, moveIndicator, [10] );
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
			TweenMax.to(nextArrow, .5, {ease:Back.easeIn, x: 1200, onComplete:_nextPage});
		}
		
		private function _nextPage():void{
			
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
		
		public function moveIndicator( frameNum:int ):void
		{
			TweenMax.to(main.highlight, 0.2, {frame:frameNum});
		}
		
		public function playInstructions():void
		{
			setTimeout(function():void{
				
				instructions = new CoreSound( new InstructionsSound4() );
				instructions.onComplete = activateSwipe;
				instructions.play(0, 0, new SoundTransform(.5));
				
				
			}, 1000); 
			
		}
		
		private function activateSwipe():void
		{
			
			_setTimeOut()
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN , onMouseDown, false, 0 , true);
			stage.addEventListener(MouseEvent.MOUSE_UP , onMouseUp, false, 0 , true);
			
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSwipe, false, 0, true);
			
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSwipe);
			blockSwipe = false;
		}
		
		
		
		protected function onSwipe(event:MouseEvent):void
		{
			
			if(blockSwipe == false){
				
				trace("Swipe!!");
				
				clearTimeout(_timeOut);
				
				blockSwipe = true;
				
				swipeCount++;
				
				if(swipeCount == 1){
					
					slideCoqui();
					
					_setTimeOut();
					
				}else if(swipeCount == 2){
					
					slideJose();
					
				}
				
			}
			
		}
		
		private function _setTimeOut():void
		{
			_timeOut = setTimeout(slideJoseAndCoqui, 10000);
		}
		
		protected function slideJoseAndCoqui():void{
			slideJose();
			slideCoqui();
		}
		
		protected function slideJose():void{
			
			new Whipping().play(0,0,new SoundTransform(.2));
			
			TweenMax.to(main.jose1, .5, {y:593, ease:Back.easeIn});
			TweenMax.to(main.jose2, .2, {x:1313, ease:Back.easeIn});
			
			showNextArrow();
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN , onMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP , onMouseUp);
			if(stage.hasEventListener(MouseEvent.MOUSE_MOVE))stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSwipe);
		}
		
		protected function slideCoqui():void{
			
			new Whipping().play(0,0,new SoundTransform(.2));
			
			TweenMax.to(main.coqui1, .5, {y:593, ease:Back.easeIn});
			TweenMax.to(main.coqui2, .2, {x:1313, ease:Back.easeIn});
			
		}
		
		
		
	}
}