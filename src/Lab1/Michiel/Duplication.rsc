module Lab1::Michiel::Duplication

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

import Lab1::Michiel::Metric;

alias chunk = list[str];
alias file = list[str];

Metric duplication(M3 model) {

	window = 6;
	
	uniquePaths = {file | <file,_> <- declaredTopTypes(model)};
	allLinesOfCode = [removeCommentsAndEmptyLines(readFileLines(filePath)) | filePath <- uniquePaths];
	<allLineGroups, allLineGroupsPerFile, totalLOC> = createWindowSizedChunks(allLinesOfCode, window);
	
	//println("Total Files : <size(allLineGroupsPerFile)>");
	//println("Total groups of size <window> : <size(allLineGroups)>");
	
	duplicateDistribution = distribution(allLineGroups);
	duplicateCandidates = [idx | idx <- duplicateDistribution, duplicateDistribution[idx] != 1];
	
	duplicates = countDuplicates(duplicateCandidates, allLineGroupsPerFile, window);
	
	println("<duplicates> : <totalLOC> : <duplicates / toReal(totalLOC)> ");
		
			
		
	real percentage = duplicates / toReal(totalLOC);
	println("Duplication percentage: <percentage> %");
	return toMetric(percentage);
}

tuple[list[chunk], list[list[chunk]], int] createWindowSizedChunks(list[file] allLinesOfCode, int window) {
	
	totalLOC = 0;
	allLineGroupsPerFile = [];
	allLineGroups = [];
	
	for(file <- allLinesOfCode) {
		nLines = size(file);
		totalLOC += nLines;
		
		if(nLines >= window) {
			nGroups = (nLines - window) + 1;
			fileLineGroups = [slice(file, i, window) | i <- [0..nGroups]];
			allLineGroupsPerFile += [fileLineGroups];
			allLineGroups += fileLineGroups;
		} 
	}
	return <allLineGroups, allLineGroupsPerFile, totalLOC>;
}

int countDuplicates(list[chunk] duplicateCandidates, list[list[chunk]] allLineGroupsPerFile, int window) {

	totalDuplicates = 0;
	i = 0;
	
	for(file <- allLineGroupsPerFile) {
		j = 0;
		prevIndex = -1;
		for(currentGroup <- file){
			if(currentGroup in duplicateCandidates) {
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
	return totalDuplicates;
}



private Metric toMetric(real result) {
	int sc = 0;
	if (result <= 3) {
		sc = 2;
	} else if (result <= 5) {
		sc = 1;
	} else if (result <= 10) {
		sc = 0;
	} else if (result >= 20) {
		sc = -1;
	} else {
		sc = -2;
	}
	return metric("Duplication", score(sc));
}

/* method for filtering all whitespace and comment lines from a list of source code lines 
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
