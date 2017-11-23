module Lab1::Volume

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

private file file = ["a","b","c","d","e","f","g","h","i","j"];
private list[file] files = [file | _ <- [0..10]];

test bool empty() = countLOC([]) == 0;
test bool files1() = countLOC([file]) == 10;
test bool files10() = countLOC(files) == 100;
test bool metric() = volume(files).score.score == 2;

