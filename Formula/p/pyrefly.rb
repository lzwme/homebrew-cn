class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.46.3.tar.gz"
  sha256 "47b8e095502557907c9cd812d19609c5e5450c867b19d35a043ea4432f6f6221"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13c2111000486d03f511e431a7a2ae0ad63f5678eebb5023cc56ec129f0a3e48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20b4ceb51e72fcd58c3d6e3beb8455d1c60a28ed855369d19bb37cc9964f84a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "599407f1a8b2cba8e4d26a73a9d9bca90c432afc0ef3498237734c65ca3d1e7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3745f9390f99c35ce3720373cf1894f0cdc3393ba7ac1476430e3ca8248c4d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cba4f65e696355453753cba2714d1ad9949397123b837b327580fec354595c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40d1e4a0bc6e0e06fe6a4ceba0db48915f62082caeaf136890d3d186e9b2a7dc"
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