require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.54.tgz"
  sha256 "0d9afc425e08a9e781fb29720ceaac0c56a43207cf0133cd41da01e218f9a0d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abe0ba33db7fdc22509ee8db1b3916c75488f9558e586fafaea19bcee66d71f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abe0ba33db7fdc22509ee8db1b3916c75488f9558e586fafaea19bcee66d71f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abe0ba33db7fdc22509ee8db1b3916c75488f9558e586fafaea19bcee66d71f9"
    sha256 cellar: :any_skip_relocation, ventura:        "18fa01bdec700c1770481bfe23d4ce2588dd094efb8c4bb3e09720cb0d757168"
    sha256 cellar: :any_skip_relocation, monterey:       "18fa01bdec700c1770481bfe23d4ce2588dd094efb8c4bb3e09720cb0d757168"
    sha256 cellar: :any_skip_relocation, big_sur:        "18fa01bdec700c1770481bfe23d4ce2588dd094efb8c4bb3e09720cb0d757168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18fa01bdec700c1770481bfe23d4ce2588dd094efb8c4bb3e09720cb0d757168"
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