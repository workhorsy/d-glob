

import BDD;

unittest {
	import glob : glob;

	describe("glob",
		it("Should work with relative paths", delegate() {
			glob("test/test_data/*").shouldEqual([
				"test/test_data/aaa", "test/test_data/bbb", "test/test_data/ccc",
				"test/test_data/test1"]);
		}),
		it("Should work with empty paths", delegate() {
			glob("/").shouldEqual(["/"]);
			glob("").shouldEqual([]);
			glob(" ").shouldEqual([]);
		}),
		it("Should glob nothing on invalid path", delegate() {
			glob("/does/not/exist").shouldEqual([]);
			glob("does/not/exist").shouldEqual([]);
		}),
		it("Should glob exact path", delegate() {
			glob("test/test_data/bbb").shouldEqual(["test/test_data/bbb"]);
		}),

		it("Should glob base name single ?", delegate() {
			glob("test/test_data/aaa/example?").shouldEqual([
				"test/test_data/aaa/example2", "test/test_data/aaa/example9"]);
		}),
		it("Should glob base name single *", delegate() {
			glob("test/test_data/aaa/example*").shouldEqual([
				"test/test_data/aaa/example", "test/test_data/aaa/example2", "test/test_data/aaa/example9"]);
		}),
		it("Should glob base name single ?", delegate() {
			glob("test/test_data/aaa/example?").shouldEqual([
				"test/test_data/aaa/example2", "test/test_data/aaa/example9"]);
		}),
		it("Should glob multiple *", delegate() {
			glob("test/test_data/*/*").shouldEqual([
				"test/test_data/aaa/example", "test/test_data/aaa/example2",
				"test/test_data/aaa/example9", "test/test_data/bbb/example3",
				"test/test_data/ccc/example4"]);
		}),
		it("Should glob * and ?", delegate() {
			glob("test/test_data/*/example?").shouldEqual([
				"test/test_data/aaa/example2", "test/test_data/aaa/example9",
				"test/test_data/bbb/example3", "test/test_data/ccc/example4"]);
		}),
	);
}

int main() {
	return BDD.printResults();
}
