class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-16.2.1.tgz"
  sha256 "f5a9e6d8d9d1956f0636677c79d39ec0c2883cb8e826a581b53fb95c38c06d94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a8447f86b22fb7ee28a60b08795213948b2eca1bdf582da7cfd32548e93b0922"
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