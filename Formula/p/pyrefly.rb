class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.40.1.tar.gz"
  sha256 "bf20b3aefbac2df45d305c7b0536070fb0b25b57d2129059ebca0dde0104e72e"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "602f3e94cd55d72f94defda38388cafd90818b2828a10a2f196f1d88efb7e7e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a5d46d34c8b23b80a7c8d656bee51478fdb5e51630bf96fac2771d8cf74a124"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "830721d963aca7a56c01dbe8da0f636e819dc0fc4ae2c3dac280549d226e6d54"
    sha256 cellar: :any_skip_relocation, sonoma:        "21f9df2630e0a9bc744b99e05000bf7267a4ac16e9e49c9c0e7dceae0f2eaba7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "855e0f3ee086be861f693fb9a46e5f3aa5dcd3ec597b88f39f08bfb9adb95774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a1a0bd16db046662ab58933073778398437b866d8dcad0ca7fb74fd952b3511"
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