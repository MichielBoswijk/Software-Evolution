module Lab1::Michiel::SIGModel

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import IO;
import List;

import Lab1::Michiel::helperMethods;

void main() {

	projectPath = |project://smallsql0.21_src|;
	myModel = createM3FromEclipseProject(projectPath);
	
	/* determine Volume of project */
	list[int] files = [countLOC(file) | <file,_> <- declaredTopTypes(myModel)];
	println("Total LOC in the enitre project: <sum(files)>");
	
	/* determine Unit size of project */
	list[int] methods = [countLOC(method) | method <- methods(myModel)];
	println("Average LOC of all project methods: <sum(methods)/size(methods)>");
}




