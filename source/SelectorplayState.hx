package;

#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;

class SelectorplayState extends MusicBeatState
{
    private var menuItems:FlxTypedGroup<FlxSprite>;
    public static var curSelected:Int = 0;
    var selectedSomethin:Bool = false;
    var bg:FlxSprite;
	var options:Array<String> = [
		'story_mode',
        'extra',
		'cover'		
	];    

    var optionsIdle:Array<String> = [
		'Story mode no selected0000',
        'Extra no selected0000',
		'Cover no selected0000'		
	];    

	var optionsSelected:Array<String> = [
		'Story mode selected0000',
        'Extra selected0000',
		'Cover selected0000'		
	];
    
    var itemPosY:Array<Float> = [0, 0, 0];

    var itemPosX:Array<Float> = [ 0, 0, 0];

    override function create(){
        bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();

        menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

        var offset:Float = 50;
        var scale:Float = 0.8;

        for (i in 0...options.length)
        {
            var menuItemStory:FlxSprite = new FlxSprite(0, (i * 230)  + offset);
            menuItemStory.scale.x = scale;
            menuItemStory.scale.y = scale;
            menuItemStory.frames = Paths.getSparrowAtlas('freeplay/' + options[i]);
            menuItemStory.animation.addByPrefix('idle', optionsIdle[i], 24);
            menuItemStory.animation.addByPrefix('selected', optionsSelected[i], 24);

            menuItemStory.animation.play('idle');
            menuItemStory.ID = i;
            //menuItemStory.screenCenter(X);
            menuItemStory.centerOffsets();

            trace('options[i]: ' + options[i]);
            trace('menuItemStory.x: ' + menuItemStory.x);
            trace('menuItemStory.y: ' + menuItemStory.y);

            itemPosY[i] = menuItemStory.y;
            itemPosX[i] = menuItemStory.x;

            menuItems.add(menuItemStory);
        }

        changeItem();

        addVirtualPad(UP_DOWN, A_B);

        super.create();
    }

	override function update(elapsed:Float)
        {
            /*if (FlxG.sound.music.volume < 0.8)
            {
                FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
                if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
            }
    
            var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
            camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));*/
    
            if (!selectedSomethin)
            {
                if (controls.UI_UP_P)
                {
                    FlxG.sound.play(Paths.sound('scrollMenu'));
                    changeItem(-1);
                }
    
                if (controls.UI_DOWN_P)
                {
                    FlxG.sound.play(Paths.sound('scrollMenu'));
                    changeItem(1);
                }
    
                if (controls.BACK)
                {
                    selectedSomethin = true;
                    FlxG.sound.play(Paths.sound('cancelMenu'));
                    FlxG.switchState(() -> new MainMenuState());
                }

                if (controls.ACCEPT)
                {
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
                                        
					menuItems.forEach(function(spr:FlxSprite)
                        {
                            if (curSelected != spr.ID)
                            {
                                FlxTween.tween(spr, {alpha: 0}, 0.4, {
                                    ease: FlxEase.quadOut,
                                    onComplete: function(twn:FlxTween)
                                    {
                                        spr.kill();
                                    }
                                });
                            }
                            else
                            {
                                FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
                                {
                                    var daChoice:String = options[curSelected];
    
                                    switch (daChoice)
                                    {
                                        case 'story_mode':
                                            FlxG.switchState(() -> new FreeplayState(daChoice));
                                        case 'extra':
                                            FlxG.switchState(() -> new FreeplayState(daChoice));
                                        case 'cover':
                                            FlxG.switchState(() -> new FreeplayState(daChoice));
                                    }
                                });
                            }
                        });                    
                }
    
            }
    
            super.update(elapsed);
        }

    function changeItem(huh:Int = 0)
        {
            trace('huh: ' + huh);
            curSelected += huh;
            trace('curSelected: ' + curSelected);
    
            if (curSelected >= menuItems.length)
                curSelected = 0;
            if (curSelected < 0)
                curSelected = menuItems.length - 1;
    
            trace('curSelected: ' + curSelected);

            var index:Int = 0;
            menuItems.forEach(function(spr:FlxSprite)
            {
                spr.animation.play('idle');
                spr.updateHitbox();
                spr.x = FlxG.width / 2 - spr.width / 2; //Centrar en X idle
                spr.y = itemPosY[index];// - anchoword[spr.ID];

                trace('spr.x: ' + spr.x);
                trace('spr.y: ' + spr.y);
    
                if (spr.ID == curSelected)
                {
                    spr.x = FlxG.width / 2 - spr.width / 2; //Centrar en X seleccionado
                    spr.y = itemPosY[index];// - anchoword[spr.ID];

                    trace('2 spr.x: ' + spr.x);
                    trace('2 spr.y: ' + spr.y);
                    spr.animation.play('selected');
                    var add:Float = 0;
                    if(menuItems.length > 4) {
                        add = menuItems.length * 8;
                    }
                    //camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
                    spr.centerOffsets();

                    trace('3 spr.x: ' + spr.x);
                    trace('3 spr.y: ' + spr.y);
                }

                index = index + 1;
            });
        }
}
