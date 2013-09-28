package
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	public class SocketServer
	{
		static private var link:Boolean=false;
		static private var sock:Socket=new Socket();
		static private var con:Function;
		public function SocketServer()
		{
		}
		static public function connect(func:Function):void{
			sock.addEventListener(Event.CONNECT,connected);
			sock.addEventListener(ProgressEvent.SOCKET_DATA,receive);
			sock.addEventListener(IOErrorEvent.IO_ERROR,connectError);
			sock.addEventListener(Event.CLOSE,socketClose);
			sock.connect("127.0.0.1",8888);
			con=func;
		}
		static public function send(str:String):void{
			if(!link)return;
			var byte:ByteArray=new ByteArray();
			byte.writeUTFBytes(str);
			sock.writeBytes(byte);
			sock.flush();
			//writeByte(byte);
			con("发送:"+str);
		}
		static private function writeByte(b:ByteArray):void{
			var res:String="";
			var n:int=b.length;
			for(var i:int=0;i<n;i++){
				res+=b[i]+" ";
			}
			con(res);
		}
		protected static function socketClose(e:Event):void
		{
			con("SOCKET已关闭");
			link=false;
		}
		
		protected static function connectError(e:IOErrorEvent):void
		{
			con("socket连接失败"+e.text);
		}
		
		protected static function receive(e:ProgressEvent):void
		{
			//sock.readByte();
			con("接收:"+sock.readUTFBytes(sock.bytesAvailable));
		}
		
		protected static function connected(e:Event):void
		{
			con("连接成功");
			link=true;
			//send("你妹啊");
		}
	}
}