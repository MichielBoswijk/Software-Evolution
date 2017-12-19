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
	writeJSON(|project://Software-Evolution/src/Lab2/Clones.json|, toResult(clones, project));
}

private list[Result] toResult(lrel[loc, loc] clones, loc project) {
	list[Result] results = [];
	map[loc, set[loc]] clonesByFile = groupByFile(clones, project);
	for(f <- clonesByFile) {
		list[loc] sublist = toList(clonesByFile[f]);
		int fileSize = getFileSize(f);
		results += result(f, fileSize, getDuplication(sublist, fileSize), size(sublist), size(sublist), f, [s.uri | s <- sublist]); 
	}
	return results;
}

private int getFileSize(loc f) {
	return size(cleanedLines(f));
}

private real getDuplication(list[loc] links, int fileSize) {
	return sum([0] + [size(cleanedLines(link)) | link <- links])/toReal(fileSize) * 100;
}

private map[loc, set[loc]] groupByFile(lrel[loc, loc] clones, loc project) {
	map[loc, set[loc]] clonesByFile = ();
	set[loc] allFiles = find(project, "java");
	for(f <- allFiles) {
		set[loc] sublist = {};
		for(<left, right> <- clones) {
			if(f.uri == left.uri) {
				sublist += right;
			}
			if(f.uri == right.uri) {
				sublist += left;
			}
		}
		clonesByFile += (f : sublist);
	}
	return clonesByFile;
}

