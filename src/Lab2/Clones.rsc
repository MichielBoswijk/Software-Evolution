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
	map[int,list[node]] subtrees = getSubtrees(asts);
	lrel[node, node] clones = [];
	list[int] keys = [key | key <- subtrees];
	for(int key <- sort(keys)) {
		list[node] bucket = subtrees[key];
		int bucketSize = size(bucket);
		if(bucketSize > 1) {
			for(countI <- [0..bucketSize]) {
				for(countJ <- [countI+1..bucketSize]) {
					node i = bucket[countI];
					node j = bucket[countJ];
					if(equalSubtrees(i, j)) {
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

private map[int,list[node]] getSubtrees(set[Declaration] ast) {
	map[int,list[node]] subtrees = ();
	visit(ast) {
		case node subtree: {
			int size = getSubtreeSize(subtree);
			if(size > MASS_THRESHOLD) {
				if(size in subtrees) {
					list[node] sublist = subtrees[size];	
					sublist += subtree;
					subtrees += (size : sublist);
				} else {
					subtrees += (size : [subtree]);
				}
			}
		}
	}
	println("Created subtrees <size(subtrees)>");
	return subtrees;
}

private bool equalSubtrees(node i, node j) {
	return unsetRec(i) == unsetRec(j);
}

private lrel[loc, loc] getLocations(list[tuple[node, node]] clones) {
	return [<i.src, j.src> | <i,j> <- clones];
}

private list[node] getSubtreesFromNode(node n) {
	list[node] subtrees = [];
	visit(n) {
		case node subtree: {
			if(getSubtreeSize(subtree) > MASS_THRESHOLD) subtrees += subtree;
		}
	}
	return subtrees - n;
}

private lrel[node, node] removeCloneI(lrel[node, node] clones, node s, node j) {
	lrel[node, node] remove = [];
	for(<left, right> <- clones) {
		if(left == s && right.src <= j.src) {
			remove += <left, right>;
		}
	}
	
	return clones - remove;
}

private lrel[node, node] removeCloneJ(lrel[node, node] clones, node s, node i) {
	lrel[node, node] remove = [];
	for(<left, right> <- clones) {
		if(right == s && isSubtreeOf(left, i)) {
			remove += <left, right>;
		}
	}
	return clones - remove;
}

private bool isSubtreeOf(node s, node subtree) {
	visit(subtree) {
		case node n: if(n == s) return true;
	}
	return false;
}
