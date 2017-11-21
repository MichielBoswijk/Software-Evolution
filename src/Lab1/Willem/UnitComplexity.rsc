module Lab1::Willem::UnitComplexity

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Math;
import List;
import Lab1::Willem::Util;
import IO;
import Lab1::Willem::Metric;

Metric unitComplexity(set[Declaration] units) {
	lrel[int,int] results = [<computeCC(unit), countLOC(unit.src)> | unit <- units];
	return toMetric(results);
}

private Metric toMetric(lrel[int,int] results) {
	int low = sum([0] + [s | <cc,s> <- results, cc >= 1 && cc <= 10]);
	int moderate = sum([0] + [s | <cc,s> <- results, cc >= 11 && cc <= 20]);
	int high = sum([0] + [s | <cc,s> <- results, cc >= 21 && cc <= 50]);
	int veryHigh = sum([0] + [s | <cc,s> <- results, cc > 50 ]);
	int total = sum([0] + [s | <_,s> <- results]);

	real lowPercentage = low/toReal(total) * 100;	
	real moderatePercentage = moderate/toReal(total) * 100;
	real highPercentage = high/toReal(total) * 100;
	real veryHighPercentage = veryHigh/toReal(total) * 100;
	
	println("Low unit complexity percentage <lowPercentage> %");
	println("Moderate unit complexity percentage <moderatePercentage> %");
	println("High unit complexity percentage <highPercentage> %");
	println("Very unit high complexity percentage <veryHighPercentage> %");
	println("Total unit percentage <veryHighPercentage + highPercentage + moderatePercentage + lowPercentage> %");
	
	int sc = 0;
	if (moderatePercentage <= 25.0 && highPercentage <= 0.0 && veryHighPercentage <= 0.0) {
		sc = 2;
	} else if (moderatePercentage <= 30.0 && highPercentage <= 5.0 && veryHighPercentage <= 0.0) {
		sc = 1;
	} else if (moderatePercentage <= 40.0 && highPercentage <= 10.0 && veryHighPercentage <= 0.0) {
		sc = 0;
	} else if (moderatePercentage <= 50.0 && highPercentage <= 15.0 && veryHighPercentage <= 5.0) {
		sc = -1;
	} else {
		sc = -2; 
	}
	
	return metric("Unit Complexity", score(sc));
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
