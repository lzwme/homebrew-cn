class HierarchyBuilder < Formula
  desc "High level commands to declare a hierarchy based on packed classes"
  homepage "https://github.com/math-comp/hierarchy-builder"
  url "https://ghfast.top/https://github.com/math-comp/hierarchy-builder/releases/download/v1.10.0/hierarchy-builder-1.10.0.tar.gz"
  sha256 "a1de2ae6b5583f26c57db62e337f02c60d0b51c621b686d91dec3650479c0970"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c58ee61f7f0ae95a827ba1e75f9fa57cc7220eebd03eb099f42a78a6d0e1e5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fc00ff76d06b869748135521cdcc994002989ecd76719b2309bd16c1538d7e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc6d1bb190d7180ad078012f1e005194ccf0d794ae3c7a598a751c25bd3a0156"
    sha256 cellar: :any_skip_relocation, sonoma:        "aca8b25647a61be1f95192e82560913cfb61b3bd8317a6ebf6d22421f546f645"
    sha256 cellar: :any_skip_relocation, ventura:       "7382e0dcf6c8e99da3bd4e98689b7ba3056720571203861028e1fb350c045b1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c811275a8dd9bb2a1284f6ab87080a65212ce39410c3452d88f943320679703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "396572fd46f48852c2ef1caeec53661811ae61566b1dca89160e656bebe718d6"
  end

  depends_on "rocq"
  depends_on "rocq-elpi"

  def install
    ENV["OCAMLFIND_CONF"] = Formula["rocq-elpi"].libexec/"lib/findlib.conf"
    system "make", "build"
    system "make", "install", "COQLIB=#{lib}/ocaml/coq"
  end

  test do
    (testpath/"test.v").write <<~ROCQ
      From HB Require Import structures.
      From Stdlib Require Import ssreflect ZArith.

      HB.mixin Record IsAddComoid A := {
        zero : A;
        add : A -> A -> A;
        addrA : forall x y z, add x (add y z) = add (add x y) z;
        addrC : forall x y, add x y = add y x;
        add0r : forall x, add zero x = x;
      }.

      HB.structure Definition AddComoid := { A of IsAddComoid A }.

      Notation "0" := zero.
      Infix "+" := add.

      Check forall (M : AddComoid.type) (x : M), x + x = 0.
    ROCQ

    ENV["OCAMLFIND_CONF"] = Formula["rocq-elpi"].libexec/"lib/findlib.conf"
    assert_equal <<~EOS, shell_output("#{Formula["rocq"].bin}/rocq compile test.v")
      forall (M : AddComoid.type) (x : M), x + x = 0
           : Prop
    EOS
  end
end