require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.327.tgz"
  sha256 "f8168fa605a665c8fc24474450ed90a91b710011175f2c8c744e21aa966e2fe8"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd74d6acab1b91a0ef6fad506cbef398f960843ec6934c32ec1be3d0c3887174"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd74d6acab1b91a0ef6fad506cbef398f960843ec6934c32ec1be3d0c3887174"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd74d6acab1b91a0ef6fad506cbef398f960843ec6934c32ec1be3d0c3887174"
    sha256 cellar: :any_skip_relocation, ventura:        "de17981d81bfc5f2005b06aec0809ea9994bbf569557d77e306cf4021404eb8b"
    sha256 cellar: :any_skip_relocation, monterey:       "de17981d81bfc5f2005b06aec0809ea9994bbf569557d77e306cf4021404eb8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "de17981d81bfc5f2005b06aec0809ea9994bbf569557d77e306cf4021404eb8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23cb8236d2ffd806a638a2360c47c15c4e14f7d338e437e6b42e9adaa1f7bada"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with native slices
    deuniversalize_machos
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