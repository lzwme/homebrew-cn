class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://ghfast.top/https://github.com/ocicl/ocicl/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "9ce6e37fc361b1c63386171981f2c899366637263ab7cb6a7146852fdc92290c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "748ab14615de586509ca9b95a5d25b3257ccfa94c2e12c369ee25cb0f91ead8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2de5f016a52fa22c8102c3a83a449ba59f4ba250852719807bd56aca8a3778c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7571d722f1fd735cec64b00e2855f8f2e5bffa71c26e2d8b98fa25c2c456e425"
    sha256 cellar: :any_skip_relocation, sonoma:        "43c8619ce00284972e696e662f8c12b9040a55d08f4ac3da2cb6d61d2576361d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a7ff6e27d010d56377104fc4f6c1d626b25d54b9f763986b5fd2e396f176edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb0db4fbba8c12a964d6c8f6654f0261154e35ea0bdb331f458412d047026a7d"
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