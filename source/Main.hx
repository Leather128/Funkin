package;

import utilities.CoolUtil;
import openfl.text.TextFormat;
import ui.SimpleInfoDisplay;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite {
	public function new() {
		super();

		CoolUtil.haxe_trace = haxe.Log.trace;
		haxe.Log.trace = CoolUtil.haxe_print;

		addChild(new FlxGame(0, 0, states.TitleState, 60, 60, true));

		#if !mobile
		display = new SimpleInfoDisplay(10, 3, 0xFFFFFF, "_sans");
		addChild(display);
		#end
	}

	public static var display:SimpleInfoDisplay;

	public static function toggleFPS(fpsEnabled:Bool):Void
		display.infoDisplayed[0] = fpsEnabled;

	public static function toggleMem(memEnabled:Bool):Void
		display.infoDisplayed[1] = memEnabled;

	public static function toggleVers(versEnabled:Bool):Void
		display.infoDisplayed[2] = versEnabled;

	public static function changeFont(font:String):Void
		display.defaultTextFormat = new TextFormat(font, (font == "_sans" ? 12 : 14), display.textColor);
}
