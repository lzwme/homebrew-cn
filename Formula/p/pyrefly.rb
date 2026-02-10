class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.52.0.tar.gz"
  sha256 "c07db9efc130e7ecda097cd12c98c30c7189ccb011585a31fb204ca0a7d449f2"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64522965d2798d477b640ac9262bf9244788a3db75dc5d9be1a4ea6b23b52547"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1478f338bdbeaf222bf0ecd8b7be7a82fd9378d76135d23639457805f7ee97d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36402f17ca65d176153272f7cbd3aa9d43c2bc5f697b2f6e45470d9bae40c047"
    sha256 cellar: :any_skip_relocation, sonoma:        "da2b39d3c55a880ef3882474ab650eab4c78de39c398a5fc50e05582be0fe11a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8c99fbf15214767657d9d370f288624f0a7e410e2e18396e8f04334c8c9f3d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d21ba1438222222ab25707510c7e2133cbb2e6b5bca45ec04e36e83babd9061a"
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