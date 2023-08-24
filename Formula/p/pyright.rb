require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.324.tgz"
  sha256 "3ab308a05accdb2c8fe6ccf51fd280e0458ff4ede4bdf24c1c532e38a6dcd1a5"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ee466d9d91da4d5ed20dca9adc5e8edf4f23de14ba15a03e86558c2d768ae8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ee466d9d91da4d5ed20dca9adc5e8edf4f23de14ba15a03e86558c2d768ae8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ee466d9d91da4d5ed20dca9adc5e8edf4f23de14ba15a03e86558c2d768ae8f"
    sha256 cellar: :any_skip_relocation, ventura:        "d036172fa8f42c1f703f4e721b7eb26fbcbd42804ff43a2719e07b1b8eb6b11b"
    sha256 cellar: :any_skip_relocation, monterey:       "d036172fa8f42c1f703f4e721b7eb26fbcbd42804ff43a2719e07b1b8eb6b11b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d036172fa8f42c1f703f4e721b7eb26fbcbd42804ff43a2719e07b1b8eb6b11b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9b3a0d7044b04ec54e116bd92a2edfa0672ecf16b914c417f5c0dfeefa6b23e"
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