class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https:github.comavwowhistle"
  url "https:registry.npmjs.orgwhistle-whistle-2.9.85.tgz"
  sha256 "b838de26128bd7dc983dabf594d1ed655eebf6604f6f1c233202489598a30003"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "405b222bfb0369b7040dbf51d2a8000e4314893a8289772fd2d4c4b4d0d6bece"
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