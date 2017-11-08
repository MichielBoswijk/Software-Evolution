module Lab1::Willem::MethodCount

import util::ValueUI;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import List;
import Set;
import IO;
import util::Math;

M3 createModel() {
	loc project = |project://smallsql0.21_src|;
	return createM3FromEclipseProject(project);
}

real countMethods(M3 model) {
	list[int] methods = [countLOC(method) | method <- methods(model)];
	return sum(methods)/toReal(size(methods));
}

int countLOC(loc file) {
	// TODO ignore empty lines and comments
	return size(readFileLines(file));
}

int countLines(M3 model) {
	list[int] files = [countLOC(file) | <file,_> <- declaredTopTypes(model)];
	return sum(files);
}