class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.6.2.tar.gz"
  sha256 "62cd2c678dcae1188c1015c076ac27002e5d29daff4cc4c425927f7bfa42f3d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "571ec493410239f33852ee4c62b71771bb7f4126674d56ae13d4f8b8180ff946"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "911df39913ce963782c163ffc26b4ebf7aede421312ec5dc09ed6f61c0d18ffa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38c0fb75c9f6b991571936381f5ae5d509092416f31e74f6360949c1341f437c"
    sha256 cellar: :any_skip_relocation, sonoma:        "82e27dd4a8bcaa76899ef01ec83ff4f5cfdd651709bfa5b239f7106dac440d49"
    sha256 cellar: :any_skip_relocation, ventura:       "a821699d83dc735a5aaebcd8cd79dd0ce3e4742a85edf1b52c7b717f4e85d993"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f49cadf70617b8685ed3d59b2417ec0c4933e6db6286d91d7fa38dc8d8bd46fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8028d669a949aa924551a9b57a4cc49f9ab043c374b93dee7ee235b97d94fcb7"
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