class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.39.4.tar.gz"
  sha256 "8af8324c7ac0c012da8878f02e260cd8fc8c104219bcb23ac3dfacac4b18a881"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3b7697f0e72291ff9806539edd0f357b0ed34bf3906aba7c8e005a5d36c176c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24723064c1d153c1cf4f8303ecffb0888e1992c8fb23ff40cbc95ac5c42caaf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83bdb0296fafba5b1dc0ff608da2e091a55869621dba884593c0d47527febcb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "9585ab0cd307d1aaad5cd45d147b1087dcbcf346869197f825e5267ddfb56276"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90b5ae44f32c1fa8eafa606b1756c6f8c0017fd5d5215b234aa2e05ddeb44c24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0461bb3941bc4a9b4674affa8a61dd4f9f298c9c2627b448398e30d6ac963837"
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