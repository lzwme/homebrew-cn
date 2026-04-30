class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://ghfast.top/https://github.com/ocicl/ocicl/archive/refs/tags/v2.16.13.tar.gz"
  sha256 "067408f0443119a25c2b34a323a829fb953542e367bb039365bdcc0a0b388500"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0ff3edeaf875b07b0fd300c61bb41de8f271a5ae24c4b46c9033128192d0689"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed96c54ff7c700869012a7d6629ab2d0fc28a1a39f58cfe5a855f36bb8aa7fe3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d86034ae0ed43dceba7ec2e2793c82fcb893a97ad870d0cb60ed84a7c648bafe"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c17ba7ad86155cf58da8edbee5b97cc347502286ace2d73cbb65b36b0bb878a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bb4c89a8358dee3311d970618b69864eee9ddb01aa5e63cfecbf0180e38f66c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab359cc8c408dc93ddb52511fb9518a4163e4541183ee41f45747dab9dc6ce18"
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