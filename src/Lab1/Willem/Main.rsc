module Lab1::Willem::Main

import IO;

import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import Lab1::Willem::Duplication;
import Lab1::Willem::Maintainability;
import Lab1::Willem::Metric;
import Lab1::Willem::UnitComplexity;
import Lab1::Willem::UnitSize;
import Lab1::Willem::UnitTesting;
import Lab1::Willem::Util;
import Lab1::Willem::Volume;

void main(loc project) {
	set[Declaration] ast = createAstsFromEclipseProject(project, true);
	M3 model = createM3FromEclipseProject(project);
	set[Declaration] units = getUnits(ast);
	list[file] files = getCleanFiles(model);
	
	Metric volumeMetric = volume(files);
	Metric unitComplexityMetric = unitComplexity(units);
	Metric duplicationMetric = duplication(files);
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