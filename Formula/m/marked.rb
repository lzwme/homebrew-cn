require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-9.1.6.tgz"
  sha256 "6cee05496e2e90947f90f431fdeb66f3093716f81d3c2b65caccd6bf0542bd2b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1e8accd64ef9fbacd2f8401715741a202766cbc7130a6bd2a839d03df781106b"
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