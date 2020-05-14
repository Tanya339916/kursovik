grammar rules;


//�������� ������� ==============================================================
STRING_LITERAL: '"' ([a-zA-Z0-9 \t\\] | '+' | '-' | '*' | '/' | ':' | '!')* '"';

LEFT_CURLY_BRACE: '{';
RIGHT_CURLY_BRACE: '}';

LEFT_BRACKET: '[';
RIGHT_BRACKET: ']';

LEFT_PARENTHESES: '(';
RIGHT_PARENTHESES: ')';

SEMICOLON: ';';
COMMA: ',';
DOT: '.';


ASSIGN_SYMBOL: '=';

LOGIC_OR: '||';
LOGIC_AND: '&&';
LOGIC_NOT: '!';

add: '+';
sub: '-';
MUL: '*';
DIV: '/';
XOR: '^';
AND: '&';
OR: '|';
NOT: '~';

LESS_THAN: '<';
LESS_OR_EQUAL_THAN: '<=';
GREATER_THAN: '>';
GREATER_OR_EQUAL_THAN: '>=';
EQUAL_SYMBOL: '==';
NOT_EQUAL_SYMBOL: '!=';


BOOL_LITERAL: 'true' | 'false';

arrayInitialization:
    '{' (rValue ',')* rValue '}' # simpleArrayInitialization
//    | '{' (arrayInitialization ',')* arrayInitialization '}' # compoundArrayInitialization
    | 'new' IDENTIFIER LEFT_BRACKET int_literal RIGHT_BRACKET # newArray
    ;



//�������� ����� ==============================================================
NAMESPACE_SYMBOL: 'namespace';
FUNCTION_DEFINITION_SYMBOL: 'def';
CLASS_DEFINITION_SYMNOL: 'struct';

IF_SYMBOL: 'if';
WHILE_SYMBOL: 'while';
ELSE_SYMBOL: 'else';
ELSE_IF_SYMBOL: 'elif';
RETURN_SYMBOL: 'return';
CONTINUE_SYMBOL: 'continue';
FOR_SYMBOL: 'for';
BREAK_SYMBOL: 'break';

//���� ������ INT_SYMBOL: 'int'; DOUBLE_SYMBOL: 'double'; CHAR_SYMBOL: 'char'; STRING_SYMBOL:
// 'string'; BOOL_SYMBOL: 'bool';

//����������� ==============================================================
IDENTIFIER: [a-zA-Z_$][a-zA-Z_$0-9]*;

//����� ==============================================================
WHITE_SPACE: [ \t\r\n]+ -> skip;

LINE_COMMENT: '//' ~[\r\n]* -> skip;

COMMENT: '/*' .*? '*/' -> skip;

literal: int_literal
    | double_literal
    | CHAR_LITERAL
    | STRING_LITERAL
    | BOOL_LITERAL
    ;


rValue:
	expression
	| arrayInitialization
	| functionCall
	| structReference
	| arrayIndex
	;


lValue:
	IDENTIFIER
	//    | lValue DOT IDENTIFIER
	| arrayIndex
	| structReference
    ;

arrayIndex:
    (/*structReference |*/ IDENTIFIER | functionCall) LEFT_BRACKET expression RIGHT_BRACKET
    ;

//������������ namespace
namespaceDefinition:
	NAMESPACE_SYMBOL IDENTIFIER LEFT_CURLY_BRACE codeContent+ RIGHT_CURLY_BRACE;

//����� ������� ��������� ==============================================================
program:
	namespaceDefinition
	;


codeContent:
	variableDefinition SEMICOLON
	| functionDefinitionBlock
	| structDefinition
    ; 

//�������������� ��� ���������� ��������� ==============================================================
expression:
    term # termLabel
	| expression add term # infixExpression
	| expression sub term # infixExpression
	| expression OR expression # infixExpression
	| expression AND expression # infixExpression
	| expression LESS_THAN expression # infixExpression
    | expression GREATER_THAN expression # infixExpression
    | expression LESS_OR_EQUAL_THAN expression # infixExpression
    | expression GREATER_OR_EQUAL_THAN expression # infixExpression
    | expression EQUAL_SYMBOL expression # infixExpression
    | expression NOT_EQUAL_SYMBOL expression # infixExpression
	| expression LOGIC_OR expression # infixExpression
	| expression LOGIC_AND expression # infixExpression
    ;

term:
    factor # factorLabel
    | term MUL factor # infixTerms
    | term DIV factor # infixTerms
    | term XOR factor # infixTerms
    ;


factor:
	IDENTIFIER # identifier
    | literal # literalLabel
	| functionCall # functionCallLabel
	| structReference # structReferenceLabel
	| LEFT_PARENTHESES expression RIGHT_PARENTHESES # expressionInParentheses
    | LOGIC_NOT factor # unaryExpression
    | NOT factor # unaryExpression
    | sub factor # unaryExpression
    ;

// ==============================================================
assignment: lValue ASSIGN_SYMBOL rValue;

//������� ��������� ==============================================================
block:
	forBlock
	| whileBlock
	| logicBlock
//	| pureBlock
//	| structDefinition
	;

pureBlock: LEFT_CURLY_BRACE blockBodyCode RIGHT_CURLY_BRACE;

statementWithoutSemicolon: //TODO
	returnStatement # returnInStatement
	| breakStatement # breakStatementLabel
	| continueStatement # continueStatementLabel
	| assignment # assignmentInStatement
	| variableDefinition # variableDefinitionInStatement
	| rValue # rValueInStatement
	;

breakStatement:
    BREAK_SYMBOL
    ;

continueStatement:
    CONTINUE_SYMBOL
    ;

statementList: blockOrStatement*;

blockOrStatement:
    block
    | statementNode
    ;

statementNode: statementWithoutSemicolon SEMICOLON;

blockBodyCode: statementList;

returnStatement: RETURN_SYMBOL rValue | RETURN_SYMBOL;

//����������� ������� ==============================================================
functionDefinitionBlock:
	FUNCTION_DEFINITION_SYMBOL IDENTIFIER IDENTIFIER functionParameterDefinition functionBody;

functionParameterDefinition:
	LEFT_PARENTHESES parameterList RIGHT_PARENTHESES;

parameterList:
	((variableDeclaration ',')* variableDeclaration)?;

functionBody: LEFT_CURLY_BRACE blockBodyCode RIGHT_CURLY_BRACE;

////���������� ���� ==============================================================
logicBlock: ifBlock elseIfBlock* elseBlock?;

ifBlock: IF_SYMBOL '(' rValue ')' '{' blockBodyCode '}';

elseIfBlock:
	ELSE_IF_SYMBOL '(' rValue ')' '{' blockBodyCode '}';

elseBlock: ELSE_SYMBOL '{' blockBodyCode '}';

//����������� ���� ==============================================================
forBlock: FOR_SYMBOL '(' initOrStepCondition SEMICOLON terminateCondition SEMICOLON initOrStepCondition ')' '{' blockBodyCode '}';

initOrStepCondition:
	| ((statementWithoutSemicolon ',')* statementWithoutSemicolon)?
	;

terminateCondition:
	rValue?
	;

whileBlock: WHILE_SYMBOL '(' rValue ')' '{' blockBodyCode '}';

//����������� ���������� ==============================================================
// semicolon
variableDefinition:
	ordinaryVariableDefinition
	| arrayDefinition
	| variableDeclaration
	;

ordinaryVariableDefinition:
	ordinaryVariableDeclaration ASSIGN_SYMBOL rValue;

variableDeclaration:
	ordinaryVariableDeclaration
	| arrayDeclaration
    ;

ordinaryVariableDeclaration:
    IDENTIFIER IDENTIFIER
    ;

arrayDeclaration:
	IDENTIFIER LEFT_BRACKET RIGHT_BRACKET IDENTIFIER;

arrayDefinition:
    arrayDeclaration ASSIGN_SYMBOL rValue;


//����� ������� ==============================================================
functionCall: IDENTIFIER '(' ((rValue ',')* rValue)? ')';

// ==============================================================
structFieldStatementList: (variableDefinition ';')*;

structDefinition:
	CLASS_DEFINITION_SYMNOL IDENTIFIER '{' structFieldStatementList '}';

structReference:
    structReference '.' IDENTIFIER
    | (IDENTIFIER | functionCall | arrayIndex) '.' IDENTIFIER
    ;


int_literal: ('+' | '-')? DIGIT+;
double_literal: ('+' | '-')? DIGIT* '.'? DIGIT+;

CHAR_LITERAL: '\'' [a-zA-Z\\] '\'';

DIGIT: [0-9];