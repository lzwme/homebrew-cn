class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.57.0.tar.gz"
  sha256 "df60a2b39f2dd0603d0ea060b1cbb4b1a47e1e914245071bbb992d703377fbbe"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c057f6922fde19162aceebc8b6f92be73d4776eab1bb72c7640fd3b0927d64c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85a393c9d231e055e35f9433617c46bd625cf512e864604549b21b7959907d77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ce24abe91fa6d355920701c2243e5e49c2c3de2e1589ede9ea2a096a571adec"
    sha256 cellar: :any_skip_relocation, sonoma:        "a447a92cc8b377d22a19bfec9c2f669e0f36685f8ccc5c13a89415dc6c07d0d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3aeca5668f73ce1892f37d5615a13874516c1227f9f7f48bd8ea83a4a7ced184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dad968c2d9ef664cee4cc57112c6bb19fb72f46fc38c62bf25c81ebb27a975a8"
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