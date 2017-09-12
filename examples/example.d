


int main() {
	import std.stdio : stdout;
	import glob : glob;

	// Print all the locations of gcc
	stdout.writefln("Searching for gcc ...");
	foreach (entry ; glob("/usr/{lib,bin}/gcc*")) {
		stdout.writefln("    %s", entry);
	}

	// Print all the locations of python
	stdout.writefln("Searching for python ...");
	foreach (entry ; glob("/usr/*/python?")) {
		stdout.writefln("    %s", entry);
	}

	return 0;
}