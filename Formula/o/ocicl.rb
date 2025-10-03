class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://ghfast.top/https://github.com/ocicl/ocicl/archive/refs/tags/v2.7.5.tar.gz"
  sha256 "1cda8d08ff69465abd4abe6e2c59a0b689d905e92adc224ccf2afbde416a3702"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33e962af87754cb1fc9e81c380208c227c91af6b90610f8ce23e8703232ff8e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d73456463c543e699ca92bcfcb92833bf173ad4daa08f3be18b421345ab3039"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "345d28611cf40e93c3944f037bc42a94444bdb7df91aec13ec9611a6483bd81f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d9302d3e3534176308205c2d7ac45d22d29d9d908385227e2f878dcc6bebb56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d11f3470c6413cdab457f0f8b05cc01df0911e6936f42b40376c7a43331a997a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ac2dcf82edcbefd9e52f44290ce1b3956177b6b0df815e0ea59e5919a06670e"
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
           "--eval", "(load \"runtime/asdf.lisp\")", "--eval", <<~LISP
             (progn
               (asdf:initialize-source-registry
                 (list :source-registry
                       :inherit-configuration (list :tree (uiop:getcwd))))
               (asdf:load-system :ocicl)
               (asdf:clear-source-registry)
               (sb-ext:save-lisp-and-die "#{libexec}/ocicl.core"))
           LISP

    # Write a shell script to wrap ocicl
    (bin/"ocicl").write <<~LISP
      #!/usr/bin/env -S sbcl --core #{libexec}/ocicl.core --script
      (uiop:restore-image)
      (ocicl:main)
    LISP
  end

  test do
    system bin/"ocicl", "install", "chat"
    assert_path_exists testpath/"ocicl.csv"

    version_files = testpath.glob("ocicl/cl-chat*/_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath/"init.lisp").write shell_output("#{bin}/ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end