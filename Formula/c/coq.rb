class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://ghproxy.com/https://github.com/coq/coq/archive/refs/tags/V8.18.0.tar.gz"
  sha256 "00a18c796a6e154a1f1bac7e1aef9e14107e0295fa4e0a18f10cdea6fc2e840b"
  license "LGPL-2.1-only"
  head "https://github.com/coq/coq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "873c6d95391701fe82d8d9e8fc2d37f399741c865987fd4f118568d7e8197d60"
    sha256 arm64_ventura:  "be55d107e0a19675723d7c5225c17e2fd893ad675d2780581d25b0be3f8dd35b"
    sha256 arm64_monterey: "ba5cdf62836250c574478192af992d2de33cedca9a5e2a6bcd9e4314de691925"
    sha256 sonoma:         "7eba477a416eb26cc4d41d7774341d67310c239c31f677e850a98bf5f948eed9"
    sha256 ventura:        "4512a999a40459a853f8201a02d23038ea64de444865416ae498bf41c1a6b68e"
    sha256 monterey:       "ff48cd04e83a995d5607bd3bcd5b899656149009c2a021c5f7bfb389b84a8baf"
    sha256 x86_64_linux:   "58ccc350c3fbd216e43ec92f547d4bf35deba6b1f88c82da988384731cd7cad6"
  end

  depends_on "dune" => :build
  depends_on "gmp"
  depends_on "ocaml"
  depends_on "ocaml-findlib"
  depends_on "ocaml-zarith"

  uses_from_macos "m4" => :build
  uses_from_macos "unzip" => :build

  def install
    ENV.prepend_path "OCAMLPATH", Formula["ocaml-zarith"].opt_lib/"ocaml"
    ENV.prepend_path "OCAMLPATH", Formula["ocaml-findlib"].opt_lib/"ocaml"
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-docdir", pkgshare/"latex"
    system "make", "dunestrap"
    system "dune", "build", "-p", "coq-core,coq-stdlib,coqide-server,coq"
    system "dune", "install", "--prefix=#{prefix}",
                              "--mandir=#{man}",
                              "coq-core",
                              "coq-stdlib",
                              "coqide-server",
                              "coq"
  end

  test do
    (testpath/"testing.v").write <<~EOS
      Require Coq.micromega.Lia.
      Require Coq.ZArith.ZArith.

      Inductive nat : Set :=
      | O : nat
      | S : nat -> nat.
      Fixpoint add (n m: nat) : nat :=
        match n with
        | O => m
        | S n' => S (add n' m)
        end.
      Lemma add_O_r : forall (n: nat), add n O = n.
      Proof.
      intros n; induction n; simpl; auto; rewrite IHn; auto.
      Qed.

      Import Coq.micromega.Lia.
      Import Coq.ZArith.ZArith.
      Open Scope Z.
      Lemma add_O_r_Z : forall (n: Z), n + 0 = n.
      Proof.
      intros; lia.
      Qed.
    EOS
    system bin/"coqc", testpath/"testing.v"
  end
end