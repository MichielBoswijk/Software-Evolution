module Lab1::Willem::Duplication

import IO;

import Lab1::Willem::Metric;

Metric duplication() {
	real percentage = 7.0;
	println("Duplication percentage: <percentage> %");
	return toMetric(percentage);
}

private Metric toMetric(real result) {
	int sc = 0;
	if (result <= 3) {
		sc = 2;
	} else if (result <= 5) {
		sc = 1;
	} else if (result <= 10) {
		sc = 0;
	} else if (result >= 20) {
		sc = -1;
	} else {
		sc = -2;
	}
	return metric("Duplication", score(sc));
}