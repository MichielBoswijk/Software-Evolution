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

map[int,list[node]] getSubtrees(set[Declaration] ast) {
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

lrel[loc, loc] getClones(map[int,list[node]] subtrees) {
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
							clones = removeCloneI(clones, s, i, j);
						}
						for(s <- getSubtreesFromNode(j)) {
							clones = removeCloneJ(clones, s, i, j);
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

private bool equalSubtrees(node i, node j) {
	return unsetRec(i) == unsetRec(j);
}

lrel[loc, loc] getLocations(list[tuple[node, node]] clones) {
	return [<i.src, j.src> | <i,j> <- clones];
}

list[node] getSubtreesFromNode(node n) {
	list[node] subtrees = [];
	visit(n) {
		case node subtree: {
			if(getSubtreeSize(subtree) > MASS_THRESHOLD) subtrees += subtree;
		}
	}
	return subtrees - n;
}

lrel[node, node] removeCloneI(lrel[node, node] clones, node s, node ni, node nj) {
	lrel[node, node] result = [];
	println("S <s.src>, I <ni.src>, J <nj.src>");
	for(<i,j> <- clones) {
		if(i == s && isSubtreeOf(j, nj)) {
			result += <i,j>;
		}
	}
	for(<i,j> <- clones-result) {
		println("RemovedI <i.src>, <j.src>");
	}
	return clones-result;
}

lrel[node, node] removeCloneJ(lrel[node, node] clones, node s, node ni, node nj) {
	lrel[node, node] result = [];
	println("S <s.src>, I <ni.src>, J <nj.src>");
	for(<i,j> <- clones) {
		if(j == s && isSubtreeOf(i, ni)) {
			result += <i,j>;
		}
	}
	for(<i,j> <- clones-result) {
		println("RemovedJ <i.src>, <j.src>");
	}
	return clones-result;
}

bool isSubtreeOf(node s, node subtree) {
	bool result = false;
	visit(subtree) {
		case node n: if(n == s) result = true;
	}
	return result;
}