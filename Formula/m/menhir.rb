class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20260203/menhir-20260203.tar.bz2"
  sha256 "6d795a21085c4fed4a165a9ceee4b1f359aae7ffe5002c31c5f665699e649ce1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ec1c5060493d1649286ef47da0ed3cee35b4f0cd2dc92b78d9866b0e2287e7a"
    sha256 cellar: :any,                 arm64_sequoia: "c449bcec9b59ce780a0a714c74272ebe4b05ac7641ad252852484b524db6e7fa"
    sha256 cellar: :any,                 arm64_sonoma:  "c0f8f397647d39c7faaf1eb10fbe5407b8646c766cfa22fb29729cb26b5ff0d1"
    sha256 cellar: :any,                 sonoma:        "10023f8a099fa1fca270e4f33115f6b8bdc38fe3dbed6e4cdebe9bb4b8debf4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d509211deb212cdc7cc907e1c0b7aef902022c24d0fcd4ab1bbb2e13b778e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ee2ca5943144c093a602f6688950249ec304674d673c792cde766fff713539c"
  end

  depends_on "dune" => :build
  depends_on "ocamlbuild" => :build
  depends_on "ocaml"

  def install
    system "dune", "build", "@install"
    system "dune", "install", "--prefix=#{prefix}", "--mandir=#{man}"
  end

  test do
    (testpath/"test.mly").write <<~EOS
      %token PLUS TIMES EOF
      %left PLUS
      %left TIMES
      %token<int> INT
      %start<int> prog
      %%

      prog: x=exp EOF { x }

      exp: x = INT { x }
      |    lhs = exp; op = op; rhs = exp  { op lhs rhs }

      %inline op: PLUS { fun x y -> x + y }
                | TIMES { fun x y -> x * y }
    EOS

    system bin/"menhir", "--dump", "--explain", "--infer", "test.mly"
    assert_path_exists testpath/"test.ml"
    assert_path_exists testpath/"test.mli"
  end
end