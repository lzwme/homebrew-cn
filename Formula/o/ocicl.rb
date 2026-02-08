class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://ghfast.top/https://github.com/ocicl/ocicl/archive/refs/tags/v2.16.4.tar.gz"
  sha256 "7325761cc958246a285177784bc7da546fd5675d908c2ef20c2d5a864c69d82a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9182abf661b3b37035618a4cc4be232c75c101d386f6f25e3d8966ee5f834cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4196ba4977f42b583a3ed861618125df915346231d1b4bbc22ed22e4d39df09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b43a6c547552de7d937392d7a5fb0229db63b73785e815fc9a9aac0453ad55fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "12e5425c19c068f94e1250eb33cc06fd092c1b23d91392741124196fac376ecb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b6753644f4c33b69c9c48ffa2aac7138eb0695ec637d31a1fb0deb552677cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c45562cf8e2f478ff7449fcda0a13a76f19a15f7494b5a2b1968cf8527fee2a"
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