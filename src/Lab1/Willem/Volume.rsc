module Lab1::Willem::Volume

import IO;
import List;
import Set;

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import Lab1::Willem::Metric;
import Lab1::Willem::Util;

Metric volume(list[list[str]] files) {
	int result = sum([0] + [size(file) | file <- files]);
	println("Total LOC: <result>");
	return toMetric(result);
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
