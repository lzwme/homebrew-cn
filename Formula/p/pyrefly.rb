class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.56.0.tar.gz"
  sha256 "5facd8d1fa4adcd69e7d4268ab74ced7836c8a7013b78aa7d89cfaed24621c06"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db5381b3b55eb18ee9bd6a13337e36473c1a31852d43ada0574002f589f31084"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e056bcb5d136d169f539644ad7cc50ce84ec9f1ec14770b6fd1e7c289708ebd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee993a89c3b498a817920405b985b36b3e40ceff15b052058b3276e8d943f0dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d26b3af3f03ce746679d39782eecd3cefc32975160e62f6afbe9a778387845c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be5925cd635db2d15dce2088555c4f974f8c24b88287173b0897b1829e166b6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "768b5e530c0c30e8a5f977c799a86c7ba5dd8709a8f93fb1caf5131260b45e8d"
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