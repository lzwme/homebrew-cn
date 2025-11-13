class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.41.2.tar.gz"
  sha256 "250be62524d0fd76fb5255f0643c23704a326a83c6061a32a76fb343990fdf6c"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c4d751710465b4a5c698b7f091d68b002a3438ca842300f39e61bbc73c97bb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01206fa51c0388db0f65eaccba7615746925b162d772a1c0724230abe5efde04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88f20916cfb9aebe3b04fcc0ac2eed6cd68648a6cde5e0dc27cf61fd588ea806"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e702ce3cb4144b7e95db78ffea9eac32bb028468893d046a568e32f121eecb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fa392c12c31fa48362a4604790025ae5a28096c8c92eed9e6c5155de5a040da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d62af9906415d44a4202f203376465279a8c233607073d1bf8fdc22382b5831"
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