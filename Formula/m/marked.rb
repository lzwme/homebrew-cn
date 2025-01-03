class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-15.0.5.tgz"
  sha256 "28e4f82613eb4de5eb6608a3f049436bc02198eec55c1c5bdb12ab55d09fe2a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "77d47cd5f9a0746ac7e0809e8149e5446f0fd46195d66df363b622b2ada69169"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output(bin/"marked", "hello *world*").strip
  end
end