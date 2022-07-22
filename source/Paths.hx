package;

import flixel.graphics.FlxGraphic;
import openfl.media.Sound;
import openfl.system.System;
import openfl.display.BitmapData;
import openfl.display3D.textures.Texture;
import lime.utils.Assets;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import sys.FileSystem;
import sys.io.File;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;
	inline public static var VIDEO_EXT = "mp4";

	static var currentLevel:String;

	static public function setCurrentLevel(name:String)
		currentLevel = name.toLowerCase();

        // stolen from forever lmao -mcagabe19
	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	public static var currentTrackedTextures:Map<String, Texture> = [];
	public static var currentTrackedSounds:Map<String, Sound> = [];

        public static function excludeAsset(key:String)
	{
		if (!dumpExclusions.contains(key))
			dumpExclusions.push(key);
	}

        public static var dumpExclusions:Array<String> = [
                'assets/preload/music/freakyNightMenu.$SOUND_EXT',
		'assets/preload/music/freakyMenu.$SOUND_EXT',
                'assets/preload/music/optionsMenu.$SOUND_EXT',
		'assets/shared/music/breakfast.$SOUND_EXT',
	];

	public static function clearUnusedMemory()
	{
		var counter:Int = 0;
		for (key in currentTrackedAssets.keys())
		{
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key))
			{
				var obj = currentTrackedAssets.get(key);
				if (obj != null)
				{
					var isTexture:Bool = currentTrackedTextures.exists(key);
					if (isTexture)
					{
						var texture = currentTrackedTextures.get(key);
						texture.dispose();
						texture = null;
						currentTrackedTextures.remove(key);
					}
					@:privateAccess
					if (openfl.Assets.cache.hasBitmapData(key))
					{
						openfl.Assets.cache.removeBitmapData(key);
						FlxG.bitmap._cache.remove(key);
					}
					trace('removed $key, ' + (isTexture ? 'is a texture' : 'is not a texture'));
					obj.destroy();
					currentTrackedAssets.remove(key);
					counter++;
				}
			}
		}
		trace('removed $counter assets');
		System.gc();
	}

	public static var localTrackedAssets:Array<String> = [];

	public static function clearStoredMemory(?cleanUnused:Bool = false)
	{
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys())
		{
			var obj = FlxG.bitmap._cache.get(key);
			if (obj != null && !currentTrackedAssets.exists(key))
			{
				openfl.Assets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
			}
		}

		for (key in currentTrackedSounds.keys())
		{
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key) && key != null)
			{
				Assets.cache.clear(key);
				currentTrackedSounds.remove(key);
			}
		}
		localTrackedAssets = [];
	}

	public static function returnGraphic(key:String, ?library:String, ?textureCompression:Bool = false)
	{
		var path = getPath('images/$key.png', IMAGE, library);
		if (FileSystem.exists(path))
		{
			if (!currentTrackedAssets.exists(key))
			{
				var bitmap = BitmapData.fromFile(path);
				var newGraphic:FlxGraphic;
				if (textureCompression)
				{
					var texture = FlxG.stage.context3D.createTexture(bitmap.width, bitmap.height, BGRA, true, 0);
					texture.uploadFromBitmapData(bitmap);
					currentTrackedTextures.set(key, texture);
					bitmap.dispose();
					bitmap.disposeImage();
					bitmap = null;
					trace('new texture $key, bitmap is $bitmap');
					newGraphic = FlxGraphic.fromBitmapData(BitmapData.fromTexture(texture), false, key, false);
				}
				else
				{
					newGraphic = FlxGraphic.fromBitmapData(bitmap, false, key, false);
					trace('new bitmap $key, not textured');
				}
				currentTrackedAssets.set(key, newGraphic);
			}
			localTrackedAssets.push(key);
			return currentTrackedAssets.get(key);
		}
		trace('oh no ' + key + ' is returning null NOOOO');
		return null;
	}
        // end stole code

	static function getPath(file:String, type:AssetType, library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);

			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");

			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);

	inline static function getLibraryPathForce(file:String, library:String)
		return '$library:assets/$library/$file';

	inline static function getPreloadPath(file:String)
		return 'assets/$file';

	inline static public function lua(key:String,?library:String)
		return getPath('data/$key.lua', TEXT, library);

	inline static public function hx(key:String,?library:String)
		return getPath('$key.hx', TEXT, library);

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
		return getPath(file, type, library);

	inline static public function txt(key:String, ?library:String)
		return getPath('data/$key.txt', TEXT, library);

	inline static public function xml(key:String, ?library:String)
		return getPath('data/$key.xml', TEXT, library);

	inline static public function json(key:String, ?library:String)
		return getPath('data/$key.json', TEXT, library);

	static public function video(key:String, ?ext:String = VIDEO_EXT)
		return 'assets/videos/$key.$ext';

	static public function sound(key:String, ?library:String)
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
		return sound(key + FlxG.random.int(min, max), library);

	inline static public function music(key:String, ?library:String)
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);

	static public function voices(song:String, ?difficulty:String)
	{
		if(difficulty != null)
		{
			if(Assets.exists('songs:assets/songs/${song.toLowerCase()}/Voices-$difficulty.$SOUND_EXT'))
				return 'songs:assets/songs/${song.toLowerCase()}/Voices-$difficulty.$SOUND_EXT';
		}

		return 'songs:assets/songs/${song.toLowerCase()}/Voices.$SOUND_EXT';
	}

	static public function inst(song:String, ?difficulty:String)
	{
		if(difficulty != null)
		{
			if(Assets.exists('songs:assets/songs/${song.toLowerCase()}/Inst-$difficulty.$SOUND_EXT'))
				return 'songs:assets/songs/${song.toLowerCase()}/Inst-$difficulty.$SOUND_EXT';
		}
		
		return 'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
	}

	static public function songEvents(song:String, ?difficulty:String)
	{
		if(difficulty != null)
		{
			if(Assets.exists(Paths.json("song data/" + song.toLowerCase() + '/events-${difficulty.toLowerCase()}')))
				return Paths.json("song data/" + song.toLowerCase() + '/events-${difficulty.toLowerCase()}');
		}

		return Paths.json("song data/" + song.toLowerCase() + "/events");
	}

	inline static public function image(key:String, ?library:String)
		return getPath('images/$key.png', IMAGE, library);

	inline static public function font(key:String)
		return 'assets/fonts/$key';

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		if(Assets.exists(file('images/$key.xml', library)))
			return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
		else
			return FlxAtlasFrames.fromSparrow(image("Bind_Menu_Assets", "preload"), file('images/Bind_Menu_Assets.xml', "preload"));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		if(Assets.exists(file('images/$key.txt', library)))
			return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
		else
			return FlxAtlasFrames.fromSparrow(image("Bind_Menu_Assets", "preload"), file('images/Bind_Menu_Assets.xml', "preload"));
	}
}
