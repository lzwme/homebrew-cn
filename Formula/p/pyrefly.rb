class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.27.0.tar.gz"
  sha256 "c0afb39e1c9edeccf24c55a37ed42d2afebce831116ec3611835c50ff3956589"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbd80e36088dcf242e1187c6c5ec2927b36885b76f124541be974df634d083ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "938f81f673d96e9b56644ca0897600e1a1ef9137fe2c195379c23472b1eb5e1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6f7f184f63efcae3ddffd1cd3919c059e8d751950b7997f6e8894969fc5feae"
    sha256 cellar: :any_skip_relocation, sonoma:        "015502f863e8a9fc4a85b4d49b80c07f4c713c043a579ee658e49164d8498e78"
    sha256 cellar: :any_skip_relocation, ventura:       "1533472bb9ad4c56476f78234af0eaace6709c1f11b3cb3b0f4de6059caab11a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bd068ca9a4aea024ac08e2228650bf1eae61b8c43e36fb07ec864e6f0dba966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dee24eee5597625851f3cb497504328178b2195f73ca3aac95721424f96116e8"
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