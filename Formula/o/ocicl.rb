class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.4.1.tar.gz"
  sha256 "e4c5457cb08016d3d4a62832d41c79134b5395102061b328348cdcefae21b82d"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "7fb12c3dd418cfaa80b8379993b42a9d57288393aaf4fb48a596da77edecfcc5"
    sha256 arm64_ventura:  "8808964e5854c2fd841b3c1c4c8022c4e759b57fce6d8a15c041b7732cc9822c"
    sha256 arm64_monterey: "6cc7d11bf55ca38123adc8c8843f457d3a9a3dbf28bd92cc0701bda190de5c26"
    sha256 sonoma:         "b8170a66e0b79f8f935266a29645695bcc0d3064a65fb5dc592c994df24b0e96"
    sha256 ventura:        "327666a2fbda18668d909c7660bf13947f3f21d012b7cc151500676220ca84c6"
    sha256 monterey:       "4a8a025c826a16ce8912dff363d6e1144caa580d510f3760b9cbc667657bce27"
    sha256 x86_64_linux:   "90d4db0c57bdba3f8c8c27cc9a061d9d1f91aa5ec49d0c9c83471f619085de68"
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