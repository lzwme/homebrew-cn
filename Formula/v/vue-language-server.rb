class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https:github.comvuejslanguage-tools"
  url "https:registry.npmjs.org@vuelanguage-server-language-server-2.2.6.tgz"
  sha256 "1a98808d442b4321a45ce5226baea8cd7d917e26cb8465d097fc9803a3758451"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "489653bb055d82a4c7c527fcd9abfdd8904647e2d8fb34e617376e9b06f022e2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin"vue-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(^Content-Length: \d+i, stdout.readline)
    end
  end
end