class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.46.1.tar.gz"
  sha256 "d4928108c6206792f975ef5d08e7bbf0678db5bc66d880d1f94d77917c318724"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8098ca5833d15db4facaa15c933984f7cb4c35a2f7de23e77a2b909334f38fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d152c066bc8d856fd47073471ef75c538315183b5a52197e353e5e050d41935e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01769a78c163ba95231b72736deaa0893c66c0fca21da8b74d0f781ae9d549fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "39c66329d02e01fbecb9508ee795429d35f54e51396cc099b7f922868a2b24d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ab172cf1a2ae0d486a2bdeb639b4f1827b6028691b53c295aa0d1292be5544e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34a6b921f487d51227265e368ec7d388b1d93a64403d79ffa39328084915b7a7"
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