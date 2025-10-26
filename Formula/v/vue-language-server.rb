class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https://github.com/vuejs/language-tools"
  url "https://registry.npmjs.org/@vue/language-server/-/language-server-3.1.2.tgz"
  sha256 "607c53543692a15fe946374aafabd6fd0662592af6fc3e7ec582c505e07f62ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b28a0765c600097e81b89c29e0e8e41e9efa503358b49a9467b39db92cd5e44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe19c059a89dd14da5c0a188d3f2ac5fee4dac12a7763618701de8c630673fb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cefed28fd2bcac3a0c9fa35914e2388306c79a804b791f996f82480f7415afa"
    sha256 cellar: :any_skip_relocation, sonoma:        "eaa843e57cf28c65fc6c43a882692e24e5155efbc786a6be234f9ba31c4e91cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "076730036e5dc4e7529558da397555da0a103a6355f4703fe6babe5e7d026693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07414fd3b7a44984ba11594db86530bb4adc6a1c8e6bf7439598b537a1f1a55c"
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