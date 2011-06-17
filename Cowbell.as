package {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.AccelerometerEvent;
import flash.events.Event;
import flash.sensors.Accelerometer;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.media.Sound;
import flash.net.URLRequest;

[SWF(width="600", height="1024", frameRate="24", backgroundColor="#000000")]
public class Cowbell extends Sprite
{
	private var textFormat:TextFormat;
	private var output:TextField;
	private var accelerometer:Accelerometer;
	private var cowbellLeft:Boolean = false;
	private var cowbellSound:Sound;

	[Embed(source='cowbell.png')]
	private static const CowbellImage:Class;
	private var cowbellImage:DisplayObject;

	public function Cowbell(){
		try{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;

			this.textFormat = new TextFormat();
			this.textFormat.color = 0xffffff;
			this.textFormat.font = "Helvetica";
			this.textFormat.size = 20;

			this.output = new TextField();
			this.output.defaultTextFormat = this.textFormat;
			this.output.text = "x:\ny:\nz:";

			this.stage.addEventListener(Event.RESIZE, doLayout);

			this.accelerometer = new Accelerometer();
			accelerometer.addEventListener(AccelerometerEvent.UPDATE, onAccelerometerUpdate);
			accelerometer.setRequestedUpdateInterval(1);
			cowbellSound = new Sound();
			cowbellSound.load(new URLRequest("cowbell.mp3"));
			cowbellImage = new CowbellImage() as DisplayObject;
			doLayout(null);
		}
		catch(e:Error){
			trace(e.toString());
		}


	}

	private function doLayout(e:Event):void{
		this.output.width = this.stage.stageWidth;
		this.output.height = this.stage.stageHeight;
		this.output.x = 0;
		this.output.y = 0;
		this.addChild(this.output);
		cowbellImage.width = this.stage.stageWidth;
		cowbellImage.scaleY = cowbellImage.scaleX;
		cowbellImage.x = 0;
		cowbellImage.y = (stage.stageHeight - cowbellImage.height) / 2;
		addChild(cowbellImage);
	}

	private function onAccelerometerUpdate(e:AccelerometerEvent):void{
		var str:String = "x: " + e.accelerationX;
		str += "\ny: " + e.accelerationY;
		str += "\nz: " + e.accelerationZ;
		this.output.text = str;
		cowbellHandler(e);
	}
	private function cowbellHandler(e:AccelerometerEvent):void{
		if((cowbellLeft && e.accelerationY > 0.3) || (!cowbellLeft && e.accelerationY < -0.3)){
			soundCowbell();
			cowbellLeft = !cowbellLeft;
		}
	}

	/** I've got a fever, and this is the only cure!
	 */

	protected function soundCowbell():void{
		cowbellSound.play();
	}
}
}
