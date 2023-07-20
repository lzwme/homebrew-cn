require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.318.tgz"
  sha256 "68bdba8071d234d0852155fa83310d1ef89d5d75b9a373526ab56eade5a79c3e"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17cec5de80e39958a944177745685d70be63935da4428d5bdf03df43545d854b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17cec5de80e39958a944177745685d70be63935da4428d5bdf03df43545d854b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17cec5de80e39958a944177745685d70be63935da4428d5bdf03df43545d854b"
    sha256 cellar: :any_skip_relocation, ventura:        "7c79ef7ab741c0b5e017d224cf8b04ea6c2775c537a616096cf89beda42aa724"
    sha256 cellar: :any_skip_relocation, monterey:       "7c79ef7ab741c0b5e017d224cf8b04ea6c2775c537a616096cf89beda42aa724"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c79ef7ab741c0b5e017d224cf8b04ea6c2775c537a616096cf89beda42aa724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67c4a1a21b0481913566e1738a89bcf54f2c99ae6c58826bcfa6a451c31d4c17"
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