class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://ghfast.top/https://github.com/ocicl/ocicl/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "c93441daeb9772922af5f7b394d60bbe44c67ea061511648943db07d33b5abb0"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "acf9195fe118e0d9651349031e5004d6b0e0c3641e5d978efaa6ea3728782c4c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b3ff7d1814cfe7166c574c91bf343147954c950d4de16499cb4c91c8a806a077"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "13e3662b5566a1167c54149ccd9a7ca7eb8c0f1b7efc74c1d07bd159f521887c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7e3b267282e9cc5a442a0ebabb7c707c96d017ac9988f2835663370f215d5414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b6bb1e48276d3a7fe7ed76ad6f6095af363021e038042487c0e6b55cfe68d3ea"
  end

  depends_on "sbcl"
  depends_on "zstd"

  allow_network_access! :test

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
    # Parallel ghcr.io downloads get reset on CI runners, and 2.20.0 fails the install on any download error
    ENV["OCICL_DOWNLOAD_CONCURRENCY"] = "1"
    ENV["OCICL_HTTP_RETRIES"] = "5"
    system bin/"ocicl", "install", "chat"
    assert_path_exists testpath/"ocicl.csv"

    version_files = testpath.glob("ocicl/cl-chat*/_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath/"init.lisp").write shell_output("#{bin}/ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end