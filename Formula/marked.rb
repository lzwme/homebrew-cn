require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-5.1.1.tgz"
  sha256 "5bf8cbaad094ffacf95bcded47bad5ab4ca468c6d861a4cbaee5a4f9bf915e98"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "56d437a6a82f032e11768ea435d325320ba9f3c01bdfb5ee0994a8bf9d46c395"
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