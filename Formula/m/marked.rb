require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-12.0.0.tgz"
  sha256 "18c27503f532a8ead55ddda756c07f5e995e567f019c1dc092e06464f3ada47e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "50387d89c1c2d91fc104507e5a8079a8cbc50eb48dee0dd086942ee8d944e1b0"
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