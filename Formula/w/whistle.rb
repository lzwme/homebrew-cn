class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://wproxy.org/"
  url "https://registry.npmjs.org/whistle/-/whistle-2.10.7.tgz"
  sha256 "dac31bb30d6bbce1deb4bdf0d53f86f29bc43ab8641a9291c41794207647d4fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f5bd2af9f036489d5cd4ae57a783d5584e1d3a82d3e1d8280113454c64f49c60"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end