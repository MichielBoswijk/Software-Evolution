module Lab2::Clones2

import Lab2::Config;
import Lab2::Normalise;
import Lab2::Util;

import List;
import Map;
import Node;
import IO;
import util::Math;

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

public lrel[loc, loc] getClones2(set[Declaration] asts) {
	lrel[node, node] clones = [];
	list[node] subtrees = getAllSubtrees(asts);
	map[node, list[node]] buckets = createBuckets(subtrees);
	list[node] keys = [key | key <- buckets];
	list[node] sortedKeys = sort(keys, bool(node a, node b){ return getSubtreeSize(a) < getSubtreeSize(b); });
	for(key <- sortedKeys) {
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
						println("Found <size(clones)> clones");
					}
				};	
			};
		}
	};
	println("Found <size(clones)> clones");
	lrel[loc, loc] locations = getLocations(clones);
	return locations;
}

private map[node, list[node]] createBuckets(list[node] subtrees) {
	map[node, list[node]] buckets = ();
	for(subtree <- subtrees) {
		node bucket = normalise(subtree);
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

bool similarity(node i, node j) {
	list[node] nodesL = subtreeToList(i);
	list[node] nodesR = subtreeToList(j);
	int S = size(nodesL & nodesR);
	int L = size(nodesL) - S;
	int R = size(nodesR) - S;
	
	real Similarity = 2*S/toReal(2*S+L+R);
	println("Values: S <S>, L <L>, R <R>, Similarity <Similarity>");
	return Similarity > 1 - SIMILARITY_THRESHOLD && Similarity < 1 + SIMILARITY_THRESHOLD;
}
