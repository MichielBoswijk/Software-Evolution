module Lab2::Main

import Lab2::Config;
import Lab2::Clones;
import Lab2::Clones2;
import Lab2::Results;

import IO;

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

void main() {
	set[Declaration] asts = createAstsFromEclipseProject(project, false);
	lrel[loc, loc] clones = getClones2(asts);
	for(clone <- clones) {
		println(clone);
	}
	writeResults(clones, project);
}
