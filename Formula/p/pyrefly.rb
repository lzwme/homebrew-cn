class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/1.1.0.tar.gz"
  sha256 "4fc08636a81626ae8b096270bc9d4a246b085e57ae3fe2f3fc30d36a015c2afb"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3708db486469f3e35668f00a9e90f7581afa1b29e32872cab29632cd56af4a24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c2a50ed7ec012160e45d26783d35a059454714a1afe879bd3dd7454c75f639f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4301609325fe5191f8a85344dc661ec2aa69f263fbdfef807145cdd9fb1861c"
    sha256 cellar: :any_skip_relocation, sonoma:        "257d3f32218c7fd8b22758c94c38650c18719abf7b56dbfd3f4cb06055db2640"
    sha256 cellar: :any,                 arm64_linux:   "0597ae05856f649b78443fe9a5e62c07b0fb87f3df283fbdde8c0a3dc2024e81"
    sha256 cellar: :any,                 x86_64_linux:  "89f0d8a11b2f5d7bf40cfc06fb3c1309c0cd25ad041dbfe8bc91ed699c6b8fe9"
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
    system bin/"pyrefly", "init"
    (testpath/"test.py").write <<~PYTHON
      def hello(name: str) -> int:
          return f"Hello, {name}!"
    PYTHON

    output = shell_output("#{bin}/pyrefly check #{testpath}/test.py 2>&1", 1)
    assert_match "`str` is not assignable to declared return type `int`", output
  end
end