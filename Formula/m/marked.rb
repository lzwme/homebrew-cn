class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-15.0.2.tgz"
  sha256 "b265d05c56b9c90572323a638274c56a9770dc5d04b95d3b1518b836286c61a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a444d04f5a4a55939470d6900e32326647495e13335c5915794db6acfc483e18"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output(bin/"marked", "hello *world*").strip
  end
end