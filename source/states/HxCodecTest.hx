package states;

import flixel.FlxState;
#if VIDEOS_ALLOWED
import hxcodec.VideoHandler;
#end
class HxCodecTest extends FlxState
{
    override public function create()
    {
        super.create();

        var video:VideoHandler = new VideoHandler();
		video.finishCallback = function()
		{
			trace("finished");
		}
		video.playVideo("assets/videos/ughCutscene.mp4");
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}