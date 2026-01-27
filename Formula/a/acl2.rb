class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/~moore/acl2/"
  url "https://ghfast.top/https://github.com/acl2/acl2/archive/refs/tags/8.6.tar.gz"
  sha256 "c2d73e66422901b3cc2a6f5a9ab50f5f3b1b4060cf9dc9148d076f3a8b957cf9"
  license "BSD-3-Clause"
  revision 14

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a4b38a21e4a0e08312a1661ecc08ac08be8e430abb8d96d0bbf58582cf7247ef"
    sha256 arm64_sequoia: "caca08c7a554d2f88b3c86d28ff38fe7bfef97410faad9a933d1237753216c9c"
    sha256 arm64_sonoma:  "0cce484281e73990c4cad9a07e9cdb95b152660e4d5ef58518c95bccf00413b4"
    sha256 sonoma:        "7efac9505fb7e9633d6817e58d9d4375c3b78252f8855396baa34739555d3fb5"
    sha256 x86_64_linux:  "1298392545f7690fe775a1ebd7352caa43fe7decfd0afdedee70ea7925c42a5c"
  end

  depends_on "sbcl"

  def install
    # Remove prebuilt binaries
    rm([
      "books/kestrel/axe/x86/examples/popcount/popcount-macho-64.executable",
      "books/kestrel/axe/x86/examples/factorial/factorial.macho64",
      "books/kestrel/axe/x86/examples/tea/tea.macho64",
      "books/kestrel/axe/x86/examples/tea/tea.elf64",
      "books/kestrel/axe/x86/examples/add/add.elf64",
    ])

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
    (testpath/"simple.lisp").write "(+ 2 2)"
    output = shell_output("#{bin}/acl2 < #{testpath}/simple.lisp | grep 'ACL2 !>'")
    assert_equal "ACL2 !>4\nACL2 !>Bye.", output.strip
  end
end