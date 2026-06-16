class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://wproxy.org/"
  url "https://registry.npmjs.org/whistle/-/whistle-2.10.3.tgz"
  sha256 "5b27c1650de36d4424521980ef1bb4c1a47206d592b06cc55d45b1a8aff66a3e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7534947d60c957a2e0abbd7cb8625d34827cfe8de7cae98fe7a12cfac06e1794"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end