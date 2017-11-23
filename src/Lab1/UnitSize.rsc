module Lab1::UnitSize

import IO;
import List;
import Set;

import util::Math;

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import Lab1::Metric;
import Lab1::Util;

Metric unitSize(set[Declaration] units) {
	list[int] sizes = [countLOC(unit.src) | unit <- units]; 	
	return toMetric(sizes);
}

/**
	See https://www.sig.eu/files/en/080_Benchmark-based_Aggregation_of_Metrics_to_Ratings.pdf Table III (a)
*/
private Metric toMetric(list[int] results) {
	int low = sum([0] + [result | result <- results, result <= 30]);
	int moderate = sum([0] + [result | result <- results, result > 30, result <= 44]);
	int high = sum([0] + [result | result <- results, result > 44, result <= 74]);
	int veryHigh = sum([0] + [result | result <- results, result > 74]);
	int total = sum([0] + results);	
	
	real lowPercentage = low/toReal(total) * 100;	
	real moderatePercentage = moderate/toReal(total) * 100;
	real highPercentage = high/toReal(total) * 100;
	real veryHighPercentage = veryHigh/toReal(total) * 100;
	
	println("Low unit size percentage: <lowPercentage> %");
	println("Moderate unit size percentage: <moderatePercentage> %");
	println("High unit size percentage: <highPercentage> %");
	println("Very high unit size percentage: <veryHighPercentage> %");
	println("Total unit size percentage: <veryHighPercentage + highPercentage + moderatePercentage + lowPercentage> %");
	
	int sc = 0;
	if (moderatePercentage <= 19.5 && highPercentage <= 10.9 && veryHighPercentage <= 3.9) {
		sc = 2;
	} else if (moderatePercentage <= 26.0 && highPercentage <= 15.5 && veryHighPercentage <= 6.5) {
		sc = 1;
	} else if (moderatePercentage <= 34.1 && highPercentage <= 22.2 && veryHighPercentage <= 11.0) {
		sc = 0;
	} else if (moderatePercentage <= 45.9 && highPercentage <= 31.4 && veryHighPercentage <= 18.1) {
		sc = -1;
	} else {
		sc = -2; 
	}
	
	return metric("Unit Size", score(sc));
}
