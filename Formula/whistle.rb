require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.50.tgz"
  sha256 "e9397e63cdeecc47cc082cedf7c94deb515a9fb1f6dce26e56dc83d330c7f6d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bb551320f0885698c9d2cefe1c737510428612da6b1a5664a9843a86f9c9ed6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bb551320f0885698c9d2cefe1c737510428612da6b1a5664a9843a86f9c9ed6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bb551320f0885698c9d2cefe1c737510428612da6b1a5664a9843a86f9c9ed6"
    sha256 cellar: :any_skip_relocation, ventura:        "836089d0b2bbebf7287b3920db41ff90cf07536fa0a2a8fde6303b1aec2ce99e"
    sha256 cellar: :any_skip_relocation, monterey:       "836089d0b2bbebf7287b3920db41ff90cf07536fa0a2a8fde6303b1aec2ce99e"
    sha256 cellar: :any_skip_relocation, big_sur:        "836089d0b2bbebf7287b3920db41ff90cf07536fa0a2a8fde6303b1aec2ce99e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "836089d0b2bbebf7287b3920db41ff90cf07536fa0a2a8fde6303b1aec2ce99e"
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