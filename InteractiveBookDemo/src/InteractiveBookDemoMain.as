package
{
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.reyco1.media.audio.CoreSound;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundTransform;

	[SWF(width = "1092", height = "559", frameRate = "60")]
	public class InteractiveBookDemoMain extends Sprite
	{

		public var pageList:Array;
		public var index:int;
		private var bgSound:CoreSound;
		public static var PAGE_COMPLETE:String = "pageComplete";

		public function InteractiveBookDemoMain()
		{

			index = 4;
			pageList = new Array(new Page1Main(), new Page2Main(), new Page3Main(), new Page4Main(), new Page5Main(), new Page6Main(), new Page7Main(), new Page8Main(), new Page9Main(), new Page10Main(), new Page11Main(), new Page12Main(), new Page13Main(), new Page14Main());

			bgSound = new CoreSound(new SalsaSound());
			bgSound.play(0, 999, new SoundTransform(0.5));

			addEventListener(Event.ADDED_TO_STAGE, _onAdded);
			
			TweenPlugin.activate([FramePlugin]);
		}

		protected function _onAdded(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAdded);

			showNextPage();
		}

		private function showNextPage():void
		{

			if (numChildren > 0)
				removeChild(pageList[index]);

			index++;

			if (index == pageList.length)
				index = 0;

			trace("next index", index);

			var newPage:Sprite = pageList[index];
			newPage.addEventListener(PAGE_COMPLETE, onPageComplete, false, 0, true);

			addChild(pageList[index]);

		}

		protected function onPageComplete(event:Event):void
		{
			showNextPage();
		}
	}
}
