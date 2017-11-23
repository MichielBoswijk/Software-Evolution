module Lab1::Duplication

import IO;
import List;
import Map;

import util::Benchmark;
import util::Math;

import Lab1::Metric;
import Lab1::Util;

Metric duplication(list[file] files) {
	int window = 6;
	int totalLOC = sum([0] + [size(file) | file <- files]);
	
	<chunks, chunksPerFile> = createChunks(files, window);
	map[chunk, int] duplicateDistribution = distribution(chunks);
	list[chunk] duplicateCandidates = [chunk | chunk <- duplicateDistribution, duplicateDistribution[chunk] != 1];
	
	int duplicates = countDuplicates(duplicateCandidates, chunksPerFile, window);
	real percentage = duplicates / toReal(totalLOC) * 100;
	println("Duplicate lines: <duplicates>");
	println("Duplication percentage: <percentage> %");
	return toMetric(percentage);
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

private tuple[list[chunk], list[list[chunk]]] createChunks(list[file] files, int window) {
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

private int countDuplicates(list[chunk] duplicateCandidates, list[list[chunk]] chunksPerFile, int window) {
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
