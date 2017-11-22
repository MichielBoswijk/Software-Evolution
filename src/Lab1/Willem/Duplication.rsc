module Lab1::Willem::Duplication

import IO;
import List;
import Map;

import util::Math;

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import Lab1::Willem::Metric;
import Lab1::Willem::Util;

Metric duplication(list[list[str]] files) {
	int total = sum([0] + [size(file) | file <- files]);
	int duplicates = countDuplicates(files, filesToChunks(files));
	real percentage = duplicates/toReal(total) * 100;
	println("Duplicated lines: <duplicates>");
	println("Total lines: <total>");
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

private list[list[str]] filesToChunks(list[list[str]] files) {
	list[list[str]] chunks = [];
	for (list[str] file <- files) {
		if(size(file) >= 6) {
			chunks += [file[i..i+6] | i <- [0..size(file)-5]];
		}
	};
	return chunks;
}

private int countDuplicates(list[list[str]] files, list[list[str]] chunks) {
	map[list[str], int] countMap = (chunk : 0 | chunk <- chunks);
	int count = 0;
	for (list[str] file <- files) {
		int lines = size(file);
		int match = -1;
		 
		if(lines < 6) { 
			continue;
		}
		
		for (index <- [0..lines-5]) {
			list[str] slice = file[index..index+6];
			countMap[slice] += 1;
			if(countMap[slice] > 1) {
                int overlap = 0;
                if(match > -1) {
                        overlap = max(0, 6 - (index - match));
                }
                count += 6 - overlap;
                println("Index: <index>, overlap: <overlap>, match: <match>");
                match = index;
        		}
		};
	};
	return count;
}
