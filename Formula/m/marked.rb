class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-16.4.0.tgz"
  sha256 "a511ffcf60ddf9f2a846f73254b1ccfbadf2f460421a009ce2a3cd0b68c9829f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "768fd2c0129713f2b0c8b0956ff43b7923fc90e256ddc7dd21e3b88e46c2e0de"
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