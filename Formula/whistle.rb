require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.49.tgz"
  sha256 "1c4e798141a4d1ef70e18e61fe50eb5a4673018517f2c1c22476888d935e414d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ccb2079f45c8f07deb1db8a5a26d280c8b2074b267090b6b441a46ede030a32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ccb2079f45c8f07deb1db8a5a26d280c8b2074b267090b6b441a46ede030a32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ccb2079f45c8f07deb1db8a5a26d280c8b2074b267090b6b441a46ede030a32"
    sha256 cellar: :any_skip_relocation, ventura:        "ba5ee166cceb27c23bed0e8d8f46a6e775fe0ce2392a5807279921603b66a88b"
    sha256 cellar: :any_skip_relocation, monterey:       "ba5ee166cceb27c23bed0e8d8f46a6e775fe0ce2392a5807279921603b66a88b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba5ee166cceb27c23bed0e8d8f46a6e775fe0ce2392a5807279921603b66a88b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba5ee166cceb27c23bed0e8d8f46a6e775fe0ce2392a5807279921603b66a88b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove x86 specific optional feature
    node_modules = libexec/"lib/node_modules/whistle/node_modules"
    rm_f node_modules/"set-global-proxy/lib/mac/whistle" if Hardware::CPU.arm?
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end