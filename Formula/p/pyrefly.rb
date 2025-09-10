class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.32.0.tar.gz"
  sha256 "b50c30a2c766e04757eb94c83102f7a2e9eae088085410a61dd22e3c80a41fd9"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53172087e7b114ed2dbba2289d531a1a6cbb82f56dacd45ed08495f254befff6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d4e04350557e981d0fb04aea930765427aab65e6fa0205f7146673a11ef6168"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d8a8a41de5f7e9b2307871d17540c5efa58f7357706864a8a21e6a6811e8622"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2f4c3a59ec86ef1e8f7377f3549ec212224ed5fd07d419c099a33c7c531ada7"
    sha256 cellar: :any_skip_relocation, ventura:       "ed09061b41f67b241871541be8867a507c0b63a63fb272aff4c65fae87a3bfdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a0aa8d0cbc2d06cbf1417d997f673924bc74fe794ff99ecb07aed20774c2e30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "671cfa053b40d2b87f747cfe0d6b4378558d204781746ecfaf60cc874fe6061e"
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