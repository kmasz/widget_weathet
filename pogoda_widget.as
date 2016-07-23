package 
{

	import se.svt.caspar.template.CasparTemplate;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.plugins.*;
	import flash.display.FocusDirection;


	public class pogoda_widget extends CasparTemplate
	{


		public function pogoda_widget()
		{
			// constructor code
			intro_up();

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
			TweenLite.to(blik_gora, 2, {x:340, ease:Cubic.easeInOut});
			TweenLite.to(blik_dol, 2, {x:340, delay:0.5, ease:Cubic.easeInOut});
		}
		//overridden preDispose that will be called just before the template is removed by the template host. Allows us to clean up.
		override public function preDispose():void
		{
			//dispose the timer
		}
		//overridden Stop that initiates the outro animation. IMPORTANT, it is very important when you override Stop to later call super.Stop() or removeTemplate()
		override public function Stop():void
		{
			//do the outro animation
			outroAnimation();
		}
		function outroAnimation():void
		{
			blik_gora.x = 340;
			blik_dol.x = 340;
			TweenLite.to(blik_dol, 2, {x:-180, ease:Cubic.easeInOut});
			TweenLite.to(blik_gora, 2, {x:-180, delay:0.5, ease:Cubic.easeInOut});
			TweenLite.to(maska, 0.8, {y:-128.15, delay:0.5, ease:Cubic.easeInOut});
			TweenLite.to(blik_dol_maska, 0.8, {y:-54, delay:0.5, ease:Cubic.easeInOut});
			TweenLite.to(maska, 0.5, {x:-249.35, delay:1.2 ,ease:Cubic.easeInOut});
			TweenLite.to(blik_gora_maska, 0.5, {width:0, delay:1.2 ,ease:Cubic.easeInOut});
		}
	}

}