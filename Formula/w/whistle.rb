class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https:github.comavwowhistle"
  url "https:registry.npmjs.orgwhistle-whistle-2.9.87.tgz"
  sha256 "18eb866c693eeb6ed7c1a09df31d96d60b0efad22ed80b9052285a5fbcdd658f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8b4c49132d29401830b4b9fc46160d7acc2a53e762fc2b8f9764939108c61ea8"
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