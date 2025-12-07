class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://ghfast.top/https://github.com/ocicl/ocicl/archive/refs/tags/v2.8.5.tar.gz"
  sha256 "abd94a5258e4114a63c5181bb6d1405eff80f8bf7e61c396b152ec8aa8b8cd01"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ceaec7601a727b7b5511270f03754c76d7fcbd5a19b2f8d5b1372cccba9be5fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b00fd735d3a06b917a850f1513e113095e6c4bbda5b77dfc549debb32245d91b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9c2d8ba2a5620b60be9ca25b1279498dc07ba5a89f5912390e961e4746f831c"
    sha256 cellar: :any_skip_relocation, sonoma:        "16ae3dde7cd2bac17802ae92e1114c44037b52d4a475d6d9db93b9911def7d4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "419e056bb066b176eefa56fbb8a982265573145e7401ad99556caff0cd770869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2b4847459c36f82aa42dd7676312ce20324965b0d9f9521ca97662c0c43ba65"
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