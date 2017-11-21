module Lab1::Willem::Main


import util::ValueUI;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import List;
import Set;
import IO;
import util::Math;

import Lab1::Willem::UnitSize;
import Lab1::Willem::UnitComplexity;
import Lab1::Willem::Volume;
import Lab1::Willem::Util;
import Lab1::Willem::Metric;
import Lab1::Willem::Maintainability;

void main(loc project) {
	set[Declaration] ast = createAstsFromEclipseProject(project, true);
	M3 model = createM3FromEclipseProject(project);
	set[Declaration] units = getUnits(ast);
	
	Metric volumeMetric = volume(model);
	Metric unitComplexityMetric = unitComplexity(units);
	Metric duplicationMetric = metric("Duplication", score(0));
	Metric unitSizeMetric = unitSize(units);
	Metric unitTestingMetric = metric("Unit Testing", score(0));
	
	println(formatMetric(volumeMetric));
	println(formatMetric(unitComplexityMetric));
	println(formatMetric(duplicationMetric));
	println(formatMetric(unitSizeMetric));
	println(formatMetric(unitTestingMetric));
	
	Properties properties = properties(volumeMetric, unitComplexityMetric, duplicationMetric, unitSizeMetric, unitTestingMetric);
	maintainability(properties);
}