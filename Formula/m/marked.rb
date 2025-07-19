class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-16.1.1.tgz"
  sha256 "ea440289ca9d7dd6e2505bf95dd02be6fb56ab618f63e1db6a452a6b1c55224b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bd5ea36353e3b2eb835e7a5ae4f1f07986aa88c35d71f0e48352cde53784f6a2"
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