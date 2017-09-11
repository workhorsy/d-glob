

import BDD;

unittest {
	import glob : glob;
	describe("glob",
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
			glob("/usr/bin/python*").shouldEqual([
				"/usr/bin/python3", "/usr/bin/python2.7-config", "/usr/bin/python3m",
				"/usr/bin/python2.7", "/usr/bin/python", "/usr/bin/python3.5",
				"/usr/bin/python3.5m", "/usr/bin/python2", "/usr/bin/python2-config",
				"/usr/bin/python-config", "/usr/bin/python2-jsonschema", "/usr/bin/python2-pbr"]);
		}),
		it("Should glob base name single ?", delegate() {
			glob("/usr/bin/python?").shouldEqual([
				"/usr/bin/python3", "/usr/bin/python2"]);
		}),
		it("Should glob multiple *", delegate() {
			glob("/usr/*/python*").shouldEqual([
				"/usr/share/python3", "/usr/share/python3-plainbox", "/usr/share/python",
				"/usr/share/python-apt", "/usr/include/python2.7", "/usr/include/python3.5m",
				"/usr/bin/python3", "/usr/bin/python2.7-config", "/usr/bin/python3m",
				"/usr/bin/python2.7", "/usr/bin/python", "/usr/bin/python3.5",
				"/usr/bin/python3.5m", "/usr/bin/python2", "/usr/bin/python2-config",
				"/usr/bin/python-config", "/usr/bin/python2-jsonschema",
				"/usr/bin/python2-pbr", "/usr/lib/python3", "/usr/lib/python2.7",
				"/usr/lib/python3.5"]);
		}),
		it("Should glob * and ?", delegate() {
			glob("/usr/*/python?").shouldEqual([
				"/usr/share/python3", "/usr/bin/python3", "/usr/bin/python2", "/usr/lib/python3"]);
		}),
	);
}

int main() {
	return BDD.printResults();
}
