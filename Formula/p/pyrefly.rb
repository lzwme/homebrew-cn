class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.46.0.tar.gz"
  sha256 "59b3e08164d28e6dafd78a854ccf5da6c3afd4a4b5621ec1b687a30a69e6ad3c"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15c4aad584775077cc1c5bd6896b810b4eb04d37587d0a9abd55312f7306c831"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94139ddfad2e7a1c343374b1cd56c92b0ff31dd54dc957a4698777d0715fbfee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c9523ab2493f9d0c93628ab11eec9979a2cac50d9bee5eaea4a3ed9023452aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "b970678c5ed9a5b632b140460e310a8912571e5493bc6af863c77dc7410125bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48c71e7283e84b522ac486e1fc6f701e4124561da5cc0436b06eafdc9b97bb2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c65a02a2ea2dd969a505a8e47651d457708e62a75643db4a2f64fceca128d19a"
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