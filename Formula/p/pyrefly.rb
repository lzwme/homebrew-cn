class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.30.0.tar.gz"
  sha256 "1c6a0d710eaf49a8a26f94b16c457ec7d78e381597c12942ff4b2fa29dc25cad"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72937130978e11c4963ed1c93aa21c841be16d5e4b06116c38541ba0b65827af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8b99031087f176d523d91842193a9b09614deb0b60f5be551bc8ac16e57191c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb2b68448ee08f23b5432db374a20ced168f13245aee707fb9bbf767b3c7da8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dacb6e4d5ecf5928327a8bf4c76f0540eab7f522ad31fcf18da174126f2466d"
    sha256 cellar: :any_skip_relocation, ventura:       "ac17ade00d1121d5ba810e89fc5f190f323cfa007882960158b5fd8e449b50de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b372f79719a0bb7e9a5b6b44db924bd118d2cac4e03e0e5857aa844fe4029e23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3b14836591eee26cd0b65886b8d1f21e3329a0f7a2bf5a0b0edfb44f6a6f6e1"
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