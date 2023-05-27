require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-5.0.3.tgz"
  sha256 "171d0685721944c1d5b0adf5ff66bc9cdbb3b8044900acfc33a14cf28acf6e27"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9b2841fd009734fb94db6f94f8f934c09f7b97befc6e9cea9ab62c3eaba97e08"
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