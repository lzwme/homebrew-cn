class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://ghfast.top/https://github.com/ocicl/ocicl/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "fd14fc5eb9f426dc462961bc7a85dbde4004701ee14fdb34f109044d25e5f686"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34e0df2787f1c59f4ce17c9c1732ba2aca6535e53a98ab747345ad93778ae287"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "068c1e894bef33a492b19f94fc4d37ee123a1d4f4c5ccca2a2d5752c6683d8e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26fabdcec6f447415119c38b4109547bcf2444003585fa3cde626f2f7323de0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e443287661d263c86588a3a96cd150f2c5e0f1fe4d95b4f1e7c22c43f82774d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f011159a87ae06993c3f3958bb87a034d4cc316a91d7d1c3d76402813b62f0af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "173d1504594e8936ba58bf956fd4a107693dfda8ccd1fd68ca1e36baac73a96d"
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