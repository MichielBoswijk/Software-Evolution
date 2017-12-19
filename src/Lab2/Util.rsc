module Lab2::Util

import Lab2::Config;

import List;
import Node;
import IO;

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

public int getSubtreeSize(node subtree) {
	int size = 0;
	visit(subtree) {
		case node n: size += 1;
	}
	return size;
}

lrel[loc, loc] getLocations(list[tuple[node, node]] clones) {
	return [<i.src, j.src> | <i,j> <- clones];
}

list[node] subtreeToList(node subtree) {
	list[node] nodes = [];
	visit(subtree) {
		case node n : nodes += unsetRec(n);
	}
	return nodes;
}

list[node] getAllSubtrees(set[Declaration] asts) {
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

bool isSubtreeOf(node s, node subtree) {
	bool result = false;
	visit(subtree) {
		case node n: if(n == s) result = true;
	}
	return result;
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

lrel[node, node] removeCloneI(lrel[node, node] clones, node s, node j) {
	lrel[node, node] remove = [];
	for(<left, right> <- clones) {
		if(left == s && isSubtreeOf(right, j)) {
			remove += <left, right>;
		}
	}
	
	return clones - remove;
}

lrel[node, node] removeCloneJ(lrel[node, node] clones, node s, node i) {
	lrel[node, node] remove = [];
	for(<left, right> <- clones) {
		if(right == s && isSubtreeOf(left, i)) {
			remove += <left, right>;
		}
	}
	return clones - remove;
}
