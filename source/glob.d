// Copyright (c) 2017 Matthew Brennan Jones <matthew.brennan.jones@gmail.com>
// Boost Software License - Version 1.0
// Search file systems with glob patterns using the D programming language
// https://github.com/workhorsy/d-glob

// https://en.wikipedia.org/wiki/Glob_%28programming%29

module glob;


import std.stdio : stdout;


string[] glob(string path_name) {
	import std.file : exists, isDir;
	import std.path : buildPath, dirName, baseName;
	string[] retvals;

	// Break the path into base name and dir name
	string dir_name = dirName(path_name);
	string base_name = baseName(path_name);

	// The path exists and has no wild cards
	if (! hasWildCard(path_name) && exists(path_name)) {
		retvals ~= path_name;
		return retvals;
	}

	return retvals;
}

private bool hasWildCard(string s) {
	import std.algorithm : canFind;
	// FIXME: There has to be a simple way to do this
	return s.canFind("*") || s.canFind("?") || s.canFind("[");
}

