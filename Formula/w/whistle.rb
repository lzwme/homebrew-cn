class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https:github.comavwowhistle"
  url "https:registry.npmjs.orgwhistle-whistle-2.9.91.tgz"
  sha256 "8a233c30e396491e1cd5402f16a1f8e3210a9c796aeccf3e592424b765a548d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "88cd2b60cb3ce270c812c56b5943e53228d9287a627e182f3398ab08af09433b"
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