require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.58.tgz"
  sha256 "1c5b0476ff97546d77b594f8c1f5335d94ec16c0247b433ff622afa71ffb8443"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37d555ed94afe1bf0025ff05b821a47c820b41b57a84f6100323372b486f5b78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37d555ed94afe1bf0025ff05b821a47c820b41b57a84f6100323372b486f5b78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37d555ed94afe1bf0025ff05b821a47c820b41b57a84f6100323372b486f5b78"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6258174b15ea6305d7ee952ac4f833e938df8aefd189ae62219f6aef118e6dd"
    sha256 cellar: :any_skip_relocation, ventura:        "b6258174b15ea6305d7ee952ac4f833e938df8aefd189ae62219f6aef118e6dd"
    sha256 cellar: :any_skip_relocation, monterey:       "b6258174b15ea6305d7ee952ac4f833e938df8aefd189ae62219f6aef118e6dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6258174b15ea6305d7ee952ac4f833e938df8aefd189ae62219f6aef118e6dd"
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