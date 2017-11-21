module Lab1::Michiel::SIGModel

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import util::Benchmark;
import util::Math;

import IO;
import List;

import Lab1::Michiel::helperMethods;

void main() {


	projectPath = |project://smallsql0.21_src|;
	//projectPath = |project://hsqldb-2.3.1|;
	myModel = createM3FromEclipseProject(projectPath);

	beforeTime = userTime(); 
	
	/* determine Volume of project */
	uniquePaths = {file | <file,_> <- declaredTopTypes(myModel)};
	list[int] files = [countLOC(file) | file <- uniquePaths];
	println("Total LOC in the entire project: <sum(files)>");
	
	afterTime = userTime();
	
	/* determine Unit size of project */
	list[int] methods = [countLOC(method) | method <- methods(myModel)];
	println("Average LOC of all project methods: <sum(methods)/size(methods)>");

	println("<(afterTime - beforeTime) / 1000000000.0>");
}	
