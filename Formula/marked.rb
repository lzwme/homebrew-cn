require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-7.0.1.tgz"
  sha256 "1f891dad70b018d732cf9a344d40e0981b241b27049c48ef9d7413441f8b0cdb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6f615a1a48dd56785920af44347f0d30a7a39954ad07adf028bb3027a43bb967"
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