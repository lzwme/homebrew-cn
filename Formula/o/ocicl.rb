class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.4.3.tar.gz"
  sha256 "722ffe7bc0d2559d758f6ebdc803357c53d0fd47612cc498047aea74ca1a481b"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sequoia:  "533252e970cb44b29364f295447b4d96a59b0ab02c869dd1d6367acede18ab6d"
    sha256 arm64_sonoma:   "82501d915221b64430f5ca69f0e202d131be1bf56ce1e247f29065d02ad4b7cd"
    sha256 arm64_ventura:  "22f4b1230a1f62b761815707b71dd01918ac29fa82d7b095c8836dac02029291"
    sha256 arm64_monterey: "85817a302ccc86e82bbd8f9696cf5229dddf03f5ff6e6a94e4d078f384f820d4"
    sha256 sonoma:         "c6f59d590cacd79e82751428541ccfc69f6e77a9169a20474fcea2ca1933563c"
    sha256 ventura:        "834f3a2f7d18c904252397dbff80b8f3679cf971b4a8dad34a39721598288485"
    sha256 monterey:       "b869271fffe25e8fa2b246be7bdb04a8ab76b7b6de18ad8044b540905a0f9e9e"
    sha256 x86_64_linux:   "f58b60f44cadddc8b1f730f726990914e045905b314e821144a64540c6e8314e"
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