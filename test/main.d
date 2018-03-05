

import BDD;

unittest {
	import glob : glob, globRegex;

	describe("glob",
		it("Should work with empty paths", delegate() {
			glob("/").shouldEqual(["/"]);
			glob("").shouldEqual([]);
			glob(" ").shouldEqual([]);
		}),
		it("Should return nothing on invalid path", delegate() {
			glob("/does/not/exist").shouldEqual([]);
			glob("does/not/exist").shouldEqual([]);
		}),
		it("Should glob exact path", delegate() {
			glob("test/test_data/bbb").shouldEqual(["test/test_data/bbb"]);
		}),
		it("Should work with relative paths", delegate() {
			glob("test/test_data/*").shouldEqual([
				"test/test_data/aaa", "test/test_data/bbb",
				"test/test_data/ccc", "test/test_data/test1"]);
		}),
		it("Should glob ?", delegate() {
			glob("test/test_data/aaa/example?").shouldEqual([
				"test/test_data/aaa/example2", "test/test_data/aaa/example4",
				"test/test_data/aaa/example9"]);
		}),
		it("Should glob *", delegate() {
			glob("test/test_data/aaa/example*").shouldEqual([
				"test/test_data/aaa/example", "test/test_data/aaa/example2",
				"test/test_data/aaa/example4", "test/test_data/aaa/example9"]);
		}),
		it("Should glob {}", delegate() {
			glob("test/test_data/{aaa,ccc}/").shouldEqual([
				"test/test_data/aaa", "test/test_data/ccc"]);
		}),
		it("Should glob []", delegate() {
			glob("test/test_data/aaa/example[29]").shouldEqual([
				"test/test_data/aaa/example2", "test/test_data/aaa/example9"]);
		}),
		it("Should glob multiple", delegate() {
			glob("test/*/{aaa,bbb}/example[29]").shouldEqual([
				"test/test_data/aaa/example2", "test/test_data/aaa/example9",
				"test/test_data/bbb/example2", "test/test_data/bbb/example9"]);
		}),
		it("Should work with Windows style path separators", delegate() {
			// Try \\
			glob("test\\test_data\\aaa\\example*").shouldEqual([
				"test/test_data/aaa/example", "test/test_data/aaa/example2",
				"test/test_data/aaa/example4", "test/test_data/aaa/example9"]);
			// Try \
			glob(`test\test_data\aaa\example*`).shouldEqual([
				"test/test_data/aaa/example", "test/test_data/aaa/example2",
				"test/test_data/aaa/example4", "test/test_data/aaa/example9"]);
		}),
		it("Should work with unicode", delegate() {
			glob("test/test_unicode/*/some_*_{漢字,עִבְרִית}").shouldEqual([
				"test/test_unicode/some_russian_ру́сский/some_hebrew_עִבְרִית",
				"test/test_unicode/some_russian_ру́сский/some_kanji_漢字"]);

			glob("test/test_unicode/*{ру́сский}*/*漢字*").shouldEqual([
				"test/test_unicode/some_russian_ру́сский/some_kanji_漢字"]);
		}),
	);


	describe("globRegex",
		it("Should work with a regex", delegate() {
			globRegex(`^test/test_regex/[0-9]*$`).shouldEqual([
				"test/test_regex/111",
				"test/test_regex/222",
				"test/test_regex/333"]);
		}),
		it("Should require ^ and $ for regexes", delegate() {
			shouldThrow(delegate() {
				globRegex(`test/test_regex/[0-9]`);
			}, "The regex must start with ^ and end with $.");
		}),
	);
}

int main() {
	return BDD.printResults();
}
