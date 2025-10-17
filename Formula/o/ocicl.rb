class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://ghfast.top/https://github.com/ocicl/ocicl/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "ff6ff152ff0e096ee25204cffdac5de15ef134b983032ffc7ac994dc65e04a6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32258ec7d9ef4a5f34877787d9801678ffc1a27206cd503afde144b6ce0ba8dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e67b03054b7808c5279ebdc99659ae99084956317db242e4c9597e69cbdf22cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f1702ecdff43e0eab469a59c47ace51357804f44a1a68f08401b811b316e597"
    sha256 cellar: :any_skip_relocation, sonoma:        "251ee86d2e2da4f91db0a60c4d9b10bbe44a3b6b15f43ab863bbbed25feca96f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7db34b60a2dc3b7a51551410314f153fecd809b9a73be01aa640be6450b04bbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f6ce182d9779fcfff7fee14f85dc73ca41f586f05d1965d6f30df001a262d8c"
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