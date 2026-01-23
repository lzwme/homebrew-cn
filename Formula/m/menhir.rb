class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20260122/menhir-20260122.tar.bz2"
  sha256 "b48f54226f1517916d0921e6081806d4ae1d072ef92d3cb1f261d95977e2cd0f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c6ef5a791843f78e5c5c10cbfc1dc854576c24f3b22ac6ec7e0af9b69778c293"
    sha256 cellar: :any,                 arm64_sequoia: "c7326dafd84a611613543309304cec4f68edb20c738792f937c81fc07b008ca8"
    sha256 cellar: :any,                 arm64_sonoma:  "d792f197f6136a7922d276424ef4121a4822aa06badddcca9973ad6a9b114b0f"
    sha256 cellar: :any,                 sonoma:        "d3e1ed8e091b1b39615d195aad094d7bf8e6160af34552251d13d8a3bca5c493"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f968299ee2023489efd3bc4000634538472661f1da210981d75fe3c8812ea55e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc43534f0c0032dfd44d3aed01855397f6fdba9a17dbd5c0b2cb3d5d2d593f11"
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