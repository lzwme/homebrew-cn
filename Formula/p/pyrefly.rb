class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.44.2.tar.gz"
  sha256 "b250b4c2d808f83404926e2b0825bb6ef127768c34048c3afba97ec526ba07f1"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fd760888f7b11eec846288aaf2f7247618a7c24c03b431f23f4f24fc375bc2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05a2cb27c926b9b2a181f68715941149cf9413c6009d071d57ba1aa7f20ba6cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d000a576c2676290dac65ae61c81f575d53c1430a529f0d74d9260532b6abe5"
    sha256 cellar: :any_skip_relocation, sonoma:        "947969d4748a9e3dedbe62b6c91cd277ca249cd0871b5e072dce82467139ad0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ecb2bc622d1722ae818453e87ddbe145cccbb53b80d92d8131a068954e016d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dc759588ead133740798fa563f1782846a267dcd451b6caae1c748317c2da84"
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