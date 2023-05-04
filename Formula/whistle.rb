require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.48.tgz"
  sha256 "63250c0dfdf763dd99c4e410b0ace0ebe3a44be8c5104e99316399b2d9864301"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e067fec03428cd10308eb713328b4e5615c28f45f85d98af6bb7b5d73f1d8f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e067fec03428cd10308eb713328b4e5615c28f45f85d98af6bb7b5d73f1d8f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e067fec03428cd10308eb713328b4e5615c28f45f85d98af6bb7b5d73f1d8f2"
    sha256 cellar: :any_skip_relocation, ventura:        "603bd46e7a221288582013076110457ed7b08d709d9d244e7145d325411ae5d0"
    sha256 cellar: :any_skip_relocation, monterey:       "603bd46e7a221288582013076110457ed7b08d709d9d244e7145d325411ae5d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "603bd46e7a221288582013076110457ed7b08d709d9d244e7145d325411ae5d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "603bd46e7a221288582013076110457ed7b08d709d9d244e7145d325411ae5d0"
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