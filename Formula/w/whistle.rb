class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https:github.comavwowhistle"
  url "https:registry.npmjs.orgwhistle-whistle-2.9.83.tgz"
  sha256 "a8784476cd25108948a7f0ef6b26fb4f64defccee96464ed7d369be56864bc94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bb76df09fff61e797e4d66e52633024eae50941cab0a88c99d77cc01c8adc11f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"package.json").write('{"name": "test"}')
    system bin"whistle", "start"
    system bin"whistle", "stop"
  end
end