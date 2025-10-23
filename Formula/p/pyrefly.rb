class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.38.2.tar.gz"
  sha256 "d8d3d4ee94174a6c4b2b0ee6d89668875e86bae14553a6ccaddcfc590f34e988"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6132b8aca941a6508cf75e39fe75df6a05e18e58ecc5fafae45f789882b58c73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2c77b4d21948a4339d13503769644b23aacadb41b61647e0c35e45b79058e71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2a3ecce4eaf850153330d43319f54c9a5dd77653b61fcd27222fe0b6b3d7134"
    sha256 cellar: :any_skip_relocation, sonoma:        "422171c6412af2871b6db00984435a6d89804a093ab9db37a6184c869de81e83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d727c9bf4fc8148dd497bf599e50955954d33cb0517500dd70149de445ea033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b09590f9e6824a746661c48db947938146cd41bfb09f6d021795bfa676332926"
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