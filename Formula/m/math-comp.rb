class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://ghfast.top/https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-2.4.0.tar.gz"
  sha256 "6307218d7e434fb6ffc81b9275c673d3f7f1f4884ad59b904abd205c437021a0"
  license "CECILL-B"
  revision 1
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c34531e7a03718fea78babb4b7a5e7105f20a4be70784a33e63d2e669694bfce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4db7e4334104d2f7290906f7be4beb51a9489b909a5ff316679a385ebb153e1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a9a0478324dc36bfa04e45ea70c9cc91a9ca6d2eb6d9577366991e372dfcc40"
    sha256 cellar: :any_skip_relocation, sonoma:        "066ad58d86a9f4982d68cef34225b46719a7bd3bd3c622ac36d8acf918294ed2"
    sha256 cellar: :any_skip_relocation, ventura:       "7a048a18d9f7e1bb9e8d519b7162c5564f59a4703fe4f5c35b8a3fda82949fb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "421fafa065e8136d76350a94a7da6baf3988c35d9ba471d3e14da0808c85251a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "409f55a55d780521e2da0458f0c61b7586960c012c35d173c2d2e8a5b6d3d3a6"
  end

  depends_on "ocaml" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "hierarchy-builder"
  depends_on "rocq"
  depends_on "rocq-elpi"

  def install
    ENV["OCAMLFIND_CONF"] = Formula["rocq-elpi"].libexec/"lib/findlib.conf"
    (buildpath/"Makefile.coq.local").append_lines "COQLIB=#{lib}/ocaml/coq\n"

    system "make"
    system "make", "install"
    elisp.install "ssreflect/pg-ssr.el"
  end

  test do
    (testpath/"testing.v").write <<~ROCQ
      From mathcomp Require Import ssreflect seq.

      Parameter T: Type.
      Theorem test (s1 s2: seq T): size (s1 ++ s2) = size s1 + size s2.
      Proof. by elim : s1 =>//= x s1 ->. Qed.

      Check test.
    ROCQ

    ENV["OCAMLFIND_CONF"] = Formula["rocq-elpi"].libexec/"lib/findlib.conf"
    assert_match(/\Atest\s+: forall/, shell_output("#{Formula["rocq"].bin}/rocq compile testing.v"))
  end
end