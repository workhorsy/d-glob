// Copyright (c) 2017 Matthew Brennan Jones <matthew.brennan.jones@gmail.com>
// Boost Software License - Version 1.0
// Search file systems with glob patterns using the D programming language
// https://github.com/workhorsy/d-glob

/++
Search file systems with glob patterns using the D programming language

See Glob  $(LINK https://en.wikipedia.org/wiki/Glob_(programming))

Home page:
$(LINK https://github.com/workhorsy/d-glob)

Version: 0.3.0

License:
Boost Software License - Version 1.0
+/

// https://en.wikipedia.org/wiki/Glob_%28programming%29

module glob;


import std.stdio : stdout;
import std.regex : regex, Regex;

/++
Return all the paths that match the glob pattern
Params:
 path_name = The path with paterns to match.
+/
string[] glob(string path_name) {
	return getGlobMatches(path_name, false);
}

///
unittest {
	import std.stdio : stdout;
	import glob : glob;

	// Use * to match zero or more instances of a character
	string[] entries = glob("/usr/bin/python*");
	/*
	entries would contain:
	/usr/bin/python2
	/usr/bin/python2.7
	/usr/bin/python3
	/usr/bin/python3.5
	*/

	// Use ? to match one instance of a character
	entries = glob("/usr/bin/python2.?");
	/*
	entries would contain:
	/usr/bin/python2.6
	/usr/bin/python2.7
	*/

	// Use [] to match one instance of a character between the brackets
	entries = glob("/usr/bin/python[23]");
	/*
	entries would contain:
	/usr/bin/python2
	/usr/bin/python3
	*/

	// Use [!] to match one instance of a character NOT between the brackets
	entries = glob("/usr/bin/python[!3]");
	/*
	entries would contain:
	/usr/bin/python2
	*/

	// Use {} to match any of the full strings
	entries = glob("/usr/bin/{python,ruby}");
	/*
	entries would contain:
	/usr/bin/python
	/usr/bin/ruby
	*/
}

/++
Return all the paths that match the regex pattern
Params:
 path_regex = The path with regex paterns to match.
+/
string[] globRegex(string path_regex) {
	import std.string : startsWith, endsWith;

	if (! path_regex.startsWith('^') || ! path_regex.endsWith('$')) {
		throw new Exception("The regex must start with ^ and end with $.");
	}

	// Remove the regex ^ and $ from the start and end
	string path_name = path_regex[1 .. $-1];

	return getGlobMatches(path_name, true);
}

///
unittest {
	import std.stdio : stdout;
	import glob : globRegex;

	// Use a regex to match all the number files in /proc/
	string[] entries = globRegex(`^/proc/[0-9]*$`);
	/*
	entries would contain:
	/proc/111
	/proc/245
	/proc/19533
	/proc/1
	*/
}

private string[] getGlobMatches(string path_name, bool is_regex) {
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
		paths = getMatches(paths, pattern, is_regex);
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

private string[] getMatches(string[] path_candidates, string pattern, bool is_regex=false) {
	import std.path : baseName, globMatch;
	import std.regex : match;

	string[] matches;

	if (is_regex) {
		auto r = regex("^" ~ pattern ~ "$");
		foreach (path ; path_candidates) {
	//		stdout.writefln("    searching \"%s\" for \"%s\"", path, pattern);
			foreach (entry ; getEntries(path)) {
				if (match(baseName(entry), r)) {
	//				stdout.writefln("        match: \"%s\"", entry);
					matches ~= entry;
				}
			}
		}
	} else {
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


