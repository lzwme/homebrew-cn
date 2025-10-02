class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://ghfast.top/https://github.com/ocicl/ocicl/archive/refs/tags/v2.7.4.tar.gz"
  sha256 "53c35727469ef830a8e80599324b316394c0fba5be918b8c920af3f8bc3b6846"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6d85437e1f19c0e54938a3e607c7a09c3c6b48ffa1f50527c549478a24bdcec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b112ecacd770c759090b23c3313ff3f92131c7977d80eb73a5fa588f656897d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f3375fd90cc286a205abb62053229a3cd5ab267c64e035e37122f3396d909dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a705fd6b4fec3fed1b1bf1b45a08bf9b2bd38092af6bdd7548f3d5cab368a173"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "001de9582356f8ebf51bbf7ae04e21854262b9fee1a7d97686a42985aff4ede4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9877e4932d4cb93e8c51c0eb3f24f0f40a51164a63e68ec0c053f11041152a33"
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