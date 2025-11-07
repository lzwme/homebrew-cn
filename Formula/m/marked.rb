class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-16.4.2.tgz"
  sha256 "f8f87a61f0f9668a675309224c55a9bb96c04592bbf757de5de40af7d2dec872"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6ab6322e1b78f2875ded69929d615fb4e9709a11b806ad97fd0ef081da4c0623"
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