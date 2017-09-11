// Copyright (c) 2017 Matthew Brennan Jones <matthew.brennan.jones@gmail.com>
// Boost Software License - Version 1.0
// Search file systems with glob patterns using the D programming language
// https://github.com/workhorsy/d-glob

// https://en.wikipedia.org/wiki/Glob_%28programming%29

module glob;


import std.stdio : stdout;


string[] glob(string path_name) {
	import std.file : exists, isDir, dirEntries, SpanMode, FileException;
	import std.path : buildPath, dirName, baseName, globMatch;
	import std.algorithm : filter, map;
	import std.array : array;
	string[] retvals;

	// Break the path into base name and dir name
	string dir_name = dirName(path_name);
	string base_name = baseName(path_name);
//	stdout.writefln("!!! path_name: %s", path_name);
//	stdout.writefln("!!! dir_name: %s", dir_name);
//	stdout.writefln("!!! base_name: %s", base_name);

	// The path exists and has no wild cards
	if (exists(path_name) && ! hasWildCard(path_name)) {
		retvals ~= path_name;
		return retvals;
	}

//	stdout.writefln("!!! exists(dir_name): %s", exists(dir_name));
//	stdout.writefln("!!! hasWildCard(base_name): %s", hasWildCard(base_name));
	// The base path exists and the dir name has wild cards
	if (exists(dir_name) && hasWildCard(base_name)) {
		string[] entries;
		try {
			entries = dirEntries(dir_name, SpanMode.shallow).map!(n => n.name).array();
		} catch (FileException) {
		}
		foreach (entry ; entries) {
			//stdout.writefln("!!! entry: %s, base_name: %s", baseName(entry), base_name);
			if (globMatch(baseName(entry), base_name)) {
				retvals ~= entry;
			}
		}

		return retvals;
	}

	return retvals;
}

private bool hasWildCard(string s) {
	import std.algorithm : canFind;
	// FIXME: There has to be a simple way to do this
	return s.canFind("*") || s.canFind("?") || s.canFind("[");
}

