class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/~moore/acl2/"
  url "https://ghfast.top/https://github.com/acl2/acl2/archive/refs/tags/8.7.tar.gz"
  sha256 "d6013c22e190cbd702870d296b5370a068c14625bf7f9d305d2d87292b594d52"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "96a49564c85f214f581c1f4489f3a96f7e531c42ea74618a7c20c044cd450eb2"
    sha256 arm64_sequoia: "6279667d450b0154a3d7bd0d2353d9f8b2d7c5838e891eb488c318dedbe66422"
    sha256 arm64_sonoma:  "54cb330834c51feee53560a0c24e5995c70684fa82417575a5e82662253673d7"
    sha256 sonoma:        "8b95410c6083d91c8865373b5be0cb1a17d409ee92ef2b35952b22209df16b9b"
    sha256 x86_64_linux:  "f69f5834cb727397eeca261e61cba3f36c19b9bd1731e105c472ed9d0900d787"
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
    (testpath/"simple.lisp").write "(+ 2 2)"
    output = shell_output("#{bin}/acl2 < #{testpath}/simple.lisp | grep 'ACL2 !>'")
    assert_equal "ACL2 !>4\nACL2 !>Bye.", output.strip
  end
end