class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.29.0.tar.gz"
  sha256 "098b4002417f47ec7063e1c9d78861640513f2ed61c5e0cf96c393d143789cb2"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "049baba0d370660a9bd031897d3d22726cb31465b0d1f60b66b55093b076cdf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32da3ed6a623eab6405dd5edd51580f365ba294e9178d7b6ce4510c4bd9f99eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "767e6dd3b3b8d12de6dae982ee25719152e4ba4214ddb515f9a04f8ff97ac7ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "994504761c9f77631bbc8727b3ac5da6280221cd5e522c1601ea9651105fa48f"
    sha256 cellar: :any_skip_relocation, ventura:       "03adbd0e983144d17fd656bd465bd6628369e7269afe179a348be3f035468a1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0c24b8775826f669c15c64af7355b5994741f5d1883d669544e0b787c9fe289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e763b951058905c255e80e889f0b8678a90aea019d45fd1002b500ae9d15da86"
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