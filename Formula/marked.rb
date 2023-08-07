require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-7.0.0.tgz"
  sha256 "fe7e33beeabea16b26e6174fcdeda2183cc22c281649b659db26e250c32392bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "24fe4a083f6fd88c2d4f3154724c0afbad7bc52921e3f846fbc489bcc4088696"
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