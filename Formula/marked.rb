require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-5.0.0.tgz"
  sha256 "cf7ec94b461aafec09371f0ba5eaea5c772eed7d5165da60f805e71df3637264"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8386f0b61541175d0ea35cc9000ee8c34dbd4fd8445892844a3be6357ebd9395"
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