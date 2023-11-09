require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.335.tgz"
  sha256 "dd7f3d0db46fcd6349223adee211e200acf52e1e4ca725570f6e4b457daad858"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76f03cd38bedf661604659230cfe68d6748288dee0661a08b50b2ecc5fcccebc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76f03cd38bedf661604659230cfe68d6748288dee0661a08b50b2ecc5fcccebc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76f03cd38bedf661604659230cfe68d6748288dee0661a08b50b2ecc5fcccebc"
    sha256 cellar: :any_skip_relocation, sonoma:         "76967d70de21022f8dccd0ad9b4e9562168892e269c008688ff0410a3914d56b"
    sha256 cellar: :any_skip_relocation, ventura:        "76967d70de21022f8dccd0ad9b4e9562168892e269c008688ff0410a3914d56b"
    sha256 cellar: :any_skip_relocation, monterey:       "76967d70de21022f8dccd0ad9b4e9562168892e269c008688ff0410a3914d56b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ee9b3e44821d0915f2aab58f5a0f86230e2ea906881e66daa691748224deba1"
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