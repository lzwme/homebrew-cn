require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.56.tgz"
  sha256 "a0abe63cb21690c35b3cee21200509bb7e39ffe7b7c27d3b4ef4eea902471312"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7f6fb9028b01b4c5c6e3a1029b5a6813da07ffecef2c2e4e5d66c358b752c49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7f6fb9028b01b4c5c6e3a1029b5a6813da07ffecef2c2e4e5d66c358b752c49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7f6fb9028b01b4c5c6e3a1029b5a6813da07ffecef2c2e4e5d66c358b752c49"
    sha256 cellar: :any_skip_relocation, ventura:        "87751d69739167903bd7868f12fe57425831adecde16bbf786cf44057bc03788"
    sha256 cellar: :any_skip_relocation, monterey:       "87751d69739167903bd7868f12fe57425831adecde16bbf786cf44057bc03788"
    sha256 cellar: :any_skip_relocation, big_sur:        "87751d69739167903bd7868f12fe57425831adecde16bbf786cf44057bc03788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9f51f4f9f6d116ff0897f14aba497da00633212a1fb27bc4b5dd6a40d406f6d"
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