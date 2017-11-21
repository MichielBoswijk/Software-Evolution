module Lab1::Willem::Volume

import Lab1::Willem::Util;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import List;
import Set;
import Lab1::Willem::Metric;
import IO;

Metric volume(M3 model) {
	set[loc] files = {file | <file,_> <- declaredTopTypes(model)};
	int result = sum([0] + [countLOC(file) | file <- files]);
	println("Total LOC: <result>");
	return toMetric(result);
}

private Metric toMetric(int result) {
	int sc = 0;
	if (result >= 0 && result < 66000) { 
		sc = 2;
	} else if (result >= 66000 && result < 246000) {
		sc = 1;
	} else if (result >= 246000 && result < 665000) {
		sc = 0;
	} else if (result >= 665000 && result < 1310000) {
		sc = -1;
	} else {
		sc = -2;	
	}
	return metric("Volume", score(sc));
}
