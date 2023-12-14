require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.340.tgz"
  sha256 "d1557935c35880ff2dae2ff3b95b56ff5e8d4f979a0b64a173c668e1169f4b48"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5785a1e581a929e5d2bc39967c5d5dbd5b6b1858157f88834f9b6bef05e1f110"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5785a1e581a929e5d2bc39967c5d5dbd5b6b1858157f88834f9b6bef05e1f110"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5785a1e581a929e5d2bc39967c5d5dbd5b6b1858157f88834f9b6bef05e1f110"
    sha256 cellar: :any_skip_relocation, sonoma:         "247fe81cbbb2a862c875466b0500a590abd57bc8efb491c74629bf15b916dbad"
    sha256 cellar: :any_skip_relocation, ventura:        "247fe81cbbb2a862c875466b0500a590abd57bc8efb491c74629bf15b916dbad"
    sha256 cellar: :any_skip_relocation, monterey:       "247fe81cbbb2a862c875466b0500a590abd57bc8efb491c74629bf15b916dbad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdfd081cf3de4516afffc336bad1e784ba1abefd96c126c42df7eb210c68a7eb"
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