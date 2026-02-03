class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.51.0.tar.gz"
  sha256 "ea16aa539e18906d60d9e58e444869e097f49d01681513ef6278a0f1c80d908a"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f5f13b6826c5b86f30cce278b98ec9360131f7bd2ef522e1f753566fd40ab02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab2ca457853711e2825572b7a0d611fdca4ebd55a08074dff339935226136cce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87cbeecc5481e5f64889bcdb3a92411c9f968c229cc533195ad4fcb8d98ab2b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4803f28410fb87d1abe2145410ab064a3495623dc531a6a1c5a7458df6fa45c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c681615e48e34ad5674f3386a2d85ccd13060b485428789af327b0362715610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c71f378b971719aaa055eb97af8a000d6dcc248d610219db634ec4dfd01dfb3"
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