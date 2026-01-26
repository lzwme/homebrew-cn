class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.108.tgz"
  sha256 "8e95abcdafd107835ab1afff6e5e888e091f1e23844676d8fbb165b2b1f00249"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e46c1fb5e0dcbabdc87936cb86cd1abd6c45b780f8f97272cc2da53ef7b6bfd4"
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