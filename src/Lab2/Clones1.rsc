module Lab2::Clones1

import Lab2::Normalise;
import Lab2::Util;

import List;
import Map;
import Node;
import IO;
import util::Math;

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

list[node] getClones1(list[node] subtrees) {
	map[node, list[node]] candidates = ();
	for(node subtree <- subtrees) {
		node normalised = normalise(subtree);
		if(normalised in candidates) {
			list[node] sublist = candidates[normalised];
			candidates += (normalised : sublist + subtree);
		} else {
			candidates += (normalised : [subtree]);
		}
	}
	
	println("Candidates size: <size(candidates)>");
	
	list[node] clones = [];
	for(node key <- candidates) {
		list[node] bucket = candidates[key];
		if(size(bucket) > 1) {
			int counter = 1;
			for(i <- bucket) {
				for(j <- bucket - i) {
					if(true) {
						visit(i) {
							case node n: {
								if(getSubtreeSize(n) > MASS_THRESHOLD) clones -= n;
							}
						}
						visit(j) {
							case node n: {
								if(getSubtreeSize(n) > MASS_THRESHOLD) clones -= n;
							}
						}
						clones += [i,j];
					}
				};
			};
			counter+=1;
		}
	}
	
	println("Clones size: <size(clones)>");	
	return clones;
}

list[node] getSubtrees1(set[Declaration] ast) {
	list[node] subtrees = [];
	visit(ast) {
		case node n: {
			if(getSubtreeSize(n) > MASS_THRESHOLD) {
				subtrees += n;
			}
		}
	}
	println("Created <size(subtrees)> subtrees");
	return subtrees;
}
