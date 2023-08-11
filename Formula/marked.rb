require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-7.0.2.tgz"
  sha256 "a64ebaf7130da9aae00b98aa57554f444eb9103924f2ff8ba1cb685d322b3ca3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ac95b3766cbcca6c65e684f262afeb1beecde5cea9d0c72a5bc1e09da4d2712a"
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