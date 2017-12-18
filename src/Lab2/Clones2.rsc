module Lab2::Clones2

import Lab2::Normalise;
import Lab2::Util;

import List;
import Map;
import Node;
import IO;
import util::Math;

list[node] getClones2(set[Declaration] asts) {
	list[node] clones = [];
	list[node] subtrees = getAllSubtrees(asts);
	map[node, list[node]] buckets = createBuckets(subtrees);
	list[node] keys = [key | key <- buckets];
	for(key <- sort(keys)) {
		list[node] bucket = buckets[key];
		if(size(bucket) > 1) {
			for(i <- bucket) {
				for(j <- bucket - i) {
					if(similarity(i, j)) {
						visit(i) {
							case node n: {
								if(getSubtreeSize(n) > MASS_THRESHOLD) {
									println("deleting node in i");
									clones -= n;
								}
							}
						}
						visit(j) {
							case node n: {
								if(getSubtreeSize(n) > MASS_THRESHOLD) {
									println("deleting node in j");
									clones -= n;
								}
							}
						}
						clones += [i,j];
						println("Found <size(clones)> clones");
					}
				};	
			};
		}
	};
	println("Found <size(clones)> clones");
	return clones;
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

private list[node] getAllSubtrees(set[Declaration] asts) {
	list[node] subtrees = [];
	visit(asts) {
		case node subtree: {
			if(getSubtreeSize(subtree) > MASS_THRESHOLD) {
				subtrees += subtree;
			}
		}
	}
	println("Created <size(subtrees)> subtrees");
	return subtrees;
}

private int getSubtreeSize(node subtree) {
	int size = 0;
	visit(subtree) {
		case node n: size += 1;
	}
	return size;
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


private list[node] subtreeToList(node subtree) {
	list[node] nodes = [];
	visit(subtree) {
		case node n : nodes += unsetRec(n);
	}
	return nodes;
}
