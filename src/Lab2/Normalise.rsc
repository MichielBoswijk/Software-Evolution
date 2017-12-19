module Lab2::Normalise

import Node;
import IO;

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

public node normalise(node subtree) {
	return visit(subtree) {
		case Declaration d => normaliseDeclarations(d)
	    case Expression e => normaliseExpressions(e)
		case Statement s => normaliseStatements(s)
		case Type t => normaliseTypes(t)
		case Modifier m => normaliseModifiers(m)
	}
}

private Declaration normaliseDeclarations(Declaration subtree) {
	return visit(subtree) {
	    case \enum(str name, list[Type] implements, list[Declaration] constants, list[Declaration] body) => \enum("", implements, constants, body)
	    case \enumConstant(str name, list[Expression] arguments, Declaration class) => \enumConstant("", arguments, class)
	    case \enumConstant(str name, list[Expression] arguments) => \enumConstant("", arguments)
	    case \class(str name, list[Type] extends, list[Type] implements, list[Declaration] body) => \class("", extends, implements, body)
	    case \interface(str name, list[Type] extends, list[Type] implements, list[Declaration] body) => \interface("", extends, implements, body)
	    case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl) => \method(\return, "", parameters, exceptions, impl)
	    case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions) => \method(\return, "", parameters, exceptions)
	    case \constructor(str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl) => \constructor("", parameters, exceptions, impl)
	    case \import(str name) => \import("")
	    case \package(str name) => \package("")
	    case \package(Declaration parentPackage, str name) => \package("")
	    case \typeParameter(str name, list[Type] extendsList) => \typeParameter("", extendsList)
	    case \annotationType(str name, list[Declaration] body) => \annotationType("", body)
	    case \annotationTypeMember(Type \type, str name) => \annotationTypeMember(\type, "")
	    case \annotationTypeMember(Type \type, str name, Expression defaultBlock) => \annotationTypeMember(\type, "", defaultBlock)
	    case \parameter(Type \type, str name, int extraDimensions) => \parameter(\type, "", extraDimensions)
	    case \vararg(Type \type, str name) => \vararg(\type, "")
		case Declaration d => unsetRec(d)
	}
}

private Expression normaliseExpressions(Expression subtree) {
	return visit(subtree) {
		case \characterLiteral(str charValue) => \null()
	    case \qualifiedName(Expression qualifier, Expression expression) => \simpleName("")
	    case \fieldAccess(bool isSuper, Expression expression, str name) => \fieldAccess(false, expression, "")
	    case \fieldAccess(bool isSuper, str name) => \fieldAccess(false, "")
	    case \methodCall(bool isSuper, str name, list[Expression] arguments) => \methodCall(false, "", arguments)
	    case \methodCall(bool isSuper, Expression receiver, str name, list[Expression] arguments) => \methodCall(false, "", arguments)
	    case \number(str numberValue) => \null()
	    case \booleanLiteral(bool boolValue) => \null()
	    case \stringLiteral(str stringValue) => \null()
	    case \variable(str name, int extraDimensions) => \variable("", extraDimensions)
	    case \variable(str name, int extraDimensions, Expression \initializer) => \variable("", extraDimensions, \initializer)
	    case \this() => \simpleName("")
	    case \this(Expression thisExpression) => \simpleName("")
	    case \super() => \simpleName("")
	    case \simpleName(str name) => \simpleName("")
	    case \markerAnnotation(str typeName) => \markerAnnotation("")
	    case \normalAnnotation(str typeName, list[Expression] memberValuePairs) => \normalAnnotation("", memberValuePairs)
	    case \memberValuePair(str name, Expression \value) => \memberValuePair("", \value)
	    case \singleMemberAnnotation(str typeName, Expression \value) => \singleMemberAnnotation("", \value)
	    case Expression e => unsetRec(e)		
	}
}

private Statement normaliseStatements(Statement subtree) {
	return visit(subtree) {
	    case \break(str label) => \break("")
	    case \continue(str label) => \continue("")
	    case \label(str name, Statement body) => \label("", body)
		case Statement s => unsetRec(s)
	}
}

private Type normaliseTypes(Type subtree) {
	return visit(subtree) {
		//case arrayType(Type \type) => simpleType(\simpleName(""))
		//case parameterizedType(Type \type) => simpleType(\simpleName(""))
		case qualifiedType(Type qualifier, Expression simpleName) => simpleType(\simpleName(""))
	    case simpleType(Expression typeName) => simpleType(\simpleName(""))
	    //case unionType(list[Type] types) => simpleType(\simpleName(""))
	    case wildcard() => simpleType(\simpleName(""))
	    //case upperbound(Type \type) => simpleType(\simpleName(""))
	    //case lowerbound(Type \type) => simpleType(\simpleName(""))
	    case \int() => simpleType(\simpleName(""))
	    case short() => simpleType(\simpleName(""))
	    case long() => simpleType(\simpleName(""))
	    case float() => simpleType(\simpleName(""))
	    case double() => simpleType(\simpleName(""))
	    case char() => simpleType(\simpleName(""))
	    case string() => simpleType(\simpleName(""))
	    case byte() => simpleType(\simpleName(""))
	    case \void() => simpleType(\simpleName(""))
	    case \boolean() => simpleType(\simpleName(""))
	    case Type t => unsetRec(t)
	}
}

private Modifier normaliseModifiers(Modifier subtree) {
	return visit(subtree) {
		case \private() => \public() 
	    case \public() => \public()
	    case \protected() => \public()
	    case \friendly() => \public()
	    case \static() => \public()
	    case \final() => \public()
	    case \synchronized() => \public()
	    case \transient() => \public()
	    case \abstract() => \public()
	    case \native() => \public()
	    case \volatile() => \public()
	    case \strictfp() => \public()
	    case \annotation(Expression \anno) => \public()
	    case \onDemand() => \public()
	    case \default()  => \public()
	}
}

private node testAst0 = createAstFromFile(|project://Sample/src/WordCount0.java|, false);
private node testAst1 = createAstFromFile(|project://Sample/src/WordCount1.java|, false);
private node testAst2 = createAstFromFile(|project://Sample/src/WordCount2.java|, false);
test bool testNormalise1() = normalise(testAst0) == normalise(testAst1);
test bool testNormalise2() = normalise(testAst1) == normalise(testAst2);
test bool testNormalise3() = normalise(testAst2) == normalise(testAst0);
