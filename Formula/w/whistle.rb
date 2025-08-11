class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.100.tgz"
  sha256 "5a7b0d55b36671e13290b60dc5dfed773c2508f153ccfdee4530e111dce0a92d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c40a01f371987427ad33f33f6b72237d5011fd243ae66002b81c340acd51c7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c40a01f371987427ad33f33f6b72237d5011fd243ae66002b81c340acd51c7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c40a01f371987427ad33f33f6b72237d5011fd243ae66002b81c340acd51c7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "144e0a78de7c44ce68338700dfb621e332988af167117f776280541de3220295"
    sha256 cellar: :any_skip_relocation, ventura:       "144e0a78de7c44ce68338700dfb621e332988af167117f776280541de3220295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c40a01f371987427ad33f33f6b72237d5011fd243ae66002b81c340acd51c7b"
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