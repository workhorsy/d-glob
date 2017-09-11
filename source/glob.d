// Copyright (c) 2017 Matthew Brennan Jones <matthew.brennan.jones@gmail.com>
// Boost Software License - Version 1.0
// Search file systems with glob patterns using the D programming language
// https://github.com/workhorsy/d-glob

// https://en.wikipedia.org/wiki/Glob_%28programming%29

module glob;


import std.stdio : stdout;


string[] glob(string pattern) {
	import std.algorithm : filter;
	import std.array : array;
	import std.string : split;

	string[] patterns = pattern.split("/").filter!(n => n != "").array();
	string[] paths = ["/"];
	stdout.writefln("pattern: \"%s\"", pattern);
	stdout.writefln("patterns: %s", patterns);

	while (patterns.length > 0) {
		string part = patterns[0];
		paths = getMatches(paths, part);
		patterns = patterns[1 .. $];
		stdout.writefln("            paths: %s", paths);
	}

	return paths;
}

private string[] getMatches(string[] path_candidates, string pattern) {
	import std.path : baseName, globMatch;

	string[] matches;

	foreach (path ; path_candidates) {
		stdout.writefln("    searching \"%s\" for \"%s\"", path, pattern);
		foreach (entry ; getEntries(path)) {
			if (globMatch(baseName(entry), pattern)) {
				stdout.writefln("        match: \"%s\"", entry);
				matches ~= entry;
			}
		}
	}

	return matches;
}

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


