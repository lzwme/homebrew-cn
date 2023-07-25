require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.55.tgz"
  sha256 "ef52728d70baeb3f9a8fa29633ffe5f94828c99abaf5025cb8d9b927d2dedbbc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ca4b81a0ea3248e828aa467196c2066541f1e2638ea9ae92ea8a315dc573726"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ca4b81a0ea3248e828aa467196c2066541f1e2638ea9ae92ea8a315dc573726"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ca4b81a0ea3248e828aa467196c2066541f1e2638ea9ae92ea8a315dc573726"
    sha256 cellar: :any_skip_relocation, ventura:        "6ba3489d4ddd9dee351b501f82e4a497545270f88839b56768e97d135c1c5932"
    sha256 cellar: :any_skip_relocation, monterey:       "6ba3489d4ddd9dee351b501f82e4a497545270f88839b56768e97d135c1c5932"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ba3489d4ddd9dee351b501f82e4a497545270f88839b56768e97d135c1c5932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6ff578912d86629d339fcb167f9dfe0041956c31b4658d924d8f660337a8208"
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