class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.39.2.tar.gz"
  sha256 "37b29d0aeb00c13ea2e764f7f8b4987960492af764767d9b155715b3de1bf7fc"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2c5b89b6beae5d4925bfc0d4ba824c56332d160104d1d92118e6e991ef65c93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f75c88474b87a9bd6f9a6d89ff6e2d84f27741c170c95409132dd6d468f1bc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18db97b2a9534bd302b15f9582ce8a9b8f12345006d31707e47942e1fbdb8a3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "915aed0e3ad54a0315b15153856c2f98f0b888165e5b255d19a43d1a60a9df9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46e6f88ea3e07202854b6afe4b8510cd8132175a6ca359486578edc34c27c3e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2036e8e9b1bbd1d8f7a3c3afa834e0cc13643ca83500430e5fffc7200ca074c0"
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