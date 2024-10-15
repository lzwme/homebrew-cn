class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.5.10.tar.gz"
  sha256 "31dabd42894f246e1c55122542543b04a865b69208259789e625a19d1defe7b2"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "d868062bd3bffe0ebc51548c7fe5ade78ac570ffb246924735d80999241304fb"
    sha256 arm64_sonoma:  "073962beef663c72c07738490b08c27c5808fe52694a2860c40361faec021c0a"
    sha256 arm64_ventura: "62351e630e71a655216ca333dec97641e54ac0cfed9831c825369655901a9c7c"
    sha256 sonoma:        "4cdac402cdb853afa43c1ac6644435cd78f7ee47f0dae05d057782aa7187b962"
    sha256 ventura:       "03ccfdd9908932eb73178c9f5206f60c7eadf6999a2b220163883ac66f41a275"
    sha256 x86_64_linux:  "f5d998bd87dd7cb820540f4001485823015a61367ef40c400144a8181946aac5"
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