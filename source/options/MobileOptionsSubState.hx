package options;

import options.BaseOptionsMenu;
import mobile.MobileControls;

class MobileOptionsSubState extends BaseOptionsMenu
{
	var exControlTypes:Array<String> = ["NONE", "SINGLE", "DOUBLE"];

	public function new()
	{
		title = 'Mobile Options';
		rpcTitle = 'Mobile Options Menu'; // for Discord Rich Presence, fuck it

		var option:Option = new Option('Mobile Controls Opacity', 'How much transparent should the Mobile Controls be?', 'controlsAlpha', 'percent');
		option.scrollSpeed = 1;
		option.minValue = 0.001;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = () ->
		{
			virtualPad.alpha = curOption.getValue();
		};
		addOption(option);

		#if mobile
		var option:Option = new Option('Allow Phone Screensaver', 'If checked, the phone will sleep after going inactive for few seconds.', 'screensaver',
			'bool');
		option.onChange = () ->
		{
			lime.system.System.allowScreenTimeout = curOption.getValue();
		};
		addOption(option);
		#end

		if (MobileControls.mode == "Hitbox")
		{
			var option:Option = new Option('Hide Hitbox Hints', 'If checked, makes the hitbox invisible.', 'hideHitboxHints', 'bool');
			addOption(option);
		}

		super();
	}
}
