// Copyright (c) 2017 Matthew Brennan Jones <matthew.brennan.jones@gmail.com>
// Boost Software License - Version 1.0
// Search file systems with glob patterns using the D programming language
// https://github.com/workhorsy/d-glob

// https://en.wikipedia.org/wiki/Glob_%28programming%29

module glob;


import std.stdio : stdout;


string[] glob3(string pattern) {
	import std.file : exists, isDir, dirEntries, SpanMode, FileException;
	import std.path : buildPath, dirName, baseName, globMatch;
	import std.algorithm : filter, map;
	import std.array : array;
	import std.string : split;

	stdout.writefln("!!! pattern: %s", pattern);
	string[] parts = pattern.split("/").filter!(n => n != "").array();
	stdout.writefln("!!! parts: %s", parts);
	string[] roots = ["/"];

	while (parts.length > 0) {
		roots = getMatches(roots, parts);
		parts = parts[1 .. $];
	}
	stdout.writefln("!!! roots: %s", roots);

	return roots;
}

string[] getMatches(string[] roots, string[] parts) {
	import std.path : buildPath, dirName, baseName, globMatch;

	string[] matches;
	string part = parts[0];
	
	foreach (root ; roots) {
		string searching = root;
		stdout.writefln("    !!! searching %s for %s", searching, part);
		string[] entries = getEntries(searching);
		//stdout.writefln("    !!! entries: %s", entries);
		foreach (entry ; entries) {
			//stdout.writefln("            !!! entry: %s", baseName(entry));
			if (globMatch(baseName(entry), part)) {
				//string match = '/' ~ buildPath(searching_parts);
				stdout.writefln("                !!! match: %s", entry);
				matches ~= entry;
			}
		}
	}

	return matches;
}

string[] getEntries(string path_name) {
	import std.file : dirEntries, SpanMode, FileException;
	import std.algorithm : filter, map;
	import std.array : array;

	string[] entries;
	try {
		entries = dirEntries(path_name, SpanMode.shallow).map!(n => n.name).array();
	} catch (FileException) {
	}
	return entries;
}


