class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https:github.comavwowhistle"
  url "https:registry.npmjs.orgwhistle-whistle-2.9.93.tgz"
  sha256 "b5f1afa5b2da8f50b90633cdddd7421a3bc652b7131e50f14234d648153f3917"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "09df8aef07c6369320f1e39922a2a194eca30db96f34e013a4e4fe6c68e8ae33"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"package.json").write('{"name": "test"}')
    system bin"whistle", "start"
    system bin"whistle", "stop"
  end
end