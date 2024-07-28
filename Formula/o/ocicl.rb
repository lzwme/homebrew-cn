class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.3.7.tar.gz"
  sha256 "7199674fe545a0a80b1cf7aed9a52b51277beca3583c95478aae24e0c9af74f8"
  license "MIT"
  revision 2

  bottle do
    sha256 arm64_sonoma:   "db598f1150c7c62388b389f0773785270ff1ee5f054c2c838c596164c685d351"
    sha256 arm64_ventura:  "bf6240551321c7cc58de3a1979127e791b620003071e010067493637aff8a365"
    sha256 arm64_monterey: "81a78edf6a178b28a86321cded4347067cb704d295bc8294878526698ee51ae1"
    sha256 sonoma:         "fa527e051513d14a3b723444e231891a117214fd0f2a3f436dba52d471a79243"
    sha256 ventura:        "5ff6f116b0139d70e5798f263076bc85cce41a699606fe63a700b3766a567a65"
    sha256 monterey:       "5d70004fb71d255b9165b8fce6bac2218bb795ab75cac8ae9feff43b21df1af9"
    sha256 x86_64_linux:   "68fa8acf7a31529cf254d14ad63a528a283de6249c6c184e0b96a226e54de825"
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
      (ocicl:main)
    EOS

    # Write a shell script to wrap oras
    (bin"ocicl-oras").write <<~EOS
      #!binsh
      oras "$@"
    EOS
  end

  test do
    system "#{bin}ocicl", "install", "chat"
    assert_predicate testpath"systems.csv", :exist?

    version_files = testpath.glob("systemscl-chat*_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath"init.lisp").write shell_output("#{bin}ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end