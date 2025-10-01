class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://ghfast.top/https://github.com/ocicl/ocicl/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "a850303c86b258648794e962127c5fb50ad4c6f9734e3d1a3fdfc735b9b2bf1d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "128c284ea7bb0ca5772da65d1efd6dd5ddb81925e24e554b9dd1f8753186b26b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a5966df0d7bc1b8c0818cab637a73e56b604a6df25aa5f78aa49e3f11899e37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "546de17f370453cfd0c0d31bd52b8895851c594f7fa653cbb2d816383a8c290c"
    sha256 cellar: :any_skip_relocation, sonoma:        "434e07122e7f8687455d60f6844b7e9d723a857537646f77ec4728d7a1cbd5c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62f0bd0738a942b72db58530fb7de3cf408f8b209e01bebfbc800dbc54cca1a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73c6dae842bfd66e7dbe81986cc1067db1b20d33206a80de5d47bdd4ad05007e"
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