module Lab1::Willem::Util

import Prelude;

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

set[Declaration] getUnits(set[Declaration] ast) {
	set[Declaration] units = {};
	visit(ast) {
		case m:\method(_,_,_,_,_): units += m;
		case c:\constructor(_,_,_,_): units += c;
	}
	return units;
}

int countLOC(loc location){

	int nLines = 0;
	bool multiline = false;

	// read source code of path into list of strings
	sourceLines = readFileLines(location);
	
	for(str line <- sourceLines){
		// when a comment start (/*) and no end is found (*/), set boolean to true
		if (/^\/\*/ := trim(line) && /\*\/$/ !:= trim(line)) {
			multiline = true;
		// when a commend end is found (*/), set boolean to false 
		} else if(/\*\/$/ := trim(line)) {
			multiline = false;
		// if no empty line or any comment starting points are found (and not part of multiline), increment counter 
		} else if (/^($|\/\/|\/\*|\*)/ !:= trim(line) && !multiline) {
			nLines += 1;
		}
	}
	return nLines;
}