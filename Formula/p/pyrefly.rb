class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.63.1.tar.gz"
  sha256 "8812f78495ced3c28fcdcb9880c4b7abf6a4dae957af55896c158a91ce0e374a"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39a0b6dd95b42487c639d5565596b40031762eea5ad05198753451152c106111"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3481758d9fdfdac344ebd15d70d2df7cd4ad70bb415f1f23f2d39e71fb1c215"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ea3275d608b2280b7a8f9f1d753afaeaeb7a84f9afd4a804977091077f3e301"
    sha256 cellar: :any_skip_relocation, sonoma:        "d598160206ea4b8e04a3716699efeee435fedb77d8264474a560041df073c16e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61bbcb054c0af22f6be838a41e198c55d1aa62a2df7018e709fac50dfdf72eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b06b2b045973a3c94bf4ecfbaec307ed8b21ca00eb712589fc4a2021d2a26b1"
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