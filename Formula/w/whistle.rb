class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https:github.comavwowhistle"
  url "https:registry.npmjs.orgwhistle-whistle-2.9.84.tgz"
  sha256 "f41dc5eff26fc75b256357d9a8e78543f6ab3166f5c07720ae058da907a4d111"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b6f4f4c1d150cb29ca7e6a6332013c725c453a45dc2eab3dcfea52e15e14b1db"
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