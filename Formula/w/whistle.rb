class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.103.tgz"
  sha256 "392da88ff566d7843daf80158a3d52004f8a09b7a6c656d9a9a1f3ec3a317e92"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1bf19b5fa547f48ce9837ea29c611a73bdfee5bb5e35c5bdc3eb9404ffe86233"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end