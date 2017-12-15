module Lab2::Clones

import Lab2::Normalise;

import List;
import Map;
import Node;
import IO;

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

int MASS_THRESHOLD = 50;
real SIMILARITY_THRESHOLD = 0.05;

map[int,list[node]] getSubtrees(set[Declaration] ast) {
	map[int,list[node]] subtrees = ();
	visit(ast) {
		case node subtree: {
			int size = getSize(subtree);
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
								if(getSize(n) > MASS_THRESHOLD) candidates -= n;
							}
						}
						visit(j) {
							case node n: {
								if(getSize(n) > MASS_THRESHOLD) candidates -= n;
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
								if(getSize(n) > MASS_THRESHOLD) clones -= n;
							}
						}
						visit(j) {
							case node n: {
								if(getSize(n) > MASS_THRESHOLD) clones -= n;
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
			if(getSize(n) > MASS_THRESHOLD) {
				subtrees += n;
			}
		}
	}
	println("Created <size(subtrees)> subtrees");
	return subtrees;
}

private bool equalSubtrees(node i, node j) {
	return unsetRec(i) == unsetRec(j);
}

bool similarity(node i, node j) {
	int S = 0;
	int L = 0;
	int R = 0;
	list[node] subtreesI = allSubtrees(i);
	list[node] subtreesJ = allSubtrees(j);
	for(node n <- subtreesI) {
		if(n in subtreesJ) {
			S += 1;
		} else {
			L += 1;
		}
	};
	for(node n <- subtreesJ) {
		if(n in subtreesI) {
			S += 1;
		} else {
			R += 1;
		}
	};
	int Similarity = S/(S+L+R);
	println("Values: 2S <S>, L <L>, R <R>");
	return Similarity > 1 - SIMILARITY_THRESHOLD && Similarity < 1 + SIMILARITY_THRESHOLD;
}

private list[node] allSubtrees(node subtree) {
	list[node] subtrees = [];
	visit(unsetRec(subtree)) {
		case node n: {
			if(getSize(n) > 0) {
				subtrees += n;
			}
		}
	}
	return subtrees;
}

private int getSize(node subtree) {
	int size = 0;
	visit(subtree) {
		case node n: size += 1;
	}
	return size;
}


