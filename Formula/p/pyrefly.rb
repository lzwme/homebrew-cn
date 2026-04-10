class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.60.1.tar.gz"
  sha256 "a2f0b2da1c82efb5b7c1d724f89851742e05df812128d470dd66ad6a1e642e7c"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b72ede4b3ef8dfba8170756c1f570495931cdc91d0ac92c04242093e9b9d236"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32e8bf8ff53b06e1c1b6e24a6f577650d378ca8d95370821e001230d849cd512"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7dec1263ec5212c5c1f8986b3f6db129077b28b353482a56834ba35496f3201"
    sha256 cellar: :any_skip_relocation, sonoma:        "863a9feb290e008c020d510930763ff535b1c192d0414ad8337bf596482d7cbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac3cfaec4847834bf1ceaf888bb72239ed856d621ae48828e5cef55109c693c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4e7d1f57bfbf214e067e0b62d77c91f8122a07df2913ab2ad4dbde80a9a4fb8"
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