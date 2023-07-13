require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.317.tgz"
  sha256 "68f2ddcb49093dfbb538a32ad580453e87cce4f6cfdd45cdfe037f65a9da06a2"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "581e3bb7a05f78096cbc7313929e604126b71a2b2bf53c57b6a97c87270438f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "581e3bb7a05f78096cbc7313929e604126b71a2b2bf53c57b6a97c87270438f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "581e3bb7a05f78096cbc7313929e604126b71a2b2bf53c57b6a97c87270438f7"
    sha256 cellar: :any_skip_relocation, ventura:        "f2b4e2aa0a9772980bf376405c366e63f5bd1fec3a5c00de1cde1af835416c35"
    sha256 cellar: :any_skip_relocation, monterey:       "f2b4e2aa0a9772980bf376405c366e63f5bd1fec3a5c00de1cde1af835416c35"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2b4e2aa0a9772980bf376405c366e63f5bd1fec3a5c00de1cde1af835416c35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "581e3bb7a05f78096cbc7313929e604126b71a2b2bf53c57b6a97c87270438f7"
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