class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.44.0.tar.gz"
  sha256 "3b69155dd8769a4c7375af34c43f6546ab17912037ce27ac40b8f68801b9a403"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a23b899c95ce96571991a256f7adcae9929f07510233b93329734b0f992a4ac8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58302f9e72691b22bd83acc977796d35ef21f9b1c93feafb23a021d947d95c71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67e4889e85f28113a4311e1c937aa11970313c01d2fb724b35786995abc5a26a"
    sha256 cellar: :any_skip_relocation, sonoma:        "22e58bd88afd5996fba93ec4c47f41d5f8ffba27c5ef08db5ac87cadbf00935e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01c3589706d8de0525df3789b35fcd18610a09d0c1cf8015c37807ce1010aee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f49af64fa822eb6f034480d4a35a493678b3965142a30f691f53b1ea1c3ece5f"
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