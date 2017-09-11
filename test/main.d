

import BDD;
import std.stdio : stdout, stderr;
import std.datetime : Date;

unittest {
	import glob : glob;
	describe("glob",
		it("Should glob nothing on invalid path", delegate() {
			glob("/does/not/exist").shouldEqual([]);
		}),
		it("Should glob exact path", delegate() {
			glob("/usr/bin/python").shouldEqual(["/usr/bin/python"]);
		}),
	);
}

int main() {
	return BDD.printResults();
}
