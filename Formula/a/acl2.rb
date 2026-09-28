class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/~moore/acl2/"
  url "https://ghfast.top/https://github.com/acl2/acl2/archive/refs/tags/8.7.tar.gz"
  sha256 "d6013c22e190cbd702870d296b5370a068c14625bf7f9d305d2d87292b594d52"
  license "BSD-3-Clause"
  revision 7

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "2ba916bb66b371f5fbb7c11a6db21c79a3a558e5689e0bfe23159be2772ffd27"
    sha256 arm64_tahoe:       "d673802a2215f160048d525a20744af1ee9b9633bc270d61b809052966e2fa7c"
    sha256 arm64_sequoia:     "2f898283caefe3eaab6eed40e7a31c5f04b2e0b656a9f42a216e4365ab1b402e"
    sha256 x86_64_linux:      "b8d56408c90a0836123e4f2000ec36de5d6f55713a7296ac0e8fa21b3a031477"
  end

  depends_on "sbcl"

  on_linux do
    # ACL2 rejects a Lisp that doesn't error on floating-point overflow
    depends_on arch: :x86_64
  end

  deny_network_access!

  def install
    # Remove prebuilt binaries
    rm_r buildpath.glob("books/kestrel/axe/*/{examples,tests}")

    # Move files and then build to avoid saving build directory in files
    libexec.install Dir["*"]

    sbcl = Formula["sbcl"]
    args = ["LISP=#{sbcl.opt_bin}/sbcl", "USE_QUICKLISP=0", "ACL2_MAKE_LOG=NONE"]
    system "make", "-C", libexec, "all", "basic", *args
    system "make", "-C", libexec, "all", "basic", *args, "ACL2_PAR=p"

    ["acl2", "acl2p"].each do |acl2|
      inreplace libexec/"saved_#{acl2}", sbcl.prefix.realpath, sbcl.opt_prefix
      (bin/acl2).write_env_script libexec/"saved_#{acl2}", ACL2_SYSTEM_BOOKS: "#{libexec}/books"
    end
  end

  test do
    output = pipe_output(bin/"acl2", "(+ 2 2)", 0)
    assert_match "ACL2 !>4\nACL2 !>Bye.", output.strip
  end
end