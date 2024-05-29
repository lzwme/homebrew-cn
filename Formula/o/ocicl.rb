class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.3.6.tar.gz"
  sha256 "7e140d57cad655b44f76631a6fb77ccacc474f7e9ec38855e94e3e4ba840d7f6"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "692c26d7c250e9ce5e342104911d1565ae60f29500273fb5802f4608aa5858e7"
    sha256 arm64_ventura:  "2a5ff385eeb2b5a431271d159148839958eb37bf4daad409f0b8b5e5feb1de16"
    sha256 arm64_monterey: "d2d119ca64fbf4a23b9b79c3b53ae6a497ea4e1fd41a51d17dd09bab9a4bc22d"
    sha256 sonoma:         "6559853794ce9f195f08e5ea52ff320b78688ec7a49eedc982f0d89cd492e354"
    sha256 ventura:        "2f5fc5e517dd65e82f07cece9b24f0f2de5393638b3f01e09d0c581de42bac5f"
    sha256 monterey:       "ef7edfa5111bc85dafaf2a656e733a9eee5e769ab4b88d05816d34d84f24c535"
    sha256 x86_64_linux:   "7cf33ae7f42076838fc0c5d6f35d5e7d35ab509032b8782d5fb67463398f8914"
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