class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.40.0.tar.gz"
  sha256 "4ff176c213cde3c7eb710bb075897bd0148941c2d805aabbab1cfb31deee4464"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9e840ffc993a3c9ef96b46fd1862f2818cbd0a2a74262ad41329f1c2edd793a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65e76cb25e9f2cd2265e8ad8cbb7e98e36a063075f0968c51d4a0af63f3ffefd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "588fb1918fac3904d052132e4dfb95cd36afd532a15fcb97016690dab6dd2f11"
    sha256 cellar: :any_skip_relocation, sonoma:        "989fcfe312c984b45154afe9005fb50c027049711fa9b62b61fb59499635f78e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd842d3d438f7928a0c3c12ff18409d4001c4feaabc77b4dcad4b43593aca21c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07df4f9cd398ab188709c24c7f5adbd5060066c20bb2cb292cc372aaea6ab214"
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