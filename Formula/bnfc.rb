class Bnfc < Formula
  desc "BNF Converter"
  homepage "https://bnfc.digitalgrammars.com/"
  url "https://ghproxy.com/https://github.com/BNFC/bnfc/archive/v2.9.4.1.tar.gz"
  sha256 "4f70f7d73302d8580c5fd12d3b40df471a8a1be92e31a4d0a8f3c330b124ce71"
  license "BSD-3-Clause"
  head "https://github.com/BNFC/bnfc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02dd838e55e80032735ad079b0b698dfc2cfc27847589cd4475fed982a5aa325"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35d33f766e0069b6809a0af8787378974278824f54a11b8d898971ffa6589c2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afe8ac12cb9fd69615fe2a1c03b645293d864e5aa7d7492c69338d856530da43"
    sha256 cellar: :any_skip_relocation, ventura:        "e7243b584f8966d37edf6e9f4bea688d0008079227162e4f86834d814e468228"
    sha256 cellar: :any_skip_relocation, monterey:       "f5f6ea64908a9e737216437245f8214db0d3002b9b0fe004ae4851d39ec1cfb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "778d506a5b438d32aebf65a8746480a8da4573e377a65e18005544f639ccf2ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "114e007a3c2506f434edb5cdc5df9f8ef6702f84403593a038af6931fd932d95"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "sphinx-doc" => :build
  depends_on "agda" => :test
  depends_on "antlr" => :test
  depends_on "bison" => :test
  depends_on "flex" => :test
  depends_on "openjdk" => :test

  # Fixes typos in upstream's code. Remove once merged and released.
  # PR ref: https://github.com/BNFC/bnfc/pull/448
  patch do
    url "https://github.com/BNFC/bnfc/commit/5940164bdffe59924e253318c346865c94b46453.patch?full_index=1"
    sha256 "5c828e85a704d02450c11adbf13dd6855a8bfc4ad25f8ec288203528bd0abc73"
  end

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

    mktemp "java-test" do
      ENV.deparallelize # only the Java test needs this
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