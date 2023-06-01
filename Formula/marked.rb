require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-5.0.4.tgz"
  sha256 "91e108e97d6c3792216774a88d53f8bd77632a8a428f5083c3c4e62a0f45010e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dc699494631c49c9bf129dc0cb030ceeffa4bda944d89574f6e16cc9a441775a"
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