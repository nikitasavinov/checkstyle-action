package com.example.checkstyle;

import com.puppycrawl.tools.checkstyle.api.AbstractCheck;
import com.puppycrawl.tools.checkstyle.api.DetailAST;
import com.puppycrawl.tools.checkstyle.api.TokenTypes;

/**
 * Minimal custom check for CI: reports custom_check_hit on every class.
 * Rebuild the jar with {@code javac --release 21} to match the action image.
 */
public class CustomCheckHitCheck extends AbstractCheck {
  public static final String MSG_KEY = "custom_check_hit";

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
