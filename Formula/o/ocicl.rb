class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://ghfast.top/https://github.com/ocicl/ocicl/archive/refs/tags/v2.16.7.tar.gz"
  sha256 "cd0783278260017ba379facde5d452e6d3b81bf99bd77f294c3dcb615bf73634"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29d22be6fab7e1ba3d589b49ba2a5074f204dcbdf6f7f6f96d7ab38f0ae8b367"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5af44a2ae18b33f383967779811f0d9151b660a75ff4f5a3910f40311a6bfb9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c60b1abada776b174c5fb645ed2b5cbaf7d48c9126804403f403346952490964"
    sha256 cellar: :any_skip_relocation, sonoma:        "70d349807f25014d5ed352e60ea294568bb69ad0bf8ea4981b1c4263b1a7689f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1de8d27e31389c61a624d505ac8037e576bb57499381b77f38b4fd6b6adacbee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "968efa9a456b2943032232b0a3ca97adac6adfa3dfb625dd39349777ab48692d"
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