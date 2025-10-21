class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.38.0.tar.gz"
  sha256 "288ec2095cb8249317f4417d7697c019aebb44e7bd23d1a25634f0418b2d3cb3"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b550cac616359dd58d167a3e129bf1c3190aea25779816465649a0d881c9e606"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d681abf3f64448a6b7f93689d8782156b519e14ce089790c5f98d52c2831c00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6d38790b91aaec62b48c4704dc6ef5ce0d6ab25280b80b61fa797ae621c05d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ec0c793944a0d28c3a8daed272e97eb7e67d1b3ceb17459a484ee0dc099b415"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "613884053853e5c9138e6a4dad4cac8656cb07150c30054fb5e040921fc96cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d1e88224e8f6625ac388aacb2d780d8f6814675fb6373d21024a059fda50323"
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