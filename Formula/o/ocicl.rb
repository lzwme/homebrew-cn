class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.5.14.tar.gz"
  sha256 "36847443822d1237c809e01ad0aeabd66ec7782f6409934ea67f0a914360333a"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "1e6018fd8446128a4e8ceebec4a539e8e8ed06b9645eb7d244398a1e3f18369e"
    sha256 arm64_sonoma:  "61010908ccbdf772ba65c752903bd2b99c1815c1de730bead5f0938411e5edcc"
    sha256 arm64_ventura: "72a864fb9afb0c7f21b844146a93825219c20f0db07f908bf2c63c009d9c343b"
    sha256 sonoma:        "526215e55907ccc765cb948f9735a57daf1067564a1b2c031c69d4857a778223"
    sha256 ventura:       "db497ff268f9e9c8822a84fcb760813c4816abb2af1d74cf9c6e96863e54df56"
    sha256 x86_64_linux:  "3e1b19caf86b76f22c2b3c80f7d04f15afeb7d18d0db1c495bd4ddb189173140"
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