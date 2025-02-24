class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https:github.comvuejslanguage-tools"
  url "https:registry.npmjs.org@vuelanguage-server-language-server-2.2.4.tgz"
  sha256 "b3a9081500180a3f50310d0194603de77f43a2d87a2c03724f5e7c4191425bdb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "379c624f586b93c2bb8cc1fbe17d337ced9a50ce597ba6a62f9c32e838e4a85a"
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