class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.59.1.tar.gz"
  sha256 "bcc435521c0801d5db0d19f872fbb6ebf26973f3e162ff66ed6ccddba17bdf41"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67bea78f26b685099c42c74bad40d1a47d7bd89baf0d3beddfc90800a4d0c844"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02f0ba6f0f1c192b99ba3b3a20f547f364f1527d67446fd29100539a1b03b231"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "107f5ad10689dad5a4e0342b8627abbae94d6c71fb5a5552c005a0b0c37468b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f998e4f41ed4c70c619f9947ed4d2bc100c548d9734ed1cf30c912de0b4f261"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d6197bfbf77837662411d267583e3f03de95f6052f2562b76059ec085d5fd0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5ae84712e1c06c5a02daaae43871cc23b8c221b0650ad2f3d8787a2c24aa0c7"
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