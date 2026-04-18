class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.61.1.tar.gz"
  sha256 "3bae471babc2073f893563d18295a385db87b4a592492b01cf21c93798295be6"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96153509bf4faf1210e50b7bfd40a02ed7b460a496b5766c0ff0d6084495d87e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f85ed09a1f01cbae32412a79f6043df6fdd696b922bb73fc656a47aa48174b1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee2606bc9985e2db3d0ecb562003942cd8f3541dcec13325850f7d919ea91f3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbd9df1b7ed1ccf62f4828081d9c74143f5506f8a848062ee1ce7e6af166f87c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09122a13de6277ab12e6da6d5bf86443aac912a93d89cc1c263586d9c5eec805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a032ed094ea49e57d94f37da9d04acfad35daba6753690138d26182e78ecc3a"
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