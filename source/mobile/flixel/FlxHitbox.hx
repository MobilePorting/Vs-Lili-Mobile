package mobile.flixel;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import openfl.display.BitmapData;
import openfl.display.Shape;
import mobile.flixel.FlxButton;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

/**
 * A zone with 4 hint's (A hitbox).
 * It's really easy to customize the layout.
 *
 * @author Mihai Alexandru (M.A. Jigsaw)
 */
class FlxHitbox extends FlxSpriteGroup
{
	public var hints(default, null):Array<FlxButton>;

	/**
	 * Create the zone.
	 * 
	 * @param ammo The ammount of hints you want to create.
	 * @param perHintWidth The width that the hints will use.
	 * @param perHintHeight The height that the hints will use.
	 * @param colors The color per hint.
	 */
	public function new(ammo:UInt, perHintWidth:Int, perHintHeight:Int, colors:Array<FlxColor>):Void
	{
		super();

		hints = new Array<FlxButton>();

		if (colors == null || (colors != null && colors.length < ammo))
			colors = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF];

		for (i in 0...ammo)
			add(hints[i] = createHint(i * perHintWidth, 0, perHintWidth, perHintHeight, colors[i]));

		scrollFactor.set();
	}

	/**
	 * Clean up memory.
	 */
	override public function destroy():Void
	{
		super.destroy();

		for (i in 0...hints.length)
			hints[i] = FlxDestroyUtil.destroy(hints[i]);

		hints.splice(0, hints.length);
	}

	private function createHint(X:Float, Y:Float, Width:Int, Height:Int, Color:Int = 0xFFFFFF):FlxButton
	{
		var hintTween:FlxTween = null;
		var hint = new FlxButton(X, Y);
		hint.loadGraphic(createHintGraphic(Width, Height));
		hint.color = Color;
		hint.solid = false;
		hint.immovable = true;
		hint.multiTouch = true;
		hint.moves = false;
		hint.scrollFactor.set();
		hint.alpha = 0.00001;
		hint.antialiasing = ClientPrefs.globalAntialiasing;
		if (!ClientPrefs.hideHitboxHints)
		{
			hint.onDown.callback = function()
			{
				if (hintTween != null)
					hintTween.cancel();

				hintTween = FlxTween.tween(hint, {alpha: ClientPrefs.controlsAlpha}, ClientPrefs.controlsAlpha / 100, {
					ease: FlxEase.circInOut,
					onComplete: function(twn:FlxTween)
					{
						hintTween = null;
					}
				});
			}
			hint.onUp.callback = function()
			{
				if (hintTween != null)
					hintTween.cancel();

				hintTween = FlxTween.tween(hint, {alpha: 0.00001}, ClientPrefs.controlsAlpha / 10, {
					ease: FlxEase.circInOut,
					onComplete: function(twn:FlxTween)
					{
						hintTween = null;
					}
				});
			}
			hint.onOut.callback = function()
			{
				if (hintTween != null)
					hintTween.cancel();

				hintTween = FlxTween.tween(hint, {alpha: 0.00001}, ClientPrefs.controlsAlpha / 10, {
					ease: FlxEase.circInOut,
					onComplete: function(twn:FlxTween)
					{
						hintTween = null;
					}
				});
			}
		}
		#if FLX_DEBUG
		hint.ignoreDrawDebug = true;
		#end
		return hint;
	}

	function createHintGraphic(Width:Int, Height:Int):BitmapData
	{
		var guh = ClientPrefs.controlsAlpha;
		if (guh >= 0.9)
			guh = ClientPrefs.controlsAlpha - 0.07;
		var shape:Shape = new Shape();
		shape.graphics.beginFill(0xFFFFFF);
		shape.graphics.lineStyle(3, 0xFFFFFF, 1);
		shape.graphics.drawRect(0, 0, Width, Height);
		shape.graphics.lineStyle(0, 0, 0);
		shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
		shape.graphics.endFill();
		shape.graphics.beginGradientFill(RADIAL, [0xFFFFFF, FlxColor.TRANSPARENT], [guh, 0], [0, 255], null, null, null, 0.5);
		shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
		shape.graphics.endFill();
		var bitmap:BitmapData = new BitmapData(Width, Height, true, 0);
		bitmap.draw(shape);
		return bitmap;
	}
}
