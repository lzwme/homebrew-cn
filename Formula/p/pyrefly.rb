class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.31.0.tar.gz"
  sha256 "1f17ca7422589b7974ae57f411675b3780f447f88352cff9239a4fb02069f6a7"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3a28f028941789431bd647769e2c6bb07a48f244c3b84adee65a620011b7036"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90fda81310d569cd4d2723fe0806ea239cf3784db1e25d7707773446a62b34eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38ecfec3ddbc67eec634631f1cc79b319bde8250156083b6a1081d69112ca0bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1b4408430cbaee6a2863de4140d5570fd768c9d2db574ac1e745bbfde3cd96b"
    sha256 cellar: :any_skip_relocation, ventura:       "65a99aef9b60dccabe01594ace8106039874c26fc4a08d755acf100f8f56b4e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "981804d7fe98442d41e3c77572b30d5ff46169c935b13ec641f5dcd70f055cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e65c6213de27f8d9c5810aa5165499012acbd265a525c7d6a73fc4706995ce92"
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