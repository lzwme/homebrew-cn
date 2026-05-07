class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.64.0.tar.gz"
  sha256 "f4d1dec27ac479d110ccd8c1cba91e4762a0290582318e42c7a85d6f7e8a2fef"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08c8f164b07c6997faef93efc18b2376d9f5d314dff4b49e2f6fce093b55d620"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b483f718bc4e27e4181effe1ce1be9171562e92ce92b34e79e9f16d90b2ffb76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "187d2dd9fa188e43149585707d20fe5aef7b0dece56cdf3012b64d9ad508872b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f11295302067912ecd9599f1b6c6fcdfa8bc056f2018ec0586a6f5b7caf76c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3ed2f77c539d47c4b3aee18aa3ca38e8cbd3f8d0a90e2aab62e01f1f2f82388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1acdc1cef39b580b4fb25fe2ccaa48a421b8e1df03d0495055b8827fc00d6d56"
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