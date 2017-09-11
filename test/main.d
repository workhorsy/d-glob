

import BDD;
import std.stdio : stdout, stderr;
import std.datetime : Date;

unittest {
	import glob : glob, glob2;
	describe("glob",
/*
		it("Should glob nothing on invalid path", delegate() {
			glob("/does/not/exist").shouldEqual([]);
		}),
		it("Should glob exact path", delegate() {
			glob("/usr/bin/python").shouldEqual(["/usr/bin/python"]);
		}),

		it("Should glob base name single ?", delegate() {
			glob("/usr/bin/python?").shouldEqual(["/usr/bin/python3", "/usr/bin/python2"]);
		}),
		it("Should glob base name single *", delegate() {
			glob("/usr/bin/python*").shouldEqual(["/usr/bin/python3", "/usr/bin/python2.7-config", "/usr/bin/python3m", "/usr/bin/python2.7", "/usr/bin/python", "/usr/bin/python3.5", "/usr/bin/python3.5m", "/usr/bin/python2", "/usr/bin/python2-config", "/usr/bin/python-config", "/usr/bin/python2-jsonschema", "/usr/bin/python2-pbr"]);
		}),
*/
		it("Should glob dir name single ?", delegate() {
			glob2("/usr/bi?/python").shouldEqual(["/usr/bin/python"]);
		}),
	);
}

int main() {
	return BDD.printResults();
}
