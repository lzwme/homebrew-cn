class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.58.0.tar.gz"
  sha256 "319ee099c12ba31fb68e286fb298f7ae7dcb85c10ab879246deac568b70fb2f0"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03e129813d7ce232265b8efba18ed4ebda29e5898a7212eacd3f0ec1b269b7e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "192de7815cc8a85ebd56a415b8c6936f1437419ccecd5a3dbb88869349d749e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f340a5ee000bcd8d56ef62d41c533ce7fab4f6df377374629b15c6b58244a15"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b8c5a101101cfdbb919e1902b7fad4503de13dc4e7c6b7974c457e3d6ef027e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c802f5729550fff967735d345e88907def7f84280a24e6851cb8a739b8512340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b27b889daea5e24f86a0a83590583ff5bf2b72a6411c3ea9ad318f99f9a05d9"
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