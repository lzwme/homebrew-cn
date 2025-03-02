class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.5.20.tar.gz"
  sha256 "a5e87e5880bb5415e9a4cdff4fd4334fc2a19a497c7aca469f359f57675eb913"
  license "MIT"
  revision 2

  bottle do
    sha256 arm64_sequoia: "3dda4811946bb1d55f4cd1343c134e73ec150b98ea96f537ab0db6b73251ef28"
    sha256 arm64_sonoma:  "78789ffe7b592a817ee761c13e8f782b9aa70aa5fc63cf6f6832b42f6d9b3190"
    sha256 arm64_ventura: "e27634cf43e8db268c7e93e38cf399d98fcac7ed1b32a299d0160c93b2de862e"
    sha256 sonoma:        "b69e9206a39c45a82ac64c6a420f16560eba9e9e5d05a47af4fd4146321faf46"
    sha256 ventura:       "905cb4e2dc6d00624bc0b3163ed758e19125c5d2fa0fc15d65451153502ab381"
    sha256 x86_64_linux:  "6d6227a5a26879cbb942588c9b3d947becd5f0ea1c081a58a8fb66feffc0380d"
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
    assert_path_exists testpath"systems.csv"

    version_files = testpath.glob("systemscl-chat*_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath"init.lisp").write shell_output("#{bin}ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end