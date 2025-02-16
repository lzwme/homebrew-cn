class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https:github.comvuejslanguage-tools"
  url "https:registry.npmjs.org@vuelanguage-server-language-server-2.2.2.tgz"
  sha256 "950bf21a1de6bf0ed58ca0dd358c98d6fda42fab584a23960fb0c16b1db50594"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5df80dac2b3068b7bb450ed9b818530a9846c7e07817f5f1a8f0a0fabaf804bb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec"binvue-language-server"
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