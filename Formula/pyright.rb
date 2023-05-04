require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.306.tgz"
  sha256 "8d417869b8f6f632e4836710f2c11764ccee2afe9701b1ded1b7355e68afaf64"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49cfbfae7f914d06d00b044467b7cc72abc4dcb58fb7d81e8ec2537c004ab683"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49cfbfae7f914d06d00b044467b7cc72abc4dcb58fb7d81e8ec2537c004ab683"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49cfbfae7f914d06d00b044467b7cc72abc4dcb58fb7d81e8ec2537c004ab683"
    sha256 cellar: :any_skip_relocation, ventura:        "14ecd821fd1a71248911efd95bb5bdb178ca75313788418451b8968b4c74dc0b"
    sha256 cellar: :any_skip_relocation, monterey:       "14ecd821fd1a71248911efd95bb5bdb178ca75313788418451b8968b4c74dc0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "14ecd821fd1a71248911efd95bb5bdb178ca75313788418451b8968b4c74dc0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49cfbfae7f914d06d00b044467b7cc72abc4dcb58fb7d81e8ec2537c004ab683"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match 'error: Expression of type "int" cannot be assigned to return type "str"', output
  end
end