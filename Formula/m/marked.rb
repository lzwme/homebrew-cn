require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-8.0.1.tgz"
  sha256 "28183493bd3ba5fad070689b1d0f4116e3266768121aee81aaa08ac8c8d1d7dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e6a0a47d7cd146f5fd0b75f68e338d28d848135ee382f2998d8de4916ce219bb"
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