class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-15.0.7.tgz"
  sha256 "4e3fbc70248d5f40e562e5185bd3babcabbf24f423bdd4c11464dd6adf443f4d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "129b1eb642a0a0049be93983dd717fd07c6cce93f44aec4129e41c63914dc6bb"
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