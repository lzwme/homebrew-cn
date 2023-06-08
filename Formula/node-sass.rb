class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.63.0.tgz"
  sha256 "309ec3ad092d2fbf253ee62793512fa4cb66fd1bc79950bee7efafcb049a3865"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "359010fdb45544c44471f65ff3d27b5f10c9a31d50fa779697a09a816e433eb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "359010fdb45544c44471f65ff3d27b5f10c9a31d50fa779697a09a816e433eb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "359010fdb45544c44471f65ff3d27b5f10c9a31d50fa779697a09a816e433eb5"
    sha256 cellar: :any_skip_relocation, ventura:        "359010fdb45544c44471f65ff3d27b5f10c9a31d50fa779697a09a816e433eb5"
    sha256 cellar: :any_skip_relocation, monterey:       "359010fdb45544c44471f65ff3d27b5f10c9a31d50fa779697a09a816e433eb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "359010fdb45544c44471f65ff3d27b5f10c9a31d50fa779697a09a816e433eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c3e874df1251d1fd31404adde98feba84d0c5f8c44f117899730ce81ae98fe2"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end