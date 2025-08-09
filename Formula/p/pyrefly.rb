class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.27.2.tar.gz"
  sha256 "d79fb195f1f681b2913d1975eaea86bae6efa6c5f6ca3e0534987a3577a7e1ab"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "602c0009dfa9506c9a6b8dd69a916c748d499c078e8d56024db52aefd7d7cc12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e06d0520280ce6a2a4ecbf3b0d215366fcd7637595ceeec3694cfefd3a57ddf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab1fd003d753154b2b0c9c40da60ff5b8ec0318af76f88745cf927502839e498"
    sha256 cellar: :any_skip_relocation, sonoma:        "89a174cee1f96ad24216e174032225c5243d2461772798d9fab3ba5c1c88a390"
    sha256 cellar: :any_skip_relocation, ventura:       "aefc356e4e536f04603e2bbd50842eba6cc5b3a09aa8870c909cbd6d0cd84d66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aafd582bdbb5e9be34a737797b97cd9bb72defe633e61ab058080b566ae7a3f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93cc8c5a2e692a4cbd7bc4ed7c3502fb0c0c7eba19ff109b2f752058e3bf769b"
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