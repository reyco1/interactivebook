package
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	[SWF(width = "1092", height = "559", frameRate = "60")]
	public class preloader extends Sprite
	{
		private var loader:LoaderMax;
		private var field:TextField;
		
		public function preloader()
		{
			super();		
			addEventListener( Event.ADDED_TO_STAGE, handleAdded );
		}
		
		protected function handleAdded(event:Event):void
		{
			trace("initializing game");
			
			field = new TextField();
			field.defaultTextFormat = new TextFormat("_sans", 30, 0x000000);
			field.autoSize = TextFieldAutoSize.LEFT;
			addChild( field );
			
			initLoading();
		}		
		
		private function initLoading():void
		{
			loader = new LoaderMax( {onProgress:progressHandler} );
			loader.append( new SWFLoader("InteractiveBookDemoMain.swf", {name:"budgetblinds", container:this, autoPlay:true}) );
			loader.load();
		}
		
		private function progressHandler(event:LoaderEvent):void 
		{
			field.text = "Building Book Elements: " + Math.ceil( event.target.progress * 100 ) + "%";
		}
	}
}