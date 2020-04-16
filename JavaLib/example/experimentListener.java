// Generated from experiment.g4 by ANTLR 4.8
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link experimentParser}.
 */
public interface experimentListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link experimentParser#start}.
	 * @param ctx the parse tree
	 */
	void enterStart(experimentParser.StartContext ctx);
	/**
	 * Exit a parse tree produced by {@link experimentParser#start}.
	 * @param ctx the parse tree
	 */
	void exitStart(experimentParser.StartContext ctx);
	/**
	 * Enter a parse tree produced by {@link experimentParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExpr(experimentParser.ExprContext ctx);
	/**
	 * Exit a parse tree produced by {@link experimentParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExpr(experimentParser.ExprContext ctx);
}