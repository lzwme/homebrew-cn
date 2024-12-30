class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.5.16.tar.gz"
  sha256 "da6d6b51ab4b5160c461f94713f3a6860bb0ef964306f5930ee2325a88a58ab4"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sequoia: "7a6718603a13fa4ae8a07bdb830dfd4edaedbd8ce24b2e603e1af86e0ddde9f5"
    sha256 arm64_sonoma:  "f80fbcf90990d2d1e26eac1fd87e8cdb257bd7f94430a7012c24019aadd30563"
    sha256 arm64_ventura: "dd361b92c2ca039f1d11628585d558561528d7f17011cb4ea7028dc9b5d6d59b"
    sha256 sonoma:        "b671aa86eff66f7ddf8e7ac1354d88b024ecea9dfe5619bb41d5088ac51af12f"
    sha256 ventura:       "f336cfac8a501f1da5a484dbdc98c8824099414990cfd51f3edc878418f6954a"
    sha256 x86_64_linux:  "1098533b721c8f4b4ec75aa0d9386709e55372ab8996267448e3af40c6ebee61"
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