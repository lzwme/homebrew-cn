require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.302.tgz"
  sha256 "4a8d881e5e3bd916ea32c8f2addcfa17f6dc11ef2fa88d1c9d36035a5efca518"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e57b31419c0cfec3e0d9bf5c2ab0a71ccf4a2a0763935864c127703ae0a2bce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e57b31419c0cfec3e0d9bf5c2ab0a71ccf4a2a0763935864c127703ae0a2bce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e57b31419c0cfec3e0d9bf5c2ab0a71ccf4a2a0763935864c127703ae0a2bce"
    sha256 cellar: :any_skip_relocation, ventura:        "62ab482a82d32590a3c1469e86877438dcc2b22094302ee61c1786a6bbd12e25"
    sha256 cellar: :any_skip_relocation, monterey:       "62ab482a82d32590a3c1469e86877438dcc2b22094302ee61c1786a6bbd12e25"
    sha256 cellar: :any_skip_relocation, big_sur:        "62ab482a82d32590a3c1469e86877438dcc2b22094302ee61c1786a6bbd12e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e57b31419c0cfec3e0d9bf5c2ab0a71ccf4a2a0763935864c127703ae0a2bce"
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