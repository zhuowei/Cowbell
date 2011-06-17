package
{
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.AccelerometerEvent;
import flash.events.Event;
import flash.sensors.Accelerometer;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.media.*;
import flash.net.URLRequest;

public class AccelerometerTest extends Sprite
{
	private var textFormat:TextFormat;
	private var output:TextField;
	private var accelerometer:Accelerometer;
	//private var cowbellText:TextField;
	private var cowbellLeft:Boolean = false;
	private var cowbellSound:Sound;

	public function AccelerometerTest()
	{
		super();
		this.stage.scaleMode = StageScaleMode.NO_SCALE;
		this.stage.align = StageAlign.TOP_LEFT;

		this.textFormat = new TextFormat();
		this.textFormat.color = 0x000000;
		this.textFormat.font = "Helvetica";
		this.textFormat.size = 20;

		this.output = new TextField();
		this.output.defaultTextFormat = this.textFormat;
		this.output.text = "Foo!";

		this.stage.addEventListener(Event.RESIZE, doLayout);

		this.accelerometer = new Accelerometer();
		accelerometer.addEventListener(AccelerometerEvent.UPDATE, onAccelerometerUpdate);
		accelerometer.setRequestedUpdateInterval(1);
		//cowbellText = new TextField();
		try{
			cowbellSound = new Sound();
			cowbellSound.load(new URLRequest("cowbell.mp3"));
		}
		catch(e:Error){
		}
	}

	private function doLayout(e:Event):void
	{
		this.output.width = this.stage.stageWidth;
		this.output.height = this.stage.stageHeight;
		this.output.x = 0;
		this.output.y = 0;
		this.addChild(this.output);
		//this.addChild(cowbellText);
	}

	private function onAccelerometerUpdate(e:AccelerometerEvent):void
	{
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
		//cowbellText.appendText("Bong!\n");
		cowbellSound.play();
	}
}
}
