module Lab1::metrics::Volume

import IO;
import List;
import Set;

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import Lab1::Metric;
import Lab1::Util;

Metric volume(list[file] files) {
	int result = countLOC(files);
	println("Total LOC: <result>");
	return toMetric(result);
}

private int countLOC(list[file] files) {
	return sum([0] + [size(file) | file <- files]);
}

private Metric toMetric(int result) {
	int sc = 0;
	if (result < 66000) { 
		sc = 2;
	} else if (result < 246000) {
		sc = 1;
	} else if (result < 665000) {
		sc = 0;
	} else if (result < 1310000) {
		sc = -1;
	} else {
		sc = -2;	
	}
	return metric("Volume", score(sc));
}


private file testFile = ["a","b","c","d","e","f","g","h","i","j"];
private list[file] testFiles = [testFile | _ <- [0..10]];

test bool testEmptyFile() = countLOC([]) == 0;
test bool testFiles1() = countLOC([testFile]) == 10;
test bool testFiles10() = countLOC(testFiles) == 100;
test bool testMetric() = volume(testFiles).score.score == 2;
