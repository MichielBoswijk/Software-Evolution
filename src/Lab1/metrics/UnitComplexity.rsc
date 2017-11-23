module Lab1::metrics::UnitComplexity

import IO;
import List;

import util::Math;

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import Lab1::Metric;
import Lab1::RiskProfile;
import Lab1::Util;

Metric unitComplexity(set[Declaration] units) {
	lrel[int,int] results = [<computeCC(unit), size(cleanedLines(unit.src))> | unit <- units];
	return toMetric(results);
}

private Metric toMetric(lrel[int,int] results) {
	RiskProfile profile = computeRiskProfile(results);	
	printRiskProfile(profile, "unit complexity");
	
	int sc = 0;
	if (profile.moderate <= 25.0 && profile.high <= 0.0 && profile.veryHigh <= 0.0) {
		sc = 2;
	} else if (profile.moderate <= 30.0 && profile.high <= 5.0 && profile.veryHigh <= 0.0) {
		sc = 1;
	} else if (profile.moderate <= 40.0 && profile.high <= 10.0 && profile.veryHigh <= 0.0) {
		sc = 0;
	} else if (profile.moderate <= 50.0 && profile.high <= 15.0 && profile.veryHigh <= 5.0) {
		sc = -1;
	} else {
		sc = -2; 
	}
	
	return metric("Unit Complexity", score(sc));
}

private RiskProfile computeRiskProfile(lrel[int, int] results) {
	int low = sum([0] + [s | <cc,s> <- results, cc >= 1 && cc <= 10]);
	int moderate = sum([0] + [s | <cc,s> <- results, cc >= 11 && cc <= 20]);
	int high = sum([0] + [s | <cc,s> <- results, cc >= 21 && cc <= 50]);
	int veryHigh = sum([0] + [s | <cc,s> <- results, cc > 50 ]);
	int total = sum([0] + [s | <_,s> <- results]);

	real lowPercentage = low/toReal(total) * 100;	
	real moderatePercentage = moderate/toReal(total) * 100;
	real highPercentage = high/toReal(total) * 100;
	real veryHighPercentage = veryHigh/toReal(total) * 100;
	
	return profile(lowPercentage, moderatePercentage, highPercentage, veryHighPercentage);
}

private int computeCC(Declaration unit) {
	int cc = 1;
	visit(unit) {
		case \do(_,_): cc += 1;
		case \foreach(_,_,_): cc += 1;
 		case \for(_,_,_,_): cc += 1;	
 		case \for(_,_,_): cc += 1;
 		case \if(_,_): cc += 1;
 		case \if(_,_,_): cc += 1;
 		case \case(_): cc += 1;
 		case \catch(_,_): cc += 1;
 		case \while(_,_): cc += 1;
 		case \conditional(_,_,_): cc += 1;
		case \infix(_,"&&",_): cc += 1;
		case \infix(_,"||",_): cc += 1;
	};
	return cc;
}
