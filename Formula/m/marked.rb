class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-15.0.4.tgz"
  sha256 "bb835befb5ecdfefb38fea62818a89148b6821b88df149b21ae4ed07858a9ed6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4df90cbbe1e039788797b31491b39199d7dd188f9f1e239c148debecfac6a0b5"
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