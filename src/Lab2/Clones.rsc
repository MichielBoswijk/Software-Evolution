module Lab2::Clones

import Lab2::Normalise;
import Lab2::Util;

import List;
import Map;
import Node;
import IO;
import util::Math;

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

public lrel[loc, loc] getClones(set[Declaration] asts) {
	list[node] subtrees = getAllSubtrees(asts);
	map[int,list[node]] buckets = createBuckets(subtrees);
	lrel[node, node] clones = [];
	list[int] keys = [key | key <- buckets];
	for(int key <- sort(keys)) {
		list[node] bucket = buckets[key];
		int bucketSize = size(bucket);
		if(bucketSize > 1) {
			for(countI <- [0..bucketSize]) {
				for(countJ <- [countI+1..bucketSize]) {
					node i = bucket[countI];
					node j = bucket[countJ];
					if(similarity(i, j)) {
						for(s <- getSubtreesFromNode(i)) {
							clones = removeCloneI(clones, s, j);
						}
						for(s <- getSubtreesFromNode(j)) {
							clones = removeCloneJ(clones, s, i);
						}
						clones += <i, j>;
					}
				};
			};
			println("Added clones for size <key> with <size(bucket)> subtrees!! Candidates size <size(clones)>");
		}
	};
	locations = getLocations(clones);
	for(location <- locations) {
		println(location);
	}
	return locations;
}

private map[int, list[node]] createBuckets(list[node] subtrees) {
	map[int, list[node]] buckets = ();
	for(subtree <- subtrees) {
		int bucket = getSubtreeSize(subtree);
		if(bucket in buckets) {
			list[node] sublist = buckets[bucket] + subtree;
			buckets += (bucket : sublist);
		} else {
			buckets += (bucket : [subtree]);
		}
	};
	println("Created <size(buckets)> buckets");
	return buckets;
}

private bool similarity(node i, node j) {
	return unsetRec(i) == unsetRec(j);
}