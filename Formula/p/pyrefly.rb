class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.47.0.tar.gz"
  sha256 "96f6c63e7a15f753357def7fc93c2a0950879abc96b6dd40c4052e8304744a93"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d6aa1f808eceffad1da1d645997aaa84715c8a97668bf3d9ef46c485ae2b08a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f70221ba6b9fa51664335831d5a6ea03e7a798cd858f8457109c926fd2c85e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39f767c93dc2d994bd9b87cc8dd01b4d4c5ba855ed8a08cd46b5a4a03159f3c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "274ad8b916835736aa96321a5db3d9e4f223f91dcac4b5f0e36ff2469d71e484"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79dab0a573d0cacdb43b7d340d53fd085f40ddcdb124e1633ae193b8cbc5bf55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd7282c3208ff52049460b41475cd21850f3b88783010c71914c109bd09409c8"
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