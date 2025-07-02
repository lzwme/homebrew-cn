class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.6.3.tar.gz"
  sha256 "8b7f43e2b7d9abfe0c4920788fb8e2daeeac8855cd27800966af69f9c8de34ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed42f8511ece79850931d51e7a7b7b5aa8a61f438e092a12561d3eede875b26e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2461431b98ca0a6320e8b9d58f875485a26f79cd60c9e2749412a76ab65f6313"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f12952f65d5b2606f6e856b37376c493fa582988fc762218c7a71b951fe4a6d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d1e65d2b9efae488ecbd3b51f9dbea14e3e0448f23b2d4a352add4da9e06d18"
    sha256 cellar: :any_skip_relocation, ventura:       "017a4dfb87f28ce0000d1493cc1a4b950ee18eb37448bb82c5e258aa82d54c9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf2287a660542da9d21944b658b155ddae1f6468fe7d416d2094c271448d4282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a81263be501937bf18ceda32d8b9c269642a4d729179e0efc6d880035e76760"
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