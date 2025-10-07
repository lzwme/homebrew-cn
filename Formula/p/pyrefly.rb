class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.36.0.tar.gz"
  sha256 "4f4205ce4b29a3ec3d32a8a920997c99ced843ab72d58fde679b017df0db547b"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "113b7902186634d6ea2a80e84b8234147c1eb27032701b15102b954fb1aebc07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0928b48814a405bf38c61829279908c535276133a6de37c97f5e9796217d619"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be6ceba03b09f2adb6b3d4e8b416a8c9199f3a9e72efed058b2c041ac7b6c730"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3a9202853acf90c98b328b1c8f95e4fae4ea8166fe5a09fa4598fa1ce0e6536"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee4b375eee46db6b9bd7e7888dce5f15d0fb0275ba4b48ce1e20d0b842b8524d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e6eb0bf0842decf65e868d1c5b637541a2877114f5df75fd24ad5566022077e"
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