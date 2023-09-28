require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.329.tgz"
  sha256 "5adf43e22e97ee8dd7c7850aeeabb5a5cb1ba30d826cbc3477a3d8414933fc5e"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dad69b844a6435e7cacc64654f84b18ac5ca22ccac3556466e57ca11035a0499"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dad69b844a6435e7cacc64654f84b18ac5ca22ccac3556466e57ca11035a0499"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dad69b844a6435e7cacc64654f84b18ac5ca22ccac3556466e57ca11035a0499"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e6bfc7f93158d319e1198d6a310c12c2557afb22ba5f1614b0d898c74519950"
    sha256 cellar: :any_skip_relocation, ventura:        "3e6bfc7f93158d319e1198d6a310c12c2557afb22ba5f1614b0d898c74519950"
    sha256 cellar: :any_skip_relocation, monterey:       "3e6bfc7f93158d319e1198d6a310c12c2557afb22ba5f1614b0d898c74519950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d62726d2fae1d1efa064e949383ed317a699ad542fe1017dc4ad413916672fa3"
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