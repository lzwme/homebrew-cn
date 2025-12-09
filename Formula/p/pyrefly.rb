class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.45.0.tar.gz"
  sha256 "e774707063d04f5206a5c6e1b627eb614d7d6cd68ae0329918366d9b2e70c7cb"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b17306846579cc5166fe536c590bf2a29a24ab287b77d264aee7596760d4e002"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ff961cb47694808928d8596ff7439b2883b31cf8be67e8af4e5f3e4cc6d426f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0acfd9efaac121c34725c4063e00b0e1bff80b195cf134e45a5c0a67ce0da20"
    sha256 cellar: :any_skip_relocation, sonoma:        "68338bbf0d777e9dddce5161afb070ad7e016df33e5c0467091a3e3b565bcd81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34f29b590ccbb679d5e132bcbd362517dfcd6ce88aa286573e3ffe1e99c81bc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "973e6fe8fc549b64ed24818efcc76a58ddec58c0b7fb3f04e9189bd14ffdd7b8"
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