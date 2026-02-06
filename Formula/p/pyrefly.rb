class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.51.1.tar.gz"
  sha256 "002f7380b7071be5562500bd9ef48a35807d104e669575faf37845b901cece50"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e1ac14fa783e50bf14ad97536d0322d75257cde0a438eed8f962374c7b17291"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7501e2d6ba499d0f91926c4e52df7f4d277deffca026d44693a25b0f606a6560"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "887eaaea01fcb08643a112205d25a6d43281444da3800b509d16f56263fedf4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f27dab3a79fa96d5474af2d8077827072a4fdff9f320d541040a5fed53c06c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d4d55deeb77c37eedb751fc9b4666a92a508b37289ca40a8d9f899112e5e0ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5878e525080289ca82a2a192f535df99ac285cf3accb058cf87c9b878ddf196"
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