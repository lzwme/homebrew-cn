class Rocq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://rocq-prover.org/"
  license "LGPL-2.1-only"

  stable do
    url "https://ghfast.top/https://github.com/rocq-prover/rocq/releases/download/V9.0.0/rocq-9.0.0.tar.gz"
    sha256 "82f86646fd3d047f760837648195c73374beee667b1c9592d31c5426e3b43a51"

    resource "stdlib" do
      url "https://ghfast.top/https://github.com/rocq-prover/stdlib/releases/download/V9.0.0/stdlib-9.0.0.tar.gz"
      sha256 "1ab6adc42dfc651ddc909604bae1a54ff5623cda837f93677a8b12aab9eec711"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "6a18bc281e4b8db55b9a977f31cc5a23331846fcdc766542e3029b6e1b6df25b"
    sha256 arm64_sonoma:  "508bb15bb5e66db300ca61124a919cce6e596a75945e789f75a054e8deea782b"
    sha256 arm64_ventura: "e874da2cbe2c8541518cca26a3be4d2ec55090f147fef311fdcfe32e0ab40da3"
    sha256 sonoma:        "055b5fc8dbbc8b35add44109a23fc43cff4e7739b2b09b138889f8e6aef1cba0"
    sha256 ventura:       "14c1364bb9071d85d09c969195ea15f3ab9cf1db999edbd4e4e70a27d1e2d1c6"
    sha256 arm64_linux:   "6256957748b8928b8457a2e1f2a415c88a609b1a246d500723dd2300d84f6126"
    sha256 x86_64_linux:  "71cc47f061ad7dee8da795cd2933ca7c0115fcb3c3e2e01e70cc599a4de49068"
  end

  head do
    url "https://github.com/rocq-prover/rocq.git", branch: "master"

    resource "stdlib" do
      url "https://github.com/rocq-prover/stdlib.git", branch: "master"
    end
  end

  depends_on "dune" => :build
  depends_on "gmp"
  depends_on "ocaml"
  depends_on "ocaml-findlib"
  depends_on "ocaml-zarith"

  uses_from_macos "m4" => :build
  uses_from_macos "unzip" => :build

  def install
    # Work around for https://github.com/Homebrew/homebrew-test-bot/issues/805
    if ENV["HOMEBREW_GITHUB_ACTIONS"] && !(Formula["ocaml-findlib"].etc/"findlib.conf").exist?
      ENV["OCAMLFIND_CONF"] = Formula["ocaml-findlib"].opt_libexec/"findlib.conf"
    end
    ENV.prepend_path "OCAMLPATH", Formula["ocaml-zarith"].opt_lib/"ocaml"
    ENV.prepend_path "OCAMLPATH", Formula["ocaml-findlib"].opt_lib/"ocaml"

    packages = %w[rocq-runtime coq-core rocq-core coqide-server]
    packages << "coq" if build.stable? # TODO: Remove on next release

    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-libdir", HOMEBREW_PREFIX/"lib/ocaml/coq",
                          "-docdir", pkgshare/"latex"
    system "make", "dunestrap"
    system "dune", "build", "-p", packages.join(",")
    system "dune", "install", "--prefix=#{prefix}",
                              "--mandir=#{man}",
                              "--libdir=#{lib}/ocaml",
                              "--docdir=#{doc.parent}",
                              *packages

    resource("stdlib").stage do
      ENV.prepend_path "PATH", bin
      ENV["ROCQLIB"] = lib/"ocaml/coq"
      system "make"
      system "make", "install"
    end
  end

  test do
    # Work around for https://github.com/Homebrew/homebrew-test-bot/issues/805
    if ENV["HOMEBREW_GITHUB_ACTIONS"] && !(Formula["ocaml-findlib"].etc/"findlib.conf").exist?
      ENV["OCAMLFIND_CONF"] = Formula["ocaml-findlib"].opt_libexec/"findlib.conf"
    end
    (testpath/"testing.v").write <<~ROCQ
      Require Stdlib.micromega.Lia.
      Require Stdlib.ZArith.ZArith.

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

      Import Stdlib.micromega.Lia.
      Import Stdlib.ZArith.ZArith.
      Open Scope Z.
      Lemma add_O_r_Z : forall (n: Z), n + 0 = n.
      Proof.
      intros; lia.
      Qed.
    ROCQ
    system bin/"rocq", "compile", testpath/"testing.v"
    # test ability to find plugin files
    output = shell_output("#{Formula["ocaml-findlib"].bin}/ocamlfind query rocq-runtime.plugins.ltac")
    assert_equal "#{HOMEBREW_PREFIX}/lib/ocaml/rocq-runtime/plugins/ltac", output.chomp
  end
end