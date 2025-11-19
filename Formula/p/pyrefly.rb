class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.42.1.tar.gz"
  sha256 "709855106b5828f38764d3c59b02d7aa4f626216c1d82396769c839e0bf6932e"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df52560bdbeef2f6d44dd6ea53a428ab34da34bf990172c103f3e3db3dbcf5cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f16547c526116f0083b9ca03c8441d8e293fdd124e9bd1dca9b7a5d72bda3071"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a057686d421b71a6106069b09ec658877a5a7c7976ae069ed7855943ac89a1dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1855f87c5d42f719136455b1e07165027f1d69530fbfb4f7d5cfa8ceee521175"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a21231df057d59f9764cfafff29d6d7ad925d0f1d02230a3372c4458f46a39f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0d896fd3ae521a3df23ed18dddfc0fd25659fee0bcb856b4f4ec835c32882c3"
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