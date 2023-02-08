package utilities;

import openfl.Assets;

class NoteVariables {
	public static var Note_Count_Directions:Array<Array<String>>;
	public static var Default_Binds:Array<Array<String>>;
	public static var Other_Note_Anim_Stuff:Array<Array<String>>;
	public static var Character_Animation_Arrays:Array<Array<String>>;

	public static function init() {
		//Mania Directions
		if (!Assets.exists(Paths.txt("mania data/"+ Options.getData("uiSkin") + "/maniaDirections")))
			Note_Count_Directions = CoolUtil.coolTextFileOfArrays(Paths.txt("mania data/default/maniaDirections"));
		else
			Note_Count_Directions = CoolUtil.coolTextFileOfArrays(Paths.txt("mania data/"+ Options.getData("uiSkin") + "/maniaDirections"));
		//Binds
		if (!Assets.exists(Paths.txt("mania data/"+ Options.getData("uiSkin") + "/defaultBinds")))
			Default_Binds = CoolUtil.coolTextFileOfArrays(Paths.txt("mania data/default/defaultBinds"));
		else
			Default_Binds = CoolUtil.coolTextFileOfArrays(Paths.txt("mania data/"+ Options.getData("uiSkin") + "/defaultBinds"));
		//Animation Directions
		if (!Assets.exists(Paths.txt("mania data/"+ Options.getData("uiSkin") + "/maniaAnimationDirections")))
			Other_Note_Anim_Stuff = CoolUtil.coolTextFileOfArrays(Paths.txt("mania data/default/maniaAnimationDirections"));
		else
			Other_Note_Anim_Stuff = CoolUtil.coolTextFileOfArrays(Paths.txt("mania data/"+ Options.getData("uiSkin") + "/maniaAnimationDirections"));
		//Character Animations
		if (!Assets.exists(Paths.txt("mania data/"+ Options.getData("uiSkin") + "/maniaCharacterAnimations")))
			Character_Animation_Arrays = CoolUtil.coolTextFileOfArrays(Paths.txt("mania data/default/maniaCharacterAnimations"));
		else
			Character_Animation_Arrays = CoolUtil.coolTextFileOfArrays(Paths.txt("mania data/"+ Options.getData("uiSkin") + "/maniaCharacterAnimations"));
	}
}
