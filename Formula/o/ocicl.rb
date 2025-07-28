class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://ghfast.top/https://github.com/ocicl/ocicl/archive/refs/tags/v2.6.5.tar.gz"
  sha256 "a4cc0055e66c948dce070c98067ebd445d55bd3e349030e819547dd203d5e75b"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26e4fc8832665f46bc1e30e81f525d2400ffebfa97c22881fc374fa307253638"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff1a0794b5de1c10c4f866e3901df7e03c3212aa61de5baf69b51f80f224b318"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c7454ffb9c0702e7fa175846a08000b918b8869d1266e161e3be0c080c405e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7b2daeb010ad3d7c3e669d51fd126efa22d307d7196223085ea1cfff6dfb493"
    sha256 cellar: :any_skip_relocation, ventura:       "22554dc9c176b203b071c9604e495c078f11cab097e5c492c9cd6f57ef7f8ecc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c5ef4bb48dac29cbe9806e26ee9f1624f9a898a1483aaf599354b595bfd578c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e300821200e6a83d64266119a700cc7527d01d5a26a130a4c0e0c2ac58316bf3"
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