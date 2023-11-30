require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.338.tgz"
  sha256 "52e098c18819fa629647c41d0a5df3ae1db96457842b8236373f6efaf5c2511b"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63b23f5f346f25cadd18a6b38a04ecfde528f3ac7a44e3b71d18d7ba5c238af3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63b23f5f346f25cadd18a6b38a04ecfde528f3ac7a44e3b71d18d7ba5c238af3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63b23f5f346f25cadd18a6b38a04ecfde528f3ac7a44e3b71d18d7ba5c238af3"
    sha256 cellar: :any_skip_relocation, sonoma:         "42ccd39d3781b8574664d87a4ae884df6d29751e780b358fd3fae1f75c5e097b"
    sha256 cellar: :any_skip_relocation, ventura:        "42ccd39d3781b8574664d87a4ae884df6d29751e780b358fd3fae1f75c5e097b"
    sha256 cellar: :any_skip_relocation, monterey:       "42ccd39d3781b8574664d87a4ae884df6d29751e780b358fd3fae1f75c5e097b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e85325afd44ac9bdb5103147aae18299e53c5cffd6f738a8d2124822a042857c"
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