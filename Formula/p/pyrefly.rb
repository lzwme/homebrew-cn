class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.63.0.tar.gz"
  sha256 "a3e3fd8284e9c4b97a82127bb25d97a6e25f95c4f2e52927f2dc4062e603d9a8"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87e31137fed91fdffc2c5e337380963375fbdb3fd5232047b968d21bdd696852"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7fd5945f7e8eb32864850bdd6ce8fadde205c4c81c1c847082e4355a01bf12a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8770e4b62c04acf087c9a1e6aac43d39a54518f6aa7dedc3156fe6a6a77d83c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd9a3c8f6f746f1c51264c76d07ffbfb2929b54765a2abe53343e744e756c897"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d2a4fa8aa0a6d37cfb42f04cc86c9c84b1013f17a88de80802940769c916ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f39deb02b88e2e4c4250b7e2915bd45c5a6f959c931b436e8565550fc01ee7a"
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