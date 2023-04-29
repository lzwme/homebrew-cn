class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20230428/menhir-20230428.tar.bz2"
  sha256 "52fca6e346e468aaf3bce38359550c99665d8037dd36e113fb35d3b4d6a7b385"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f7867e3c9be6f618a5050d843ee6ef0495b0707630bac51ef780f80835ef1230"
    sha256 cellar: :any,                 arm64_monterey: "50f450cf57bbe5b177e14551c4cb2cd25220baf879cfac6d46cd82dc5420c585"
    sha256 cellar: :any,                 arm64_big_sur:  "b96985bc14cfa6690e80a58fbb594467cfe57a973800555cc4f4dbf2087c9fa5"
    sha256 cellar: :any,                 ventura:        "e1ea495ccf269b15a2c2681d07e15c53c31ca3426cb556d00cbe5a835da88350"
    sha256 cellar: :any,                 monterey:       "89b5c3cb37c70b8ec7491fb81d12db122c6fb2e6fa45213c0779269b8a349179"
    sha256 cellar: :any,                 big_sur:        "793c412efebafc9a43852839017cd6f4f46905250fab10d55ee489d4813d3e2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11364f255f6ef37a6a1d5fcb55a66b6d5c4372d23295e16a593ef4a80970190f"
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

    system "#{bin}/menhir", "--dump", "--explain", "--infer", "test.mly"
    assert_predicate testpath/"test.ml", :exist?
    assert_predicate testpath/"test.mli", :exist?
  end
end