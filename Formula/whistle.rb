require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.53.tgz"
  sha256 "3a6c557c4f3f09ec3ef35de1d50ec39a8c59bb98a2691bc91df10d8826053559"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e15e202b0677b6b49eebc5da7f26a389933add7db50f26230c78c66a5c310517"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e15e202b0677b6b49eebc5da7f26a389933add7db50f26230c78c66a5c310517"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e15e202b0677b6b49eebc5da7f26a389933add7db50f26230c78c66a5c310517"
    sha256 cellar: :any_skip_relocation, ventura:        "fd4b0d5f189d7d90fb542151be99445ab9630f1a838294e1d14c9742205122c4"
    sha256 cellar: :any_skip_relocation, monterey:       "fd4b0d5f189d7d90fb542151be99445ab9630f1a838294e1d14c9742205122c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd4b0d5f189d7d90fb542151be99445ab9630f1a838294e1d14c9742205122c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd4b0d5f189d7d90fb542151be99445ab9630f1a838294e1d14c9742205122c4"
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