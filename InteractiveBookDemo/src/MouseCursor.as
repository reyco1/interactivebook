package
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	/**
	 * ...
	 * @author Daniel Montano
	 */
	public class MouseCursor
	{
		private var isShowing:Boolean = false;

		private var _stage:Stage;

		private var _mouseDownGraphicFrame:Number;

		private var _mc:MovieClip;

		private var _hideCursor:Boolean;

		public function set mouseDownGraphicFrame($n:Number):void
		{
			_mouseDownGraphicFrame = $n;
		}

		public function MouseCursor($mc:MovieClip, $hideCursor:Boolean = true)
		{
			_mc = $mc;
			_mc.mouseEnabled = false;
			_mc.mouseChildren = false;

			_hideCursor = $hideCursor;

			if (_mc.stage)
				_onAdded(null);
			else
				_mc.addEventListener(Event.ADDED_TO_STAGE, _onAdded, false, 0, true);

			_mc.visible = false;
			_mc.mouseEnabled = false;
			_mouseDownGraphicFrame = -1;
		}

		public function show():void
		{

			isShowing = true;

			if (_hideCursor)
				Mouse.hide();

			_mc.visible = true;

			if (_mc.stage)
				_mc.stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove, false, 0, true);

			if (_mouseDownGraphicFrame > -1)
			{
				if (_mc.stage)
					_mc.stage.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown, false, 0, true);

				if (_mc.stage)
					_mc.stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp, false, 0, true);
			}

		}

		public function hide():void
		{

			Mouse.show();

			_mc.visible = false

			_removeStageListener();
		}

		public function clear():void
		{
			_onRemoved(null);
		}

		/*PRIVATE*/

		private function _removeStageListener():void
		{
			if (_stage)
			{
				if (_stage.hasEventListener(MouseEvent.MOUSE_MOVE))
					_stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);

				if (_stage.hasEventListener(MouseEvent.MOUSE_DOWN))
					_stage.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);

				if (_stage.hasEventListener(MouseEvent.MOUSE_UP))
					_stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			}
		}

		/*HANDLERS*/

		private function _onAdded(e:Event):void
		{
			_stage = _mc.stage;

			if (isShowing)
				show(); // this keeps it from breaking if you called the show method before you added it to the stage.
			_mc.removeEventListener(Event.ADDED_TO_STAGE, _onAdded);
			_mc.addEventListener(Event.REMOVED_FROM_STAGE, _onRemoved, false, 0, true);

		}

		private function _onRemoved(e:Event):void
		{
			try
			{
				_mc.removeEventListener(Event.REMOVED_FROM_STAGE, _onRemoved);
			}
			catch (e:Error)
			{
			}

			hide();
			_stage = null;
		}

		private function _onMouseMove($e:MouseEvent):void
		{

			_mc.x = _mc.stage.mouseX;
			_mc.y = _mc.stage.mouseY;

		}

		private function _onMouseDown(e:MouseEvent):void
		{
			_mc.gotoAndStop(_mouseDownGraphicFrame);
		}

		private function _onMouseUp(e:MouseEvent):void
		{
			_mc.gotoAndStop(1);
		}

	}

}

