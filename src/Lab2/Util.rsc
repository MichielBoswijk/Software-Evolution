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

public lrel[loc, loc] getLocations(list[tuple[node, node]] clones) {
	return [<i.src, j.src> | <i,j> <- clones];
}

public list[node] subtreeToList(node subtree) {
	list[node] nodes = [];
	visit(subtree) {
		case node n : nodes += unsetRec(n);
	}
	return nodes;
}

public list[node] getAllSubtrees(set[Declaration] asts) {
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

public bool isSubtreeOf(node s, node subtree) {
	bool result = false;
	visit(subtree) {
		case node n: if(n == s) result = true;
	}
	return result;
}

public list[node] getSubtreesFromNode(node n) {
	list[node] subtrees = [];
	visit(n) {
		case node subtree: {
			if(getSubtreeSize(subtree) > MASS_THRESHOLD) subtrees += subtree;
		}
	}
	return subtrees - n;
}

public lrel[node, node] removeCloneI(lrel[node, node] clones, node s, node j) {
	lrel[node, node] remove = [];
	for(<left, right> <- clones) {
		if(left == s && isSubtreeOf(right, j)) {
			remove += <left, right>;
		}
	}
	
	return clones - remove;
}

public lrel[node, node] removeCloneJ(lrel[node, node] clones, node s, node i) {
	lrel[node, node] remove = [];
	for(<left, right> <- clones) {
		if(right == s && isSubtreeOf(left, i)) {
			remove += <left, right>;
		}
	}
	return clones - remove;
}

private Declaration testAst0 = createAstFromFile(|project://Sample/src/WordCount0.java|, false);
private Declaration testAst1 = createAstFromFile(|project://Sample/src/WordCount1.java|, false);
private Declaration testAst2 = createAstFromFile(|project://Sample/src/WordCount2.java|, false);
private loc testLoc1 = |project://Sample/src/File1.java|(151,6,<8,1>,<8,7>);
private loc testLoc2 = |project://Sample/src/File2.java|(151,6,<8,1>,<8,7>);
private loc testLoc3 = |project://Sample/src/File3.java|(151,6,<8,1>,<8,7>);
private loc testLoc4 = |project://Sample/src/File4.java|(151,6,<8,1>,<8,7>);
private node testNode1 = simpleType(simpleName("String",src=|project://Sample/src/File1.java|(151,6,<8,1>,<8,7>),typ=unresolved()));
private node testNode2 = simpleType(simpleName("Int",src=|project://Sample/src/File4.java|(151,6,<8,1>,<8,7>),typ=unresolved()));
private node testNode3 = simpleName("Int",src=|project://Sample/src/File3.java|(151,6,<8,1>,<8,7>),typ=unresolved());
private node testNode4 = simpleName("Int",src=|project://Sample/src/File4.java|(151,6,<8,1>,<8,7>),typ=unresolved());

test bool testGetSize1() = getSubtreeSize(testAst0) == 99;
test bool testGetSize2() = getSubtreeSize(testNode1) == 3;
test bool testGetSize3() = getSubtreeSize(testNode4) == 2;
test bool testGetLocations1() = getLocations([]) == [];
test bool testGetLocations2() = getLocations([<testNode4, testNode4>]) == [<testLoc4, testLoc4>];
test bool testGetLocations3() = getLocations([<testNode3, testNode4>]) == [<testLoc3, testLoc4>];
test bool testSubtreeToList1() = size(subtreeToList(testNode4)) == 2;
test bool testSubtreeToList2() = size(subtreeToList(testNode1)) == 3;
test bool testGetAllSubtrees1() = size(getAllSubtrees({testAst0})) == 5;
test bool testGetAllSubtrees2() = size(getAllSubtrees({testAst0, testAst1, testAst2})) == 15;
test bool testGetAllSubtrees3() = size(getAllSubtrees({})) == 0;
test bool testIsSubtreeOf1() = isSubtreeOf(testNode4, testNode2);
test bool testIsSubtreeOf2() = isSubtreeOf(testNode4, testNode4);
test bool testIsSubtreeOf3() = !isSubtreeOf(testNode3, testNode4);
test bool testGetSubtreesFromNode1() = size(getSubtreesFromNode(testNode1)) == 0;
test bool testGetSubtreesFromNode2() = size(getSubtreesFromNode(testAst0)) == 4;
