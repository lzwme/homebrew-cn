require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.44.tgz"
  sha256 "43a0e1e778830a070d2cfa0543ade8e54a9a3887441a81c8fc2c4e98102c1c53"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a6237f8c7b05efdf05205b725a64c25a51c0b980ebe72946dec5ee142647f68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a6237f8c7b05efdf05205b725a64c25a51c0b980ebe72946dec5ee142647f68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a6237f8c7b05efdf05205b725a64c25a51c0b980ebe72946dec5ee142647f68"
    sha256 cellar: :any_skip_relocation, ventura:        "e66008504a44d972e3ff14f2f2dd944ab52ec0d774299dd63effdc3793836c64"
    sha256 cellar: :any_skip_relocation, monterey:       "e66008504a44d972e3ff14f2f2dd944ab52ec0d774299dd63effdc3793836c64"
    sha256 cellar: :any_skip_relocation, big_sur:        "e66008504a44d972e3ff14f2f2dd944ab52ec0d774299dd63effdc3793836c64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e66008504a44d972e3ff14f2f2dd944ab52ec0d774299dd63effdc3793836c64"
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