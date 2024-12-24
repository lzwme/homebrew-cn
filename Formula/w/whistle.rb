class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https:github.comavwowhistle"
  url "https:registry.npmjs.orgwhistle-whistle-2.9.92.tgz"
  sha256 "648cfd15c94bb54d9699adc5a8a8c0cd9934fb951d8e4f88b5b36056a068b153"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2fe6eaccddb15ec48e48fe22b9ff1069db50ff075956ee0b6757e2c0a4540c4f"
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