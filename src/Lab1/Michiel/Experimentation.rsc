////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Lab1::Michiel::Experimentation

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void testDuplication(loc project) {
	//window = 6;
	//M3 model = createM3FromEclipseProject(project);
	//uniquePaths = {file | <file,_> <- declaredTopTypes(model)};
	//println(getTotalDuplicationCount(toList(uniquePaths), window));
	
	a = [0,1,2,3,2,5,3,2]; // should yield 2, 4, 7 for input 2
	partOfList = a;
	while(true){
		idx = indexOf(partOfList, 2);
		if(idx != -1){
			println(idx);
			partOfList[idx] = 123123124;
			println(partOfList);
		} else {
			break;
		}
	}	
}


void mapApproach() {
	
	//loc project = |project://smallsql0.21_src|;
	loc project = |project://hsqldb-2.3.1|;
	window = 6;
	M3 model = createM3FromEclipseProject(project);
	uniquePaths = {file | <file,_> <- declaredTopTypes(model)};
	allLinesOfCode = [removeCommentsAndEmptyLines(readFileLines(filePath)) | filePath <- uniquePaths];
	
	allLineGroupsPerFile = [];
	allLineGroups = [];
	int smallLOC = 0;
	
	for(file <- allLinesOfCode){
		nLines = size(file);
		if(nLines >= window){
			nGroups = (nLines - window) + 1;
			fileLineGroups = [slice(file, i, window) | i <- [0..nGroups]];
			allLineGroupsPerFile += [fileLineGroups];
			allLineGroups += fileLineGroups;
		} else {
			smallLOC += nLines;
		}
	}
	
	println("Total Files : <size(allLineGroupsPerFile)>");
	println("Total groups of size <window> : <size(allLineGroups)>");
	
	duplicatesDistribution = distribution(allLineGroups);
	duplicationCandidates = [idx | idx <- duplicatesDistribution, duplicatesDistribution[idx] != 1];
	
	a = [duplicatesDistribution[idx] | idx <- duplicatesDistribution, duplicatesDistribution[idx] != 1];
	println("Total duplicate sections of <window> lines : <sum(a)>");
	
	int totalDuplicates = 0;
	int i = 0;
	
	for(file <- allLineGroupsPerFile) {
		j = 0;
		prevIndex = -1;
		for(currentGroup <- file){
			if(currentGroup in duplicationCandidates) {
				if(j - prevIndex >= window || prevIndex == -1){
					totalDuplicates += window;
				} else {
					totalDuplicates += (j - prevIndex);
				}
				prevIndex = j;
			}
			j += 1;
		}
		i += 1;	
	}
	
	
	println("Number of duplicates : <totalDuplicates>");
	
	
	//int totalDuplicates = 0;
	
	//println(size(duplicationCandidates));
	
	
	
	//for(candidate <- duplicationCandidates){
	//	println(getAllIndices(candidate, allLine));
	//	indices = getAllIndices(candidate, a);
	//	println(countDuplicates(indices, 3));
	//	
	//}
	
	
	
	//println(smallLOC); 
	//println("<size(allLineGroups) - size(distribution(allLineGroups))> : <size(allLineGroups)>");		
	//println(distribution(allLineGroups));
	
	//i = 0;
	//for(currentGroup <- allLineGroups){
	//	println(getAllIndices(allLineGroups[i], allLineGroups));
	//}
	//
	
	
	
	
	
}

void testDistribution() {
	a = [["a","b","c"], ["b","c","a"], ["c","a","b"], ["a","b","c"]];
	d = distribution(a);
	duplicateCandidates = [idx | idx <- d, d[idx] != 1];
	println(duplicateCandidates);
	
	for(candidate <- duplicateCandidates){
		println(candidate);
		println(getAllIndices(candidate, a));
		indices = getAllIndices(candidate, a);
		println(countDuplicates(indices, 3));
		
	}
}


list[int] getAllIndices(list[str] codeBlock, list[list[str]] allBlocks) {
	indices = [];
		
	while(true){
		idx = indexOf(allBlocks, codeBlock); 
		if(idx != -1){
			indices += idx;
			allBlocks[idx] = ["//"];
		} else {
			break;
		}
	}
	return indices;
}

int countDuplicates(list[int] indices, int window){
	
	int totalDuplicates = 0;	
	int prevIndex = -1;
		
	for(idx <- indices){
		if(idx - prevIndex >= window || prevIndex == -1){
			totalDuplicates += window;
		} else {
			totalDuplicates += (idx - prevIndex);
		}
		prevIndex = idx;
	}
	return totalDuplicates / 2;
}








/* function for counting the total number of duplicated lines versus their total lines in a project 
 * input: list of locations to all files in project, a window indicating a minimum number of code lines to consider for duplication
 * output: a tuple with the number of duplicated lines and the number of total lines respectively
 */
tuple[int, int] getTotalDuplicationCount(list[loc] allPaths, int window){
	  
	allLinesOfCode = [removeCommentsAndEmptyLines(readFileLines(filePath)) | filePath <- allPaths]; // pre parse all code
	
	int totalLOC = 0;
	int fileCounter = 0;
	int nFiles = size(allLinesOfCode);
	map[int,set[int]] duplicateIndicesMap = ();
	//set[int] inFileDuplicates = {};
	
	for(file1 <- allLinesOfCode){
		
		int nLines = size(file1);
		int nGroups = (nLines - window) + 1;
		int file2Counter = 0;
					
		if(nLines >= window){																			// file size in window range
		
			//inFileDuplicates += duplicatesInSingleFile(file1,window);
			
			list[list[str]] file1LineGroups = [slice(file1, i, window) | i <- [0..nGroups]];			// divide into window sized chunks
			
			for(file2 <- slice(allLinesOfCode, fileCounter + 1, nFiles - (fileCounter + 1))) {			// slice to avoid double counting
				
				int nLines2 = size(file2);
				int nGroups2 = (nLines2 - window) + 1;
				
				if(nLines2 >= window){																	// file size in window range
				
					list[list[str]] file2LineGroups = [slice(file2, j, window) | j <- [0..nGroups2]]; 	// divide into window sized chunks
					
					set[int] duplicateIndices = {};
					set[int] referenceIndices = {};
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
		        		duplicateIndicesMap[fileCounter] = duplicateIndicesMap[fileCounter] + duplicateIndices;
					}
					catch:{
						duplicateIndicesMap = duplicateIndicesMap + (fileCounter:duplicateIndices);
					}
					try {
		        		duplicateIndicesMap[file2Counter + fileCounter] = duplicateIndicesMap[file2Counter + fileCounter] + referenceIndices;
					}
					catch:{
						duplicateIndicesMap = duplicateIndicesMap + ((file2Counter+fileCounter):referenceIndices);
					}
				}		
			}
		}
		totalLOC += nLines;
		fileCounter += 1;
	}
	return <countTotalDuplication(duplicateIndicesMap, window),totalLOC>; 
}

/* function for counting the number of duplicated file from a file index - duplication indices map 
 * input: index - duplication indices map
 * output: number of duplicated lines
 */
int countTotalDuplication(map[int,set[int]] duplicationIndices, int window) {
	
	println(duplicationIndices);
	
	int totalDuplication = 0;
	
	for(idx <- duplicationIndices) { 									// calculate duplicates for each file
		
		duplicateIndexOld = -1;
		duplicateList = sort(toList(duplicationIndices[idx]));			// sort necessary for detecting code blocks
		
		for(i <- duplicateList){
			totalDuplication += calculateNewLines(i, duplicateIndexOld, window);
			duplicateIndexOld = i;
		}
	}
	return totalDuplication;
}

/* function calculating the number of consecutive duplicated lines from a list of indices 
 * indices should indicate duplicate code in any file
 * input: two values (previous and current index)
 * output: number of consecutive lines of code found
 */
int calculateNewLines(int currentIndex, int prevIndex, int window) {
	if((currentIndex - prevIndex >= window) || (prevIndex == -1)){
		return window;
	}
	return (currentIndex - prevIndex);
}	


/* function for filtering all whitespace and comment lines from a list of source code lines 
 * input: list of unfiltered source code lines
 * output: list of filtered source code lines
 */
list[str] removeCommentsAndEmptyLines(list[str] sourceLines) {
	
	list[str] filteredSourceLines = [];
	bool multiline = false;

	for(str line <- sourceLines){
		if (/^\/\*/ := trim(line) && /\*\/$/ !:= trim(line)) { 			// find start (/*) and no end (*/)
			multiline = true;
		} else if(/\*\/$/ := trim(line)) { 								// find end (*/) 
			multiline = false;												 
		} else if (/^($|\/\/|\/\*|\*)/ !:= trim(line) && !multiline) {	// no multiline, empty line or comment starts
			filteredSourceLines += trim(line);
		}
	}
	return filteredSourceLines;
}


/* function for identifying duplication indices within a single file   
 * input: lines of code in a list and a window size to consider
 * output: list of duplicate indices
 */
set[int] duplicatesInSingleFile(list[str] codeLines, int window) {
		
	int nLines = size(codeLines);
	int nGroups = (nLines - window) + 1;
	
	list[list[str]] lineGroups = [slice(codeLines, i, window) | i <- [0..nGroups]];
	
	int nDuplicateLines = 0;
	
	int i = 0;
	int j = 0;
	int duplicateIndexOld = -1;
	int referenceIndexOld = -1;
	
	set[int] duplicateIndices = {};
	set[int] referenceIndices = {};
	
	for(currentGroup <- lineGroups){
		j = indexOf(lineGroups, currentGroup);
		if(j != i){
			duplicateIndices += i;
			referenceIndices += j;	
		}
		i += 1;
	}
	return duplicateIndices + referenceIndices;
}