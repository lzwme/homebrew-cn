class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.37.0.tar.gz"
  sha256 "3a17af1d18fc4309a72a71a0779f895b4063cfe8b4d7f10095282ca95885877d"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50950cca556e4d8bcdfab4f80cdea6a60841d4afb8f8dd0e0814248cfb285363"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e6f4c04e0c3d47e8f81b900c2dec7fe04bc52e1c5858f16f7ec1ef1e288af83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9474d2c4a04f27373e171108f2d02a77be7ac6a8754ac476cfb123a33c89f010"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd8d75707d63f7815b6d0d5a8d4c8bfd04b1447b688f32eac5911980c105df9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc0952342142d7e2a049d88812b7f333aead6b6e6704dd1c82d27ed7c83e8ea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14a7ac826b1c82e85d6440ef3fa47fb54501b8d324bf74e3748cde82ec77467e"
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