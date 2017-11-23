module Lab1::UnitTesting

import IO;

import Lab1::Metric;

Metric unitTesting() {
	real percentage = 70.0;
	println("***** NOT IMPLEMENTED YET *****");
	println("Unit testing percentage: <percentage> %");
	return toMetric(percentage);
}

private Metric toMetric(real result) {
	int sc = 0;
	if (result >= 95) {
		sc = 2;
	} else if (result >= 80) {
		sc = 1;
	} else if (result >= 60) {
		sc = 0;
	} else if (result >= 20) {
		sc = -1;
	} else {
		sc = -2;
	}
	return metric("Unit Testing", score(sc));
}