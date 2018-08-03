package hxp;


import haxe.io.Path;
import haxe.Unserializer;
import hxp.Architecture;
import hxp.Haxelib;
import hxp.Project;
import hxp.Platform;
import hxp.HaxelibHelper;
import hxp.LogHelper;
import hxp.PathHelper;
import hxp.PlatformHelper;
import sys.io.File;
import sys.io.Process;
import sys.FileSystem;


class PlatformTargetMain {
	
	
	private static var additionalArguments = new Array<String> ();
	private static var targetFlags = new Map<String, String> ();
	private static var traceEnabled:Bool = true;
	
	
	public static function main () {
		
		var arguments = Sys.args ();
		var runFromHaxelib = false;
		
		if (arguments.length > 0) {
			
			// When the command-line tools are called from haxelib, 
			// the last argument is the project directory and the
			// path to Lime is the current working directory 
			
			var lastArgument = "";
			
			for (i in 0...arguments.length) {
				
				lastArgument = arguments.pop ();
				if (lastArgument.length > 0) break;
				
			}
			
			lastArgument = new Path (lastArgument).toString ();
			
			if (((StringTools.endsWith (lastArgument, "/") && lastArgument != "/") || StringTools.endsWith (lastArgument, "\\")) && !StringTools.endsWith (lastArgument, ":\\")) {
				
				lastArgument = lastArgument.substr (0, lastArgument.length - 1);
				
			}
			
			if (FileSystem.exists (lastArgument) && FileSystem.isDirectory (lastArgument)) {
				
				Sys.setCwd (lastArgument);
				runFromHaxelib = true;
				
			} else {
				
				arguments.push (lastArgument);
				
			}
			
		}
		
		if (!runFromHaxelib) {
			
			if (FileSystem.exists ("tools.n")) {
				
				HaxelibHelper.setOverridePath (new Haxelib("lime"), PathHelper.combine (Sys.getCwd (), "../"));
				
			} else if (FileSystem.exists ("run.n")) {
				
				HaxelibHelper.setOverridePath (new Haxelib("lime"), Sys.getCwd ());
				
			}
			
		}
		
		var additionalArguments = [];
		var catchArguments = false;
		var className = "";
		var command = "";
		var words = [];
		
		for (argument in arguments) {
			
			var equals = argument.indexOf ("=");
			
			if (catchArguments) {
				
				additionalArguments.push (argument);
				
			} else if (argument == "-v" || argument == "-verbose") {
				
				LogHelper.verbose = true;
				
			} else if (argument == "-args") {
				
				catchArguments = true;
				
			} else if (argument == "-notrace") {
				
				traceEnabled = false;
				
			} else if (argument == "-debug") {
				
				//debug = true;
				
			} else if (argument == "-nocolor") {
				
				LogHelper.enableColor = false;
				
			} else if (className.length == 0) {
				
				className = argument;
				
			} else if (command.length == 0) {
				
				command = argument;
				
			} else {
				
				words.push (argument);
				
			}
			
		}
		
		if (words.length > 0) {
			
			try {
				
				var classRef = Type.resolveClass (className);
				if (classRef == null) throw "Cannot find class name \"" + className + "\"";
				
				var inputPath = words[0];
				var projectData = File.getContent (inputPath);
				
				var unserializer = new Unserializer (projectData);
				unserializer.setResolver (cast { resolveEnum: Type.resolveEnum, resolveClass: resolveClass });
				var project:Project = unserializer.unserialize ();
				
				var platform = Type.createInstance (classRef, [ command, project, project.targetFlags ]);
				platform.traceEnabled = traceEnabled;
				platform.execute (additionalArguments);
				
			} catch (e:Dynamic) {
				
				LogHelper.error (e);
				
			}
			
		}
		
	}
	
	
	private static function resolveClass (name:String):Class<Dynamic> {
		
		var result = Type.resolveClass (name);
		
		if (result == null) {
			
			result = Project;
			
		}
		
		return result;
		
	}
	
	
}