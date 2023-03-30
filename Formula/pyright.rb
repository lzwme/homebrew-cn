require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.301.tgz"
  sha256 "27c524ae6470b969afdae1f38164b1c11ed84768b809f2f2a4d510077792eeec"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60368245f460905a92c28172fef865a8592cd4ff596fe34173533e62b37a9210"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60368245f460905a92c28172fef865a8592cd4ff596fe34173533e62b37a9210"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60368245f460905a92c28172fef865a8592cd4ff596fe34173533e62b37a9210"
    sha256 cellar: :any_skip_relocation, ventura:        "435ce4e7c7d30a5fc93f74ef88e7e65715a6a4e51787298da17526e8ae4b46d7"
    sha256 cellar: :any_skip_relocation, monterey:       "435ce4e7c7d30a5fc93f74ef88e7e65715a6a4e51787298da17526e8ae4b46d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "435ce4e7c7d30a5fc93f74ef88e7e65715a6a4e51787298da17526e8ae4b46d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60368245f460905a92c28172fef865a8592cd4ff596fe34173533e62b37a9210"
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