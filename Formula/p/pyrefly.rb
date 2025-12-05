class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.44.1.tar.gz"
  sha256 "ddafde5bfaa2cf07970a3731918743b085365bc9f852050bc5b50dda240a0cb5"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c86bb6884a9232a13dbd44c3c60e45a849c360ff98db20701c5cca3d4d5aea2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e71cadc3433d7fa7ac8cbfaa75f2c6659927be7ded46bd4c5693816774e3553"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0f8edbdcfd4ea7b3cfb0dc83b8eaca60e41274af8ad0f34559fe62b9d71ea61"
    sha256 cellar: :any_skip_relocation, sonoma:        "86316446700d2712e1374f2f2192862a2f59561df81aa8999d81db720cde1e3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ba6e5bc13a063502f818703467b8baa020de0cdefe83fcd3a70caae6723c3d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9db8219f87bf780ff03a7ad2f7f4810a6822abc4661b40e2622194754ef9f82"
  end

  depends_on "rust" => :build

  def install
    # Currently uses nightly rust features. Allow our stable rust to compile
    # these unstable features to avoid needing a rustup-downloaded nightly.
    # See https://rustc-dev-guide.rust-lang.org/building/bootstrapping/what-bootstrapping-does.html#complications-of-bootstrapping
    # Remove when fixed: https://github.com/facebook/pyrefly/issues/374
    ENV["RUSTC_BOOTSTRAP"] = "1"
    # Set JEMALLOC configuration for ARM builds
    ENV["JEMALLOC_SYS_WITH_LG_PAGE"] = "16" if Hardware::CPU.arm?

    system "cargo", "install", *std_cargo_args(path: "pyrefly")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      def hello(name: str) -> int:
          return f"Hello, {name}!"
    PYTHON

    output = shell_output("#{bin}/pyrefly check #{testpath}/test.py 2>&1", 1)
    assert_match "`str` is not assignable to declared return type `int`", output
  end
end