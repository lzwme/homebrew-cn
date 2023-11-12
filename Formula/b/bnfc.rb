class Bnfc < Formula
  desc "BNF Converter"
  homepage "https://bnfc.digitalgrammars.com/"
  url "https://ghproxy.com/https://github.com/BNFC/bnfc/archive/refs/tags/v2.9.5.tar.gz"
  sha256 "32a6293b95e10cf1192f348ec79f3c125b52a56350caa4f67087feb3642eef77"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/BNFC/bnfc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d6495160b391c2f2df39f2bea851f7af0a55eae3c61d50a42915236a13e7ffa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98764cf7fb287c267adbb0bf39b49c74396375ea93635f509b02d27954e2451c"
    sha256 cellar: :any_skip_relocation, ventura:        "2b3c7ed91b5489b2242ce90f13fcb4579d360dd62f50d306ab13a3b5e370eede"
    sha256 cellar: :any_skip_relocation, monterey:       "72fab056fe4ccaf675e0c1cc7e975cd674ddf0ac035eac1689c55c96e7e80d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "767ae7164902739f188191a4626ea1e66fa83e6df32920f3352c79f6f9907aea"
  end

  depends_on "cabal-install" => [:build, :test]
  # ghc 9.8 support issue, https://github.com/BNFC/bnfc/issues/469
  depends_on "ghc@9.6" => [:build, :test]
  depends_on "sphinx-doc" => :build
  depends_on "agda" => :test
  depends_on "antlr" => :test
  depends_on "bison" => :test
  depends_on "flex" => :test
  depends_on "openjdk" => :test

  def install
    cd "source" do
      system "cabal", "v2-update"
      system "cabal", "v2-install", *std_cabal_v2_args
      doc.install "CHANGELOG.md"
      doc.install "src/BNFC.cf" => "BNFC.cf"
    end
    cd "docs" do
      system "make", "text", "man", "SPHINXBUILD=#{Formula["sphinx-doc"].bin/"sphinx-build"}"
      cd "_build" do
        doc.install "text" => "manual"
        man1.install "man/bnfc.1" => "bnfc.1"
      end
    end
    doc.install %w[README.md examples]
  end

  test do
    ENV.prepend_create_path "PATH", testpath/"tools-bin"
    system "cabal", "v2-update"
    system "cabal", "v2-install",
           "--jobs=#{ENV.make_jobs}", "--max-backjumps=100000",
           "--install-method=copy", "--installdir=#{testpath/"tools-bin"}",
           "alex", "happy"

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

    mktemp "c-test" do
      system bin/"bnfc", "-m", "-o.", "--c", testpath/"calc.cf"
      system "make", "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}",
             "FLEX=#{Formula["flex"].bin/"flex"}",
             "BISON=#{Formula["bison"].bin/"bison"}"
      test_out = shell_output("./Testcalc #{testpath}/test.calc")
      assert_equal check_out_c, test_out
    end

    mktemp "cxx-test" do
      system bin/"bnfc", "-m", "-o.", "--cpp", testpath/"calc.cf"
      system "make", "CC=#{ENV.cxx}", "CCFLAGS=#{ENV.cxxflags}",
             "FLEX=#{Formula["flex"].bin/"flex"}",
             "BISON=#{Formula["bison"].bin/"bison"}"
      test_out = shell_output("./Testcalc #{testpath}/test.calc")
      assert_equal check_out_c, test_out
    end

    mktemp "agda-test" do
      system bin/"bnfc", "-m", "-o.", "--haskell", "--text-token",
             "--generic", "--functor", "--agda", "-d", testpath/"calc.cf"
      system "make"
      test_out = shell_output("./Calc/Test #{testpath/"test.calc"}") # Haskell
      assert_equal check_out_hs, test_out
      test_out = shell_output("./Main #{testpath/"test.calc"}") # Agda
      assert_equal check_out_agda, test_out
    end

    ENV.deparallelize do # only the Java test needs this
      mktemp "java-test" do
        jdk_dir = Formula["openjdk"].bin
        antlr_bin = Formula["antlr"].bin/"antlr"
        antlr_jar = Dir[Formula["antlr"].prefix/"antlr-*-complete.jar"][0]
        ENV["CLASSPATH"] = ".:#{antlr_jar}"
        system bin/"bnfc", "-m", "-o.", "--java", "--antlr4", testpath/"calc.cf"
        system "make", "JAVAC=#{jdk_dir/"javac"}", "JAVA=#{jdk_dir/"java"}",
               "LEXER=#{antlr_bin}", "PARSER=#{antlr_bin}"
        test_out = shell_output("#{jdk_dir}/java calc.Test #{testpath}/test.calc")
        assert_equal check_out_java, test_out
      end
    end
  end
end