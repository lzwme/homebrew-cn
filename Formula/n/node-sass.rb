class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.74.1.tgz"
  sha256 "9bd8b86118b1eeedf1086c3bf8ff0bced0a78a9bbd7c67fb7e533cbdd5cdf331"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4a5d085e069f9086e1d29a649ffa1055cdbdb1834968c5d9eda60b73ae0863cd"
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