require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.321.tgz"
  sha256 "5b893d41098282fb5d5a9082480be2948e770bf1344446c96d3092e981527f1b"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9eb0746f6b0c5ec9ad0166447134b4f13ac02f41e18173b70bd06607090ae514"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9eb0746f6b0c5ec9ad0166447134b4f13ac02f41e18173b70bd06607090ae514"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9eb0746f6b0c5ec9ad0166447134b4f13ac02f41e18173b70bd06607090ae514"
    sha256 cellar: :any_skip_relocation, ventura:        "d163094bb38e4a6f427a8e2c69e9d435fd8a6550f0be087011f0cbc5a4ab7260"
    sha256 cellar: :any_skip_relocation, monterey:       "d163094bb38e4a6f427a8e2c69e9d435fd8a6550f0be087011f0cbc5a4ab7260"
    sha256 cellar: :any_skip_relocation, big_sur:        "d163094bb38e4a6f427a8e2c69e9d435fd8a6550f0be087011f0cbc5a4ab7260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77162c47cd164d782f7cf1024120e65c4ffaf667bb55e35bb21788394b76b07f"
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