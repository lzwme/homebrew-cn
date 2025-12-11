class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://ghfast.top/https://github.com/ocicl/ocicl/archive/refs/tags/v2.8.6.tar.gz"
  sha256 "fdf668e9c89f7a2b9b9c96d27b0997227da04ad752eed1f5cccbf07bad6e6fd4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2af5845f3b61a352129dc84058652a1793114eb756f43be15f9349a69f96f43c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bf6aaf4ac259af3928db242727c5b14290225cc7a2697e0c27e2ece7c7d09b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11308444b5ac338b30f3c6dddc6ac36bfc0841cf7f25f0fbb747507939d31aea"
    sha256 cellar: :any_skip_relocation, sonoma:        "f99301b32038a53cf5296f13ffdbbc7a9a7b3ce6449b15b70c6fdbef112f967c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f08ed6bec20051dc4c8a89613ed2385c921f4f9321d0f22f6b25d28c9bdda1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "692f809eeb0c11118d4a187072d07e6506f6956d1d08e8ae696dabceaf1b4632"
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