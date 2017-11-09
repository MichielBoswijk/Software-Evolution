module Lab1::Michiel::helperMethods

import IO;
import String;

// counts the lines of code (no comments/whitespace) from a path (loc) of a program/method 
int countLOC(loc filePath){

	int nLines = 0;
	bool multiline = false;

	// read source code of path into list of strings
	sourceLines = readFileLines(filePath);
	
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