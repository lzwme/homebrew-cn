class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.28.1.tar.gz"
  sha256 "d7ddcfeba007c3cdcd447fda6a053997e45b2d4bcba08c1d823fc16a316e136d"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6b34a6b80a14b7057ffa04529518284350c92faa324e6ce11c8c6b58ccb670c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f3df1d168b41545ccaeebc55223579b3b17701c8a1b947ab1130bbe3d35f702"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17115afb0bd7c4ce1d9ff259c6775e1c2479a8855c40ca87d0809512d71d9ce8"
    sha256 cellar: :any_skip_relocation, sonoma:        "55fbfaee30ab974e7d1b4264c45c82d6d5e69ed85bdf313bed507fbb292121bc"
    sha256 cellar: :any_skip_relocation, ventura:       "314f6345af0867fec6ec1cdcb551fe8f5361ea49d27c28b282042d614ffe8879"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "049792b78f7943085626ab481f29b0fc116bd2b70336283a3493d253fa710a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb388ab1b228a43e7dcbaff35bd7686f5b3a6a1af561708db5166381aae5dbb9"
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