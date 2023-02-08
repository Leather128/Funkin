package utilities;

import shaders.NoteColors;
import modding.ModList;
import game.Highscore;

class SaveData {
	public static function init() {
		NoteVariables.init();
		
		Options.init();
		Options.fixBinds();

		PlayerSettings.init();
		PlayerSettings.player1.controls.loadKeyBinds();

		Highscore.load();
		ModList.load();
		NoteColors.load();
	}
}
