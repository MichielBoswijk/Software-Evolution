module Lab2::Util

public int MASS_THRESHOLD = 50;
public real SIMILARITY_THRESHOLD = 0.05;

public int getSubtreeSize(node subtree) {
	int size = 0;
	visit(subtree) {
		case node n: size += 1;
	}
	return size;
}
