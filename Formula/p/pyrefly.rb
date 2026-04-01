class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.59.0.tar.gz"
  sha256 "a64ac380c6b2324e1f888f71943b079e337ec326ffa28f6175d320629d28e617"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2afa807a1c67e7cea8b725172015000d5d20912f6ec09b47cd5d211e308faea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8da162b72edcb2ea8bfe6f041332e5aab283b5f35e0b767b7ee8f1b0434bf32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c9fcc141fd6d2c731e06a68f982b6994f4ea8b0e9a06624e24893f1985464a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c751b759e40457331a23769893dd5ea33717f5339751a0bf516d0f6b28137f87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb6ca08bb0f8b5a4fb3831748763846098ef574ca754059198c12e4e1c8d1598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1187d1588a4622db2200030bdee7c3978f74765af429c2684880f7aa33110f8"
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