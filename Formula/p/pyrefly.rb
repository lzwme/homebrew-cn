class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.36.2.tar.gz"
  sha256 "c6e31e4517ecddb733724fbcc4304b623d475fc1a8a51da108449f1cf5ff33fc"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43b59aeeefc06f222215918712f4e10fe33546d0e5c1285877a604fc7c802c19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "960994659820df8ce9bfcae430a0a4f0dc95833c79183dd4fcdda85d0a0ea067"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b408f22e2e0eabe4ba1e3104edb76ff0c5ee85a8a49e2c6b0efd1d4478f7133"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e25590f1b44a3e82395f12e01ed09a1912ffceb2015dac3b01f4ecbcaecbd77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "961a4efa1114e8b2d7987e518983ef836139ae5f4f1c1e8d424f27da2795e3e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84bd471401dcbc710b09cd8d1c00a80dbac829c49f20e317a1c8c3c038c12d70"
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