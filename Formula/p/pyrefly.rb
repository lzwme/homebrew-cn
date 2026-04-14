class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.61.0.tar.gz"
  sha256 "e8b77c4eba9c40a4bce7543431febb1b238bb881ab9b24908229d2156e31fb2f"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ec0496d5114023344fd6af53918cb034ceda45bfd6ad431ae47df6a5de6f5ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "116c605f7e1af46850f053c2190b1932e4bea095c305f7775c0030c7b7140f77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06f8c82ac98f37a27e5ba713768ad16e5bc8919c0528478f67c18afba6399cf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3be564949cee13485b7d2c4a4a8af59595eb9a588f5abff9f4075c77a95425ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bea8ecd889d1ee913adccc91d6a5c3fd24e314194b39198ad7e8f2d574b4f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf2852280ad9f3b25a08a4f758244a5f7c1dcca3b49ded19edaa64b7b1d4b399"
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