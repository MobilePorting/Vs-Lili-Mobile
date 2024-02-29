package;

#if android
import android.content.Context as AndroidContext;
#end
import haxe.Exception;
import haxe.io.Path;
import lime.system.System as LimeSystem;
import lime.utils.Log as LimeLogger;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

/**
 * A storage class for mobile.
 * @author Mihai Alexandru (M.A. Jigsaw) and Lily (mcagabe19)
 */
class SUtil
{
	#if sys
	public static function getStorageDirectory():String
	{
		var daPath:String = '';

		#if android
		daPath = AndroidContext.getExternalFilesDir(null);
		#elseif ios
		daPath = LimeSystem.documentsDirectory;
		#end

		return daPath;
	}

	public static function mkDirs(directory:String):Void
	{
		var total:String = '';
		if (directory.substr(0, 1) == '/')
			total = '/';

		var parts:Array<String> = directory.split('/');
		if (parts.length > 0 && parts[0].indexOf(':') > -1)
			parts.shift();

		for (part in parts)
		{
			if (part != '.' && part != '')
			{
				if (total != '' && total != '/')
					total += '/';

				total += part;

				if (!FileSystem.exists(total))
					FileSystem.createDirectory(total);
			}
		}
	}

	public static function saveContent(fileName:String = 'file', fileExtension:String = '.json',
			fileData:String = 'you forgot to add something in your code :3'):Void
	{
		try
		{
			if (!FileSystem.exists('saves'))
				FileSystem.createDirectory('saves');

			File.saveContent('saves/' + fileName + fileExtension, fileData);
			showPopUp(fileName + " file has been saved.", "Success!");
		}
		catch (e:Exception)
			showPopUp("File couldn't be saved.\n(${e.message})", "Error!");
	}
	#end

    public static function readDirectory(directory:String):Array<String>
    {
        #if MODS_ALLOWED
        return FileSystem.readDirectory(directory);
        #else
        var dirsWithNoLibrary = openfl.utils.Assets.list().filter(folder -> folder.startsWith(directory));
        var dirsWithLibrary:Array<String> = [];
        for(dir in dirsWithNoLibrary)
        {
            @:privateAccess
            for(library in lime.utils.Assets.libraries.keys())
            {
                if(openfl.utils.Assets.exists('$library:$dir') && library != 'default' && (!dirsWithLibrary.contains('$library:$dir') || !dirsWithLibrary.contains(dir)))
                    dirsWithLibrary.push('$library:$dir');
                else if(openfl.utils.Assets.exists(dir) && !dirsWithLibrary.contains(dir))
                        dirsWithLibrary.push(dir);
            }
        }
        return dirsWithLibrary;
        #end
    }
	public static function showPopUp(message:String, title:String #if android, ?positiveText:String = "OK", ?positiveFunc:Void->Void #end):Void
	{
		#if (android || windows || web)
		openfl.Lib.application.window.alert(message, title);
		#else
		LimeLogger.println('$title - $message');
		#end
	}
}
