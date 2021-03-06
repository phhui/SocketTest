package
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.system.Security;
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
			sock.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityError);
			sock.connect("192.168.1.199",8888);
			con=func;
		}
		
		protected static function securityError(e:SecurityErrorEvent):void
		{
			con("未正确设置安全策略文件"+e.text+"\n注意：\n1、返回的策略文件IP和端口要正确。\n2、返回的策略文件结尾要加\\0否则无法正常解析");
		}
		static public function send(arr:Array):void{
			if(!link)return;
			var byte:ByteArray=new ByteArray();
			writeByte(arr,byte);
			tracebyte(byte);
			sock.writeBytes(byte);
			sock.flush();
			con("发送:"+arr.toString());
		}
		static private function writeByte(obj:*,byte:ByteArray):void{
			var type:String=typeof(obj);
			type=type.toLocaleLowerCase();
			switch(type){
				case "string":
					byte.writeUTF(String(obj));
					break;
				case "int":
					byte.writeInt(int(obj));
					break;
				case "double":
					byte.writeDouble(Number(obj));
					break;
				case "number":
					byte.writeInt(int(obj));
					break;
				case "byte":
					byte.writeByte(int(obj));
					break;
				default:
					if(obj is Array){
						var n:int=obj.length;
						for(var i:int=0;i<n;i++){
							writeByte(obj[i],byte);
						}
					}
					break;
			}
		}
		static private function tracebyte(by:ByteArray):void{
			var n:int=by.length;
			var s:String="";
			for(var i:int=0;i<n;i++){
				s+=by[i]+" ";
			}
			con(s);
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