class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.5.23.tar.gz"
  sha256 "ce640190f04b46d46c4f371d2256283d4cf68ef7d06da5f7d5b9e51834cc0007"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcbf19eead0042bc5457b1138d72a4a8113ee823f4e0afdd79ed82e8af35844c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d72776bb9a1e788046056bbc5374faeae2fa566d7569a49be15f7f77f8f4cbfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02efe8630552a08400c04b26909f04f23aa9043d6e8c4a53e9f1676fa871fb74"
    sha256 cellar: :any_skip_relocation, sonoma:        "71491675afbcb28f09f9ea09cc17b6d3b9f7e59c76860e9e7edb4992b5138f24"
    sha256 cellar: :any_skip_relocation, ventura:       "4a5574b6ef9f68515781bbdebd93f5accacf6d62e7cbea402f51aae11c820e82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1206a0bf1b2c23fd5038eb94d4a3474af2541b0ed55f65a89640146cb171dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfc6db817c1386a5ead612ca9e0919adbe48d0e2325d9628b5b6ea81a1c88012"
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