module Lab1::Michiel::Experimentation

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import IO;
import List;
import Set;
import String;

import Lab1::Michiel::helperMethods;

void main() {

loc filePath = |project://SIGModelProject/src/Lab1/Michiel/Puppy.java|;
list[str] sourceLines = readFileLines(filePath);
for(x <- sourceLines) {
	println(x);
	}
}
