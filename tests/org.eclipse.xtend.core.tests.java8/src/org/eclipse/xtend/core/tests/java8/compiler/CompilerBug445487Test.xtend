/*******************************************************************************
 * Copyright (c) 2014 itemis AG (http://www.itemis.eu) and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package org.eclipse.xtend.core.tests.java8.compiler

import org.eclipse.xtend.core.tests.compiler.AbstractXtendCompilerTest
import org.eclipse.xtend.core.tests.java8.Java8RuntimeInjectorProvider
import org.eclipse.xtext.junit4.InjectWith
import org.junit.Test

/**
 * @author Sebastian Zarnekow - Initial contribution and API
 * @author Miro Spoenemann - Copied and adapted to Java 8 output
 */
@InjectWith(Java8RuntimeInjectorProvider)
class CompilerBug445487Test extends AbstractXtendCompilerTest {
	
	@Test def test_01() {
		'''
			import com.google.inject.Provider
			import org.antlr.runtime.Lexer
			import org.eclipse.xtend.core.parser.antlr.internal.InternalXtendLexer
			class C {
				Provider<Lexer> lexerProvider= [return new InternalXtendLexer(null)]
			}
		'''.assertCompilesTo('''
			import com.google.inject.Provider;
			import org.antlr.runtime.Lexer;
			import org.eclipse.xtend.core.parser.antlr.internal.InternalXtendLexer;
			
			@SuppressWarnings("all")
			public class C {
			  private Provider<Lexer> lexerProvider = ((Provider<Lexer>) () -> {
			    return new InternalXtendLexer(null);
			  });
			}
		''')
	}
	
	@Test def test_02() {
		'''
			import com.google.inject.Provider
			import org.antlr.runtime.Lexer
			import org.eclipse.xtend.core.parser.antlr.internal.InternalXtendLexer
			class C {
				Provider<? super Lexer> lexerProvider= [return new InternalXtendLexer(null)]
			}
		'''.assertCompilesTo('''
			import com.google.inject.Provider;
			import org.antlr.runtime.Lexer;
			import org.eclipse.xtend.core.parser.antlr.internal.InternalXtendLexer;
			
			@SuppressWarnings("all")
			public class C {
			  private Provider<? super Lexer> lexerProvider = ((Provider<Lexer>) () -> {
			    return new InternalXtendLexer(null);
			  });
			}
		''')
	}
	
	@Test def test_03() {
		'''
			import com.google.inject.Provider
			import org.antlr.runtime.Lexer
			import org.eclipse.xtend.core.parser.antlr.internal.InternalXtendLexer
			class C {
				Provider<? extends Lexer> lexerProvider= [return new InternalXtendLexer(null)]
			}
		'''.assertCompilesTo('''
			import com.google.inject.Provider;
			import org.antlr.runtime.Lexer;
			import org.eclipse.xtend.core.parser.antlr.internal.InternalXtendLexer;
			
			@SuppressWarnings("all")
			public class C {
			  private Provider<? extends Lexer> lexerProvider = ((Provider<Lexer>) () -> {
			    return new InternalXtendLexer(null);
			  });
			}
		''')
	}
	
	@Test def test_04() {
		'''
			import com.google.inject.Provider
			import org.antlr.runtime.Lexer
			import org.eclipse.xtend.core.parser.antlr.internal.InternalXtendLexer
			class C {
				Provider<Lexer> lexerProvider= [|return new InternalXtendLexer(null)] as Provider<Lexer> 
			}
		'''.assertCompilesTo('''
			import com.google.inject.Provider;
			import org.antlr.runtime.Lexer;
			import org.eclipse.xtend.core.parser.antlr.internal.InternalXtendLexer;
			import org.eclipse.xtext.xbase.lib.Functions.Function0;
			
			@SuppressWarnings("all")
			public class C {
			  private Provider<Lexer> lexerProvider = ((Provider<Lexer>) new Provider<Lexer>() {
			      public Lexer get() {
			        return ((Function0<InternalXtendLexer>) () -> {
			          return new InternalXtendLexer(null);
			        }).apply();
			      }
			  });
			}
		''')
	}
	
	@Test def test_05() {
		'''
			import com.google.inject.Provider
			import org.antlr.runtime.Lexer
			import org.eclipse.xtend.core.parser.antlr.internal.InternalXtendLexer
			class C {
				Provider<Lexer> lexerProvider= [|return new InternalXtendLexer(null)] as ()=>Lexer
			}
		'''.assertCompilesTo('''
			import com.google.inject.Provider;
			import org.antlr.runtime.Lexer;
			import org.eclipse.xtend.core.parser.antlr.internal.InternalXtendLexer;
			import org.eclipse.xtext.xbase.lib.Functions.Function0;
			
			@SuppressWarnings("all")
			public class C {
			  private Provider<Lexer> lexerProvider = new Provider<Lexer>() {
			      public Lexer get() {
			        return ((Function0<? extends Lexer>) ((Function0<InternalXtendLexer>) () -> {
			          return new InternalXtendLexer(null);
			        })).apply();
			      }
			  };
			}
		''')
	}
	
}