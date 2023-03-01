class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://ghproxy.com/https://github.com/coq/coq/archive/V8.16.1.tar.gz"
  sha256 "583471c8ed4f227cb374ee8a13a769c46579313d407db67a82d202ee48300e4b"
  license "LGPL-2.1-only"
  head "https://github.com/coq/coq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "a0058990f3f38468311a6b8d21dc9190e0c85e0a3d6b0566f2fa999bf269e255"
    sha256 arm64_monterey: "3bc7aa1ac3c19daaf0067b05ef7f3e657220de11ff58d4df10aa98f1a0dabd7e"
    sha256 arm64_big_sur:  "69601869940c2f3e0fcfb39de3414cbfb741913988ab35e44db9725245e10af7"
    sha256 ventura:        "54bb8ebd69af1d5f2e947ac44b34153e40e9fa9ba3e17d42f4d865605d4d465d"
    sha256 monterey:       "346ea8b3daf2398ba4fad2ffb7f814bdb94ede607f8831ef54874dae9079abaf"
    sha256 big_sur:        "d2736451cb3e1233209f850fb3a33fafadcb081af9fffbf10bb09c2fd43fd2a7"
    sha256 catalina:       "e31207f3bda0fedf8b15e0cff39d450628784dc55e1acd388c8cb7ec33b41e62"
    sha256 x86_64_linux:   "963c072eae7fc4345f890594442f0a6537e272a3ef8f63e11c287b7216b0f98a"
  end

  depends_on "dune" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "gmp"
  depends_on "ocaml"
  depends_on "ocaml-zarith"

  uses_from_macos "m4" => :build
  uses_from_macos "unzip" => :build

  def install
    ENV.prepend_path "OCAMLPATH", Formula["ocaml-zarith"].opt_lib/"ocaml"
    ENV.prepend_path "OCAMLPATH", Formula["ocaml-findlib"].opt_lib/"ocaml"
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-docdir", pkgshare/"latex",
                          "-coqide", "no",
                          "-with-doc", "no"
    system "make", "world"
    ENV.deparallelize { system "make", "install" }
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