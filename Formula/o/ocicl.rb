class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://ghfast.top/https://github.com/ocicl/ocicl/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "fd14fc5eb9f426dc462961bc7a85dbde4004701ee14fdb34f109044d25e5f686"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9504ec274a04b277b5a41b29aa0d2f2ed190f1bca3f46fd51c277507b89d2bb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aeecf0dce04c52943ad30ffb997db34d4b394023309becd2b76b530a7edb5513"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0aec49c17358e1f541602a0ba2929737d9fe8967875c1579f4453a631a696559"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d8f709aec96b092ec9006a872ee9e595291f1f96bbd4d1378ae9f23dbcae51a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9846e63349f808ae98bff7ca2a498d25aed5a6f6c201686e98d78807c4ed5e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "314ec401c109a66d722fa14658fc213d97e14fc9e8298009680f8367778c2e31"
  end

  depends_on "sbcl"
  depends_on "zstd"

  def install
    mkdir_p [libexec, bin]

    # ocicl's setup.lisp generates an executable that is the binding
    # of the sbcl executable to the ocicl image core.  Unfortunately,
    # on Linux, homebrew somehow manipulates the resulting ELF file in
    # such a way that the sbcl part of the binary can't find the image
    # cores.  For this reason, we are generating our own image core as
    # a separate file and loading it at runtime.
    system "sbcl", "--dynamic-space-size", "3072", "--no-userinit",
           "--eval", "(load \"runtime/asdf.lisp\")", "--eval", <<~LISP
             (progn
               (asdf:initialize-source-registry
                 (list :source-registry
                       :inherit-configuration (list :tree (uiop:getcwd))))
               (asdf:load-system :ocicl)
               (asdf:clear-source-registry)
               (sb-ext:save-lisp-and-die "#{libexec}/ocicl.core"))
           LISP

    # Write a shell script to wrap ocicl
    (bin/"ocicl").write <<~LISP
      #!/usr/bin/env -S sbcl --core #{libexec}/ocicl.core --script
      (uiop:restore-image)
      (ocicl:main)
    LISP
  end

  test do
    system bin/"ocicl", "install", "chat"
    assert_path_exists testpath/"ocicl.csv"

    version_files = testpath.glob("ocicl/cl-chat*/_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath/"init.lisp").write shell_output("#{bin}/ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end