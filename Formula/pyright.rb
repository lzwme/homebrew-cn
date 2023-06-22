require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.315.tgz"
  sha256 "e74e5298967e891d74ccb9d720fe194b7da78697ad164e5b118f51a3331c5174"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "126ba1db0d200e14e04eae68685d0c6545df0dc06cf2d7f45d03140fbb831b37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "126ba1db0d200e14e04eae68685d0c6545df0dc06cf2d7f45d03140fbb831b37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "126ba1db0d200e14e04eae68685d0c6545df0dc06cf2d7f45d03140fbb831b37"
    sha256 cellar: :any_skip_relocation, ventura:        "3e6f76f5fdc4cb69758df44dc971b4bce97e42888b9fe71b10d67b146ecf8d8c"
    sha256 cellar: :any_skip_relocation, monterey:       "3e6f76f5fdc4cb69758df44dc971b4bce97e42888b9fe71b10d67b146ecf8d8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e6f76f5fdc4cb69758df44dc971b4bce97e42888b9fe71b10d67b146ecf8d8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "126ba1db0d200e14e04eae68685d0c6545df0dc06cf2d7f45d03140fbb831b37"
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