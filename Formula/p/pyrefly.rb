class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.46.2.tar.gz"
  sha256 "ea81b19356f202e597a1d95784c19a06cbee98b02f6a990a393a97acc468a995"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32ce00b7a0ceb327d7c56cece29e7bfec04fe11f8279eae9b130508b4904242c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68a944474f3ca9be63f9f9903df8650ad1be68841bfa8d66efeebbe784691750"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d30305daf2cecbc88ce8de2ff004e661b1f3c09f193f5b1c175baa41826f8c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd432b373a37e89b32bdad0826d9516e4151d8ddec0c4f1cf6c2edbfe994414c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fc0b560e612a0f939b08b3a7ef162a14202a5a29cf301809737908d6e3dde93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31cd3e42a3c0edef31287dbc61866f7b4d961617768b50b4546b103deb1e5e54"
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