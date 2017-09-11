// Copyright (c) 2017 Matthew Brennan Jones <matthew.brennan.jones@gmail.com>
// Boost Software License - Version 1.0
// Search file systems with glob patterns using the D programming language
// https://github.com/workhorsy/d-glob

// https://en.wikipedia.org/wiki/Glob_%28programming%29

module glob;


import std.stdio : stdout;


string[] glob(string path_name) {
	import std.algorithm : map, filter;
	import std.array : array;
	import std.string : split, startsWith;
	import std.file : getcwd;

	// Break the path into a stack separated by /
	string cwd = getcwd();
	bool is_relative_path = ! path_name.startsWith("/");
	string[] patterns = path_name.split("/").filter!(n => n != "").array();
	string[] paths = (is_relative_path ? [cwd] : ["/"]);
//	stdout.writefln("path_name: \"%s\"", path_name);
//	stdout.writefln("patterns: %s", patterns);

	// For each pattern get the directory entries that match the pattern
	while (patterns.length > 0) {
		// Pop the next pattern off the stack
		string pattern = patterns[0];
		patterns = patterns[1 .. $];

		// Get the matches
		paths = getMatches(paths, pattern);
//		stdout.writefln("            paths: %s", paths);
	}

	// Convert from an absolute path to a relative one, if path_name is relative
	if (is_relative_path) {
		size_t len = cwd.length + 1;
		paths = paths.map!(n => n[len .. $]).array();
	}

	return paths;
}

private string[] getMatches(string[] path_candidates, string pattern) {
	import std.path : baseName, globMatch;

	string[] matches;

	// Iterate through all the entries in the paths
	// and return the ones that match the pattern
	foreach (path ; path_candidates) {
//		stdout.writefln("    searching \"%s\" for \"%s\"", path, pattern);
		foreach (entry ; getEntries(path)) {
			if (globMatch(baseName(entry), pattern)) {
//				stdout.writefln("        match: \"%s\"", entry);
				matches ~= entry;
			}
		}
	}

	return matches;
}

// Returns the name of all the shallow entries in a directory
private string[] getEntries(string path_name) {
	import std.file : dirEntries, SpanMode, FileException;
	import std.algorithm : map;
	import std.array : array;

	string[] entries;
	try {
		entries = dirEntries(path_name, SpanMode.shallow).map!(n => n.name).array();
	} catch (FileException) {
	}
	return entries;
}


