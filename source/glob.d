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
	stdout.writefln("!!! path_name: %s", path_name);
	stdout.writefln("!!! dir_name: %s", dir_name);
	stdout.writefln("!!! base_name: %s", base_name);

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

	// /usr/bi?/python
	if (hasWildCard(dir_name)) {
		string sub_dir_name = dirName(dir_name);
		string sub_base_name = baseName(dir_name);
		stdout.writefln("    !!! dir_name: %s", dir_name);
		stdout.writefln("    !!! sub_dir_name: %s", sub_dir_name);
		stdout.writefln("    !!! sub_base_name: %s", sub_base_name);
		if (exists(sub_dir_name)) {
			string[] entries;
			try {
				entries = dirEntries(sub_dir_name, SpanMode.shallow).map!(n => n.name).array();
			} catch (FileException) {
			}
		}
/*
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
*/
	}

	return retvals;
}

// /usr/bi?/python*
string[] glob2(string path_name) {
	import std.file : exists, isDir, dirEntries, SpanMode, FileException;
	import std.path : buildPath, dirName, baseName, globMatch;
	import std.algorithm : filter, map;
	import std.array : array;
	import std.string : split;
	string[] retvals;

	// Break the path into base name and dir name
	string dir_name = dirName(path_name);
	string base_name = baseName(path_name);
	stdout.writefln("!!! path_name: %s", path_name);
	stdout.writefln("!!! dir_name: %s", dir_name);
	stdout.writefln("!!! base_name: %s", base_name);

	string[] searching_parts;
	string[] parts = path_name.split("/");
	while (parts.length > 0) {
		string part = parts[0];
		stdout.writefln("!!! part: %s", part);
		parts = parts[1 .. $];
		searching_parts ~= part;
		string searching = '/' ~ buildPath(searching_parts);
		if (hasWildCard(searching)) {
			stdout.writefln("    !!! searching: %s", searching);
			string search_dir = dirName(searching);
			string search_base = baseName(searching);
			stdout.writefln("    !!! search_dir: %s", search_dir);
			stdout.writefln("    !!! search_base: %s", search_base);
			string[] entries;
			try {
				entries = dirEntries(search_dir, SpanMode.shallow).map!(n => n.name).array();
			} catch (FileException) {
			}
			stdout.writefln("        !!! entries: %s", entries);
			foreach (entry ; entries) {
				//stdout.writefln("            !!! entry: %s", baseName(entry));
				if (globMatch(baseName(entry), search_base)) {
					//string match = '/' ~ buildPath(searching_parts);
					stdout.writefln("                !!! match: %s", entry);
				}
			}
		}
	}

	return retvals;
}

string[] glob3(string pattern) {
	import std.file : exists, isDir, dirEntries, SpanMode, FileException;
	import std.path : buildPath, dirName, baseName, globMatch;
	import std.algorithm : filter, map;
	import std.array : array;
	import std.string : split;

	string[] retval;

	//string dir_name = dirName(path_name);
	//string base_name = baseName(path_name);
	stdout.writefln("!!! pattern: %s", pattern);
	string[] parts = pattern.split("/").filter!(n => n != "").array();
	stdout.writefln("!!! parts: %s", parts);
	//string[] searching_parts;
	string[] roots = ["/"];

	while (parts.length > 0) {
		//stdout.writefln("!!! part: %s", part);

		//string searching = '/' ~ buildPath(searching_parts);
		//string[] entries = getEntries(searching);
		roots = getMatches(roots, parts);
		parts = parts[1 .. $];
	}

	return retval;
}

string[] getMatches(string[] roots, string[] parts) {
	import std.path : buildPath, dirName, baseName, globMatch;

	string[] matches;
	string part = parts[0];
	stdout.writefln("!!! part: %s", part);
	stdout.writefln("!!! roots: %s", roots);
	
	foreach (root ; roots) {
		string searching = root;
		stdout.writefln("    !!! searching: %s", searching);
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

private bool hasWildCard(string s) {
	import std.algorithm : canFind;
	// FIXME: There has to be a simple way to do this
	return s.canFind("*") || s.canFind("?") || s.canFind("[");
}

