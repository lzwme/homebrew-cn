class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://wproxy.org/"
  url "https://registry.npmjs.org/whistle/-/whistle-2.10.8.tgz"
  sha256 "b941b3c23221a59ca93769de70cab117f6ff5c1df8120768af5c699a3ffa4bdb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8c2e5cd160a533ba68d32e6eb4c5931d6b112d15f0fcd303cf6ec02b6fa67aa2"
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