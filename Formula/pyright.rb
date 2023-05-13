require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.308.tgz"
  sha256 "8a5b767466078263bc4538789a2f89b7d34bcaf346087195388cb4b46385518e"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a75563437a7be115395d08e862f81379bc12a92cf8b7d80700e25f5676f0ddc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a75563437a7be115395d08e862f81379bc12a92cf8b7d80700e25f5676f0ddc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a75563437a7be115395d08e862f81379bc12a92cf8b7d80700e25f5676f0ddc"
    sha256 cellar: :any_skip_relocation, ventura:        "1df5d04755b8f2d312cf195fcb46005307d69af62a84aea942e1056cc8b36410"
    sha256 cellar: :any_skip_relocation, monterey:       "1df5d04755b8f2d312cf195fcb46005307d69af62a84aea942e1056cc8b36410"
    sha256 cellar: :any_skip_relocation, big_sur:        "1df5d04755b8f2d312cf195fcb46005307d69af62a84aea942e1056cc8b36410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a75563437a7be115395d08e862f81379bc12a92cf8b7d80700e25f5676f0ddc"
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