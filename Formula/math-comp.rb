class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://ghproxy.com/https://github.com/math-comp/math-comp/archive/mathcomp-1.16.0.tar.gz"
  sha256 "36fe4f5487f4685db9c6e6affa92abb47248440e6d4dfaaa01ab31df5fd4b513"
  license "CECILL-B"
  revision 1
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dede842bd48fa520d3f8dd2a18b34aaeca71b774d58989f38c3dfb9ae70ed641"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be41daf71e27a55d33d26ec46444425a74997e475ac8e77090defc38f02e638c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecda54248cb932e538dd22c498e990141c07670be6029023e1a4ee8f2ba7ce1b"
    sha256 cellar: :any_skip_relocation, ventura:        "fb4a9f131486c583f6f6cc31b6a11cf572457a7e943b98f23d3e4276ece15f5a"
    sha256 cellar: :any_skip_relocation, monterey:       "97c65a86df6bb527a643091c2b7751a3997727a4534042d4ed684aaeb7048986"
    sha256 cellar: :any_skip_relocation, big_sur:        "14979b3bb8ae23ac9740520516dd7645a4bd7f47e0170cb58fdbbc1b18565c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f8910d836172b74ec7f9caa30ed1a28ec582b2c1c39fc2f1bf1c0a9fb1d5d33"
  end

  depends_on "ocaml" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "coq"

  def install
    coqlib = "#{lib}/coq/"

    (buildpath/"mathcomp/Makefile.coq.local").write <<~EOS
      COQLIB=#{coqlib}
    EOS

    cd "mathcomp" do
      system "make", "Makefile.coq"
      system "make", "-f", "Makefile.coq", "MAKEFLAGS=#{ENV["MAKEFLAGS"]}"
      system "make", "install", "MAKEFLAGS=#{ENV["MAKEFLAGS"]}"

      elisp.install "ssreflect/pg-ssr.el"
    end

    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"testing.v").write <<~EOS
      From mathcomp Require Import ssreflect seq.

      Parameter T: Type.
      Theorem test (s1 s2: seq T): size (s1 ++ s2) = size s1 + size s2.
      Proof. by elim : s1 =>//= x s1 ->. Qed.

      Check test.
    EOS

    coqc = Formula["coq"].opt_bin/"coqc"
    cmd = "#{coqc} -R #{lib}/coq/user-contrib/mathcomp mathcomp testing.v"
    assert_match(/\Atest\s+: forall/, shell_output(cmd))
  end
end