// Copyright (c) 2017 Matthew Brennan Jones <matthew.brennan.jones@gmail.com>
// Boost Software License - Version 1.0
// Search file systems with glob patterns using the D programming language
// https://github.com/workhorsy/d-glob

/++
Search file systems with glob patterns using the D programming language

See Glob  $(LINK https://en.wikipedia.org/wiki/Glob_(programming))

Home page:
$(LINK https://github.com/workhorsy/d-glob)

Version: 0.2.0

License:
Boost Software License - Version 1.0

Examples:
----
import std.stdio : stdout;
import glob : glob;

foreach (entry ; glob("/usr/*/python*")) {
	stdout.writefln("%s", entry);
}

// outputs
/*
/usr/bin/python2
/usr/bin/python2.7
/usr/bin/python3
/usr/bin/python3.5
/usr/lib/python2.7
/usr/lib/python3
/usr/lib/python3.5
*/
----
+/

// https://en.wikipedia.org/wiki/Glob_%28programming%29

module glob;


import std.stdio : stdout;

/++
Return all the paths that match the pattern
Params:
 path_name = The path with paterns to match.
+/
string[] glob(string path_name) {
	import std.algorithm : map, filter;
	import std.array : array, replace;
	import std.string : split, startsWith;
	import std.file : getcwd;

	// Convert the Windows path to a posix path
	path_name = path_name.replace("\\", "/");

	// Break the path into a stack separated by /
	string[] patterns = path_name.split("/").filter!(n => n != "").array();

	// Figure out if using a relative path
	string cwd = getcwd();
	bool is_relative_path = ! path_name.startsWith("/");

	// Make the first path to search the cwd or /
	string[] paths = [is_relative_path ? cwd : "/"];
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
		paths =
			paths
				.filter!(n => n.length > len) // Remove paths that are just the prefix
				.map!(n => n[len .. $]) // Remove the path prefix
				.array();
	}

	return paths;
}

///
unittest {
	import std.stdio : stdout;
	import glob : glob;

	string[] entries = glob("/usr/*/python*");

	// entries would contain:
	/*
	/usr/bin/python2
	/usr/bin/python2.7
	/usr/bin/python3
	/usr/bin/python3.5
	/usr/lib/python2.7
	/usr/lib/python3
	/usr/lib/python3.5
	*/

	entries = glob("/usr/bin/python?");

	// entries would contain:
	/*
	/usr/bin/python2
	/usr/bin/python3
	*/
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
	import std.algorithm : map, sort;
	import std.array : array, replace;

	string[] entries;
	try {
		entries = dirEntries(path_name, SpanMode.shallow).map!(n => n.name).array();
	} catch (FileException) {
	}

	// Convert Windows file paths to posix format
	version (Windows) {
		entries = entries.map!(n => n.replace("\\", "/")).array();
	}

	entries.sort!("a < b");
	return entries;
}


