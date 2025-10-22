class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.38.1.tar.gz"
  sha256 "13756211f7ebe2ed270b377d4c4474ef1e8150470edcbaadf983c1c4bf8253e2"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b67727c88a82f1d9a0a3bcb28d66d1545a5fc817d14ce0ad91f2455dc9f49d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efdc8cfb4fd0578851053ee9c057776be8c22aa60e205e555eb2bdc082f04acf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9a037092fbfa3be98b15549d558655280e0863e33c161d0f186dd35fcd22c00"
    sha256 cellar: :any_skip_relocation, sonoma:        "67a3ddef6ab164d02f252d9735c69954f1d9b50984a0f51dbef994edf4cb5f47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9baada5d54861cdd5724513817fe558e2e863d4c19aec6a669126b2c11417384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b5a6fb908b0e7890d5916b4a3382b9f38daac95e804c1f54644ecc3d3f27f99"
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