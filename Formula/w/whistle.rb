require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.59.tgz"
  sha256 "ed0e301d6bb356500f04a3824ee9adba27188ffc33eaa6e1b9f982853ee53f70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "372fe96d604b6f36e0fc302c0eb9eeea549b76b60e513efcdbe5821bb1047a6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "372fe96d604b6f36e0fc302c0eb9eeea549b76b60e513efcdbe5821bb1047a6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "372fe96d604b6f36e0fc302c0eb9eeea549b76b60e513efcdbe5821bb1047a6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "266eda486e624c3e52128e2c33ecd29c2a8bba181338b8df41c4cb6ec1dc703d"
    sha256 cellar: :any_skip_relocation, ventura:        "266eda486e624c3e52128e2c33ecd29c2a8bba181338b8df41c4cb6ec1dc703d"
    sha256 cellar: :any_skip_relocation, monterey:       "266eda486e624c3e52128e2c33ecd29c2a8bba181338b8df41c4cb6ec1dc703d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "266eda486e624c3e52128e2c33ecd29c2a8bba181338b8df41c4cb6ec1dc703d"
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