class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.48.0.tar.gz"
  sha256 "8c56f40afbc30078534ec792753745e2118a36e668ffa8b61ff979b3b5dd0dc5"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8584dfef4068ef9cd79780455c7554687afe21e6c94c8a2c7a5d861a9960ff38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2927d725141968c660c3193c8a43fba503f72ab09a33bfe3fa3eed4075f46c6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f0a6c1d08fab3ca1225e048ae027bd52de41e8c0d7f57c8392e9cebc9f9d02b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffa2b03510e33799984e551bca4d6fbfdd078a02cdc55bd0768349199302bc7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69959f6163b1617017f7ba058288fdfe75bc3debd4822c1dae9aad089daaec3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ec0edfe4f95b91725532ec174c4d7668cc6016da4485a4128105944a08a5f30"
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