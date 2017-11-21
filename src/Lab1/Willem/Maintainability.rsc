module Lab1::Willem::Maintainability

import IO;
import List;

import Lab1::Willem::Metric;

data Properties = properties(Metric volume, Metric unitComplexity, Metric duplication, Metric unitSize, Metric unitTesting);

void maintainability(Properties properties) {
	Metric analysabilityMetric = getAnalysability(properties);
	Metric changabilityMetric = getChangability(properties);
	Metric stabilityMetric = getStability(properties);
	Metric testabilityMetric = getTestability(properties);
	
	println(formatMetric(analysabilityMetric));
	println(formatMetric(changabilityMetric));
	println(formatMetric(stabilityMetric));
	println(formatMetric(testabilityMetric));
	println(formatMetric(getMaintainability(analysabilityMetric, changabilityMetric, stabilityMetric, testabilityMetric)));
}

private Metric getAnalysability(Properties properties) {
	list[int] results = [properties.volume.score.score, 
						properties.duplication.score.score, 
						properties.unitSize.score.score, 
						properties.unitTesting.score.score];
	return metric("Analysability", score(average(results)));
}

private Metric getChangability(Properties properties) {
	list[int] results = [properties.unitComplexity.score.score,
						properties.duplication.score.score];
	return metric("Changability", score(average(results)));
}

private Metric getStability(Properties properties) {
	list[int] results = [properties.unitTesting.score.score];
	return metric("Stability", score(average(results)));
}

private Metric getTestability(Properties properties) {
	list[int] results = [properties.unitComplexity.score.score,
						properties.unitSize.score.score, 
						properties.unitTesting.score.score];
	return metric("Testability", score(average(results)));
}

private Metric getMaintainability(Metric analysability, Metric changability, Metric stability, Metric testability) {
	list[int] results = [analysability.score.score,
						changability.score.score, 
						stability.score.score,
						testability.score.score];
	return metric("Maintainability", score(average(results)));
}

private int average(list[int] results) {
	return sum(results)/size(results);
}
