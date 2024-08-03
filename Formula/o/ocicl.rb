class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.3.9.tar.gz"
  sha256 "f1066fc58fab4ae2162da22a5795a16deb4cc8bb6b34c0431d96173fae0aeb79"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "8a7e2c6f2954c8da856bb82db2dd8859cb9bc90a95ffce6539d940f0be3c83f5"
    sha256 arm64_ventura:  "bb437ad5eeafdc711c82a5e914bde1086c66011163c3efa4acbe8d5efbddefc7"
    sha256 arm64_monterey: "f5d29c6d75bc63a7a3b1beb7993e5cc009c5ab94cb62629d44cdfd4fcd9d80a0"
    sha256 sonoma:         "93280afcb33f7a1009801bc82a36317aaf3cd69bfb3a069a843b2261ba0e6b7f"
    sha256 ventura:        "ce8b2c840e8714c7ed6809e483d5c468578c28ad34ed77ed082f6c1922f8215c"
    sha256 monterey:       "6d897b8c30ca96136b970d2cfdc8b2850728be4d067ea3c6dc5654de4332bf40"
    sha256 x86_64_linux:   "79439bab5529092afe152d8c4c331914f63e8b1dd7baab39b4a63d6c49e084cb"
  end

  depends_on "oras"
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
    system "sbcl", "--dynamic-space-size", "3072", "--no-userinit", "--eval",
           "(require 'asdf)", "--eval", <<~LISP
             (progn
               (push (uiop:getcwd) asdf:*central-registry*)
               (asdf:load-system :ocicl)
               (sb-ext:save-lisp-and-die "#{libexec}ocicl.core"))
           LISP

    # Write a shell script to wrap ocicl
    (bin"ocicl").write <<~EOS
      #!usrbinenv -S sbcl --core #{libexec}ocicl.core --script
      (uiop:restore-image)
      (ocicl:main)
    EOS

    # Write a shell script to wrap oras
    (bin"ocicl-oras").write <<~EOS
      #!binsh
      oras "$@"
    EOS
  end

  test do
    system bin"ocicl", "install", "chat"
    assert_predicate testpath"systems.csv", :exist?

    version_files = testpath.glob("systemscl-chat*_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath"init.lisp").write shell_output("#{bin}ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end