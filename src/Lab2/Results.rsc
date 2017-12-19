module Lab2::Results

import List;
import Set;
import util::FileSystem;
import lang::json::IO;
import IO;
import Lab1::Util;
import util::Math;

data Result = result(loc name, int size, real duplication, int nclones, int nclasses, loc link, list[str] imports);

public void writeResults(lrel[loc, loc] clones, loc project) {
	results = toResult(clones, project);
	writeJSON(|project://Software-Evolution/src/Lab2/Clones.json|, [res | <res, _> <- results]);
	writeJSON(|project://Software-Evolution/src/Lab2/ClonesCodes.json|, [code | <_, code> <- results]);
}

private list[tuple[Result, list[str]]] toResult(lrel[loc, loc] clones, loc project) {
	list[tuple[Result, list[str]]] results = [];
	map[loc, lrel[loc, loc]] clonesByFile = groupByFile(clones, project);
	for(f <- clonesByFile) {
		lrel[loc, loc] sublist = clonesByFile[f];
		list[loc] clonesPerFile = [s | <s,_> <- sublist];
		int fileSize = getFileSize(f);
		if(size(sublist) > 0) {
			results += <result(f, fileSize, getDuplication(clonesPerFile, fileSize), size(sublist), size(sublist), f, [s.uri | <_,s> <- sublist]), [readFile(s) | s <- clonesPerFile]>;
		} 
	}
	return results;
}

private int getFileSize(loc f) {
	return size(cleanedLines(f));
}

private real getDuplication(list[loc] links, int fileSize) {
	return sum([0] + [size(cleanedLines(link)) | link <- links])/toReal(fileSize) * 100;
}

private map[loc, lrel[loc, loc]] groupByFile(lrel[loc, loc] clones, loc project) {
	map[loc, lrel[loc, loc]] clonesByFile = ();
	set[loc] allFiles = find(project, "java");
	for(f <- allFiles) {
		set[tuple[loc, loc]] sublist = {};
		for(<left, right> <- clones) {
			if(f.uri == left.uri) {
				sublist += <left, right>;
			}
			if(f.uri == right.uri) {
				sublist += <right, left>;
			}
		}
		clonesByFile += (f : toList(sublist));
	}
	return clonesByFile;
}

