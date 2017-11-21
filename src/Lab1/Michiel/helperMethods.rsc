module Lab1::Michiel::helperMethods

import IO;
import List;
import Set;
import String;
import Exception;
import Map;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import util::Benchmark;
import util::Math;

/*
Still needs refactoring and cleaning!
Willem Jan, relevante code voor duplication vanaf 110
*/

// counts the lines of code (no comments/whitespace) from a path (loc) of a program/method 
int countLOC(loc filePath){
	// read source code of path into list of strings
	sourceLines = readFileLines(filePath);
	return size(removeCommentsAndEmptyLines(sourceLines));
}

list[str] removeCommentsAndEmptyLines(list[str] sourceLines) {
	
	list[str] filteredSourceLines = [];
	bool multiline = false;

	for(str line <- sourceLines){
		// when a comment start (/*) and no end is found (*/), set boolean to true
		if (/^\/\*/ := trim(line) && /\*\/$/ !:= trim(line)) {
			multiline = true;
		// when a commend end is found (*/), set boolean to false 
		} else if(/\*\/$/ := trim(line)) {
			multiline = false;
		// if no empty line or any comment starting points are found (and not part of multiline), increment counter 
		} else if (/^($|\/\/|\/\*|\*)/ !:= trim(line) && !multiline) {
			filteredSourceLines += trim(line);
		}
	}
	return filteredSourceLines;
}

// [3.5,10,20] for duplication percentages
// [30, 44, 74, 94] for unit size?
// [66000, 246000, 665000, 1310000] for volume

str calculateScore(int nLOC, list[int] thresholds) {
	if (nLOC <= thresholds[0]) {
		return "++";
	} else if (nLOC <= thresholds[1]) {
		return "+";
	} else if (nLOC <= thresholds[2]) {
		return "o";
	} else if (nLOC <= thresholds[3]) {
		return "-";
	} else {
		return "--";
	}
}


void calculateComplexity(loc filePath) {
	println("This does nothing yet");
}


//map[int, set[int]] findDuplicateIndices(list[list[str]] allLinesOfCode) {
//	
//	map[int, set[int]] fileDuplicateIndicesMap = (i:{} | i <- [0..size(allLinesOfCode)]);
//
//	nFiles = size(allLinesOfCode);
//	fileIterator = 0;
//	
//	for(file1 <- allLinesOfCode){
//	
//		fileIterator2 = 0;
//		for(file2 <- slice(allLinesOfCode, fileIterator + 1, nFiles - (fileIterator + 1))) {
//			duplicateIndices = {};
//			lineIterator = 0;
//			for(line <- file1) {
//				if(line in file2) {
//					duplicateIndices += lineIterator;
//				}
//				lineIterator += 1;
//			}
//			//fileDuplicateIndicesMap[fileIterator2 + fileIterator] = fileDuplicateIndicesMap[fileIterator2 + fileIterator + 1] & duplicateIndices;
//			fileIterator2 += 1;
//			println("For <fileIterator> : <fileIterator2 + fileIterator>");
//			println("I found <sort(duplicateIndices)>");
//			fileDuplicateIndicesMap[fileIterator] += duplicateIndices;	
//			fileDuplicateIndicesMap[fileIterator + fileIterator2] += duplicateIndices;
//		}
//		
//		fileIterator += 1;
//		
//	}
//	return fileDuplicateIndicesMap;
//}





/* DuplicateInFile checkt duplicates binnen 1 file. */


map[int,list[int]] duplicatesInFile() {
	
	int window = 3;
	//loc filePath = |project://SIGModelProject/src/Lab1/Michiel/Puppy.java|;
	loc filePath = |project://SIGModelProject/src/Lab1/Michiel/test.java|;
	list[str] codeLines = removeCommentsAndEmptyLines(readFileLines(filePath));
	
	int nLines = size(codeLines);
	int nGroups = (nLines - window) + 1;
	
	list[list[str]] lineGroups = [slice(codeLines, i, window) | i <- [0..nGroups]];
	
	int nDuplicateLines = 0;
	
	int i = 0;
	int j = 0;
	int duplicateIndexOld = -1;
	int referenceIndexOld = -1;
	
	map[int,list[int]] masterMap = ();
	
	list[int] duplicateIndices = [];
	list[int] referenceIndices = [];
	
	for(currentGroup <- lineGroups){
		j = indexOf(lineGroups, currentGroup);
		if(j != i){
			duplicateIndices += i;
			referenceIndices += j;	
		}
		i += 1;
	}
	
	masterMap += (0:(duplicateIndices+referenceIndices));
	println(countTotalDuplication(masterMap, window));
	return masterMap;
}

int calculateNewLines(int val1, int val2, int window) {
	if((val1 - val2 >= window) || (val2 == -1)){
		return window;
	}
	return (val1 - val2);
}	

/////////////////////////////////////////////////////////////////////////////

int countTotalDuplication(map[int,list[int]] duplicationIndices, int window) {
	
	int totalDuplication = 0;
	
	// calculate duplicates for each file
	for(idx <- duplicationIndices) {
		
		duplicateIndexOld = -1;
		duplicateList = sort(duplicationIndices[idx]);
		
		for(i <- duplicateList){
			totalDuplication += calculateNewLines(i, duplicateIndexOld, window);
			duplicateIndexOld = i;
		}
	}
	
	return totalDuplication;
}

/////////////////////////////////////////////////////////////////////////////	
	
tuple[int, int] getTotalDuplicationCount(loc projectPath, int window){

	int totalLOC = 0;
	
	// test					  
	list[loc] allPaths = [|project://SIGModelProject/src/Lab1/Michiel/Puppy.java|, 
						  |project://SIGModelProject/src/Lab1/Michiel/Puppy2.java|,
						  |project://SIGModelProject/src/Lab1/Michiel/Puppy4.java|];
						  
	// parse all code to remove comments and whitespace
	allLinesOfCode = [removeCommentsAndEmptyLines(readFileLines(filePath)) | filePath <- allPaths];
	
	// initialize counter for file that is currently checked
	int fileCounter = 0;
	int nFiles = size(allLinesOfCode);
	
	// initialize map that will contain file index - duplication index mappings
	map[int,list[int]] masterMap = ();
	
	// iterate every file and compare with every other file to compute duplicates
	for(file1 <- allLinesOfCode){
	
		int nLines = size(file1);
		int nGroups = (nLines - window) + 1;
		int file2Counter = 0;
		
		list[list[str]] file1LineGroups = [slice(file1, i, window) | i <- [0..nGroups]];
		
		for(file2 <- slice(allLinesOfCode, fileCounter + 1, nFiles - (fileCounter + 1))) {
			
			int nLines2 = size(file2);
			int nGroups2 = (nLines2 - window) + 1;
			
			list[list[str]] file2LineGroups = [slice(file2, j, window) | j <- [0..nGroups2]];
			
			list[int] duplicateIndices = [];
			list[int] referenceIndices = [];
			
			int i = 0;
			int j = 0;
			
			for(currentGroup <- file1LineGroups){
				j = indexOf(file2LineGroups, currentGroup);
				if(j != -1){
					duplicateIndices += i;
					referenceIndices += j;	
				}
				i += 1;
			}
			
			file2Counter += 1;
			
			try {
				temp1 = masterMap[fileCounter] + duplicateIndices;
        		temp2 = masterMap[(file2Counter + fileCounter)] + referenceIndices;
        		
        		masterMap += (fileCounter : temp1);
        		masterMap += ((file2Counter + fileCounter) : temp2);
			}
			catch:{
				println(duplicateIndices);
				println(fileCounter);
				println(referenceIndices);
				println(file2Counter);
				
				masterMap += (fileCounter:duplicateIndices);
				masterMap += ((file2Counter+fileCounter):referenceIndices);
				println(masterMap); 
			}
				
			println("For <fileCounter> : <file2Counter + fileCounter>");
			
		}
		
		totalLOC += nLines;
		fileCounter += 1;
	}
	
	println(masterMap);
	//println(countTotalDuplication(masterMap, window));
	return <countTotalDuplication(masterMap, window),totalLOC>; 
}












	
