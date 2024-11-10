class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-15.0.0.tgz"
  sha256 "417c788863e0daf63604d24c05eccea06095a6c4448ed22faba6840355dfb2ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cb0febc6a7a94a23a8b6267071afa95947dcba833efbf93505994ac1cde8f012"
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