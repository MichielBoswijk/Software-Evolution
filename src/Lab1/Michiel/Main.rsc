module Lab1::Michiel::Main

import IO;

import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import Lab1::Michiel::Duplication;
import Lab1::Michiel::Maintainability;
import Lab1::Michiel::Metric;
import Lab1::Michiel::UnitComplexity;
import Lab1::Michiel::UnitSize;
import Lab1::Michiel::UnitTesting;
import Lab1::Michiel::Util;
import Lab1::Michiel::Volume;

void main(loc project) {
	set[Declaration] ast = createAstsFromEclipseProject(project, true);
	M3 model = createM3FromEclipseProject(project);
	set[Declaration] units = getUnits(ast);
	
	Metric volumeMetric = volume(model);
	Metric unitComplexityMetric = unitComplexity(units);
	Metric duplicationMetric = duplication();
	Metric unitSizeMetric = unitSize(units);
	Metric unitTestingMetric = unitTesting();
	
	println(formatMetric(volumeMetric));
	println(formatMetric(unitComplexityMetric));
	println(formatMetric(duplicationMetric));
	println(formatMetric(unitSizeMetric));
	println(formatMetric(unitTestingMetric));
	
	Properties props = properties(volumeMetric, unitComplexityMetric, duplicationMetric, unitSizeMetric, unitTestingMetric);
	maintainability(props);
}