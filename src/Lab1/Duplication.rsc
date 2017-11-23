module Lab1::Duplication

import IO;
import List;

import util::Math;

import Lab1::Metric;
import Lab1::Util;

int window = 6;

Metric duplication(list[file] files) {
	int totalLOC = sum([0] + [size(file) | file <- files]);
	int duplicates = computeDuplicates(files);
	real percentage = duplicates / toReal(totalLOC) * 100;
	println("Duplicate lines: <duplicates>");
	println("Duplication percentage: <percentage> %");
	return toMetric(percentage);
}

private int computeDuplicates(list[file] files) {
	<chunks, chunksPerFile> = createChunks(files);
	map[chunk, int] duplicateDistribution = distribution(chunks);
	list[chunk] duplicateCandidates = [chunk | chunk <- duplicateDistribution, duplicateDistribution[chunk] != 1];
	return countDuplicates(duplicateCandidates, chunksPerFile);
}

private Metric toMetric(real result) {
	int sc = 0;
	if (result <= 3) {
		sc = 2;
	} else if (result <= 5) {
		sc = 1;
	} else if (result <= 10) {
		sc = 0;
	} else if (result <= 20) {
		sc = -1;
	} else {
		sc = -2;
	}
	return metric("Duplication", score(sc));
}

private tuple[list[chunk], list[list[chunk]]] createChunks(list[file] files) {
	list[chunk] chunks = [];
	list[list[chunk]] chunksPerFile = [];
	
	for(file <- files) {
		int lines = size(file);
		
		if(lines >= window) {
			int groups = (lines - window) + 1;
			newChunks = [slice(file, i, window) | i <- [0..groups]];
			chunksPerFile += [newChunks];
			chunks += newChunks;
		} 
	}
	return <chunks, chunksPerFile>;
}

private int countDuplicates(list[chunk] duplicateCandidates, list[list[chunk]] chunksPerFile) {
	int totalDuplicates = 0;
	int i = 0;
	
	for(file <- chunksPerFile) {
		int j = 0;
		int prevIndex = -1;
		
		for(currentChunk <- file){
			if(currentChunk in duplicateCandidates) {
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

private file testFile = ["a","b","c","d","e","f","g","h","i","j"];
private file testFileShuffled5 = ["a","c","d","e","f","g","b","h","i","j"];
private file testFileShuffled6 = ["a","c","d","e","f","g","h","b","i","j"];
private file testFileShuffled7 = ["a","c","d","e","f","g","h","i","b","j"];
private list[file] testFiles = [testFile | _ <- [0..10]];

test bool testEmpty() = computeDuplicates([]) == 0;
test bool testFiles1() = computeDuplicates([testFile]) == 0;
test bool testFiles10() = computeDuplicates(testFiles) == 100;
test bool testFiles5() = computeDuplicates([testFile] + [testFileShuffled5]) == 0;
test bool testFiles6() = computeDuplicates([testFile] + [testFileShuffled6]) == 12;
test bool testFiles7() = computeDuplicates([testFile] + [testFileShuffled7]) == 14;
test bool testMetric100() = duplication(testFiles).score.score == -2;
test bool testMetric0() = duplication([testFile]).score.score == 2;
