class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.5.16.tar.gz"
  sha256 "da6d6b51ab4b5160c461f94713f3a6860bb0ef964306f5930ee2325a88a58ab4"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "d449375481964b02ad6f19e17b17a816e6f7629f22cf54ec5160c9bcf8d09d99"
    sha256 arm64_sonoma:  "53f9210140924c357b8f6b1737c341a33d87ac2e81caf460730d8d33544e5550"
    sha256 arm64_ventura: "3b60006cac1a8c42f391d8f0d316d89ee52d975e75820a77a7703918986f48ec"
    sha256 sonoma:        "b1148d7a949037fcca38faea1d5f4c33bb2c1c8208beffd4a423b7e8a238f09e"
    sha256 ventura:       "44abeae14a81399b6b180b9f2d5e8bb055249bf50de38004c2d04f5dac071052"
    sha256 x86_64_linux:  "2e94fe0393f3b06b4c15eec427562da6f3f181370d80c12b27f87d954fa69201"
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
           "--eval", "(load \"runtimeasdf.lisp\")", "--eval", <<~LISP
             (progn
               (asdf:initialize-source-registry
                 (list :source-registry
                       :inherit-configuration (list :tree (uiop:getcwd))))
               (asdf:load-system :ocicl)
               (asdf:clear-source-registry)
               (sb-ext:save-lisp-and-die "#{libexec}ocicl.core"))
           LISP

    # Write a shell script to wrap ocicl
    (bin"ocicl").write <<~LISP
      #!usrbinenv -S sbcl --core #{libexec}ocicl.core --script
      (uiop:restore-image)
      (ocicl:main)
    LISP
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