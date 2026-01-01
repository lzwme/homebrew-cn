class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://ghfast.top/https://github.com/ocicl/ocicl/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "17af18e05b1c09b33d91489532fcac60c52f25817073fd5f580be8340c3e66c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db090dbdd53a1548fff77650d01cd250d0071a7a48bb71279caf00d2cdc1d26a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b8f08a2e8b378a7ea65c0841efec3841b308e15ffbfa4963a8940f2bf5044e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45b63a9446f235bdb6b1005a7505738d8b02d48b6363ca9d5a0c3e5b29d302da"
    sha256 cellar: :any_skip_relocation, sonoma:        "38e074dff69733ac419f05d8a3b4f8f4a61367ef23ce1dd4b2b0b00b7e5ae7b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30eea57a0aa9f60740d365c8a6095c51f1b9fc11dba5fc4ff1e1d4a6c970263e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efe9b04d52f437d5c7db6703995bd2e444dd7ea3cd18154f30b52c9327312607"
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