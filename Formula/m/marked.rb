require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-9.1.3.tgz"
  sha256 "22fee450fecda1848580579097d67aa01a029360939a0a22f2078c08b3566181"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "35b471d3017e48ba97a44734d25861967ebb6e0bc22e603cbb36b22b907c27c3"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end