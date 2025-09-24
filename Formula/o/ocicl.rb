class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://ghfast.top/https://github.com/ocicl/ocicl/archive/refs/tags/v2.6.7.tar.gz"
  sha256 "488e6162d2a9b0f2e50376e583e06575ad0dbd1d5cc819393e00c33602dad8f9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd4ba2caa43af3a464021992cb84238aee90285b988f20b32c5e105898f87bb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "720add1da9e06f06cf02c919026f174731fa14e90b62d726f2e6053d10820ae6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "971cd2db966fceca168c15af1dfca054ace6867dc4592284b422219af8f48b05"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8fcd8508d369368f1376087ca40d304b84e48472bc8c0c375ec209a432b71b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3a6701dba23b63977aacdc9339efbfa566ce2ad8e8355ab4bc2504b4bd6bcfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfc0d205f461ad35b8043e453e9fe91cec47d2195a35a6fead166e568643452d"
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