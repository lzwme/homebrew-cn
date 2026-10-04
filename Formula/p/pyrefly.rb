class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/1.3.2.tar.gz"
  sha256 "7da05b862497dafa3d34e7b574a9954f4daec71fe8423eb32f3765982d705b10"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ff84d77dbfa4beca5e65ce38b91a8462b0c3d2e0564c0a8074bf60c21120b951"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c22299efa2b12801fc8ff222b6b3bc0ed869ee1bb1806cb63e5230a8a77e58c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d2e530634d675dad2c52920508484711bdf3c56de5b15b655e6792f709ded6bd"
    sha256 cellar: :any,                 arm64_linux:       "c702381da8b2fb81c01c1902ec54fa656a7c383be5fc95d5ab54412fc85b6e65"
    sha256 cellar: :any,                 x86_64_linux:      "fa834b488910df012b1923ee1e538ff9145c703e2567d7987cecbd03aa2c0da8"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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