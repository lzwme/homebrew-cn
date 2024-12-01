class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.5.14.tar.gz"
  sha256 "36847443822d1237c809e01ad0aeabd66ec7782f6409934ea67f0a914360333a"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sequoia: "d0c375fcd9272e0fb8b502a56dc8d1ec963f1a15933d931364820a45d9fd4a72"
    sha256 arm64_sonoma:  "be39883255c4cfe3054ae8b7f9da1e173b0e7ce18bc6211d9e30072312485595"
    sha256 arm64_ventura: "573b5e088afbe58d475fdd111cfceaa2ac0c608449aa408bcbc257b5b147b006"
    sha256 sonoma:        "2779172e7aa8cf65d1d48a201570fb5642b1ef129191d261b702b032263482ec"
    sha256 ventura:       "63dbb815032a8d0e3cbc0d720deee01cc872c2c88fac8f3ade7f8c79ee54342b"
    sha256 x86_64_linux:  "f5ae99e6a1f8d2ecc5e01dd30c0e3706db9144d7a941f349ee680f61d738bbd8"
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
    (bin"ocicl").write <<~EOS
      #!usrbinenv -S sbcl --core #{libexec}ocicl.core --script
      (uiop:restore-image)
      (ocicl:main)
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