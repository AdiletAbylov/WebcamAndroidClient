package views.renderers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	import mx.graphics.BitmapScaleMode;
	
	import spark.components.BusyIndicator;
	import spark.components.LabelItemRenderer;
	import spark.core.DisplayObjectSharingMode;
	import spark.primitives.BitmapImage;
	import spark.primitives.Graphic;
	
	
	/**
	 * 
	 * ASDoc comments for this item renderer class
	 * 
	 */
	public class CamsItemRenderer extends LabelItemRenderer
	{
		public function CamsItemRenderer()
		{
			super();
		}
				
		/**
		 * @private
		 *
		 * Override this setter to respond to data changes
		 */
		override public function set data(value:Object):void
		{
			super.data = value;
			// the data has changed.  push these changes down in to the 
			// subcomponents here
			if(backgroundImage)
			{
				backgroundImage.source = data.image;
			}
			if(labelDisplay)
			{
				labelDisplay.text = data.label;
				invalidateSize();
			}
		} 
		
		/**
		 * @private
		 * 
		 * Override this method to create children for your item renderer 
		 */	
		override protected function createChildren():void
		{
			super.createChildren();
			createBackgroundImage();
			createLabelBackground();
			createSpinner();
		}
		
		private var spinner:BusyIndicator;
		
		private function createSpinner():void
		{
			spinner = new BusyIndicator();
			addChildAt(spinner, numChildren);
		}
		
		private function destroySpinner():void
		{
			removeChild(spinner);
			spinner = null;
		}
		
		override protected function createLabelDisplay():void
		{
			super.createLabelDisplay();
			labelDisplay.multiline = true;
			labelDisplay.wordWrap = true;
		}
		
		private  var labelBackground:Sprite;
		
		private function createLabelBackground():void
		{
			labelBackground = new Sprite();
			addChildAt(labelBackground, 1);
		}		
		
		
		private var backgroundImage:BitmapImage;
		private var backgroundGraphic:Graphic;
		
		private function createBackgroundImage():void
		{	
			backgroundImage = new BitmapImage();
			backgroundImage.scaleMode = BitmapScaleMode.ZOOM;
			backgroundImage.smooth = true;
			backgroundImage.percentWidth = 100;
			backgroundImage.percentHeight = 100;
			
			backgroundGraphic = new Graphic();
			backgroundGraphic.addElement(backgroundImage);
			addChildAt(backgroundGraphic, 0);
			backgroundImage.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			backgroundImage.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			backgroundImage.addEventListener(Event.COMPLETE, onLoadComplete);
		}
		
		protected function onLoadComplete(event:Event):void
		{
			destroySpinner();
		}
		
		protected function onSecurityError(event:SecurityErrorEvent):void
		{
			destroySpinner();
			trace(event.toString());
		}
		
		protected function onIOError(event:IOErrorEvent):void
		{
			destroySpinner();
			trace(event.toString());
		}
		
		/**
		 * @private
		 * 
		 * Override this method to change how the item renderer 
		 * sizes itself. For performance reasons, do not call 
		 * super.measure() unless you need to.
		 */ 
		override protected function measure():void
		{
			//super.measure();
			
		}
		
		/**
		 * @private
		 * 
		 * Override this method to change how the background is drawn for 
		 * item renderer.  For performance reasons, do not call 
		 * super.drawBackground() if you do not need to.
		 */
		override protected function drawBackground(unscaledWidth:Number, 
												   unscaledHeight:Number):void
		{
			super.drawBackground(unscaledWidth, unscaledHeight);
			    		
		}
		
		/**
		 * @private
		 *  
		 * Override this method to change how the background is drawn for this 
		 * item renderer. For performance reasons, do not call 
		 * super.layoutContents() if you do not need to.
		 */
		override protected function layoutContents(unscaledWidth:Number, 
												   unscaledHeight:Number):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight);
			if(labelDisplay)
			{
//				setElementPosition(labelDisplay, 0,0);
//				setElementSize(labelDisplay, unscaledWidth, labelDisplay.height);
			}
			if(backgroundGraphic)
			{
				calculateBackgroundImageSize(unscaledWidth, unscaledHeight);
				height = backgroundGraphic.height;
			}
			if(labelBackground)
			{	
				drawLabelbackground(unscaledWidth, unscaledHeight);
			}
			

			if(spinner)
			{
				var spinnerx:Number = unscaledWidth / 2 - spinner.width / 2;
				var spinnery:Number = unscaledHeight / 2  - spinner.height / 2;
				setElementPosition(spinner, spinnerx, spinnery);
			}
		}
		
		protected function drawLabelbackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var paddingTop:Number = getStyle("paddingTop");
			var bgHeight:Number =  paddingTop + labelDisplay.height;
			setElementPosition(labelBackground, 0,0);
			setElementSize(labelBackground, unscaledWidth, bgHeight);
			labelBackground.graphics.clear();
			labelBackground.graphics.beginFill(0x000000, 0.3);
			labelBackground.graphics.drawRect(0, 0, unscaledWidth, bgHeight);
			labelBackground.graphics.endFill();
		}
		
		protected function calculateBackgroundImageSize(unscaledWidth:Number, unscaledHeight:Number):void
		{
			backgroundGraphic.width = unscaledWidth;
			backgroundGraphic.height = backgroundGraphic.width / 1.78;
		}
	}
}