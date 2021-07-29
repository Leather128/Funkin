package debuggers;

import utilities.PlayerSettings;
import states.MainMenuState;
import utilities.Controls;
import states.MusicBeatState;
import utilities.CoolUtil;
import game.StageGroup;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.ui.FlxButton;
import flixel.FlxState;

/*
    MOVE CODE
        if (FlxG.mouse.overlaps(sick) && FlxG.mouse.pressed)
        {
            sick.x = FlxG.mouse.x - sick.width / 2;
            sick.y = FlxG.mouse.y - sick.height;
        }
*/

class StageMakingState extends FlxState
{
    private var controls(get, never):Controls;

    inline function get_controls():Controls
		return PlayerSettings.player1.controls;

    /* STAGE STUFF */
    public var stages:Array<String>;

    public var stage_Name:String = 'chromatic-stage';
    private var stage:StageGroup;

    /* UI */
    private var beat_Button:FlxButton;
    private var stage_Dropdown:FlxUIDropDownMenu;
    private var cam_Zoom:FlxText;

    private var startY:Int = 50;
    private var zoom:Float;

    /* CAMERA */
    private var stageCam:FlxCamera;
    private var camHUD:FlxCamera;

    private var camSpeed:Float = 1.0;

    public function new(selectedStage:String)
    {
        super();
        stages = CoolUtil.coolTextFile(Paths.txt('stageList'));

        if(selectedStage != null)
        {
            stage_Name = selectedStage;
        }

        FlxG.mouse.visible = true;
    }

    override public function create()
    {
        stageCam = new FlxCamera();
        camHUD = new FlxCamera();
        camHUD.bgColor.alpha = 0;

        #if (flixel >= "4.9.0")
        FlxG.cameras.add(stageCam, true);
        FlxG.cameras.add(camHUD, false);
        #else
        FlxG.cameras.reset(stageCam);
        FlxG.cameras.add(camHUD);

        FlxCamera.defaultCameras = [stageCam];
        #end

        stage = new StageGroup(stage_Name);
        add(stage);

        beat_Button = new FlxButton(10, startY, "Beat Hit", function(){
            if(stage != null)
            {
                stage.beatHit();
            }
        });
        beat_Button.cameras = [camHUD];
        add(beat_Button);

        stage_Dropdown = new FlxUIDropDownMenu(10, startY + 50, FlxUIDropDownMenu.makeStrIdLabelArray(stages, true), function(stageName:String)
        {
            trace(stageName);
            stage_Name = stages[Std.parseInt(stageName)];
            stage.updateStage(stage_Name);
        });

        stage_Dropdown.selectedLabel = stage_Name;
        stage_Dropdown.cameras = [camHUD];
        add(stage_Dropdown);

        cam_Zoom = new FlxText(10, startY + 100, 0, "Camera Zoom: " + stageCam.zoom, 32);
        cam_Zoom.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        cam_Zoom.cameras = [camHUD];
        add(cam_Zoom);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        // camera movement zoom
        if(FlxG.keys.justPressed.E)
        {
            stageCam.zoom += 0.1;
        }

        if(FlxG.keys.justPressed.Q)
        {
            stageCam.zoom -= 0.1;
        }

        if(controls.BACK)
        {
            FlxG.switchState(new MainMenuState());
        }

        /*
        // y position
        if(FlxG.keys.pressed.UP)
        {
            stageCam.y -= camSpeed;
        }

        if(FlxG.keys.pressed.DOWN)
        {
            stageCam.y += camSpeed;
        }

        // x position
        if(FlxG.keys.pressed.LEFT)
        {
            stageCam.x -= camSpeed;
        }

        if(FlxG.keys.pressed.RIGHT)
        {
            stageCam.x += camSpeed;
        }
        */

        // zoom lock
        if(stageCam.zoom < 0.1)
        {
            stageCam.zoom = 0.1;
        }

        // da math
        zoom = stageCam.zoom;
        zoom = zoom * Math.pow(10, 1);
        zoom = Math.round(zoom) / Math.pow(10, 1);

        cam_Zoom.text = "Camera Zoom: " + zoom;
    }
}