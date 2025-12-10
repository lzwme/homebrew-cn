class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.45.1.tar.gz"
  sha256 "64d010ca80558326677b877cab1617d80040043c450e7b8ec0c66b34296a2c3d"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "870caaeff27e1c62f3e5ea34680caac13598f92c06aba1d3eeda9474803ce950"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf907f80ef1e92bee3c48874571de745c559342f18cc5b55065cb5bf02b8869d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ebe572df8235227f8ace62a2f6a26335c56e476c1e1c1e3d56b04a4464b671e"
    sha256 cellar: :any_skip_relocation, sonoma:        "455eae277ee45a93293e29be0f24768a4a0910949aebde7a2255db8757283d6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25e2af472a34bf18d28effee34150ab793c29b9214ea38c10f6e0b3f7bc1ffc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77dcc38189bb80ec5af44d96707ea06cfb524ab7f0b35aadbcdcf65e0aedce9f"
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