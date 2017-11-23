module Lab1::Util

import Prelude;

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

alias chunk = list[str];
alias file = list[str];

set[Declaration] getUnits(set[Declaration] ast) {
	set[Declaration] units = {};
	visit(ast) {
		case m:\method(_,_,_,_,_): units += m;
		case c:\constructor(_,_,_,_): units += c;
	}
	return units;
}

int countLOC(loc location) {
	return size(cleanedLines(location));
}

list[file] getCleanFiles(M3 model) {
	set[loc] locations = {location | <location,_> <- declaredTopTypes(model)};
	return [cleanedLines(location) | location <- locations];
}

private file cleanedLines(loc location) {
	list[str] lines = [];
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
			lines += line;
		}
	}
	return lines;
}
