class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https:github.comavwowhistle"
  url "https:registry.npmjs.orgwhistle-whistle-2.9.88.tgz"
  sha256 "af32302804627afc763e7904b1ab1218105c890557744a4199d3f08328e2df2c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e6bc3539aaa1fc0b027b45cd68cc44f87fb2658ca177cd11a380821f2c087a1b"
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