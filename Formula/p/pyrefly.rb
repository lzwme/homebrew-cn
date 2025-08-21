class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.29.1.tar.gz"
  sha256 "50e780e491236c484cf0f32260aaa1f43ee52b3cad9195bd3ccbd56648fd278f"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "216a45884979b7ed1919aff9f558c5b74899f6be7e52fe4fc795103962f3f991"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc19aa6b27d43a79b7d0d4d4bf2c8afc4b39ed1e3882a8f33f3afdda764b2e6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec366b8944de3537835f071b5c94bc26cdca8fcb6aef4bae8281590d1112679c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ac02cd562d6e7755db98e91ec4794c21574b91b11f422b695fe9e54d980f8fd"
    sha256 cellar: :any_skip_relocation, ventura:       "55f0cb352bf1b1ea32ba1b2a3b3f2ca0a11b7fe84ac1eb0c877c8dd8d2519183"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbfcde94055edf2c7f31eacb92ce30acb8e46aa6dfeceaf41b1e9e91fb1e9ce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "149001ab267e333d6c2bf4e8d292203ce43d0f8e87a3d1ae66f8a200a840fc8b"
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