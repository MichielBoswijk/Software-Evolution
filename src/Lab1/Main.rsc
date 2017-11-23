module Lab1::Main

import IO;

import util::Benchmark;
import util::Math;

import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import Lab1::Maintainability;
import Lab1::Metric;
import Lab1::Util;

import Lab1::metrics::Duplication;
import Lab1::metrics::UnitComplexity;
import Lab1::metrics::UnitSize;
import Lab1::metrics::UnitTesting;
import Lab1::metrics::Volume;

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
	println(formatMetric(maintainability(props)));
}