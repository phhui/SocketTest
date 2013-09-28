package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	public class SocketTest extends Sprite
	{
		private var txt_output:TextField=new TextField();
		private var txt_input:TextField=new TextField();
		public function SocketTest()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,stage_add);
		}
		
		protected function stage_add(event:Event):void
		{
			txt_output.width=this.stage.stageWidth;
			txt_output.height=this.stage.stageHeight-30;
			txt_output.multiline=true;
			txt_output.wordWrap=true;
			txt_output.border=true;
			txt_input.width=this.stage.stageWidth;
			txt_input.y=this.stage.stageHeight-30;
			txt_input.type=TextFieldType.INPUT;
			txt_input.border=true;
			txt_input.addEventListener(KeyboardEvent.KEY_DOWN,send);
			this.addChild(txt_output);
			this.addChild(txt_input);
			SocketServer.connect(contact);
			txt_output.mouseEnabled=false;
		}
		
		protected function send(e:KeyboardEvent):void
		{
			if(e.keyCode!=13)return;
			if(txt_input.text.length<1)return;
			SocketServer.send(txt_input.text);
		}
		private function contact(str:String):void{
			txt_output.htmlText+=str+"\r\n";
		}
	}
}