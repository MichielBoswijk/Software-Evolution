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

list[node] getClones(map[int,list[node]] subtrees) {
	list[node] candidates = [];
	list[int] keys = [key | key <- subtrees];
	for(int key <- sort(keys)) {
		list[node] bucket = subtrees[key];
		if(size(bucket) > 1) {
			int counter = 1;
			for(i <- bucket) {
				for(j <- bucket - i) {
					if(equalSubtrees(i,j)) {
						visit(i) {
							case node n: {
								if(getSubtreeSize(n) > MASS_THRESHOLD) candidates -= n;
							}
						}
						visit(j) {
							case node n: {
								if(getSubtreeSize(n) > MASS_THRESHOLD) candidates -= n;
							}
						}
						candidates += [i,j];
					}
				};
			};
			counter+=1;
			println("Added candidates for size <key> with <size(bucket)> subtrees!! Candidates size <size(candidates)>");
		}
	};
	return candidates;
}

private bool equalSubtrees(node i, node j) {
	return unsetRec(i) == unsetRec(j);
}
