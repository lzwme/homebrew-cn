class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.45.2.tar.gz"
  sha256 "78a51eab7d90e83ee88308b31d16f09a7134cef9d337f5bc2b085d63ffad4b38"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8a1b2df1482e1eeeda8c1989d04f5d88b4f580d30f32f122348bfb05582085b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f857355e8d8cf7bbe1fcaba87ae1e120241f3b42571389552622a0fe159174c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bdea3f3ac1bf2409ede8f6075af4cbb328a38e14a76dcc8c0442c3c7d49710a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8806f24751d7301e28d2a86a1d42956de934fbe2878429b14653720933adde34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b04bd62f36e485ebc32bb5f80d51da6ff148a2a72cc248fa1862263634976321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0a80abc3523a4830fade764a1ea19510746932f57d5f0e8d3b2d87136e09a87"
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