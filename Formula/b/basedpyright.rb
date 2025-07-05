class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.29.5.tgz"
  sha256 "cbbf4105ffb03cb4b0dc8a41c795e7954d6dc309f7bfbc39a8e7a2ae6cf15997"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec396bea5f2e0c1d8cd69b19047511bb19272399a145993c949cbf82d843d66b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec396bea5f2e0c1d8cd69b19047511bb19272399a145993c949cbf82d843d66b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec396bea5f2e0c1d8cd69b19047511bb19272399a145993c949cbf82d843d66b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d0c2fd0d61a1ca5bc774530f74c338e180090314850e19c8ad2cef1fea5aeb1"
    sha256 cellar: :any_skip_relocation, ventura:       "9d0c2fd0d61a1ca5bc774530f74c338e180090314850e19c8ad2cef1fea5aeb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec396bea5f2e0c1d8cd69b19047511bb19272399a145993c949cbf82d843d66b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec396bea5f2e0c1d8cd69b19047511bb19272399a145993c949cbf82d843d66b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/pyright" => "basedpyright"
    bin.install_symlink libexec/"bin/pyright-langserver" => "basedpyright-langserver"
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = shell_output("#{bin}/basedpyright broken.py 2>&1", 1)
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end