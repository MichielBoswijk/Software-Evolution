module Lab1::Willem::Maintainability

import Lab1::Willem::Metric;
import IO;
import List;

data Properties = properties(Metric volume, Metric unitComplexity, Metric duplication, Metric unitSize, Metric unitTesting);

void maintainability(Properties properties) {
	println(formatMetric(getAnalysability(properties)));
	println(formatMetric(getChangability(properties)));
	println(formatMetric(getStability(properties)));
	println(formatMetric(getTestability(properties)));
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

private int average(list[int] results) {
	return sum(results)/size(results);
}
