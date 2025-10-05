class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://ghfast.top/https://github.com/ocicl/ocicl/archive/refs/tags/v2.7.7.tar.gz"
  sha256 "0c7959d2db9a1a7b8fd3ef7bbe4b673e2b5fd4402a5cb3e780d22f610ef059fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "935567b2474f291cf8ee097ab8ac9954934be5172dde079b8e12846675a9bb21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "413e509be1452d0cc71042f8f1a8cc05a71c491ee3dea4ebff650639bcc893c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9559132b0fd171ff533181162b0e717c0c08cfc84f2383cffb9fcc50904a9272"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d0994ee293b54079c3c859544ac99bc63a80e332329d38e1cd37d9dbee689be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed98e1fcfc08eea7ceea7585ae369bd0b40e6024004ff3d389ea7046147fe270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72606b36bb9531611b619d06197c71be160c6c18f67e83ef6af9e8c0b5f4f294"
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