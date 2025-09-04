class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20250903/menhir-20250903.tar.bz2"
  sha256 "17240a67cc724911312a09a1af6b35974450279a71f18c71ef4eacae5f315358"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1d7d2a92006bd116b33eba485235f3d4b120c56b54780734609a6932df2362ff"
    sha256 cellar: :any,                 arm64_sonoma:  "73db65eda2bf6a6daf1203d702aa63b96bdf66c96fc0e0c66b1da1f1237a45da"
    sha256 cellar: :any,                 arm64_ventura: "c89bb55894224a694a69a601d1bed304bbe4ac4a08eb8918ff1d2ecf7b3405e6"
    sha256 cellar: :any,                 sonoma:        "14810d2c725e18865fd50b291d7c5fe87275ef6f81064b1a243ea18788a41a1d"
    sha256 cellar: :any,                 ventura:       "b59480b3cc6ae7760906589344290b687e4477c2b41a2b9803f5d1e8b29aae7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b6b8a0e8d6a387d1b74a10808941c2efd82667da6b40e0917e93559d72f6bd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17a9cedc5c1a3057b77aff7fe719c75a67ef48197142c554c776d8438191b133"
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