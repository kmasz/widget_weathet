package 
{

	import se.svt.caspar.template.CasparTemplate;
	import flash.events.Event;
	import flash.display.FocusDirection;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import com.greensock.*;
	import com.greensock.easing.*;
	//import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.plugins.*;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.net.Socket;




	public class pogoda_widget extends CasparTemplate
	{
		var xmlLoader:URLLoader = null;
		var format2:TextFormat = new TextFormat();
		var format1:TextFormat = new TextFormat();
		var temp_data:Vector.<String> = new Vector.<String>();
		var cisn_data:Vector.<String> = new Vector.<String>();
		var godz_data:Vector.<String> = new Vector.<String>();
		var ikona:Vector.<String> = new Vector.<String>();
		var petla:Number = 0;
		var timer:Timer = null;
		var socket:Socket = null;
		var initStart:Boolean = true;


		public function pogoda_widget()
		{
			// constructor code
			var myXML:XML = new XML();
			var XML_URL:String = "WidgetPog.xml";
			var myXMLURL:URLRequest = new URLRequest(XML_URL);
			xmlLoader = new URLLoader(myXMLURL);
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			format2.letterSpacing = 2;
			format1.letterSpacing = 1;
			intro_up();
		}
		public function xmlLoaded(event:Event):void
		{
			SetData(XML(xmlLoader.data));
		}
		public override function SetData(xmlData:XML):void
		{
			dzien_roku.text = xmlData.DZIEN;
			dzien_roku.setTextFormat(format2);
			godz_data[0] = xmlData.GODZ1;
			godz_data[1] = xmlData.GODZ2;
			godz_data[2] = xmlData.GODZ3;
			cisn_data[0] = xmlData.CISN1;
			cisn_data[1] = xmlData.CISN2;
			cisn_data[2] = xmlData.CISN3;
			temp_data[0] = xmlData.TEMP_R1;
			temp_data[1] = xmlData.TEMP_R2;
			temp_data[2] = xmlData.TEMP_R3;
			//data_change();
			godzina.text = godz_data[0];
			godzina.setTextFormat(format2);
			temp.text = temp_data[0];
			temp.setTextFormat(format1);
			cisn.text = cisn_data[0];
			cisn.setTextFormat(format1);
			ikona[0] = xmlData.VIDEOLINK1;
			ikona[1] = xmlData.VIDEOLINK2;
			ikona[2] = xmlData.VIDEOLINK3;
			//trace(ikona[0]);
			//waitLoop();
			init_video();
		}
		function intro_up():void
		{
			TweenLite.to(maska, 0.5, {x:40, ease:Cubic.easeInOut, onComplete:intro_down});
		}
		function intro_down():void
		{
			TweenLite.to(maska, 0.8, {y:15, ease:Cubic.easeInOut});
			blik_on();
		}
		function blik_on():void
		{
			blik_gora.x = -180;
			blik_dol.x = -180;
			TweenLite.to(blik_gora, 3, {x:340, ease:Cubic.easeInOut});
			TweenLite.delayedCall(1.7,change_data);
			//change_data();
			if (initStart == true)
			{
				play_video(petla);
				initStart = false;
			}
			else
			{
				if (petla >= 3)
				{
					play_video(0);
				}
				else
				{
					play_video(petla);
				}
			}
			TweenLite.to(blik_dol, 2, {x:340, delay:0.5, ease:Cubic.easeInOut});
		}
		function change_data():void
		{
			if (petla < 3)
			{
				//TweenLite.to(godzina, 0.1, {alpha:0, ease:Cubic.easeInOut});
				//play_video(petla);
				godzina.text = godz_data[petla];
				godzina.setTextFormat(format2);
				//TweenLite.to(godzina, 0.1, {alpha:1, ease:Cubic.easeInOut});
				temp.text = temp_data[petla];
				temp.setTextFormat(format1);
				cisn.text = cisn_data[petla];
				cisn.setTextFormat(format1);
				//trace(petla);
				petla++;
			}
			else
			{
				petla = 0;
				//play_video(petla);
				godzina.text = godz_data[petla];
				godzina.setTextFormat(format2);
				temp.text = temp_data[petla];
				temp.setTextFormat(format1);
				cisn.text = cisn_data[petla];
				cisn.setTextFormat(format1);
				petla++;
			}
			waitLoop();
		}
		function data_change(event:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER, data_change);
			timer = null;
			//change_data();
			blik_on();
		}
		function waitLoop():void
		{
			timer = new Timer(5000);
			timer.addEventListener(TimerEvent.TIMER, data_change);
			timer.start();
		}
		function init_video():void
		{
			socket = new Socket("localhost",5250);
			socket.writeUTFBytes("MIXER 1-20 FILL 0.1 0.14 0.12 0.25\r\n");
			socket.flush();
		}
		function play_video(counter:Number):void
		{
			socket = new Socket("localhost",5250);
			socket.writeUTFBytes("play 1-20 "+ikona[counter]+" loop mix 10\r\n");
			socket.flush();
		}

		function stop_video():void
		{
			socket = new Socket("localhost",5250);
			socket.writeUTFBytes("CLEAR 1-20\r\n");
			socket.writeUTFBytes("MIXER 1-20 CLEAR\r\n");
			socket.flush();
		}
		//overridden preDispose that will be called just before the template is removed by the template host. Allows us to clean up.
		override public function preDispose():void
		{
			//dispose the timer
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, data_change);
			timer = null;
			stop_video();
		}
		//overridden Stop that initiates the outro animation. IMPORTANT, it is very important when you override Stop to later call super.Stop() or removeTemplate()
		override public function Stop():void
		{
			//do the outro animation
			stop_video();
			outroAnimation();
		}
		function outroAnimation():void
		{
			blik_gora.x = 340;
			blik_dol.x = 340;
			TweenLite.to(blik_dol, 2, {x:-180, delay:0.2, ease:Cubic.easeInOut});
			TweenLite.to(blik_gora, 2, {x:-180, delay:0.7, ease:Cubic.easeInOut});
			TweenLite.to(maska, 0.8, {y:-128.15, delay:0.7, ease:Cubic.easeInOut});
			TweenLite.to(blik_dol_maska, 0.8, {y:-54, delay:0.7, ease:Cubic.easeInOut});
			TweenLite.to(maska, 0.5, {x:-249.35, delay:1.4 ,ease:Cubic.easeInOut});
			TweenLite.to(blik_gora_maska, 0.5, {width:0, delay:1.4 ,ease:Cubic.easeInOut, onComplete: removeTemplate});
		}
	}

}