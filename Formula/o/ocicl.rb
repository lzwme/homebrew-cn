class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.6.4.tar.gz"
  sha256 "12796c4a5ea08cb2b2339367311ce8acdda260c472a47a1f33a589a5d9b646f9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84c8e38fd657df36911e2c8fe65bd87906b3543d6ec2256c23aafc329694cce0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71f7b9b1fe9308485f481f19222a755a1fee51b1b35c160bc7c0ae52e99dc679"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebc186ac02da8108413d9f5efcbd6eaacd12d683aedddb5e6097d895c5efd7a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5942111e3a057aeea9ab3ea1b4b521d26229959a0ab0c97aa6840273985f2a2"
    sha256 cellar: :any_skip_relocation, ventura:       "4db9169bc8d4bef538f4aa012b579e0b4085de38f222f5c2f373fe93a1ea9af6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "156208e158e978dbd301aee9e5fc8c8c034011050ad428d238b5b63cb6893592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "571abdf9016b483e1827d595b92c9a7525f3ae2fa0170c38b952c3112fc9eaaa"
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
    assert_path_exists testpath"ocicl.csv"

    version_files = testpath.glob("ociclcl-chat*_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath"init.lisp").write shell_output("#{bin}ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end