class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.28.0.tar.gz"
  sha256 "8062700dfa652223c417b3f49d2ad652182e84b0de7abb9ea64f2adfc3978549"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9f31d33a3f53f253d355e0128e4030dceb84d666dde0495b6181b23839685ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d6dedd3d8a6e6f001137591a1692a33212c03a9214b67cb8a152bf1d72c5e6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e966d12ee992bf9a4165c908aa7030320b46de28df575969d73263646f753551"
    sha256 cellar: :any_skip_relocation, sonoma:        "1298d09c2cb7c6af1bcf56940681e2d30cc9e5aec136237431cebc453dbf6460"
    sha256 cellar: :any_skip_relocation, ventura:       "55fc972475e56537e9d5434b3b9a87b2c13f32c88c83a6dc876885b1b154d5cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14ae5ac2f796e392cd8b4e5ee7cee5540386fb9e0a24fbd4699d0337c8088d8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dba69ff1f7a37924580aeb1461c37248aa6947f487969ebca16f12e3b5d61709"
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