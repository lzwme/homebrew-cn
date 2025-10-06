class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://ghfast.top/https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-2.4.0.tar.gz"
  sha256 "6307218d7e434fb6ffc81b9275c673d3f7f1f4884ad59b904abd205c437021a0"
  license "CECILL-B"
  revision 4
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff9e114a152936ef20294955fea51e5ff3ea8517e3c2edfa7118b876a9e28231"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30082a5dfdab43dab0366d5786849e9f083c9e65862a8fb9636fd0098fb93a28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7b68e89c8367d4dd92552d89a3186116639c067f3b1b4fe3a64e4117c6bb5b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fe80b0b9b352c34d042ca6d1e92661473b645700f9fdd3fc29bd095f877ac0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6e78761c625c53fe79ee04f3a2203bbdcb9d5baa2efcc162bb905b58f8fd6df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "909068d86716ce2c0f6d9d000d95617123dd3bf666bc245bc2147c0f4727bd3d"
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