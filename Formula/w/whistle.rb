class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.104.tgz"
  sha256 "3d627aa1ab6b99218483f83520cc7018eec77e825851683a89754126b3bf284f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3116e88f579d9a6856af45bffa54d0b918466dc2a7a0a243ac6b2cd445729fa3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end