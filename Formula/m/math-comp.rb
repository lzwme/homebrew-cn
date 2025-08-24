class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://ghfast.top/https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-2.4.0.tar.gz"
  sha256 "6307218d7e434fb6ffc81b9275c673d3f7f1f4884ad59b904abd205c437021a0"
  license "CECILL-B"
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1b17f5b8e2b20af5ace23ec57d4f829365e9d3c83be65dd642c165fd283aadb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb066cd30672083829614bbcd0e41978bf52ad087babd5c235e2eaa1c62599f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4275cbb056423ca15041aa0747de7fdd3a09cfa0b929867078aea003cd9f4b23"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c0c18fb7f34cc5654a45941050d490cc12170de49dbdd2baab705ba6d18a6b2"
    sha256 cellar: :any_skip_relocation, ventura:       "0f6ad3b1eb56318a578ba2e1e20beeef645c28bdd6e8c27b7f23a17af70530ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b0ba0eabc25b6b96add7b36f58647b6cb76600c56880c714c99e2c78e632371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c95940eb318c627d6d5cad82e9cc87dcbf9e943718889a57f0d493512c419b1d"
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