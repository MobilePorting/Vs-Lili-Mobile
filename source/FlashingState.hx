package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

                if (controls.mobileC) {
		warnText = new FlxText(0, 0, FlxG.width,
			"Thanks for downloading vs Lili!\n
			This Mod contains strongs flashing lights!\n
			If you are sensitive we recommend you not to play.\n
			If you don't, touch your screen to ignore this message.\n
			Have fun!",
			32);
                } else {
                warnText = new FlxText(0, 0, FlxG.width,
                        "Thanks for downloading vs Lili!\n
                        This Mod contains strongs flashing lights!\n
                        If you are sensitive we recommend you not to play.\n
                        If you don't, press ESCAPE to ignore this message.\n
                        Have fun!",
                        32);
                }
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			var back:Bool = controls.BACK;
                        var justTouched:Bool = false;
		for (touch in FlxG.touches.list)
			if (touch.justPressed)
				justTouched = true;
			if (justTouched || controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
//					ClientPrefs.flashing = false;
//					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new TitleState());
						});
					});
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					FlxTween.tween(warnText, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
							MusicBeatState.switchState(new TitleState());
						}
					});
				}
			}
		}
		super.update(elapsed);
	}
}
