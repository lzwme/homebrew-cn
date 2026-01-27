class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://ghfast.top/https://github.com/ocicl/ocicl/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "4b8a51b5a6c1d413f321721b10ade0e8c9bb0a70e8e2f05e6c58743cc57e12b2"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "690f503ff640f0d0d07824dcd86d0f09e1b774e1b5dd1ab4b2be3c1a29bde8fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d05b34a46dee778bd4bcf4b4f70518ff5af77684a534f2694f9e0dd9131eb70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d15a18140683757a40ac4d32414d41f43497b8732cdac61319e313dd4a79e657"
    sha256 cellar: :any_skip_relocation, sonoma:        "017c83593d9342770a1df1c07554b80a1eb0777c9723d9b663cf7eaeddf7ed28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "343796411e500b84215d637f476cb7c89811262658b7a8e80938e19f3aa1e3b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d3ee5c20e1352743e97314d018a108b9534a9d6da26f097150cc355bd614331"
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