class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.31.1.tar.gz"
  sha256 "f42d7b6accf4bda120345bcffdc04f49b4436e7c44bd0f9f17f4230cb3ec084f"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd85425fd93ad3528ebb3b6e2920e600593e0d015a963414d0021ca922c902e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76d450c45b7f3934f76be559ccda9dd593636614f784d9988660dc2ed0bf5ae1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b13904d0c4b682c369d99bca8eb226f5281cc725560b88a70e011130ae515e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d8b5cbb89c4e6ba94eefdd82c108696b89d12ff3d2cfa6ff37087ec1ed21639"
    sha256 cellar: :any_skip_relocation, ventura:       "4b8c71e657d8db3fd752572a95e2c99725d807e10e92286c7817395be7c33560"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80a48ce1487d162a183c818803336a81f77933600100b3842fedc19260d2409b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cbb94aa5107a7501085066cd8228f291b25e18556f7d29bfd577e8af477eabb"
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