require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-11.1.0.tgz"
  sha256 "ef04a4aeef87fca27584e441148b4f84533cd53138fb8a8a8a136e2465b911d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f39fc4d6872388cd88d85e6db86cf3c791818bb2e3872c242e33cffe7b4f7b32"
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