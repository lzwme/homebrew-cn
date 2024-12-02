class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https:github.comavwowhistle"
  url "https:registry.npmjs.orgwhistle-whistle-2.9.89.tgz"
  sha256 "a71b0b8e3aea4b3ec72a055ad1d3d6bb13ebfc43c66c5d537bbe6fc07479b689"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "87a385f90d88e2edf5a545191170f2e150b409b1a4ea07cc198c9bb5713c0475"
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