class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://ghfast.top/https://github.com/ocicl/ocicl/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "4b8a51b5a6c1d413f321721b10ade0e8c9bb0a70e8e2f05e6c58743cc57e12b2"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a0f1a3e15516059276fb25914f75d0f87aeee7f1d760d57e7dc17efaf21f52f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "566e95de2777d858985e5f5c61eda467fb9b4931373b2844d72827130dc7a388"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6909cb64a76d878b8300cab5a143cf5e81971fcf43f85f11cd63933815bcbe73"
    sha256 cellar: :any_skip_relocation, sonoma:        "36cc832e4d12d3f7acc3124486f4497e1a6f6d83cfa571cbb7cbc401623893d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0b79b9881935ad2bb46686f8cf6e79a76041bbddb27d3d53b65989c432cd95e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea0825516bcdc2ae540eb6078400e5b563ef761156cb0da266ded4d5366cffb5"
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