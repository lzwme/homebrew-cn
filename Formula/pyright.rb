require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.305.tgz"
  sha256 "b13d5fa18d197c19d1565930872229ebea6c548899b465c95e5abb548e5fd5d2"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4888ed14e065ee856248bcff80996a9b63e160fd64313625b20d68ed9ea9036a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4888ed14e065ee856248bcff80996a9b63e160fd64313625b20d68ed9ea9036a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4888ed14e065ee856248bcff80996a9b63e160fd64313625b20d68ed9ea9036a"
    sha256 cellar: :any_skip_relocation, ventura:        "51b336d4c719effb0c130fe3bf92b7db724bbafe202b116e0d1c581efc1148b9"
    sha256 cellar: :any_skip_relocation, monterey:       "51b336d4c719effb0c130fe3bf92b7db724bbafe202b116e0d1c581efc1148b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "51b336d4c719effb0c130fe3bf92b7db724bbafe202b116e0d1c581efc1148b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4888ed14e065ee856248bcff80996a9b63e160fd64313625b20d68ed9ea9036a"
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