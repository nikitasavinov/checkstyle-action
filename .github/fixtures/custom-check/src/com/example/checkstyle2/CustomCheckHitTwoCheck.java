package com.example.checkstyle2;

import com.puppycrawl.tools.checkstyle.api.AbstractCheck;
import com.puppycrawl.tools.checkstyle.api.DetailAST;
import com.puppycrawl.tools.checkstyle.api.TokenTypes;

/**
 * Second custom check for multi-JAR CI: reports custom_check_hit_two on every class.
 * Rebuild with {@code javac --release 21} to match the action image.
 */
public class CustomCheckHitTwoCheck extends AbstractCheck {
  public static final String MSG_KEY = "custom_check_hit_two";

  @Override
  public int[] getDefaultTokens() {
    return new int[] {TokenTypes.CLASS_DEF};
  }

  @Override
  public int[] getAcceptableTokens() {
    return getDefaultTokens();
  }

  @Override
  public int[] getRequiredTokens() {
    return getDefaultTokens();
  }

  @Override
  public void visitToken(DetailAST ast) {
    log(ast, MSG_KEY);
  }
}
