class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.42.0.tar.gz"
  sha256 "2374213f049db46697040db5872b93d105b35076bc5f4a0570c52401a06742e8"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32db1437c295814cf97a12f5c570f4954bfab8dfa4f286182b0310a894a99cfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ead26161dd524ed897f373f0a6d3da71c0c6e17f38006c2738bd7a93e3d28fd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c7187b695806c1dbe49f39da8d770f3650298be41b180756a2e104012c29dcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "933d92263896d1a6f73129009e192e2169a9c5eb322a0500102f0cb3ab5bd523"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6af0cd20f3f60f059bd008e365b667f1bf8fed934b7420f85424053913ff9a45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf2b25fbccfb49565c4a895afec9c6d762a32573c84edc5e80848d1aeafe84c0"
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