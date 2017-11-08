module Lab1::Willem::MethodCount

import util::ValueUI;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import List;
import Set;
import IO;

loc project = |project://smallsql0.21_src|;

int countMethods(loc project) {
	list[int] methods = [size(readFileLines(method)) | method <- methods(createM3FromEclipseProject(project))];
	return sum(methods)/size(methods);
}
