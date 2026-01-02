class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://ghfast.top/https://github.com/ocicl/ocicl/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "44ffd681f109c912d539664886f905c934aeaed940543d1f521cd0f9a12b5882"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fc939ca04eca281d9866953f9cd71b41896bd280ac20eb045af8cd67399fe1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ab7465e376c0b8f17b10d262d6a32e709dfb8f908ca5a0047c8b4e335f5c30f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d97a664164897e7d376f34608304d2ff839b4fc59f481ed92cb134d5251e694a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff1989579708f697aff8d31f33c3412d525078d032ff248a9335882d205752e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33b16a54f0f547503c34a0bdb409cdebaed6a50f5afb76fce413075ba246ef01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1abf5034d817569234dd31b179deb122617c6df86994bd442ca1f5f65a68805"
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