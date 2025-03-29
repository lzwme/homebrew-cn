class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.5.22.tar.gz"
  sha256 "78e378a84f96f52a0dd8518a9d049f94d2d76ee0c3ec7db1384104e45b5c20e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd5e7a25b7505036891371d712c40250e97518ec5a3e8a77124f012cf4f24e67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b13978939bf4d0ff84f467edb7352764e4cbdae764eb1838a886aa6798585e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e89e56fea7c2807faa7cae5385bf47a5e78b02ebea4ed356683764bcfc7e707"
    sha256 cellar: :any_skip_relocation, sonoma:        "861299104e352fc65399b579c1f6a916a24a90ebe88b7a5dc9391b7772cf97fa"
    sha256 cellar: :any_skip_relocation, ventura:       "8817a432d011e8a1839773ca3207ae7fb9d723f8bc4f2ff75fe4cc7eda11e612"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57e92f90bb7ccfefd2126480374cbc0153debe42bb3b84059146e55d4b8edb60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3884f900b9978659ddc993edf9c85abeb8579427df9c29dbcf896ed5a6c047b"
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