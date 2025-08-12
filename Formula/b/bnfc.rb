class Bnfc < Formula
  desc "BNF Converter"
  homepage "https://github.com/BNFC/bnfc"
  url "https://ghfast.top/https://github.com/BNFC/bnfc/archive/refs/tags/v2.9.6.tar.gz"
  sha256 "aec9b5042e40fb5af044ae64ffb5bba252f004245013922b0029c0855966a9ed"
  license "BSD-3-Clause"
  head "https://github.com/BNFC/bnfc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "66fe298726e102d01681d06c210f5771124f165ee068da66c02116de3ba32040"
    sha256 cellar: :any,                 arm64_sonoma:  "84f03cdd01d8c7f8b276c841de059eec9259c6deb17c67750d098e0b45005b2e"
    sha256 cellar: :any,                 arm64_ventura: "9405ad1f4531497bf297c791d4d728e953f0a744d68de750d960adc071498859"
    sha256 cellar: :any,                 sonoma:        "ced40491932fce15b06e3905ef92ce886816c5efb4e297a4a5d67e51ab1cb62d"
    sha256 cellar: :any,                 ventura:       "6654d3c5b903fa26de9a4dc21d2401a55c08ff98d059cefca1ea677abc036f30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b95c8e9e0e12c13d5118fb3af768f80e260c916e36b15528f13664302fb6f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8588d96533acd834bf8d7affafe7a7d52945385c4e2a12bd3b3dc5767839f61"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "sphinx-doc" => :build
  depends_on "agda" => :test
  depends_on "antlr" => :test
  depends_on "bison" => :test
  depends_on "flex" => :test
  depends_on "openjdk" => :test
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", buildpath/"source", *std_cabal_v2_args
    system "make", "-C", "docs", "text", "man", "SPHINXBUILD=#{Formula["sphinx-doc"].bin}/sphinx-build"

    man1.install "docs/_build/man/bnfc.1"
    doc.install "docs/_build/text" => "manual"
    doc.install "README.md", "examples", "source/CHANGELOG.md", "source/src/BNFC.cf"
  end

  test do
    ENV.prepend_create_path "PATH", testpath/"tools-bin"
    system "cabal", "v2-update"
    system "cabal", "v2-install", "alex", "happy", *std_cabal_v2_args.map { |s| s.sub bin, testpath/"tools-bin" }

    (testpath/"calc.cf").write <<~EOS
      EAdd. Exp  ::= Exp  "+" Exp1 ;
      ESub. Exp  ::= Exp  "-" Exp1 ;
      EMul. Exp1 ::= Exp1 "*" Exp2 ;
      EDiv. Exp1 ::= Exp1 "/" Exp2 ;
      EInt. Exp2 ::= Integer ;
      coercions Exp 2 ;
      entrypoints Exp ;
      comment "(#" "#)" ;
    EOS
    system bin/"bnfc", "--check", testpath/"calc.cf"

    (testpath/"test.calc").write "14 * (# Parsing is fun! #) (3 + 2 / 5 - 8)"
    space = " "
    check_out_c = <<~EOS

      Parse Successful!

      [Abstract Syntax]
      (EMul (EInt 14) (ESub (EAdd (EInt 3) (EDiv (EInt 2) (EInt 5))) (EInt 8)))

      [Linearized Tree]
      14 * (3 + 2 / 5 - 8)#{space}

    EOS
    check_out_hs = <<~EOS
      #{testpath/"test.calc"}

      Parse Successful!

      [Abstract Syntax]

      EMul (Just (1,1)) (EInt (Just (1,1)) 14) (ESub (Just (1,29)) (EAdd (Just (1,29)) (EInt (Just (1,29)) 3) (EDiv (Just (1,33)) (EInt (Just (1,33)) 2) (EInt (Just (1,37)) 5))) (EInt (Just (1,41)) 8))

      [Linearized tree]

      14 * (3 + 2 / 5 - 8)
    EOS
    check_out_agda = <<~EOS
      PARSE SUCCESSFUL

      14 * (3 + 2 / 5 - 8)
    EOS
    check_out_java = <<~EOS

      Parse Successful!

      [Abstract Syntax]

      (EMul (EInt 14) (ESub (EAdd (EInt 3) (EDiv (EInt 2) (EInt 5))) (EInt 8)))#{space}

      [Linearized Tree]

      14 * (3 + 2 / 5 - 8)
    EOS

    flex_bison_args = ["FLEX=#{Formula["flex"].bin}/flex", "BISON=#{Formula["bison"].bin}/bison"]

    mkdir "c-test" do
      system bin/"bnfc", "-m", "-o.", "--c", testpath/"calc.cf"
      system "make", "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}", *flex_bison_args
      assert_equal check_out_c, shell_output("./Testcalc #{testpath}/test.calc")
    end

    mkdir "cxx-test" do
      system bin/"bnfc", "-m", "-o.", "--cpp", testpath/"calc.cf"
      system "make", "CC=#{ENV.cxx}", "CCFLAGS=#{ENV.cxxflags}", *flex_bison_args
      assert_equal check_out_c, shell_output("./Testcalc #{testpath}/test.calc")
    end

    mkdir "agda-test" do
      system bin/"bnfc", "-m", "-o.", "--haskell", "--text-token",
             "--generic", "--functor", "--agda", "-d", testpath/"calc.cf"
      system "make"
      assert_equal check_out_hs, shell_output("./Calc/Test #{testpath}/test.calc") # Haskell
      assert_equal check_out_agda, shell_output("./Main #{testpath}/test.calc") # Agda
    end

    ENV.deparallelize do # only the Java test needs this
      mkdir "java-test" do
        jdk_dir = Formula["openjdk"].bin
        antlr_bin = Formula["antlr"].bin/"antlr"
        antlr_jar = Formula["antlr"].prefix.glob("antlr-*-complete.jar").first
        ENV["CLASSPATH"] = ".:#{antlr_jar}"
        system bin/"bnfc", "-m", "-o.", "--java", "--antlr4", testpath/"calc.cf"
        system "make", "JAVAC=#{jdk_dir}/javac", "JAVA=#{jdk_dir}/java",
               "LEXER=#{antlr_bin}", "PARSER=#{antlr_bin}"
        assert_equal check_out_java, shell_output("#{jdk_dir}/java calc.Test #{testpath}/test.calc")
      end
    end
  end
end