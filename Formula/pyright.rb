require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.320.tgz"
  sha256 "fcac6c7dcaf4ac8c9103337b25a1a95ed9ef180d90f6df557724ea91d1c426ae"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b3a0a2b0f8f65bbf58912eb64749a87b4b4046bdb2a6d33d5c9283dc4599351"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b3a0a2b0f8f65bbf58912eb64749a87b4b4046bdb2a6d33d5c9283dc4599351"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b3a0a2b0f8f65bbf58912eb64749a87b4b4046bdb2a6d33d5c9283dc4599351"
    sha256 cellar: :any_skip_relocation, ventura:        "cc032556ec02dda4fd70ff114ce056322b44ba44e7bf67af186a86535bf616d8"
    sha256 cellar: :any_skip_relocation, monterey:       "cc032556ec02dda4fd70ff114ce056322b44ba44e7bf67af186a86535bf616d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc032556ec02dda4fd70ff114ce056322b44ba44e7bf67af186a86535bf616d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eab7b5aec783d0968a3ff6bc0046247f4669c6772f2dca9509a6881653c86f33"
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