class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.39.1.tar.gz"
  sha256 "d8460c9033ba50ecf893006f8a0eecc525fce5d511add70912bcf2ce4e96c287"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37a92a749a578ccbb41549c11ff93493a10ce4ce3787aee46424c3e7f7bb3541"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9634398cac218cff997ce1d4350fddff2f232311fc365da965f54161cad6dbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a92eab54e5a0bba6643c4aa66464d66def0d69cdb277503575d29ae24f56c44"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7446d858c5118ffcd69c34c5205d04f752ca6f17b870953d41dafbbfcceed3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "badac94a7069e5c060d86b4dca2161a8aa8e142185c64c44d3dbfd2dc8e7c301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0de013bcdde5562333d984fe353c5e36a7104f98c4577b258d0eb90754f27ee3"
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