class HierarchyBuilder < Formula
  desc "High level commands to declare a hierarchy based on packed classes"
  homepage "https://github.com/math-comp/hierarchy-builder"
  url "https://ghfast.top/https://github.com/math-comp/hierarchy-builder/releases/download/v1.10.0/hierarchy-builder-1.10.0.tar.gz"
  sha256 "a1de2ae6b5583f26c57db62e337f02c60d0b51c621b686d91dec3650479c0970"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4c7f356c6c0ea6ddcb8b3dba5de33967f17540a66f2c474625ef2671839d170"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dd8f078055ccaeaa927289af06eb2a48953e7fdfadbfd42ab2f9bc32ef6d2a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "973b5d3834b34bfaf12d93e4162fe4bc3e757434ddb54dc8640191a8d8bc5a71"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8f7287ab60415236f12ea6b6b7372a70ee9be011be44b7a90d6ecdba49967af"
    sha256 cellar: :any_skip_relocation, ventura:       "272ea5e5c32b59016f754f50fbb584a4520bd8892c6e84b3b69ab4a34a2afc40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dce0efb758f0035c32755833212250959387c9d3c53bf8f1513eaca1a34fc8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f58dee9ca573ce03f534459081e7332c5e0ed49dcbe0ff967ab0696b4baacd45"
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