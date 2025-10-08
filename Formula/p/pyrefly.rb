class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.36.1.tar.gz"
  sha256 "3231478f0aafefd2aa21ab056f7d28749296e6facb72b2f887c7ba56cb1e90b0"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f4e131f3dd571970c1c7a0612c38f164eaf30e0b47185eec5f1e58b7105e552"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd81e872b5bbe1ae6ce48d983e3263f578ef2920b44b2f44dc92500ac3f21e54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa6bb678511a30294f47ab612dd3bb4c986ee9595fe3b09c0343c6900495e597"
    sha256 cellar: :any_skip_relocation, sonoma:        "20cf3973edcc4ffab649a0931c0b88feb45946747d5bd0e2ba2fd631ea176929"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d56c0ba2a3feff4ac36f2de82f202ebb00028768bd77cc7fe6d49e522246c4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9cfe3f86cf61f217ffaa11c8550a341845b1ed52df82dbb0d4007f0e2abca84"
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