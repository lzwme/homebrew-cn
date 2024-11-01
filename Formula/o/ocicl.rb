class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.5.13.tar.gz"
  sha256 "ba28c9dc813fcd9f519a736daacc3362e6e4780a33f6fceba9b25fb0fdef35a5"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sequoia: "225ce3b0531983673b264b9cbddab740dbe436f6f9370d4d7e52d51458db1374"
    sha256 arm64_sonoma:  "49c0978da52737b7c779dcbcb2d1ac303ed4225f4616d6fbc23dbb44d94c9c28"
    sha256 arm64_ventura: "ec01b9c86a7d97f3096ba684dbe72fce6cb7e01b7ee01688d3fa15d780c1ba7f"
    sha256 sonoma:        "8c56987e4a96595ec567e92401ffa91742426c72e65b7c8b7fb721728e875e10"
    sha256 ventura:       "92423e44512c7cd31dafc29e42866690fd77cfcbb4a1dcf2b4399a0f156749ef"
    sha256 x86_64_linux:  "05b84d129fa33f548079bf233c21126b0d5d90cf2e98fc7da806a0629a158f9c"
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