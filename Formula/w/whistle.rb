class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.101.tgz"
  sha256 "ec867a1642b6868eb35b0a9a28dd84b6b3b1db7b002ac938e68bc819913be965"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "37c68518667708a935e67ddfa506ce928d00b551e87d8d212793352e258cc7c0"
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