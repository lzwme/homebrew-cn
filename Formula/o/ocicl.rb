class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.5.11.tar.gz"
  sha256 "c87ccedeb7f7e116030f1a0ffdbcddb28921f6db2c31a893ea8c197cdf6ca4ea"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "7cfabce89ddc30e3f5ee011c5c868b8a979af6cf494d93b387e376b8b018fea6"
    sha256 arm64_sonoma:  "641e9e79a1851efdd721058aa3f1e403b2d177a22aef8fabc760a182cf7e688e"
    sha256 arm64_ventura: "6aa5cae6ce67ccf4a8da6bb849ca76f741a2d811f0fe0924d2d28186500ed80a"
    sha256 sonoma:        "601c1908fe00b936a7a50e9a775fc7de58cb08dbba0d63c6a01e57c4cd60b593"
    sha256 ventura:       "7007769f2aaec73436d8f166b7079603e6b7195e03f8f9af7a9a0095ee42ae2f"
    sha256 x86_64_linux:  "765165a1e3eb245e92b1444151341293ce525ede2804f8c6f015891ae57409be"
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