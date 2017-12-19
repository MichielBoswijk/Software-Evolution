module Lab2::Results

import List;
import Set;
import util::FileSystem;
import lang::json::IO;
import IO;
import Lab1::Util;
import util::Math;

data Result = result(loc name, int size, real duplication, int nclones, int nclasses, loc link, list[str] imports);
data Clone = clone(list[str] code);

public void writeResults(lrel[loc, loc] clones, loc project) {
	println("Number of clones: <size(clones)*2>");
	println("Number of clone classes: <size(clones)>");
	
	results = toResult(clones, project);
	writeJSON(|project://Software-Evolution/src/Lab2/Clones.json|, [res | <res, _> <- results]);
	writeJSON(|project://Software-Evolution/src/Lab2/ClonesCodes.json|, [code | <_, code> <- results]);
}

private list[tuple[Result, Clone]] toResult(lrel[loc, loc] clones, loc project) {
	int volume = 0;
	int duplication = 0;
	list[str] biggest = [];
	list[tuple[Result, Clone]] results = [];
	map[loc, lrel[loc, loc]] clonesByFile = groupByFile(clones, project);
	for(f <- clonesByFile) {
		lrel[loc, loc] sublist = clonesByFile[f];
		list[loc] clonesPerFile = [s | <s,_> <- sublist];
		int fileSize = getFileSize(f);
		volume += size(cleanedLines(f));
		cloneSourceCode = [cleanedLines(c) | c <- clonesPerFile];
		for(a <- cloneSourceCode) {
			if(size(a) > size(biggest)) {
				biggest = a;
			}
		}
		duplication += sum([0] + [size(c) | c <- cloneSourceCode]); 
		results += <result(f, fileSize, getDuplication(clonesPerFile, fileSize), size(sublist), size(sublist), f, [s.uri | <_,s> <- sublist]), clone([readFile(s) | s <- clonesPerFile])>;
 
	}
	println("Volume <volume>");
	println("Duplication <duplication>");
	println("Duplication percentage <duplication/toReal(volume) * 100> %");
	println("Biggest clone:");
	for(big <- biggest) {
		println(big);
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

