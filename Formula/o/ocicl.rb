class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.5.24.tar.gz"
  sha256 "2a3c6b8c5d3e4fcb0da3f5796143a35aeb202215b56e7b7d7c2755f994d29377"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a06f8f6b722e51f7cd09a9500ed6092e09c690e2c6d5e347ca6d32b5a4f5a115"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df30f690994546b91ccf886db5a91f314b1c5499ed50f1b534307c7c6f7ea798"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f49435d7cfcef4d789346a1fdb42f6dfa81e4d7fe5c0fbf1b5bf9c8fb601d508"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3ffc9b6b1895c613400f1855009439968acb2f8ba370ba83c26e089df952dbb"
    sha256 cellar: :any_skip_relocation, ventura:       "b0e2a6dfba7f65bd09cdc5d9098f33603db6a9e8f765322845f82c702a630df4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc7f54e836c1097d1a7950c7e39b21624146a056f055d59380717b4b64db79c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69c590b1efcd1e986a39053023f181607f2447be6455374421626f8cbd47669e"
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