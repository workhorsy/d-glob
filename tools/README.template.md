# D Glob
Search file systems with glob patterns using the D programming language

# Example

```d
import std.stdio : stdout;
import glob : glob, globRegex;


// Use glob to search by glob pattern
foreach (entry ; glob("/usr/*/python*")) {
	stdout.writefln("%s", entry);
}

/*
/usr/bin/python2
/usr/bin/python2.7
/usr/bin/python3
/usr/bin/python3.5
/usr/lib/python2.7
/usr/lib/python3
/usr/lib/python3.5
*/

// Use globRegex to search by regex pattern
foreach (entry ; globRegex(`^/proc/[0-9]*$`)) {
	stdout.writefln("%s", entry);
}
/*
/proc/111
/proc/245
/proc/19533
/proc/1
*/

```

# Documentation

[https://workhorsy.github.io/d-glob/$VERSION/](https://workhorsy.github.io/d-glob/$VERSION/)

# Generate documentation

```
dub --build=docs
```

# Run unit tests

```
dub test
```

[![Dub version](https://img.shields.io/dub/v/d-glob.svg)](https://code.dlang.org/packages/d-glob)
[![Dub downloads](https://img.shields.io/dub/dt/d-glob.svg)](https://code.dlang.org/packages/d-glob)
[![License](https://img.shields.io/badge/license-BSL_1.0-blue.svg)](https://raw.githubusercontent.com/workhorsy/d-glob/master/LICENSE)
