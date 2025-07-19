class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https://github.com/vuejs/language-tools"
  url "https://registry.npmjs.org/@vue/language-server/-/language-server-3.0.3.tgz"
  sha256 "87b5490d56b96fb82cdc098c7d710a6cde12b8eed30318b107df2491325462ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b26b4517f263783ba85dc64bd4dc7e6543a4c052218aff9d67cf51f1a67ff97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bc28ea516c02e477bf8f2c44816b39db5e2c8feb9d9514df19bf2a99bf6091a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36ffb8127a950928f5f6d06c3f4a94171b0e5faad2ea2f3d6a480f611b62b281"
    sha256 cellar: :any_skip_relocation, sonoma:        "3536922f3b60f76aff0ab9c2abb74eb1e6e2d91516cfceea56c6d48e465224d4"
    sha256 cellar: :any_skip_relocation, ventura:       "0806049e9125ff94c6347d601e373b7eeafa6bd30f8984babdb6facae16609f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ee0f8966124fe92ea13689580cad23f0e627d66ee1ab249323c5eebf6cd284a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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

    Open3.popen3(bin/"vue-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end