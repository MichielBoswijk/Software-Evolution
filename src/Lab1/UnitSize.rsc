module Lab1::UnitSize

import IO;
import List;
import Set;

import util::Math;

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import Lab1::Metric;
import Lab1::RiskProfile;
import Lab1::Util;

Metric unitSize(set[Declaration] units) {
	list[int] sizes = [countLOC(unit.src) | unit <- units]; 	
	return toMetric(sizes);
}

private Metric toMetric(list[int] results) {
	RiskProfile profile = computeRiskProfile(results);
	printRiskProfile(profile, "unit size");
	
	int sc = 0;
	if (profile.moderate <= 19.5 && profile.high <= 10.9 && profile.veryHigh <= 3.9) {
		sc = 2;
	} else if (profile.moderate <= 26.0 && profile.high <= 15.5 && profile.veryHigh <= 6.5) {
		sc = 1;
	} else if (profile.moderate <= 34.1 && profile.high <= 22.2 && profile.veryHigh <= 11.0) {
		sc = 0;
	} else if (profile.moderate <= 45.9 && profile.high <= 31.4 && profile.veryHigh <= 18.1) {
		sc = -1;
	} else {
		sc = -2; 
	}
	
	return metric("Unit Size", score(sc));
}

private RiskProfile computeRiskProfile(list[int] results) {
	int low = sum([0] + [result | result <- results, result <= 30]);
	int moderate = sum([0] + [result | result <- results, result > 30, result <= 44]);
	int high = sum([0] + [result | result <- results, result > 44, result <= 74]);
	int veryHigh = sum([0] + [result | result <- results, result > 74]);
	int total = sum([0] + results);
	
	real lowPercentage = low/toReal(total) * 100;	
	real moderatePercentage = moderate/toReal(total) * 100;
	real highPercentage = high/toReal(total) * 100;
	real veryHighPercentage = veryHigh/toReal(total) * 100;
	
	return profile(lowPercentage, moderatePercentage, highPercentage, veryHighPercentage);	
}
