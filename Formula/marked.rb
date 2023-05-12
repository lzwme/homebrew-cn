require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-5.0.2.tgz"
  sha256 "49eba0c16a479d2cf33bd25634b5f5633d685a787ea5afdda4c0c1306944331a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "682e312600e67d03746fdb4f5f290f5483af86559fa4486e966f7f5e7200e3f3"
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