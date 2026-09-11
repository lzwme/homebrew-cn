class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/1.3.0.tar.gz"
  sha256 "f26552aae8957d6924319034eadd69830f2442685fc4e696c97e777c827a4082"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b519d261eb0451ff03a5001de8c466a3bd8d281f14cf39fd22d23d27ac3cba76"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8890ec28d2a70d60521202216b2c0524accc4403d2ca549267c5316da16f679b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "89a3f760f69212058960ace2a2c9bea1cd8bed020f58c8e8616e7eb49f521d5a"
    sha256 cellar: :any,                 arm64_linux:       "b11f53fe1a0333ac90be417ba46d0f0f45fee714f3ec9b25872320082aa8c4fd"
    sha256 cellar: :any,                 x86_64_linux:      "47ead3a74f42260eef8e6a89cfdedc714dbbbb2f8a8920a27791c7be5b73fc04"
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
    system bin/"pyrefly", "init"
    (testpath/"test.py").write <<~PYTHON
      def hello(name: str) -> int:
          return f"Hello, {name}!"
    PYTHON

    output = shell_output("#{bin}/pyrefly check #{testpath}/test.py 2>&1", 1)
    assert_match "`str` is not assignable to declared return type `int`", output
  end
end